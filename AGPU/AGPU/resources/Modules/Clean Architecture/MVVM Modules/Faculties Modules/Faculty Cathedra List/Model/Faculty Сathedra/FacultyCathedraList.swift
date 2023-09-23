//
//  FacultyCathedraList.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import Foundation

struct FacultyCathedraList {
    
    static let cathedra = [
        
        "Институт русской и иностранной филологии": [
            FacultyCathedraModel(
                name: "Кафедра русского языка, литературы и методики их преподавания",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-ryalimip/index.php",
                address: "ул.Р.Люксембург, 159, главн. корпус ФГБОУ ВО АГПУ, ауд.№3",
                coordinates: [
                    45.001817,
                    41.132393
                ],
                email: "ofizh@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-ryalimip/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-ryalimip/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-ryalimip/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра иностранных языков и методики их преподавания",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/index.php",
                address: "ул. Р. Люксембург 159, кабинет №12",
                coordinates: [
                    45.001817,
                    41.132393
                ],
                email: "angl_kaf_agpu@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Институт прикладной информатики, математики и физики": [
            FacultyCathedraModel(
                name: "Кафедра математики, физики и методики их преподавания",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-mfimip/index.php",
                address: "ул. Р.Люксембург, 159, ауд. 17",
                coordinates: [
                    45.001817,
                    41.132393
                ],
                email: "arctgx@yandex.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-mfimip/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-mfimip/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра информатики и информационных технологий обучения",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/index.php",
                address: "ул. Р. Люксембург 159, кабинет №13",
                coordinates: [
                    45.001817,
                    41.132393
                ],
                email: "agpu_kaf_inf@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Социально-психологический факультет": [
            FacultyCathedraModel(
                name: "Кафедра социальной, специальной педагогики и психологии",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-sspip/index.php",
                address: "ул. Ленина, 79",
                coordinates: [
                    45.002263,
                    41.121873
                ],
                email: "sspp2010@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-sspip/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-sspip/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-sspip/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра физической культуры и медико-биологических дисциплин",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-fkimbd/index.php",
                address: "ул. П. Осипенко, 83/1",
                coordinates: [
                    45.006374,
                    41.128629
                ],
                email: "andrmaz@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-fkimbd/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-fkimbd/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-fkimbd/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Факультет дошкольного и начального образования": [
            FacultyCathedraModel(
                name: "Кафедра теории, истории педагогики и образовательной практики",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-tipiop/index.php",
                address: "ул. Р. Люксембург 159, 2 этаж, кабинет №15",
                coordinates: [
                    45.001817,
                    41.132393
                ],
                email: "kaf_tipiop@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-tipiop/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-tipiop/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-tipiop/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра педагогики и технологий дошкольного и начального образования",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-pitdino/index.php",
                address: "ул. Р. Люксембург 159, 2 этаж, кабинет №14",
                coordinates: [
                    45.001817,
                    41.132393
                ],
                email: "kaf_pitdino@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-pitdino/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-pitdino/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-pitdino/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Факультет технологии, экономики и дизайна": [
            FacultyCathedraModel(
                name: "Кафедра технологии и дизайна",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-tid/index.php",
                address: "ул. Комсомольская, 93, кабинет 55а",
                coordinates: [
                    45.003697,
                    41.122763
                ],
                email: "agpu_ofap@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-tid/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-tid/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-tid/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра экономики и управления",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-eiu/index.php",
                address: "ул. Комсомольская, 93",
                coordinates: [
                    45.003697,
                    41.122763
                ],
                email: "pshmahova_m@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-eiu/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-eiu/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-eiu/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Исторический факультет": [
            FacultyCathedraModel(
                name: "Кафедра всеобщей и отечественной истории",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-vioi/index.php",
                address: "ул. Володарского 120б",
                coordinates: [
                    44.989082,
                    41.126904
                ],
                email: "kvioi-agpu@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-vioi/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-vioi/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-vioi/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра философии, права и социально-гуманитарных наук",
                url: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-fpisgn/index.php",
                address: "ул. Володарского, д. 120б",
                coordinates: [
                    44.989082,
                    41.126904
                ],
                email: "kaffilosof@mail.ru",
                staffUrl: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-fpisgn/sostav-kafedry/index.php",
                manualUrl: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-fpisgn/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-fpisgn/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
    ]
}
