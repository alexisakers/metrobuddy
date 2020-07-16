import MetroKit
import SwiftUI

@UIApplicationMain
final class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let groupID = Bundle.main.infoValue(forKey: AppGroupNameInfoPlistKey.self)!
        
        let dataStore = try! PersistentMetroCardDataStore(
            persistentStore: .onDisk(
                .securityGroupContainer(id: groupID, path: ["Path"])
            ),
            useCloudKit: true
        )
                
        let viewModel = RootViewModel(dataStore: dataStore, preferences: UserDefaults.standard)
        let contentView = RootView(viewModel: viewModel)
            .accentColor(.metroCardOrange)
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
