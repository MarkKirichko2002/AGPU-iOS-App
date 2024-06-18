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
            description: "ASPU Button (АГПУ кнопка) – кнопка, расположенная в центре панели вкладок, автоматически изменяет изображение в зависимости от ваших действий. Также для этой кнопки вы можете выбрать одно или несколько действий, иконку или анимацию.",
            videoURL: "https://youtu.be/_HppFZQ1Y_o?si=4ZCTBe40j2tBtVFO"
        ),
        
        AppFeatureModel(
            id: 2,
            name: "Voice Control",
            description: "Voice Control (голосовое управление) - просто используйте свой голос, чтобы открыть нужные разделы на сайте, найти конкретный корпус на карте или даже голосом прокручивать веб-страницы сайта. Вы можете просто сказать \"Вниз\" или \"Вверх\", и страница автоматически будет прокручиваться в соответствующем направлении.",
            videoURL: "https://youtu.be/yiFvs_O6cO0?si=KsxuMbjf3Oc3IP30"
        ),
        
        AppFeatureModel(
            id: 3,
            name: "Find Campus",
            description: "Find Campus (найти кампус) - простой и удобный способ быстрого поиска всех корпусов или кафедр на карте. С помощью этой опции вы сможете легко найти все необходимые корпуса или кафедры, отображенные на карте, в удобном интерфейсе. Особенно полезно то, что эта опция предоставляет актуальную информацию о погоде и парах на текущий день для выбранного корпуса или кафедры. Кроме того, вы можете с легкостью поделиться локацией конкретного корпуса или кафедры. Вам доступен выбор, в каком приложении просматривать локации Apple Maps, Google Maps или Яндекс Карты.",
            videoURL: "https://youtu.be/BidM9LgLJps?si=QaPdO70bTjzc4Rop"
        ),
        
        AppFeatureModel(
            id: 4,
            name: "Action To Recall",
            description: "Action To Recall (действуйте чтобы вспомнить) - функция, которая позволяет мгновенно вернуться к последней веб-странице, которую вы читали. Просто потрясите ваше устройство или нажмите на ASPU Button, и она автоматически откроется, прокрутка будет на место, на котором вы остановились. Вы также сможете увидеть время последнего посещения этой страницы. Это удобно, быстро и точно по времени. Кроме того, вы также можете открыть недавний документ, новость, воспроизвести недавнее видео или посмотреть недавнее расписание.",
            videoURL: "https://youtu.be/VtLzV-g46H0?si=ia4WdK2x25Kgm_W6"
        ),
        
        AppFeatureModel(
            id: 5,
            name: "Selected Faculty",
            description: "Selected Faculty (выбранный факультет) - выберите свой факультет, чтобы получать самые свежие новости, связанные именно с ним. Также, выберите свою группу, чтобы быстро получать актуальное расписание, специально для нее. И не забудьте выбрать кафедру, чтобы получать доступ к полезным методическим материалам.",
            videoURL: "https://youtu.be/GATdheOGg3k?si=MOPOjpHjTiVF6kj_"
        ),
        
        AppFeatureModel(
            id: 6,
            name: "Adaptive News",
            description: "Adaptive News (адаптивные новости) - новости адаптируются в зависимости от выбранного факультета. При выборе факультета, вы получаете релевантные новости, связанные с вашим факультетом. В дополнение, в настройках есть опции: категория, порядок опций, вид, адаптация от веб-страницы, показывать новости за сегодня, выделять новости за сегодня. Также у каждой новости сохраняется позиция, тем самым вы сможете продолжить читать с того места, где остановились. К тому же у вас есть возможность взаимодействовать со списком недавно прочитанных новостей.",
            videoURL: "https://youtu.be/PariiH7RAdE?si=jfAzEeQX3UvY_6bz"
        ),
        
        AppFeatureModel(
            id: 7,
            name: "ASPU Wallpapers",
            description: "ASPU Wallpapers (АГПУ обои) - вы можете скачать и установить обои связанные с АГПУ на экран вашего устройства.",
            videoURL: "https://youtu.be/eY4_nsl4_g0?si=VrkY3d-MAjdANHNm"
        ),
        
        AppFeatureModel(
            id: 8,
            name: "Your Status",
            description: "Your Status (ваш статус) - позволяет выбрать свой статус в настройках приложения и получать уникальный контент, приспособленный под ваш выбор. На экранах \"Абитуриенту\", \"Студенту\", \"Сотруднику\" вы можете изменить порядок разделов или вернуть его в исходное состояние.",
            videoURL: "https://youtu.be/Qllf8W-Ilxc?si=F1LZYhGefeSQQZHj"
        ),
        
        AppFeatureModel(
            id: 9,
            name: "Advanced Timetable",
            description: "Advanced Timetable (продвинутое расписание) - опция, позволяющая получить расписание на основе выбранной группы, аудитории или преподавателя. Она позволяет выбрать неделю из списка, автоматически прокрутиться до нужной недели, дня недели и группы, а также предоставляет информацию о том, в каком корпусе будут проходить занятия. Кроме того, вы можете отфильтровать пары по типу, чтобы быстро и удобно получить доступ к интересующим вас занятиям. Также у вас есть возможность поделиться расписанием на день или неделю в виде изображения или сохранить изображение расписания в фото вашего устройства. В дополнение к этому, данная функция предоставляет информацию о времени, оставшемся до начала или конца пары. Вместе с тем вы можете взаимодействовать со списком \"Избранное\". Это позволяет вам легко планировать свое время и не опаздывать на занятия.",
            videoURL: "https://youtu.be/elFL00qmzJY?si=HtqLT5ueV_bQ58Qv"
        ),
        
        AppFeatureModel(
            id: 10,
            name: "Smart Calendar",
            description: "Smart Calendar (умный календарь) - при выборе даты в календаре отображается информация о расписании.",
            videoURL: "https://youtu.be/DGWhPXIg1Dk?si=UHWPAddwmmubeNe1"
        ),
        
        AppFeatureModel(
            id: 11,
            name: "Personalized App Icons",
            description: "Personalized App Icons (персональные иконки приложения) - функция, позволяющая вам установить иконку для приложения, а также выбрать иконку, которая соответствует вашему факультету.",
            videoURL: "https://youtu.be/RJC2sEhU2IA?si=g0dibHXUmhuH4p_U"
        ),
        
        AppFeatureModel(
            id: 12,
            name: "Only Main",
            description: "Only Main (только главное) - сокращает количество вкладок с 4 до 2, оставляя один из вариантов вкладок: 1) \"Расписание\" и \"Настройки\" 2) \"Новости\" и \"Настройки\" 3) \"Разделы\" и \"Настройки\". Включение этой опции позволяет сфокусироваться только на самом важном - вашем расписании занятий, новостях или на разделах сайта.",
            videoURL: "https://youtu.be/2gZqU2DPCEk?si=_-LVwLR3-cYyLq9b"
        ),
        
        AppFeatureModel(
            id: 13,
            name: "My Splash Screen",
            description: "My Splash Screen (мой экран заставки) - выберите экран заставки приложения соответствующий вашим предпочтениям. Также вы можете сделать экран заставки со своим изображением, текстом и выбрать цвет для фона. На данный момент доступно \(SplashScreenOptions.allCases.count) вариантов для экрана заставки.",
            videoURL: "https://youtu.be/TaZXJ0SzWUQ?si=5y3yAO60k_pSzUmR"
        ),
        
        AppFeatureModel(
            id: 14,
            name: "Important Things",
            description: "Important Things (важные вещи) - опция, которая позволяет сохранять, делиться и удалять документы, изображения, видео, а также контакты. Кроме того, вы можете добавить документ или видео в список, введя его URL; добавить контакт; или добавить изображение в список из фото устройства.",
            videoURL: "https://youtu.be/pt8mm52DadA?si=9-vaD-eRBeWn5FZE"
        ),
        
        AppFeatureModel(
            id: 15,
            name: "Custom TabBar",
            description: "Custom TabBar (своя панель вкладок) - у вас есть возможность настроить панель вкладок по своему усмотрению. Например, вы можете настроить порядок вкладок, выбрать цвет или включить/выключить анимацию для них.",
            videoURL: "https://youtu.be/GFn-5phP5UU?si=n0GD1qtBirSuIomY"
        ),
        
        AppFeatureModel(
            id: 16,
            name: "Visual Changes",
            description: "Visual Changes (наглядные изменения) - показывает, что изменилось для интересующего вас контента. Например, вы будете знать, какие новости появились за сегодня.",
            videoURL: ""
        )
    ]
}
