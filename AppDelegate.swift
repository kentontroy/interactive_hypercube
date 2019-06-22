import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        let assetSelectionView : UIView = {
            let colorView = UIView(frame: CGRect(x: 0, y: 0, width: AssetTableViewCell.width, height: AssetTableViewCell.height))
            let color = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 0.10)
            colorView.backgroundColor = color
            return colorView
        }()
        AssetTableViewCell.appearance().selectedBackgroundView = assetSelectionView
        
        return true
    }
    func applicationWillResignActive(_ application: UIApplication)
    {
    }
    func applicationDidEnterBackground(_ application: UIApplication)
    {
    }
    func applicationWillEnterForeground(_ application: UIApplication)
    {
    }
    func applicationDidBecomeActive(_ application: UIApplication)
    {
    }
    func applicationWillTerminate(_ application: UIApplication)
    {
    }


}

