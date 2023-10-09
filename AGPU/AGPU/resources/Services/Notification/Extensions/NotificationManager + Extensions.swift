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
        
        // Создаем запрос на уведомление
        let request = UNNotificationRequest(identifier: "NotificationIdentifier", content: content, trigger: trigger)
        
        // Запланировать запрос уведомления
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("Ошибка при отправке уведомления: \(error.localizedDescription)")
            } else {
                print("Уведомление успешно отправлено")
            }
        })
    }
}
