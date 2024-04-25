import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        
        AuthService.shared.scheduledLogout() {
            self.navigationController?.replaceTopViewController(with: LoginViewController(), animated: false)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = String(localized: "MainViewController.Main")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let button = UIBarButtonItem(title: nil, image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), target: self, action: #selector(logout))
        button.tintColor = .systemCyan
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func logout() {
        AuthService.shared.logout {
            self.navigationController?.replaceTopViewController(with: LoginViewController(), animated: false)
        }
    }
}


