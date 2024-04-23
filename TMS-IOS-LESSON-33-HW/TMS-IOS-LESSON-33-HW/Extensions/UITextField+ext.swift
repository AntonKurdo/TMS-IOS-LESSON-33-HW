import UIKit

extension UITextField {
    convenience init(placeholder: String) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        self.placeholder = placeholder
        autocapitalizationType = .none
        autocorrectionType = .no
        leftView = UIView(frame: CGRectMake(0, 0, 12, 0))
        leftViewMode = .always
    }
    
    func shake(count : Float = 3,for duration : TimeInterval = 0.2, withTranslation translation : Float = 5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        
        let prevColor = layer.borderColor
        layer.borderColor = UIColor.red.cgColor
        layer.add(animation, forKey: "shake")
        
        DispatchQueue.main.asyncAfter(deadline:.now() + duration) {
            UIView.animate(withDuration: 1) {
                self.layer.borderColor = prevColor
            }
        }
    }
}
