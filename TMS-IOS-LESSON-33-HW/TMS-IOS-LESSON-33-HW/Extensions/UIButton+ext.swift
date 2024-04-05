import UIKit

extension UIButton {
    convenience init(title: String, color: UIColor? ) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = color ?? .blue
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
    }
    
    func loadingIndicator(_ show: Bool) {
        let tag = 1
        if show {
            self.setTitle("", for: .disabled)
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.tag = tag
            self.addSubview(indicator)
          
            NSLayoutConstraint.activate([
                indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
            indicator.color = .black
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
