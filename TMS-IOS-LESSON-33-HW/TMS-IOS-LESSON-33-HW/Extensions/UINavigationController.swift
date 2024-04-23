import UIKit

extension UINavigationController {
  func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
    var vcs = viewControllers
    vcs[vcs.count - 1] = viewController
    setViewControllers(vcs, animated: animated)
  }
}
