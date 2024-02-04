//
//  AnimationClass + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import UIKit

// MARK: - AnimationClassProtocol
extension AnimationClass: AnimationClassProtocol {
    
    // пружинная анимация
    func springAnimation<T: UIView>(view: T) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 300
        animation.mass = 1
        animation.duration = 0.5
        animation.beginTime = CACurrentMediaTime() + 0
        view.layer.add(animation, forKey: nil)
    }
    
    // анимация вращения
    func rotateAnimation<T: UIView>(view: T) {
        rotationAnimation.toValue = NSNumber(value: 180)
        view.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    // начать анимацию вращения
    func startRotateAnimation<T: UIView>(view: T) {
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotationAnimation.duration = 2.0;
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = .infinity;
        view.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    // завершить анимацию вращения
    func stopRotateAnimation<T: UIView>(view: T) {
        view.layer.removeAnimation(forKey: "rotationAnimation")
    }
   
    // анимация TabBarItem
    func tabBarItemAnimation(item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        let timeInterval: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 1.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
        HapticsManager.shared.hapticFeedback()
    }
   
    // анимация переворота
    func flipAnimation<T: UIView>(view: T, completion: @escaping()->Void) {
        UIView.transition(
            with: view,
            duration: 0.5,
            options: .transitionFlipFromRight,
            animations: {},
            completion: { finished in
                if finished {
                    completion()
                }
            }
        )
    }
}
