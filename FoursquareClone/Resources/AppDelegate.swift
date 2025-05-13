import UIKit
import ParseCore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

            // 🔐 Gizli key'leri plist'ten oku
            guard
                let path = Bundle.main.path(forResource: "secrets", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: path),
                let appID = dict["ParseAppID"] as? String,
                let clientKey = dict["ParseClientKey"] as? String,
                let server = dict["ParseServer"] as? String
            else {
                fatalError("❌ Secrets.plist okunamadı!")
            }

            let configuration = ParseClientConfiguration { config in
                config.applicationId = appID
                config.clientKey = clientKey
                config.server = server
            }
            Parse.initialize(with: configuration)

            return true
        }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

