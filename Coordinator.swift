import Foundation
import UIKit

protocol Coordinator
{
    var children: [Coordinator] { get set }
    var navController: UINavigationController { get set }
    
    func start()
}
