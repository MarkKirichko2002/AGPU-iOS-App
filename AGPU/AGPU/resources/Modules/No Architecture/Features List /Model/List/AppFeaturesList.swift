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
            name: "ASPU Buttons",
            description: "ASPU Buttons (АГПУ кнопки) - имеются разные кнопки: 1) В центре панели вкладок - вы можете выбрать действия, иконку, анимацию, жест для активации кнопки, свайпы: вверх - открывает настройки кнопки, влево/вправо – навигация между вкладками. 2) \"Плавающая\" кнопка - для каждого экрана разные действия. Обе кнопки меняет изображение в зависимости от действий.",
            videoURL: "https://youtu.be/_HppFZQ1Y_o?si=4ZCTBe40j2tBtVFO"
        ),
        
        AppFeatureModel(
            id: 2,
            name: "Say Anywhere",
            description: "Say Anywhere (скажите где угодно) - голосовые команды для различных действий: открыть нужные разделы на сайте, прокручивать веб-страницы сказав \"Вниз\" или \"Вверх\", найти конкретный корпус на карте, просматривать следующее и предыдущее изображение в AR, открыть список недель для расписания. Также вы можете выбрать на каком экране будет включаться микрофон.",
            videoURL: "https://youtu.be/yiFvs_O6cO0?si=KsxuMbjf3Oc3IP30"
        ),
        
        AppFeatureModel(
            id: 3,
            name: "Find Campus",
            description: "Find Campus (найти кампус) - быстрый поиск корпусов и кафедр на карте. Получайте информацию о погоде и расписании для выбранного места. Делитесь локациями и открывайте их в удобных вам картах (Apple, Google, Яндекс). Приложите палец, чтобы переместиться к своему местоположению.",
            videoURL: "https://youtu.be/BidM9LgLJps?si=QaPdO70bTjzc4Rop"
        ),
        
        AppFeatureModel(
            id: 4,
            name: "Action To Get",
            description: "Action To Get (действуйте чтобы получить) -  мгновенный доступ к недавнему контенту: просто потрясите устройство или нажмите на ASPU Button.",
            videoURL: "https://youtu.be/VtLzV-g46H0?si=ia4WdK2x25Kgm_W6"
        ),
        
        AppFeatureModel(
            id: 5,
            name: "Selected Faculty",
            description: "Selected Faculty (выбранный факультет) - выберите факультет для получения новостей, расписания и полезных методичек.",
            videoURL: "https://youtu.be/GATdheOGg3k?si=MOPOjpHjTiVF6kj_"
        ),
        
        AppFeatureModel(
            id: 6,
            name: "Adaptive News",
            description: "Adaptive News (адаптивные новости) - предлагает новости по выбранному факультету. Настройки включают категорию, порядок опций, вид, индикатор загрузки и выделение новостей за сегодня. Сохраняет позицию чтения и показывает недавно прочитанные новости. Имеет AR для просмотра изображений. Фильтрация по дате или месяцу.",
            videoURL: "https://youtu.be/PariiH7RAdE?si=jfAzEeQX3UvY_6bz"
        ),
        
        AppFeatureModel(
            id: 7,
            name: "ASPU Wallpapers",
            description: "ASPU Wallpapers (АГПУ обои) - вы можете скачать и установить обои, связанные с АГПУ, на экран вашего устройства.",
            videoURL: "https://youtu.be/eY4_nsl4_g0?si=VrkY3d-MAjdANHNm"
        ),
        
        AppFeatureModel(
            id: 8,
            name: "Favourite Sections",
            description: "Favourite Sections (избранные разделы) - редактирование списка необходимых разделов. Потяните чтобы восстановить список разделов.",
            videoURL: "https://youtu.be/Qllf8W-Ilxc?si=F1LZYhGefeSQQZHj"
        ),
        
        AppFeatureModel(
            id: 9,
            name: "Grounbreaking Timetable",
            description: "Grounbreaking Timetable (революционное расписание) - получение расписания на основе выбора группы, аудитории или преподавателя. Позволяет выбрать неделю, день недели. Поддерживает распознавание жестов руки, голосовые команды, AR. Фильтрация по типу пары, корпусу, времени: день, день недели. Дает возможность делиться расписанием в виде изображения, сохранять его, посмотреть расписание для аудиторий ближайшего корпуса, изменять список \"Избранное\". При повороте устройства, изменение уровня громкости происходит навигация между днями и неделями. Можно узнать наличие пары на следующий, предыдущий или выбранный в календаре день.",
            videoURL: "https://youtu.be/elFL00qmzJY?si=HtqLT5ueV_bQ58Qv"
        ),
        
        AppFeatureModel(
            id: 10,
            name: "Smart Calendar",
            description: "Smart Calendar (умный календарь) - показывает расписание или информацию о нем при выборе даты. Вы можете взаимодействовать со списком недавних дат и просматривать расписание для нескольких выбранных дат одновременно. Доступна фильтрация новостей по выбранной дате.",
            videoURL: "https://youtu.be/DGWhPXIg1Dk?si=UHWPAddwmmubeNe1"
        ),
        
        AppFeatureModel(
            id: 11,
            name: "Schedule Days",
            description: "Schedule Days (дни расписания) - позволяет выбрать расписание на ближайшие дни, дни выбранной недели или даты в календаре, а также показывает количество пар.",
            videoURL: ""
        ),
        
        AppFeatureModel(
            id: 12,
            name: "My Splash Screen",
            description: "My Splash Screen (мой экран заставки) - выбор экрана заставки с настраиваемыми опциями.",
            videoURL: "https://youtu.be/TaZXJ0SzWUQ?si=5y3yAO60k_pSzUmR"
        ),
        
        AppFeatureModel(
            id: 13,
            name: "Important List",
            description: "Important List (список важного) - опция для управления документами, изображениями, видео, web-страницами и контактами. Позволяет добавлять документы, видео, web-страницы по URL, изображения из галереи и имеет список избранного для расписания.",
            videoURL: "https://youtu.be/pt8mm52DadA?si=9-vaD-eRBeWn5FZE"
        ),
        
        AppFeatureModel(
            id: 14,
            name: "Your TabBar",
            description: "Your TabBar (ваша панель вкладок) - позволяет настроить для панели вкладок: порядок вкладок, название для каждой вкладки, выбрать: действия для каждой вкладки, вариант дополнительной вкладки, цвет, шрифт, стиль иконок, вариант звуков, вариант вкладок включая сокращенные варианты (до 2 вкладок), включить/выключить: анимацию, сохранение недавней вкладки.",
            videoURL: "https://youtu.be/pt8mm52DadA?si=9-vaD-eRBeWn5FZE"
        ),
        
        AppFeatureModel(
            id: 15,
            name: "Glance Info",
            description: "Glance Info (информация c первого взгляда) - показывает актуальную информацию, например, вы будете знать, какие новости появились или сколько сегодня пар.",
            videoURL: ""
        ),
        
        AppFeatureModel(
            id: 16,
            name: "AR Mode",
            description: "AR Mode (AR режим) - просмотр изображений в AR, навигация между ними с помощью свайпов, голоса с использованием фонарика.",
            videoURL: ""
        ),
        
        AppFeatureModel(
            id: 17,
            name: "Settable Communication",
            description: "Settable Communication (настраиваемое общение) - вы можете указать свое имя, стиль общения и включить/выключить озвучивание сообщений.",
            videoURL: ""
        ),
        
        AppFeatureModel(
            id: 18,
            name: "Needed Building",
            description: "Needed Building (нужное здание) - находит ближайший корпус в заданном радиусе или по номеру аудитории.",
            videoURL: ""
        ),
        
        AppFeatureModel(
            id: 19,
            name: "Pair Info",
            description: "Pair Info (информация о паре) - показывает время до начала/конца пары, расстояние до корпуса и время прибытия.",
            videoURL: ""
        ),
        
        AppFeatureModel(
            id: 20,
            name: "Useful Shortcuts",
            description: "Useful Shortcuts (полезные шорткаты) - позволяет настроить список шорткатов для приложения.",
            videoURL: ""
        )
    ]
}
