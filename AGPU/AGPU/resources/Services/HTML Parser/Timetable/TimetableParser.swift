//
//  TimetableDayParser.swift
//  AGPU
//
//  Created by Марк Киричко on 08.09.2025.
//

import Foundation
import SwiftSoup

enum TimetableOwner: String {
    case group = "Group"
    case teacher = "Teacher"
    case classroom = "Classroom"
}

struct Lesson: Identifiable {
    let id = UUID()
    var name: String?
    var teacherName: String?
    var audienceId: String?
    var groupName: String?
    var date: String?
    var time: String?
    var isDistant: Bool = false
    var subgroup: Int = 0
    var type: PairType = .none
    var colspan: Int = 1
}

struct TimetableDay: Identifiable {
    let id = UUID()
    var date: String
    var lessons: [Lesson]
    var owner: TimetableOwner?
}

final class GetTimetableService {
    static let shared = GetTimetableService(getSearchIdService: GetSearchIdService.shared)
    private let getSearchIdService: GetSearchIdService
    
    private init(getSearchIdService: GetSearchIdService) {
        self.getSearchIdService = getSearchIdService
    }
    
    // MARK: - Public API
    func getDisciplines(id: String,
                        owner: TimetableOwner,
                        startDate: String,
                        endDate: String) async throws -> [TimetableDay] {
        var result: [TimetableDay] = []
        for date in Self.getDatesBetween(startDate: startDate, endDate: endDate) {
            do {
                let day = try await getTimetableDayFromSite(id: id, date: date, owner: owner)
                result.append(day)
            } catch {
                print("Failed to fetch timetable for \(date): \(error)")
                result.append(TimetableDay(date: date, lessons: [], owner: owner))
            }
        }
        return result
    }
    
    func getTimetableDayFromSite(id: String,
                                 date: String,
                                 owner: TimetableOwner) async throws -> TimetableDay {
        let week = try await getTimetableWeek(id: id, date: date, owner: owner)
        guard let found = week.first(where: { $0.date == date }) else {
            print("No timetable day found for \(date)")
            return TimetableDay(date: date, lessons: [], owner: owner)
        }
        return found
    }
    
    func getTimetableWeek(id: String,
                          date: String,
                          owner: TimetableOwner) async throws -> [TimetableDay] {
        let weekId = WeekIdService.weekIdByDate(date)
        print("Fetching timetable for id: \(id), weekId: \(weekId), owner: \(owner.rawValue)")
        let html = try await getHtmlFromPage(
            searchText: id,
            searchId: try await getSearchIdService.getSearchId(searchText: id, owner: owner),
            owner: owner,
            weekId: weekId
        )
        let week = try parseHtml(html: html, owner: owner)
        
        var filteredWeek = week
        for i in filteredWeek.indices {
            filteredWeek[i].lessons.removeAll { $0.name == nil && $0.teacherName == nil && $0.audienceId == nil }
            // Сортируем уроки по времени
            filteredWeek[i].lessons.sort { (lhs, rhs) in
                guard let time1 = lhs.time, let time2 = rhs.time else { return false }
                let start1 = time1.split(separator: "-").first?.trimmingCharacters(in: .whitespaces) ?? ""
                let start2 = time2.split(separator: "-").first?.trimmingCharacters(in: .whitespaces) ?? ""
                return start1 < start2
            }
        }
        return filteredWeek
    }
    
    // MARK: - Private
    
    private func getHtmlFromPage(searchText: String, searchId: Int, owner: TimetableOwner, weekId: Int64) async throws -> String {
        let ownerString = owner.rawValue.capitalized
        let encoded = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
        let urlStr = "http://it-institut.ru/Raspisanie/SearchedRaspisanie?OwnerId=118&SearchId=\(searchId)&SearchString=\(encoded)&Type=\(ownerString)&WeekId=\(weekId)"
        
        guard let url = URL(string: urlStr) else {
            print("Invalid URL: \(urlStr)")
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("HTTP error: status code \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw URLError(.badServerResponse)
        }
        guard let html = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .windowsCP1251) else {
            print("Failed to decode HTML")
            throw URLError(.cannotDecodeContentData)
        }
        return html
    }
    
    private func parseHtml(html: String, owner: TimetableOwner) throws -> [TimetableDay] {
        let doc = try SwiftSoup.parse(html)
        guard let table = try doc.getElementsByClass("table").first() else {
            print("Table with class 'table' not found")
            return []
        }
        guard let tbody = try table.getElementsByTag("tbody").first() else {
            print("Tbody not found")
            return []
        }
        
        let rows = try tbody.getElementsByTag("tr")
        print("Found \(rows.size()) rows in timetable")
        
        let times = try doc.getElementsByClass("thead-light").first()?
            .getElementsByTag("tr").first()?
            .getElementsByTag("th") ?? Elements()
        
        let dayCells = try rows.array().compactMap { try $0.getElementsByTag("th").first() }
        print("Found \(dayCells.count) day cells")
        
        let dates: [String] = try dayCells.map {
            let html = try $0.html()
            print("Parsing th: \(html)")
            let parts = html.components(separatedBy: "<br>")
            if parts.count > 1 {
                return parts[1].trimmingCharacters(in: .whitespaces)
            } else {
                let text = try $0.text().trimmingCharacters(in: .whitespaces)
                let regex = try NSRegularExpression(pattern: "\\d{2}\\.\\d{2}\\.\\d{4}")
                if let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) {
                    return String(text[Range(match.range, in: text)!])
                }
                return ""
            }
        }.filter { !$0.isEmpty }
        
        print("Parsed dates: \(dates)")
        
        var week: [TimetableDay] = dates.map { TimetableDay(date: $0, lessons: [], owner: owner) }
        let timeSlots = parseCol(elements: times)
        
        for i in 0..<min(rows.size(), week.count) {
            try parseDay(el: rows.get(i), day: &week[i], timeSlots: timeSlots)
        }
        
        return week
    }
    
    private func parseCol(elements: Elements) -> [(time: String, colspan: Int)] {
        return elements.array().compactMap { element in
            let text = try? element.text().trimmingCharacters(in: .whitespaces)
            let colspan = Int(try! element.attr("colspan")) ?? 1
            // Проверяем, что текст содержит время в формате "HH:mm-HH:mm"
            let timeRegex = try? NSRegularExpression(pattern: "\\d{1,2}:\\d{2}-\\d{1,2}:\\d{2}")
            if let text = text, let match = timeRegex?.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) {
                let time = String(text[Range(match.range, in: text)!])
                return (time: time, colspan: colspan)
            }
            return nil
        }
    }
    
    private func parseDay(el: Element, day: inout TimetableDay, timeSlots: [(time: String, colspan: Int)]) throws {
        guard let nameOfClass = try el.getElementsByTag("th").first() else {
            print("No th element found for day \(day.date)")
            return
        }
        let disciplines = try el.getElementsByTag("td")
        print("Parsing day \(day.date) with \(disciplines.size()) td elements")
        
        for i in 0..<disciplines.size() {
            try parseLesson(el: disciplines.get(i), day: &day, date: day.date, timeSlots: timeSlots)
        }
        
        assignTimeOfLessons(&day.lessons, timeSlots: timeSlots)
    }
    
    private func parseLesson(el: Element, day: inout TimetableDay, date: String, timeSlots: [(time: String, colspan: Int)]) throws {
        print("Parsing lesson for \(date): \(try el.html())")
        var lesson = Lesson()
        lesson.date = date
        lesson.colspan = Int(try el.attr("colspan")) ?? 1
        lesson.isDistant = try el.text().lowercased().contains("дист")
        
        let text = try el.text().trimmingCharacters(in: .whitespaces)
        if text.isEmpty {
            print("Empty lesson for \(date)")
            day.lessons.append(lesson)
            return
        }
        
        let spans = try el.getElementsByTag("span")
        if spans.isEmpty() {
            let lines = text.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
            if lines.count >= 3 {
                let nameParts = lines[0].components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                lesson.name = nameParts.first
                let teacherAndRoom = lines[1].components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                lesson.teacherName = teacherAndRoom.first
                lesson.audienceId = teacherAndRoom.count > 1 ? teacherAndRoom.last : nil
                lesson.groupName = lines[2].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            } else if !lines.isEmpty {
                lesson.name = lines[0]
            }
        } else {
            if spans.size() > 0, let name = try? spans.get(0).text().trimmingCharacters(in: .whitespaces), !name.isEmpty {
                lesson.name = name
                if name.last == "," || name.last == "." {
                    lesson.name = String(name.dropLast())
                }
            }
            if spans.size() > 1 {
                let prepodAndAudience = try spans.get(1).text().components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                if prepodAndAudience.count >= 2 {
                    lesson.teacherName = prepodAndAudience[0]
                    lesson.audienceId = prepodAndAudience.last
                } else if !prepodAndAudience.isEmpty {
                    lesson.teacherName = prepodAndAudience[0]
                }
            }
            if spans.size() > 2 {
                lesson.groupName = try spans.get(2).text().replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            }
            if spans.size() > 3 {
                lesson.subgroup = try spans.get(3).text().contains("1") ? 1 : 2
            }
        }
        
        assignTypeAndRenameLesson(&lesson)
        if lesson.name != nil || lesson.teacherName != nil || lesson.audienceId != nil {
            print("Adding lesson: \(lesson)")
            day.lessons.append(lesson)
        } else {
            print("Skipping lesson, all fields are nil: \(lesson)")
        }
    }
    
    private func assignTypeAndRenameLesson(_ lesson: inout Lesson) {
        let map: [String: PairType] = [
            "конс": .cons,
            "лек": .lec,
            "фэпо": .fepo,
            "зач": .cred,
            "выходной": .hol,
            "каникулы": .hol,
            "лаб": .lab,
            "экз": .exam,
            "прак": .prac,
            "курсов": .cours
        ]
        
        guard let name = lesson.name?.lowercased() else { return }
        for (key, type) in map {
            if name.contains("," + key) || name.contains(" " + key) {
                lesson.name = lesson.name?.replacingOccurrences(of: "," + key, with: "")
                    .replacingOccurrences(of: " " + key, with: "")
                    .trimmingCharacters(in: .whitespaces)
                lesson.type = type
                return
            }
        }
        lesson.type = .none
    }
    
    private func assignTimeOfLessons(_ lessons: inout [Lesson], timeSlots: [(time: String, colspan: Int)]) {
        let resolved = resolve(timeSlots: timeSlots, pairs: lessons.map { $0.colspan })
        for i in 0..<min(lessons.count, resolved.count) {
            lessons[i].time = resolved[i].time
        }
    }
    
    private func resolve(timeSlots: [(time: String, colspan: Int)], pairs: [Int]) -> [(time: String, colspan: Int)] {
        var res: [(time: String, colspan: Int)] = []
        var currentIndex = 0
        var remainder = timeSlots.count > currentIndex ? timeSlots[currentIndex].colspan : 1
        
        for pair in pairs {
            if currentIndex < timeSlots.count {
                res.append(timeSlots[currentIndex])
                remainder -= pair
                if remainder <= 0 {
                    currentIndex += 1
                    remainder = currentIndex < timeSlots.count ? timeSlots[currentIndex].colspan : 1
                }
            }
        }
        return res
    }
    
    static func getDatesBetween(startDate: String, endDate: String) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        guard let start = formatter.date(from: startDate),
              let end = formatter.date(from: endDate) else {
            print("Invalid date format: \(startDate) - \(endDate)")
            return []
        }
        
        var dates: [String] = []
        var dateCursor = start
        while dateCursor <= end {
            dates.append(formatter.string(from: dateCursor))
            guard let next = Calendar.current.date(byAdding: .day, value: 1, to: dateCursor) else { break }
            dateCursor = next
        }
        return dates
    }
}
