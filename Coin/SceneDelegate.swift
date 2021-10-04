import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appDependency = AppDependency()
    var coordinator: AppCoordinator?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let screen = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = screen
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator = AppCoordinator(navigationController: navigationController,
                                     dependency: .init(
                                        tabBarCoordinatorFactory: appDependency.makeTabBarCoordinator(navigation:),
                                        splashViewFactory: appDependency.makeSplashViewController))
        coordinator?.start()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        appDependency.socket.connect()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        appDependency.socket.disconnect()
    }
}
