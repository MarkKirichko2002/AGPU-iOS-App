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
            abbreviation: "ИРиИФ",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/iriif/index.php",
            newsAbbreviation: "iriif",
            videoURL: "http://priem.agpu.net/video/stud/iriif.mp4",
            contacts: [],
            email: "markkir123@gmail.com",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 2,
            name: "Институт прикладной информатики, математики и физики",
            cathedra: FacultyCathedraList.cathedra["Институт прикладной информатики, математики и физики"]!,
            icon: "icon2",
            abbreviation: "ИПИМиФ",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/ipimif/index.php",
            newsAbbreviation: "ipimif",
            videoURL: "http://priem.agpu.net/video/stud/ipimif.mp4",
            contacts: [
                ContactsModel(
                    name: "-",
                    degree: "-",
                    phoneNumber: "+7(861)373-35-17"
                ),
                ContactsModel(
                    name: "-",
                    degree: "-",
                    phoneNumber: "+7(953)118-02-41"
                )
            ],
            email: "ipimif2011@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 3,
            name: "Социально-психологический факультет",
            cathedra: FacultyCathedraList.cathedra["Социально-психологический факультет"]!,
            icon: "icon3",
            abbreviation: "СПФ",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/spf/index.php",
            newsAbbreviation: "spf",
            videoURL: "http://priem.agpu.net/video/stud/spf.mp4",
            contacts: [
                ContactsModel(
                    name: "-",
                    degree: "специалист по учебно-методической работе",
                    phoneNumber: "+7(989)276-17-86"
                ),
                ContactsModel(
                    name: "Костенко Анаид Арсеновна",
                    degree: "декан социально-психологического факультета, кандидат психологических наук, доцент",
                    phoneNumber: "+7(918)384-97-79"
                ),
                ContactsModel(
                    name: "Алдакимова Ольга Викторовна",
                    degree: "заместитель декана по учебной работе",
                    phoneNumber: "+7(918)405-38-20"
                ),
                ContactsModel(
                    name: "Ромашина Елена Владимировна",
                    degree: "заместитель декана по воспитательной работе",
                    phoneNumber: "+7(918)154-31-23"
                ),
                ContactsModel(
                    name: "Клюковкина Олеся Александровна",
                    degree: "диспетчер очной и очно-заочной формы обучения",
                    phoneNumber: "+7(918)171-13-19"
                ),
                ContactsModel(
                    name: "Хачатурова Диана Александровна",
                    degree: "cпециалист по учебно-методической работе заочной формы обучения бакалавриата",
                    phoneNumber: "+7(989)276-17-86"
                ),
                ContactsModel(
                    name: "Михаилян Наталья Евгеньевна",
                    degree: "специалист по учебно-методической работе заочной формы обучения магистратуры",
                    phoneNumber: "+7(960)477-04-49"
                ),
            ],
            email: "pedfak_agpu@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 4,
            name: "Факультет дошкольного и начального образования",
            cathedra: FacultyCathedraList.cathedra["Факультет дошкольного и начального образования"]!,
            icon: "icon4",
            abbreviation: "ФДиНО",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/fdino/index.php",
            newsAbbreviation: "fdino",
            videoURL: "http://priem.agpu.net/video/stud/fdino.mp4",
            contacts: [
                ContactsModel(
                    name: "деканат",
                    degree: "-",
                    phoneNumber: "+7(861)373-32-64"
                )
            ],
            email: "dekanat_fdino@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 5,
            name: "Факультет технологии, экономики и дизайна",
            cathedra: FacultyCathedraList.cathedra["Факультет технологии, экономики и дизайна"]!,
            icon: "icon5",
            abbreviation: "ФТЭиД",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/fteid/index.php",
            newsAbbreviation: "fteid",
            videoURL: "http://priem.agpu.net/video/stud/fteid.mp4",
            contacts: [
                ContactsModel(
                    name: "Мукучян Размон Рубенович",
                    degree: "декан факультета",
                    phoneNumber: "8(861)372-80-94"
                ),
                ContactsModel(
                    name: "Мукучян Размон Рубенович",
                    degree: "декан факультета",
                    phoneNumber: "8(861)372-82-17"
                )
            ],
            email: "dekanat.tekhfak@mail.ru",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 6,
            name: "Исторический факультет",
            cathedra: FacultyCathedraList.cathedra["Исторический факультет"]!,
            icon: "icon6",
            abbreviation: "ИстФак",
            url: "http://agpu.net/struktura-vuza/faculties-institutes/istfak/index.php",
            newsAbbreviation: "istfak",
            videoURL: "http://priem.agpu.net/video/stud/istfak.mp4",
            contacts: [],
            email: "markkir123@gmail.com",
            isSelected: false
        ),
        AGPUFacultyModel(
            id: 7,
            name: "Научно-исследовательский институт развития образования",
            cathedra: [],
            icon: "АГПУ",
            abbreviation: "НИИРО",
            url: "https://niiro-agpu.ru/",
            newsAbbreviation: "",
            videoURL: "",
            contacts: [
                ContactsModel(
                    name: "-",
                    degree: "-",
                    phoneNumber: "8(86137)3-85-04"
                )
            ],
            email: "NIIRO_AGPU@mail.ru",
            isSelected: false
        )
    ]
}
