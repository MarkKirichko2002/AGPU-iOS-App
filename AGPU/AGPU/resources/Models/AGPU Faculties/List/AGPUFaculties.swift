//
//  AGPUFaculties.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import Foundation

struct AGPUFaculties {
    static let faculties = [
        AGPUFacultyModel(
            id: 1,
            name: "Институт русской и иностранной филологии",
            cathedra: [
                FacultyCathedraModel(
                    name: "Кафедра русского языка, литературы и методики их преподавания",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-ryalimip/index.php"
                ),
                FacultyCathedraModel(
                    name: "Кафедра иностранных языков и методики их преподавания",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/kafedra-iyaimip/index.php"
                ),
            ],
            icon: "icon1",
            abbreviation: "ИРиИФ",
            appIcon: "AppIcon 1",
            url: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/index.php",
            newsURL: "http://test.agpu.net/struktura-vuza/faculties-institutes/iriif/news/news.php",
            videoURL: "http://priem.agpu.net/video/stud/iriif.mp4",
            phoneNumbers: ["89883610402"],
            email: "markkir123@gmail.com",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 2,
            name: "Институт прикладной информатики, математики и физики",
            cathedra: [
                FacultyCathedraModel(
                    name: "Кафедра математики, физики и методики их преподавания",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-mfimip/index.php"
                ),
                FacultyCathedraModel(
                    name: "Кафедра информатики и информационных технологий обучения",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/index.php"
                ),
            ],
            icon: "icon2",
            abbreviation: "ИПИМиФ",
            appIcon:  "AppIcon 2",
            url: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/index.php",
            newsURL: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/news/news.php",
            videoURL: "http://priem.agpu.net/video/stud/ipimif.mp4",
            phoneNumbers: ["89883610402"],
            email: "markkir123@gmail.com",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 3,
            name: "Социально-психологический факультет",
            cathedra: [
                FacultyCathedraModel(
                    name: "Кафедра социальной, специальной педагогики и психологии",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-sspip/index.php"
                ),
                FacultyCathedraModel(
                    name: "Кафедра физической культуры и медико-биологических дисциплин",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/kafedra-fkimbd/index.php"
                ),
            ],
            icon: "icon3",
            abbreviation: "СПФ",
            appIcon:  "AppIcon 3",
            url: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/index.php",
            newsURL: "http://test.agpu.net/struktura-vuza/faculties-institutes/spf/news/news.php",
            videoURL: "http://priem.agpu.net/video/stud/spf.mp4",
            phoneNumbers: ["88613737994", "89892761786"],
            email: "pedfak_agpu@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 4,
            name: "Факультет дошкольного и начального образования",
            cathedra: [
                FacultyCathedraModel(
                    name: "Кафедра теории, истории педагогики и образовательной практики",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-tipiop/index.php"
                ),
                FacultyCathedraModel(
                    name: "Кафедра педагогики и технологий дошкольного и начального образования",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/kafedra-pitdino/index.php"
                ),
            ],
            icon: "icon4",
            abbreviation: "ФДиНО",
            appIcon:  "AppIcon 4",
            url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/index.php",
            newsURL: "http://test.agpu.net/struktura-vuza/faculties-institutes/fdino/news/news.php",
            videoURL: "http://priem.agpu.net/video/stud/fdino.mp4",
            phoneNumbers: ["88613733264"],
            email: "dekanat_fdino@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 5,
            name: "Факультет технологии, экономики и дизайна",
            cathedra: [
                FacultyCathedraModel(
                    name: "Кафедра технологии и дизайна",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-tid/index.php"
                ),
                FacultyCathedraModel(
                    name: "Кафедра экономики и управления",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/kafedra-eiu/index.php"
                ),
            ],
            icon: "icon5",
            abbreviation: "ФТЭиД",
            appIcon:  "AppIcon 5",
            url: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/index.php",
            newsURL: "http://test.agpu.net/struktura-vuza/faculties-institutes/fteid/news/news.php",
            videoURL: "http://priem.agpu.net/video/stud/fteid.mp4",
            phoneNumbers: ["88613728094", "88613728217"],
            email: "dekanat.tekhfak@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 6,
            name: "Исторический факультет",
            cathedra: [
                FacultyCathedraModel(
                    name: "Кафедра всеобщей и отечественной истории",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-vioi/index.php"
                ),
                FacultyCathedraModel(
                    name: "Кафедра философии, права и социально-гуманитарных наук",
                    url: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/kafedra-fpisgn/index.php"
                ),
            ],
            icon: "icon6",
            abbreviation: "ИстФак",
            appIcon:  "AppIcon 6",
            url: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/index.php",
            newsURL: "http://test.agpu.net/struktura-vuza/faculties-institutes/istfak/news/news.php",
            videoURL: "http://priem.agpu.net/video/stud/istfak.mp4",
            phoneNumbers: ["89883610402"],
            email: "markkir123@gmail.com",
            isSelected: false
        )
    ]
}
