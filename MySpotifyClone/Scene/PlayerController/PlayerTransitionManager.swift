//
//  PlayerTransitionManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 14.03.26.
//

import UIKit

class PlayerTransitionManager: NSObject {
    
    private weak var viewController: UIViewController?
    
    /// Dismiss tamamlananda çağırılır (mini player göstərmək üçün)
    var onDismissCompleted: (() -> Void)?
    
    // Pan gesture başlayanda view-un orijinal frame-i
    private var originalFrame: CGRect = .zero
    
    /// PlayerController-in view-una pan gesture əlavə edir
    func attach(to viewController: UIViewController) {
        self.viewController = viewController
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        viewController.view.addGestureRecognizer(pan)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let vc = viewController, let view = vc.view else { return }
        
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
            
        case .began:
            // Başlanğıc frame-i yadda saxla
            originalFrame = view.frame
            
        case .changed:
            // Yalnız aşağı hərəkətə icazə ver (yuxarı getməsin)
            let offsetY = max(0, translation.y)
            view.frame = originalFrame.offsetBy(dx: 0, dy: offsetY)
            
            // Sürüşdürdikcə küncləri yumruqla
            let progress = offsetY / view.bounds.height
            view.layer.cornerRadius = min(progress * 80, 16)
            
            // Arxa plan bir az görünsün deyə alpha azalt
            let alpha = 1.0 - (progress * 0.2)
            view.alpha = max(0.8, alpha)
            
        case .ended, .cancelled:
            let offsetY = max(0, translation.y)
            let progress = offsetY / view.bounds.height
            
            // Dismiss şərti: 30%-dən çox sürüşdürüb VƏ YA sürətli swipe
            if progress > 0.3 || velocity.y > 800 {
                // DISMISS — aşağı sürüşdür və dismiss et
                let remainingDistance = view.bounds.height - offsetY
                let duration = max(0.15, min(0.35, Double(remainingDistance / max(1, velocity.y))))
                
                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: .curveEaseOut
                ) {
                    view.frame = self.originalFrame.offsetBy(dx: 0, dy: view.bounds.height)
                    view.alpha = 0.8
                } completion: { _ in
                    vc.dismiss(animated: false) { [weak self] in
                        self?.onDismissCompleted?()
                    }
                }
                
            } else {
                // GERİ QAYIT — dismiss etmə, yerə qaytar
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.85,
                    initialSpringVelocity: 0.5,
                    options: .curveEaseOut
                ) {
                    view.frame = self.originalFrame
                    view.layer.cornerRadius = 0
                    view.alpha = 1.0
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension PlayerTransitionManager: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let velocity = pan.velocity(in: pan.view)
        // Yalnız aşağı + şaquli hərəkətdə işləsin
        // (slider sürüşdürmə ilə conflict olmasın)
        return velocity.y > 0 && abs(velocity.y) > abs(velocity.x)
    }
}
