//
//  AGPUSubSections.swift
//  AGPU
//
//  Created by Марк Киричко on 10.06.2023.
//

import Foundation

struct AGPUSubSections {
    
    static let subsections = [
        "Главное": [
            AGPUSubSectionModel(
                id: 0,
                name: "Главное",
                icon: "home icon",
                url: "http://agpu.net/",
                voiceCommand: "главное"
            )
        ], "Университет" : [
            AGPUSubSectionModel(
                id: 0,
                name: "Сведения об образовательной организации",
                icon: "university",
                url: "http://agpu.net/sveden/index.php",
                voiceCommand: "образовательнаяорганизация"
            ),
            AGPUSubSectionModel(
                id: 1,
                name: "Ученый совет",
                icon: "university",
                url: "http://agpu.net/struktura-vuza/uchenyy-sovet/index.php",
                voiceCommand: "учёныйсовет"
            ),
            AGPUSubSectionModel(
                id: 2,
                name: "Руководство. Педагогический(научно-педагогический состав) состав",
                icon: "university",
                url: "http://agpu.net/sveden/employees/index.php",
                voiceCommand: "руководств"
            ),
            AGPUSubSectionModel(
                id: 3,
                name: "Институты и Факультеты",
                icon: "university",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/index.php",
                voiceCommand: "факультеты"
            ),
            AGPUSubSectionModel(
                id: 4,
                name: "Структура университета/Подразделения",
                icon: "university",
                url: "http://agpu.net/struktura-vuza/index.php",
                voiceCommand: "структура"
            ),
            AGPUSubSectionModel(
                id: 5,
                name: "Первичная профсоюзная организация",
                icon: "university",
                url: "http://agpu.net/profsouz/index.php",
                voiceCommand: "профсоюзнаяорганизация"
            ),
            AGPUSubSectionModel(
                id: 6,
                name: "История ВУЗа",
                icon: "university",
                url: "http://agpu.net/about/history.php",
                voiceCommand: "история"
            ),
            AGPUSubSectionModel(
                id: 7,
                name: "Миссия и ценности",
                icon: "university",
                url: "http://agpu.net/contacts/missiya.php",
                voiceCommand: "миссия"
            ),
            AGPUSubSectionModel(
                id: 8,
                name: "Реквизиты",
                icon: "university",
                url: "http://agpu.net/contacts/requisites.php",
                voiceCommand: "реквизиты"
            ),
            AGPUSubSectionModel(
                id: 9,
                name: "Контакты",
                icon: "university",
                url: "http://agpu.net/contacts/index.php",
                voiceCommand: "контакты"
            )
        ], "Абитуриенту" :  [
            AGPUSubSectionModel(
                id: 0,
                name: "Институты/Факультеты",
                icon: "user",
                url: "http://agpu.net/abitur/faculties-institutes/index.php",
                voiceCommand: "факультеты"
            ),
            AGPUSubSectionModel(
                id: 1,
                name: "Информация для поступающих",
                icon: "user",
                url: "http://priem.agpu.net/",
                voiceCommand: "информациядляпоступающих"
            ),
            AGPUSubSectionModel(
                id: 2,
                name: "Вопросы и ответы",
                icon: "user",
                url: "http://priem.agpu.net/contact-form/Quest.php",
                voiceCommand: "вопросыиответы"
            ),
            AGPUSubSectionModel(
                id: 3,
                name: "Дополнительное образование",
                icon: "user",
                url: "https://niiro-agpu.ru/",
                voiceCommand: "дополнительноеобразование"
            )
        ], "Студенту" :  [
            AGPUSubSectionModel(
                id: 0,
                name: "Личный кабинет ЭИОС",
                icon: "student",
                url: "http://plany.agpu.net/WebApp/#/",
                voiceCommand: "личный кабинет"
            ),
            AGPUSubSectionModel(
                id: 1,
                name: "Расписание занятий",
                icon: "student",
                url: "http://www.it-institut.ru/SearchString/Index/118",
                voiceCommand: "-"
            ),
            AGPUSubSectionModel(
                id: 2,
                name: "Институты/Факультеты и кафедры",
                icon: "student",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/index.php",
                voiceCommand: "кафедры"
            ),
            AGPUSubSectionModel(
                id: 3,
                name: "Кампус и общежития",
                icon: "student",
                url: "http://agpu.net/studentu/obshchezhitiya/index.php",
                voiceCommand: "кампусиобщежития"
            ),
            AGPUSubSectionModel(
                id: 4,
                name: "Студенческие клубы и организации, спорт и фитнес, культурная жизнь",
                icon: "student",
                url: "http://agpu.net/struktura-vuza/otdel-mpivd/index.php",
                voiceCommand: "спорт"
            ),
            AGPUSubSectionModel(
                id: 5,
                name: "Дополнительное образование",
                icon: "student",
                url: "https://niiro-agpu.ru/",
                voiceCommand: "дополнительноеобразование"
            ),
            AGPUSubSectionModel(
                id: 6,
                name: "Внутренние нормативные документы",
                icon: "student",
                url: "http://www.agpu.net/struktura-vuza/uapik/wnutrennie_dokumenti/index.php",
                voiceCommand: "внутренние нормативные документы"
            ),
            AGPUSubSectionModel(
                id: 7,
                name: "Карьера",
                icon: "student",
                url: "http://agpu.net/struktura-vuza/uapik/sodeystvie-trudoustroystvu/index.php",
                voiceCommand: "карьера"
            ),
            AGPUSubSectionModel(
                id: 8,
                name: "Библиотека",
                icon: "student",
                url: "http://www.agpu.net/struktura-vuza/biblioteka/index.php",
                voiceCommand: "библиотека"
            ),
            AGPUSubSectionModel(
                id: 9,
                name: "Психологическая служба",
                icon: "student",
                url: "http://agpu.net/PsychologicalService/index.php",
                voiceCommand: "психологическаяслужба"
            ),
            AGPUSubSectionModel(
                id: 10,
                name: "Профсоюз",
                icon: "student",
                url: "http://agpu.net/profsouz/index.php",
                voiceCommand: "профсоюз"
            ),
            AGPUSubSectionModel(
                id: 11,
                name: "Платные образовательные услуги",
                icon: "student",
                url: "http://agpu.net/sveden/paid_edu/index.php",
                voiceCommand: "платныеобразовательныеуслуги"
            ),
            AGPUSubSectionModel(
                id: 12,
                name: "Реквизиты",
                icon: "student",
                url: "http://agpu.net/contacts/requisites.php",
                voiceCommand: "реквизиты"
            )
        ], "Сотрудникам" : [
            AGPUSubSectionModel(
                id: 0,
                name: "Личный кабинет ЭИОС",
                icon: "student",
                url: "http://plany.agpu.net/WebApp/#/",
                voiceCommand: "личный кабинет"
            ),
            AGPUSubSectionModel(
                id: 1,
                name: "Расписание занятий",
                icon: "people",
                url: "http://www.it-institut.ru/SearchString/Index/118",
                voiceCommand: "-"
            ),
            AGPUSubSectionModel(
                id: 2,
                name: "Ведомости Online",
                icon: "people",
                url: "http://vedomosti.agpu.net/login",
                voiceCommand: "ведомости"
            ),
            AGPUSubSectionModel(
                id: 3,
                name: "Подразделения",
                icon: "people",
                url: "http://agpu.net/struktura-vuza/index.php",
                voiceCommand: "подразделени"
            ),
            AGPUSubSectionModel(
                id: 4,
                name: "Документы",
                icon: "people",
                url: "http://agpu.net/sveden/document/index.php",
                voiceCommand: "документы"
            ),
            AGPUSubSectionModel(
                id: 5,
                name: "Внутренние нормативные документы",
                icon: "people",
                url: "http://agpu.net/struktura-vuza/uapik/wnutrennie_dokumenti/index.php",
                voiceCommand: "внутренниенормативныедокументы"
            ),
            AGPUSubSectionModel(
                id: 6,
                name: "Информация отдела кадровой политики",
                icon: "people",
                url: "http://agpu.net/struktura-vuza/ukppsip/otdel-kadrovoy-politiki/index.php",
                voiceCommand: "информацияотделакадровойполитики"
            ),
            AGPUSubSectionModel(
                id: 7,
                name: "Профсоюз",
                icon: "people",
                url: "http://agpu.net/profsouz/index.php",
                voiceCommand: "профсоюз"
            ),
            AGPUSubSectionModel(
                id: 8,
                name: "Эффективный Университет",
                icon: "people",
                url: "http://www.agpu.net/struktura-vuza/uapik/EffectiveUniversity/index.php",
                voiceCommand: "эффективныйуниверситет"
            ),
            AGPUSubSectionModel(
                id: 9,
                name: "Информационная система мониторинга научных достижений преподавателей",
                icon: "people",
                url: "https://nir.it-institut.ru/",
                voiceCommand: "информационнаясистемамониторинганаучныхдостиженийпреподавателей"
            ),
            AGPUSubSectionModel(
                id: 10,
                name: "Психологическая служба",
                icon: "people",
                url: "http://agpu.net/PsychologicalService/index.php",
                voiceCommand: "психологическаяслужба"
            )
        ], "Наука" : [
            AGPUSubSectionModel(
                id: 0,
                name: "Диссертационные советы",
                icon: "science",
                url: "http://agpu.net/nauka/dissertation/index.php",
                voiceCommand: "диссертационныесоветы"
            ),
            AGPUSubSectionModel(
                id: 1,
                name: "Управление научно-исследовательской и инновационной деятельности",
                icon: "science",
                url: "http://agpu.net/struktura-vuza/uniind/index.php",
                voiceCommand: "инноваци"
            ),
            AGPUSubSectionModel(
                id: 2,
                name: "Отдел по подготовке кадров высшей квалификации",
                icon: "science",
                url: "http://agpu.net/nauka/aspirant/index.php",
                voiceCommand: "отделпоподготовкекадроввысшей квалификации"
            ),
            AGPUSubSectionModel(
                id: 3,
                name: "Научные лаборатории и центры",
                icon: "science",
                url: "http://agpu.net/nauka/NIR/index.php",
                voiceCommand: "лаборатори"
            ),
            AGPUSubSectionModel(
                id: 4,
                name: "Научные журналы",
                icon: "science",
                url: "http://agpu.net/nauka/Jurnaly/index.php",
                voiceCommand: "научныежурналы"
            ),
            AGPUSubSectionModel(
                id: 5,
                name: "Научные мероприятия",
                icon: "science",
                url: "http://agpu.net/nauka/konf/news.php",
                voiceCommand: "научныемероприятия"
            ),
            AGPUSubSectionModel(
                id: 6,
                name: "Совет молодых ученых",
                icon: "science",
                url: "http://agpu.net/nauka/SMU/index.php",
                voiceCommand: "советмолодыхучёных"
            ),
            AGPUSubSectionModel(
                id: 7,
                name: "Научное студенческое общество",
                icon: "science",
                url: "http://agpu.net/nauka/NSO/index.php",
                voiceCommand: "научноестуденческоеобщество"
            ),
            AGPUSubSectionModel(
                id: 8,
                name: "Редакционно-издательский отдел",
                icon: "science",
                url: "http://rits.agpu.net/",
                voiceCommand: "редакционноиздательскийотдел"
            )
        ], "Международная деятельность" : [
            AGPUSubSectionModel(
                id: 0,
                name: "Отдел международной деятельности",
                icon: "world",
                url: "http://agpu.net/struktura-vuza/otdel-mezhdunarodnoy-deyatelnosti/index.php",
                voiceCommand: "отделмеждународнойдеятельности"
            ),
            AGPUSubSectionModel(
                id: 1,
                name: "Центры открытого образования",
                icon: "world",
                url: "http://agpu.net/mezhdunarodnaya-deyatelnost/tsentry-otkrytogo-obrazovaniya/index.php",
                voiceCommand: "центрыоткрытогообразования"
            ),
            AGPUSubSectionModel(
                id: 2,
                name: "Информация для иностранных абитуриентов",
                icon: "world",
                url: "http://agpu.net/mezhdunarodnaya-deyatelnost/abiturient/index.php",
                voiceCommand: "информациядляиностранныхабитуриентов"
            ),
            AGPUSubSectionModel(
                id: 3,
                name: "Информация для иностранных студентов",
                icon: "world",
                url: "http://agpu.net/mezhdunarodnaya-deyatelnost/student/index.php",
                voiceCommand: "информациядляиностранныхстудентов"
            ),
            AGPUSubSectionModel(
                id: 4,
                name: "Международное сотрудничество",
                icon: "world",
                url: "http://agpu.net/mezhdunarodnaya-deyatelnost/sotrudnichestvo/index.php",
                voiceCommand: "международноесотрудничество"
            ),
            AGPUSubSectionModel(
                id: 5,
                name: "Программы обмена",
                icon: "world",
                url: "http://agpu.net/mezhdunarodnaya-deyatelnost/programmy-obmena/index.php",
                voiceCommand: "программыобмена"
            )
        ], "Безопасность" : [
            AGPUSubSectionModel(
                id: 0,
                name: "Сведения о доходах, об имуществе и обязательствах имущественного характера руководителя и членов его семьи",
                icon: "security",
                url: "http://agpu.net/struktura-vuza/otdel-bezopasnosti/DohodRukovod/index.php",
                voiceCommand: "сведенияодоходах"
            ),
            AGPUSubSectionModel(
                id: 1,
                name: "Противодействие коррупции",
                icon: "security",
                url: "http://agpu.net/struktura-vuza/otdel-bezopasnosti/protivodeystvie-korruptsii/index.php",
                voiceCommand: "коррупци"
            ),
            AGPUSubSectionModel(
                id: 2,
                name: "Противодействие экстремизму и терроризму",
                icon: "security",
                url: "http://agpu.net/struktura-vuza/otdel-bezopasnosti/protivodeystvie-ekstremizmu-i-terrorizmu/index.php",
                voiceCommand: "противодействиеэкстремизмуитерроризму"
            ),
            AGPUSubSectionModel(
                id: 3,
                name: "Профилактика наркомании и иных видов зависимостей",
                icon: "security",
                url: "http://agpu.net/struktura-vuza/otdel-bezopasnosti/profilaktika-narkomanii/index.php",
                voiceCommand: "профилактиканаркоманииииныхвидовзависимостей"
            ),
            AGPUSubSectionModel(
                id: 4,
                name: "Защита информации",
                icon: "security",
                url: "http://agpu.net/struktura-vuza/otdel-bezopasnosti/zashchita-informatsii/index.php",
                voiceCommand: "защитаинформации"
            ),
            AGPUSubSectionModel(
                id: 5,
                name: "Охрана труда",
                icon: "security",
                url: "http://agpu.net/struktura-vuza/otdel-okhrany-truda/index.php",
                voiceCommand: "охранатруда"
            ),
            AGPUSubSectionModel(
                id: 6,
                name: "Взаимодействие с правоохранительными органами",
                icon: "security",
                url: "http://agpu.net/struktura-vuza/otdel-bezopasnosti/vzaimodeystvie-s-pravookhranitelnymi/index.php",
                voiceCommand: "правоохранительнымиорганами"
            ),
            AGPUSubSectionModel(
                id: 7,
                name: "ГО и ЧС",
                icon: "security",
                url: "http://agpu.net/struktura-vuza/otdel-bezopasnosti/go-i-chs/index.php",
                voiceCommand: "гоичс"
            )
        ]
    ]
}
