//
//  CustomSplashScreenModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.02.2024.
//

import RealmSwift

class CustomSplashScreenModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var image: Data?
    @Persisted var title: String
}
