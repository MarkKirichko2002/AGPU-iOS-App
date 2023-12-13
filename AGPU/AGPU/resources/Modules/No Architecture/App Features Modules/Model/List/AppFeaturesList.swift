//
//  AppFeaturesList.swift
//  AGPU
//
//  Created by Марк Киричко on 22.07.2023.
//

import Foundation

struct AppFeaturesList {
    
    static let features = [
        
        AppFeatureModel(
            id: 1,
            name: "Dynamic Button",
            description: "Dynamic Button (динамическая кнопка) - автоматически изменяет изображение на кнопке, находящейся в середине панели вкладок, в зависимости от ваших действий."
        ),
        
        AppFeatureModel(
            id: 2,
            name: "Voice Control",
            description: "Voice Control (голосовое управление) - просто используйте свой голос, чтобы открыть нужные разделы на сайте, найти конкретный корпус на карте или даже голосом прокручивать веб-страницы сайта. Вы можете просто сказать \"Вниз\" или \"Вверх\", и страница автоматически будет прокручиваться в соответствующем направлении."
        ),
        
        AppFeatureModel(
            id: 3,
            name: "Find ASPU",
            description: "Find ASPU (найти АГПУ) - простой и удобный способ быстрого поиска всех корпусов и кафедр на карте. С помощью этой опции вы сможете легко найти все необходимые корпуса и кафедры, отображенные на карте, в удобном интерфейсе. Особенно полезно то, что эта опция предоставляет актуальную информацию о погоде и парах на текущий день для выбранного корпуса и кафедры. Кроме того, вы можете с легкостью поделиться локацией конкретного корпуса или кафедры."
        ),
        
        AppFeatureModel(
            id: 4,
            name: "Shake To Recall",
            description: "Shake To Recall (встряхните чтобы вспомнить) - функция, которая позволяет мгновенно вернуться к последней веб-странице, которую вы читали. Просто потрясите ваше устройство, и она автоматически откроется, прокрутка будет на место, на котором вы остановились. Вы также сможете увидеть время последнего посещения этой страницы. Это удобно, быстро и точно по времени. Кроме того, вы также можете открыть недавний документ, воспроизвести недавнее видео или посмотреть недавнее расписание."
        ),
        
        AppFeatureModel(
            id: 5,
            name: "Selected Faculty",
            description: "Selected Faculty (выбранный факультет) - выберите свой факультет, чтобы получать самые свежие новости, связанные именно с ним. Также, выберите свою группу, чтобы быстро получать актуальное расписание, специально для нее. И не забудьте выбрать кафедру, чтобы получать доступ к полезным методическим материалам."
        ),
        
        AppFeatureModel(
            id: 6,
            name: "Adaptive News",
            description: "Adaptive News (адаптивные новости) - новости адаптируются в зависимости от выбранного факультета. При выборе факультета, вы получаете релевантные новости, связанные с вашим факультетом. При этом, вы также можете выбрать и сохранить другую категорию новостей на экране категорий или в настройках приложения."
        ),
        
        AppFeatureModel(
            id: 7,
            name: "ASPU Wallpapers",
            description: "ASPU Wallpapers (АГПУ обои) - вы можете скачать и установить обои связанные с АГПУ на экран вашего устройства."
        ),
        
        AppFeatureModel(
            id: 8,
            name: "Your Status",
            description: "Your Status (ваш статус) - выберите свой статус в настройках и раскройте уникальный контент, приспособленный под ваш выбор."
        ),
        
        AppFeatureModel(
            id: 9,
            name: "Advanced Timetable",
            description: "Advanced Timetable (продвинутое расписание) - функция, позволяющая получить расписание на основе выбранной группы. Она позволяет выбрать неделю из списка, автоматически прокрутиться до нужной недели, дня недели и группы, а также предоставляет информацию о том, в каком корпусе будут проходить занятия. Кроме того, вы можете отфильтровать пары по типу, чтобы быстро и удобно получить доступ к интересующим вас занятиям. Также вы можете поделиться расписанием на день или неделю в виде изображения или сохранить изображение расписания в фото вашего устройства. В дополнение к этому, данная функция предоставляет информацию о времени, оставшемся до начала или конца пары. Это позволяет вам легко планировать свое время и не опаздывать на занятия."
        ),
        
        AppFeatureModel(
            id: 10,
            name: "Smart Calendar",
            description: "Smart Calendar (умный календарь) - функция, которая при выборе даты в календаре показывает наличие пар, их количество и указывает на особые дни. Это помогает быстро организовать время и быть в курсе изменений в расписании."
        ),
        
        AppFeatureModel(
            id: 11,
            name: "Personalized App Icons",
            description: "Personalized App Icons (персональные иконки приложения) - функция, позволяющая вам установить иконку для приложения, а также выбрать иконку, которая соответствует вашему факультету."
        )
    ]
}
