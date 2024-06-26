import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let viewModel = CalculatorViewModel()
        viewModel.brain = CalculatorBrain()

        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: Constants.storyboardId) { coder in
            ViewController(coder: coder, viewModel: viewModel)
        }
        
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
