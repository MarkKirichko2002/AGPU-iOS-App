//
//  AnimationClassProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2023.
//

import UIKit

protocol AnimationClassProtocol {
    func springAnimation<T: UIView>(view: T)
    func rotateAnimation<T: UIView>(view: T)
    func startRotateAnimation<T: UIView>(view: T)
    func stopRotateAnimation<T: UIView>(view: T)
    func tabBarItemAnimation(item: UITabBarItem)
    func flipAnimation<T: UIView>(view: T, completion: @escaping()->Void)
}
