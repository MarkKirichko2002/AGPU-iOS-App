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
            name: "ASPU Button",
            description: "ASPU Button (АГПУ кнопка) – кнопка, расположенная в центре панели вкладок, автоматически изменяет изображение в зависимости от ваших действий. Также для этой кнопки вы можете выбрать одно или несколько действий, иконку или анимацию."
        ),
        
        AppFeatureModel(
            id: 2,
            name: "Voice Control",
            description: "Voice Control (голосовое управление) - просто используйте свой голос, чтобы открыть нужные разделы на сайте, найти конкретный корпус на карте или даже голосом прокручивать веб-страницы сайта. Вы можете просто сказать \"Вниз\" или \"Вверх\", и страница автоматически будет прокручиваться в соответствующем направлении."
        ),
        
        AppFeatureModel(
            id: 3,
            name: "Find Campus",
            description: "Find Campus (найти кампус) - простой и удобный способ быстрого поиска всех корпусов или кафедр на карте. С помощью этой опции вы сможете легко найти все необходимые корпуса или кафедры, отображенные на карте, в удобном интерфейсе. Особенно полезно то, что эта опция предоставляет актуальную информацию о погоде и парах на текущий день для выбранного корпуса или кафедры. Кроме того, вы можете с легкостью поделиться локацией конкретного корпуса или кафедры. Вам доступен выбор, в каком приложении просматривать локации Apple Maps, Google Maps или Яндекс Карты."
        ),
        
        AppFeatureModel(
            id: 4,
            name: "Action To Recall",
            description: "Action To Recall (действуйте чтобы вспомнить) - функция, которая позволяет мгновенно вернуться к последней веб-странице, которую вы читали. Просто потрясите ваше устройство или нажмите на ASPU Button, и она автоматически откроется, прокрутка будет на место, на котором вы остановились. Вы также сможете увидеть время последнего посещения этой страницы. Это удобно, быстро и точно по времени. Кроме того, вы также можете открыть недавний документ, новость, воспроизвести недавнее видео или посмотреть недавнее расписание."
        ),
        
        AppFeatureModel(
            id: 5,
            name: "Selected Faculty",
            description: "Selected Faculty (выбранный факультет) - выберите свой факультет, чтобы получать самые свежие новости, связанные именно с ним. Также, выберите свою группу, чтобы быстро получать актуальное расписание, специально для нее. И не забудьте выбрать кафедру, чтобы получать доступ к полезным методическим материалам."
        ),
        
        AppFeatureModel(
            id: 6,
            name: "Adaptive News",
            description: "Adaptive News (адаптивные новости) - новости адаптируются в зависимости от выбранного факультета. При выборе факультета, вы получаете релевантные новости, связанные с вашим факультетом. При этом, вы также можете выбрать и сохранить другую категорию новостей на экране категорий или в настройках приложения. В дополнение, в настройках есть опции: вид, адаптация от веб-страницы, показывать новости за сегодня, выделять новости за сегодня. Также у каждой новости сохраняется позиция, тем самым вы сможете продолжить читать с того места, где остановились. К тому же у вас есть возможность взаимодействовать со списком недавно прочитанных новостей."
        ),
        
        AppFeatureModel(
            id: 7,
            name: "ASPU Wallpapers",
            description: "ASPU Wallpapers (АГПУ обои) - вы можете скачать и установить обои связанные с АГПУ на экран вашего устройства."
        ),
        
        AppFeatureModel(
            id: 8,
            name: "Your Status",
            description: "Your Status (ваш статус) - позволяет выбрать свой статус в настройках приложения и получать уникальный контент, приспособленный под ваш выбор."
        ),
        
        AppFeatureModel(
            id: 9,
            name: "Advanced Timetable",
            description: "Advanced Timetable (продвинутое расписание) - опция, позволяющая получить расписание на основе выбранной группы, аудитории или преподавателя. Она позволяет выбрать неделю из списка, автоматически прокрутиться до нужной недели, дня недели и группы, а также предоставляет информацию о том, в каком корпусе будут проходить занятия. Кроме того, вы можете отфильтровать пары по типу, чтобы быстро и удобно получить доступ к интересующим вас занятиям. Также у вас есть возможность поделиться расписанием на день или неделю в виде изображения или сохранить изображение расписания в фото вашего устройства. В дополнение к этому, данная функция предоставляет информацию о времени, оставшемся до начала или конца пары. Вместе с тем вы можете взаимодействовать со списком \"Избранное\". Это позволяет вам легко планировать свое время и не опаздывать на занятия."
        ),
        
        AppFeatureModel(
            id: 10,
            name: "Smart Calendar",
            description: "Smart Calendar (умный календарь) - при выборе даты в календаре отображается информация о расписании. Это помогает быстро организовать время и быть в курсе изменений в расписании."
        ),
        
        AppFeatureModel(
            id: 11,
            name: "Personalized App Icons",
            description: "Personalized App Icons (персональные иконки приложения) - функция, позволяющая вам установить иконку для приложения, а также выбрать иконку, которая соответствует вашему факультету."
        ),
        
        AppFeatureModel(
            id: 12,
            name: "Only Schedule",
            description: "Only Schedule (только расписание) - сокращает количество вкладок с 4 до 2, оставляя только вкладки \"Расписание\" и \"Настройки\". Включение этой опции позволяет сфокусироваться только на самом важном - вашем расписании занятий."
        ),
        
        AppFeatureModel(
            id: 13,
            name: "My Splash Screen",
            description: "My Splash Screen (мой экран заставки) - выберите экран заставки приложения соответствующий вашим предпочтениям. Также вы можете сделать экран заставки со своим изображением, текстом и выбрать цвет для фона. На данный момент доступно \(SplashScreenOptions.allCases.count) вариантов для экрана заставки."
        ),
        
        AppFeatureModel(
            id: 14,
            name: "Important Documents",
            description: "Important Documents (важные документы) - опция, которая позволяет сохранять, делиться и удалять документы. Кроме того, вы можете добавить документ в список, введя его URL. Это позволяет вам легко организовывать свои документы и иметь к ним доступ всегда, где бы вы ни находились."
        ),
        
        AppFeatureModel(
            id: 15,
            name: "Custom TabBar",
            description: "Custom TabBar (своя панель вкладок) - у вас есть возможность настроить панель вкладок по своему усмотрению. Например, вы можете настроить порядок вкладок, выбрать цвет или включить/выключить анимацию для них."
        ),
    ]
}
