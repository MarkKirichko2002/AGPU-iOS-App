//
//  NotificationManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 09.10.2023.
//

import UserNotifications

// MARK: - NotificationManagerProtocol
extension NotificationManager: NotificationManagerProtocol {
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Разрешение на уведомление получено")
                //TimeTableService().startLongPolling()
                self.sendTimetableNotification()
            } else {
                print("Разрешение на уведомление не получено")
            }
        }
    }
    
    func sendTimetableNotification() {
        
        // Создаем содержимое уведомления
        let content = UNMutableNotificationContent()
        content.title = "Расписание обновилось."
        content.body = "проверьте его сейчас."
        content.sound = UNNotificationSound.default
        
        // Создаем триггер для уведомления
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let uniqueIdentifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: uniqueIdentifier, content: content, trigger: trigger)
        
        // Запланировать запрос уведомления
        center.add(request, withCompletionHandler: { error in
            if let error = error {
                print("Ошибка при отправке уведомления: \(error.localizedDescription)")
            } else {
                print("Уведомление успешно отправлено")
            }
        })
    }
}
