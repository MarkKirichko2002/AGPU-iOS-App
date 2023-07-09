//
//  ElectedFaculties.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import Foundation

struct ElectedFaculties {
    static let faculties = [
        ElectedFacultyModel(id: 1, name: "Институт русской и иностранной филологии", icon: "icon1", appIcon: "AppIcon 1", url: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/index.php", phoneNumbers: ["89883610402"], email: "markkir123@gmail.com", isSelected: false),
        ElectedFacultyModel(id: 2, name: "Институт прикладной информатики, математики и физики", icon: "icon2", appIcon:  "AppIcon 2", url: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/index.php", phoneNumbers: ["89883610402"], email: "markkir123@gmail.com", isSelected: false),
        ElectedFacultyModel(id: 3, name: "Социально-психологический факультет", icon: "icon3", appIcon:  "AppIcon 3", url: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/index.php", phoneNumbers: ["88613737994", "89892761786"], email: "pedfak_agpu@mail.ru", isSelected: false),
        ElectedFacultyModel(id: 4, name: "Факультет дошкольного и начального образования", icon: "icon4", appIcon:  "AppIcon 4", url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/index.php", phoneNumbers: ["88613733264"], email: "dekanat_fdino@mail.ru", isSelected: false),
        ElectedFacultyModel(id: 5, name: "Факультет технологии, экономики и дизайна", icon: "icon5", appIcon:  "AppIcon 5", url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/index.php", phoneNumbers: ["88613728094", "88613728217"], email: "dekanat.tekhfak@mail.ru", isSelected: false),
        ElectedFacultyModel(id: 6, name: "Исторический факультет", icon: "icon6", appIcon:  "AppIcon 6", url: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/index.php", phoneNumbers: ["89883610402"], email: "markkir123@gmail.com", isSelected: false)
    ]
}
