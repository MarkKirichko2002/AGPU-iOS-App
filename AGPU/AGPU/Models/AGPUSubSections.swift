//
//  AGPUSubSections.swift
//  AGPU
//
//  Created by Марк Киричко on 10.06.2023.
//

import Foundation

struct AGPUSubSections {
    static let subsections = [
        "Университет" : [
            AGPUSubSectionModel(name: "Ученый совет", icon: "", url: "http://test.agpu.net/struktura-vuza/uchenyy-sovet/index.php", voiceCommand: "учёный совет"),
            AGPUSubSectionModel(name: "Руководство. Педагогический(научно-педагогический состав) состав", icon: "", url: "http://test.agpu.net/sveden/employees/index.php", voiceCommand: "руководство"),
            AGPUSubSectionModel(name: "Институты и Факультеты", icon: "", url: "http://test.agpu.net/struktura-vuza/faculties-institutes/index.php", voiceCommand: "институты и факультеты"),
            AGPUSubSectionModel(name: "Структура университета/Подразделения", icon: "", url: "http://test.agpu.net/struktura-vuza/index.php", voiceCommand: "структура"),
            AGPUSubSectionModel(name: "Первичная профсоюзная организация", icon: "", url: "http://test.agpu.net/profsouz/index.php", voiceCommand: "профсоюзная организация"),
            AGPUSubSectionModel(name: "История ВУЗа", icon: "", url: "http://test.agpu.net/about/history.php", voiceCommand: "история"),
            AGPUSubSectionModel(name: "Миссия и ценности", icon: "", url: "http://test.agpu.net/contacts/missiya.php", voiceCommand: "миссия"),
            AGPUSubSectionModel(name: "Реквизиты", icon: "", url: "http://test.agpu.net/contacts/requisites.php", voiceCommand: "реквизиты"),
            AGPUSubSectionModel(name: "Контакты", icon: "", url: "http://test.agpu.net/contacts/index.php", voiceCommand: "контакты")
        ], "Абитуриенту" :  [
            AGPUSubSectionModel(name: "Личный кабинет абитуриента", icon: "", url: "http://abit.agpu.net/", voiceCommand: "личный кабинет абитуриента"),
            AGPUSubSectionModel(name: "Институты/Факультеты", icon: "", url: "http://test.agpu.net/abitur/faculties-institutes/index.php", voiceCommand: "институты факультеты"),
            AGPUSubSectionModel(name: "Информация для поступающих", icon: "", url: "http://priem.agpu.net/", voiceCommand: "информация для поступающих"),
            AGPUSubSectionModel(name: "Вопросы и ответы", icon: "", url: "http://priem.agpu.net/contact-form/Quest.php", voiceCommand: "вопросы и ответы"),
            AGPUSubSectionModel(name: "Дополнительное образование", icon: "", url: "https://niiro-agpu.ru/", voiceCommand: "дополнительное образование")
        ], "Студенту" :  [
            AGPUSubSectionModel(name: "Личный кабинет ЭИОС", icon: "", url: "http://plany.agpu.net/WebApp/#/", voiceCommand: "личный кабинет iOS"),
            AGPUSubSectionModel(name: "Расписание занятий", icon: "", url: "http://www.it-institut.ru/SearchString/Index/118", voiceCommand: "расписание"),
            AGPUSubSectionModel(name: "Институты/Факультеты и кафедры", icon: "", url: "http://test.agpu.net/struktura-vuza/faculties-institutes/index.php", voiceCommand: "кафедры"),
            AGPUSubSectionModel(name: "Кампус и общежития", icon: "", url: "http://test.agpu.net/studentu/obshchezhitiya/index.php", voiceCommand: "кампус и общежития"),
            AGPUSubSectionModel(name: "Студенческие клубы и организации, спорт и фитнес, культурная жизнь", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-mpivd/index.php", voiceCommand: "спорт"),
            AGPUSubSectionModel(name: "Дополнительное образование", icon: "", url: "https://niiro-agpu.ru/", voiceCommand: "дополнительное образование"),
            AGPUSubSectionModel(name: "Карьера", icon: "", url: "http://test.agpu.net/struktura-vuza/uapik/sodeystvie-trudoustroystvu/index.php", voiceCommand: "карьера"),
            AGPUSubSectionModel(name: "Психологическая служба", icon: "", url: "http://test.agpu.net/PsychologicalService/index.php", voiceCommand: "психолог"),
            AGPUSubSectionModel(name: "Профсоюз", icon: "", url: "http://test.agpu.net/profsouz/index.php", voiceCommand: "профсоюз"),
            AGPUSubSectionModel(name: "Платные образовательные услуги", icon: "", url: "http://test.agpu.net/sveden/paid_edu/index.php", voiceCommand: "платные образовательные услуги"),
            AGPUSubSectionModel(name: "Реквизиты", icon: "", url: "http://test.agpu.net/contacts/requisites.php", voiceCommand: "реквизиты")
        ], "Сотрудникам" : [
            AGPUSubSectionModel(name: "Личный кабинет ЭИОС", icon: "", url: "http://plany.agpu.net/WebApp/#/", voiceCommand: "личный кабинет iOS"),
            AGPUSubSectionModel(name: "Расписание занятий", icon: "", url: "http://www.it-institut.ru/SearchString/Index/118", voiceCommand: "расписание занятий"),
            AGPUSubSectionModel(name: "Ведомости Online", icon: "", url: "http://vedomosti.agpu.net/login", voiceCommand: "ведомости"),
            AGPUSubSectionModel(name: "Подразделения", icon: "", url: "http://test.agpu.net/struktura-vuza/index.php", voiceCommand: "подразделения"),
            AGPUSubSectionModel(name: "Документы", icon: "", url: "http://test.agpu.net/sveden/document/index.php", voiceCommand: "документы"),
            AGPUSubSectionModel(name: "Внутренние нормативные документы", icon: "", url: "http://test.agpu.net/struktura-vuza/uapik/wnutrennie_dokumenti/index.php", voiceCommand: "внутренние нормативные документы"),
            AGPUSubSectionModel(name: "Информация отдела кадровой политики", icon: "", url: "http://test.agpu.net/struktura-vuza/ukppsip/otdel-kadrovoy-politiki/index.php", voiceCommand: "информация отдела кадровой политики"),
            AGPUSubSectionModel(name: "Профсоюз", icon: "", url: "http://test.agpu.net/profsouz/index.php", voiceCommand: "профсоюз"),
            AGPUSubSectionModel(name: "Информационная система мониторинга научных достижений преподавателей", icon: "", url: "https://nir.it-institut.ru/", voiceCommand: "информационная система мониторинга научных достижений преподавателей"),
            AGPUSubSectionModel(name: "Психологическая служба", icon: "", url: "http://test.agpu.net/PsychologicalService/index.php", voiceCommand: "психолог")
        ], "Наука" : [
            AGPUSubSectionModel(name: "Диссертационные советы", icon: "", url: "http://test.agpu.net/nauka/dissertation/index.php", voiceCommand: "диссертационные советы"),
            AGPUSubSectionModel(name: "Управление научно-исследовательской и инновационной деятельности", icon: "", url: "http://test.agpu.net/struktura-vuza/uniind/index.php", voiceCommand: "инноваци"),
            AGPUSubSectionModel(name: "Отдел по подготовке кадров высшей квалификации", icon: "", url: "http://test.agpu.net/nauka/aspirant/index.php", voiceCommand: "отдел по подготовке кадров высшей квалификации"),
            AGPUSubSectionModel(name: "Научные лаборатории и центры", icon: "", url: "http://test.agpu.net/nauka/NIR/index.php", voiceCommand: "лаборатории"),
            AGPUSubSectionModel(name: "Научные журналы", icon: "", url: "http://test.agpu.net/nauka/Jurnaly/index.php", voiceCommand: "научные журналы"),
            AGPUSubSectionModel(name: "Научные мероприятия", icon: "", url: "http://test.agpu.net/nauka/konf/news.php", voiceCommand: "научные мероприятия"),
            AGPUSubSectionModel(name: "Совет молодых ученых", icon: "", url: "http://test.agpu.net/nauka/SMU/index.php", voiceCommand: "совет молодых ученых"),
            AGPUSubSectionModel(name: "Научное студенческое общество", icon: "", url: "http://test.agpu.net/nauka/NSO/index.php", voiceCommand: "научное студенческое общество")
        ], "Партнерам" : [
            AGPUSubSectionModel(name: "Взаимодействие с бизнесом и государством", icon: "", url: "http://test.agpu.net/partneram/vzaimodeystvie-s-biznesom-i-gosudarstvom.php", voiceCommand: "взаимодействие с бизнесом и государством"),
            AGPUSubSectionModel(name: "Научно-технические консультации", icon: "", url: "http://test.agpu.net/partneram/nauchno-tekhnicheskie-konsultatsii.php", voiceCommand: "научно технические консультации"),
            AGPUSubSectionModel(name: "Услуги для партнеров", icon: "", url: "http://test.agpu.net/partneram/uslugi-dlya-partnerov.php", voiceCommand: "услуги для партнеров")
        ], "Международная деятельность" : [
            AGPUSubSectionModel(name: "Отдел международной деятельности", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-mezhdunarodnoy-deyatelnosti/index.php", voiceCommand: "отдел международной деятельности"),
            AGPUSubSectionModel(name: "Информация для иностранных абитуриентов", icon: "", url: "http://test.agpu.net/mezhdunarodnaya-deyatelnost/abiturient/index.php", voiceCommand: "информация для иностранных абитуриентов"),
            AGPUSubSectionModel(name: "Информация для иностранных студентов", icon: "", url: "http://test.agpu.net/mezhdunarodnaya-deyatelnost/student/index.php", voiceCommand: "информация для иностранных студентов"),
            AGPUSubSectionModel(name: "Международное сотрудничество", icon: "", url: "http://test.agpu.net/mezhdunarodnaya-deyatelnost/sotrudnichestvo/index.php", voiceCommand: "международное сотрудничество"),
            AGPUSubSectionModel(name: "Программы обмена", icon: "", url: "http://test.agpu.net/mezhdunarodnaya-deyatelnost/programmy-obmena/index.php", voiceCommand: "программы обмена")
        ], "Безопасность" : [
            AGPUSubSectionModel(name: "Сведения о доходах, об имуществе и обязательствах имущественного характера руководителя и членов его семьи", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-bezopasnosti/DohodRukovod/index.php", voiceCommand: "сведения о доходах"),
            AGPUSubSectionModel(name: "Противодействие коррупции", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-bezopasnosti/protivodeystvie-korruptsii/index.php", voiceCommand: "коррупци"),
            AGPUSubSectionModel(name: "Противодействие экстремизму и терроризму", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-bezopasnosti/protivodeystvie-ekstremizmu-i-terrorizmu/index.php", voiceCommand: "противодействие экстремизму и терроризму"),
            AGPUSubSectionModel(name: "Профилактика наркомании и иных видов зависимостей", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-bezopasnosti/profilaktika-narkomanii/index.php", voiceCommand: "профилактика наркомании и иных видов зависимостей"),
            AGPUSubSectionModel(name: "Защита информации", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-bezopasnosti/zashchita-informatsii/index.php", voiceCommand: "защита информации"),
            AGPUSubSectionModel(name: "Охрана труда", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-okhrany-truda/index.php", voiceCommand: "охрана труда"),
            AGPUSubSectionModel(name: "Взаимодействие с правоохранительными органами", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-bezopasnosti/vzaimodeystvie-s-pravookhranitelnymi/index.php", voiceCommand: "правоохранительными органами"),
            AGPUSubSectionModel(name: "ГО и ЧС", icon: "", url: "http://test.agpu.net/struktura-vuza/otdel-bezopasnosti/go-i-chs/index.php", voiceCommand: "го и чс")
        ]
    ]
}
