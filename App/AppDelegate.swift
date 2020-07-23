import MetroKit
import SwiftUI
import Intents

@UIApplicationMain
final class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let (dataStore, preferences) = AppFactory.loadDataStores()
        let viewModel = RootViewModel(dataStore: dataStore, preferences: preferences)

        let contentView = RootView(viewModel: viewModel)
            .accentColor(.metroCardOrange)
            .environmentObject(ToastQueue())

        let hostingController = UIHostingController(rootView: contentView)
        hostingController.overrideUserInterfaceStyle = .dark

        UIScrollView.appearance(whenContainedInInstancesOf: [type(of: hostingController)])
            .backgroundColor = .contentBackground

        self.window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = hostingController
            return window
        }()

        window?.makeKeyAndVisible()
        return true
    }
}
