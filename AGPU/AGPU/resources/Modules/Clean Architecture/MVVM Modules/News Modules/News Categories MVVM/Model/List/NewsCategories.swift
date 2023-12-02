//
//  NewsCategories.swift
//  AGPU
//
//  Created by Марк Киричко on 17.08.2023.
//

import Foundation

struct NewsCategories {
    
    static var categories = [
        
        NewsCategoryModel(
            id: 0,
            name: "АГПУ",
            newsAbbreviation: "",
            icon: "новый год",
            pagesCount: 0
        ),
        NewsCategoryModel(
            id: 1,
            name: "ИРиИФ",
            newsAbbreviation: "iriif",
            icon: "icon1",
            pagesCount: 0
        ),
        NewsCategoryModel(
            id: 2,
            name: "ИПИМиФ",
            newsAbbreviation: "ipimif",
            icon: "icon2",
            pagesCount: 0
        ),
        NewsCategoryModel(
            id: 3,
            name: "СПФ",
            newsAbbreviation: "spf",
            icon: "icon3",
            pagesCount: 0
        ),
        NewsCategoryModel(
            id: 4,
            name: "ФДиНО",
            newsAbbreviation: "fdino",
            icon: "icon4",
            pagesCount: 0
        ),
        NewsCategoryModel(
            id: 5,
            name: "ФТЭиД",
            newsAbbreviation: "fteid",
            icon: "icon5",
            pagesCount: 0
        ),
        NewsCategoryModel(
            id: 6,
            name: "ИстФак",
            newsAbbreviation: "istfak",
            icon: "icon6",
            pagesCount: 0
        )
    ]
}
