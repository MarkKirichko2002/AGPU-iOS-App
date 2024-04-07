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
            cathedra: FacultyCathedraList.cathedra["Институт русской и иностранной филологии"]!,
            icon: "icon1",
            AppIcon: "AppIcon 1",
            abbreviation: "ИРиИФ",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/index.php",
            newsAbbreviation: "iriif",
            contactsURL: "http://www.agpu.net/struktura-vuza/faculties-institutes/iriif/kontakty/index.php",
            email: "markkir123@gmail.com",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 2,
            name: "Институт прикладной информатики, математики и физики",
            cathedra: FacultyCathedraList.cathedra["Институт прикладной информатики, математики и физики"]!,
            icon: "icon2",
            AppIcon: "AppIcon 2",
            abbreviation: "ИПИМиФ",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/index.php",
            newsAbbreviation: "ipimif",
            contactsURL: "http://www.agpu.net/struktura-vuza/faculties-institutes/ipimif/kontakty/index.php",
            email: "ipimif2011@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 3,
            name: "Социально-психологический факультет",
            cathedra: FacultyCathedraList.cathedra["Социально-психологический факультет"]!,
            icon: "icon3",
            AppIcon: "AppIcon 3",
            abbreviation: "СПФ",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/spf/index.php",
            newsAbbreviation: "spf",
            contactsURL: "http://www.agpu.net/struktura-vuza/faculties-institutes/spf/kontakty/index.php",
            email: "pedfak_agpu@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 4,
            name: "Факультет дошкольного и начального образования",
            cathedra: FacultyCathedraList.cathedra["Факультет дошкольного и начального образования"]!,
            icon: "icon4",
            AppIcon: "AppIcon 4",
            abbreviation: "ФДиНО",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/index.php",
            newsAbbreviation: "fdino",
            contactsURL: "http://www.agpu.net/struktura-vuza/faculties-institutes/fdino/kontakty/index.php",
            email: "dekanat_fdino@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 5,
            name: "Факультет технологии, экономики и дизайна",
            cathedra: FacultyCathedraList.cathedra["Факультет технологии, экономики и дизайна"]!,
            icon: "icon5",
            AppIcon: "AppIcon 5",
            abbreviation: "ФТЭиД",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/index.php",
            newsAbbreviation: "fteid",
            contactsURL: "http://www.agpu.net/struktura-vuza/faculties-institutes/fteid/kontakty/index.php",
            email: "dekanat.tekhfak@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 6,
            name: "Исторический факультет",
            cathedra: FacultyCathedraList.cathedra["Исторический факультет"]!,
            icon: "icon6",
            AppIcon: "AppIcon 6",
            abbreviation: "ИстФак",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/index.php",
            newsAbbreviation: "istfak",
            contactsURL: "http://www.agpu.net/struktura-vuza/faculties-institutes/istfak/kontakty/index.php",
            email: "markkir123@gmail.com",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 7,
            name: "Научно-исследовательский институт развития образования",
            cathedra: [],
            icon: "АГПУ",
            AppIcon: "AppIcon",
            abbreviation: "НИИРО",
            url: "https://niiro-agpu.ru/",
            newsAbbreviation: "-",
            contactsURL: "",
            email: "NIIRO_AGPU@mail.ru",
            isSelected: false
        )
    ]
}
