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
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-ryalimip/index.php",
                address: "ул.Р.Люксембург, 159",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-ryalimip/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-ryalimip/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра иностранных языков и методики их преподавания",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/index.php",
                address: "ул. Р. Люксембург 159",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Институт прикладной информатики, математики и физики": [
            FacultyCathedraModel(
                name: "Кафедра математики, физики и методики их преподавания",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-mfimip/index.php",
                address: "ул. Р.Люксембург, 159",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-mfimip/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра информатики и информационных технологий обучения",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/index.php",
                address: "ул. Р. Люксембург 159",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Социально-психологический факультет": [
            FacultyCathedraModel(
                name: "Кафедра социальной, специальной педагогики и психологии",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-sspip/index.php",
                address: "ул. Ленина, 79",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-sspip/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-sspip/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра физической культуры и медико-биологических дисциплин",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-fkimbd/index.php",
                address: "ул. П. Осипенко, 83/1",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-fkimbd/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-fkimbd/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Факультет дошкольного и начального образования": [
            FacultyCathedraModel(
                name: "Кафедра теории, истории педагогики и образовательной практики",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-tipiop/index.php",
                address: "ул. Р. Люксембург 159",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-tipiop/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-tipiop/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра педагогики и технологий дошкольного и начального образования",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-pitdino/index.php",
                address: "ул. Р. Люксембург 159",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-pitdino/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-pitdino/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Факультет технологии, экономики и дизайна": [
            FacultyCathedraModel(
                name: "Кафедра технологии и дизайна",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-tid/index.php",
                address: "ул. Комсомольская, 93",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-tid/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-tid/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра экономики и управления",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-eiu/index.php",
                address: "ул. Комсомольская, 93",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-eiu/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-eiu/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
        
        "Исторический факультет": [
            FacultyCathedraModel(
                name: "Кафедра всеобщей и отечественной истории",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-vioi/index.php",
                address: "ул. Володарского 120б",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-vioi/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-vioi/dopolnitelnoe-obrazovanie/index.php"
            ),
            FacultyCathedraModel(
                name: "Кафедра философии, права и социально-гуманитарных наук",
                url: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-fpisgn/index.php",
                address: "ул. Володарского, д. 120 б",
                manualUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-fpisgn/MetodicheskoyeObespecheniye/index.php",
                additionalEducationUrl: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-fpisgn/dopolnitelnoe-obrazovanie/index.php"
            ),
        ],
    ]
}
