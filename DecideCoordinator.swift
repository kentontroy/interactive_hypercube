import UIKit

class DecideCoordinator: Coordinator
{
    var children = [Coordinator]()
    var navController: UINavigationController
    
    init(navController: UINavigationController)
    {
        self.navController = navController
    }
    func start()
    {
        let vc = AssetViewController.instantiate()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        vc._coordinator = self
        self.navController.pushViewController(vc, animated: false)
    }
}



/*
www.quandl.com
www.quandl.com/tools/python
*/
