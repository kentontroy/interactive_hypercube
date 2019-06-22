import UIKit

class VisualizeCoordinator: Coordinator
{
    var children = [Coordinator]()
    var navController: UINavigationController
    
    init(navController: UINavigationController)
    {
        self.navController = navController
    }
    func start()
    {
        let vc = CubeViewController.instantiate()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        vc._coordinator = self
        self.navController.pushViewController(vc, animated: false)
    }
    func sliceGridFromCube(slice: HyperCubeFace)
    {
        let vc = GridViewController.instantiate()
        vc._coordinator = self
        vc._face = slice
        self.navController.pushViewController(vc, animated: true)
    }
}
