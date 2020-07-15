import MetroKit
import SwiftUI

@UIApplicationMain
final class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let dataStore = try! PersistentMetroCardDataStore(
            persistentStore: .onDisk(.documentsFolder(path: ["Data"])),
            useCloudKit: false
        )
                
        let viewModel = RootViewModel(dataStore: dataStore, preferences: UserDefaults.standard)
        let contentView = RootView(viewModel: viewModel)
            .accentColor(Color("MetroCardOrange"))
            .environmentObject(ToastQueue())
        
        let hostingController = UIHostingController(rootView: contentView)
        hostingController.overrideUserInterfaceStyle = .dark
        
        self.window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = hostingController
            return window
        }()

        window?.makeKeyAndVisible()
        return true
    }
}
