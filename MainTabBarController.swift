import UIKit

class MainTabBarController: UITabBarController
{
    let _visualize = VisualizeCoordinator(navController: UINavigationController())
    let _decide = DecideCoordinator(navController: UINavigationController())

    override func viewDidLoad()
    {
        super.viewDidLoad()
        _visualize.start()
        _decide.start()
        viewControllers = [_decide.navController, _visualize.navController]
    }
    
}
