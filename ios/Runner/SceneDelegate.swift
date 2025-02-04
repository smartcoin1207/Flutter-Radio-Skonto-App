import os.log
import CarPlay
import Flutter

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, CPApplicationDelegate {
    var window: UIWindow?
    var interfaceController: CPInterfaceController?
    var pendingMessages: [String] = []
    private var flutterViewController: FlutterViewController?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        os_log("SceneDelegate launched!")
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)

        flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window = window
        }

        window?.rootViewController = flutterViewController // Assign it to the window
        window?.makeKeyAndVisible()
        
        // let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        //     self.window = UIWindow(windowScene: windowScene)
        //     self.window?.rootViewController = flutterViewController
        //     self.window?.makeKeyAndVisible()

        //     // Set up Flutter method channel
        //     let channel = FlutterMethodChannel(name: "carplay_channel", binaryMessenger: flutterViewController.binaryMessenger)
        //     channel.setMethodCallHandler { [weak self] (call, result) in
        //         if call.method == "showMessage" {
        //             guard let args = call.arguments as? [String: String],
        //                   let message = args["message"] else {
        //                 result(FlutterError(code: "INVALID_ARGUMENTS", message: "Message is required", details: nil))
        //                 return
        //             }
        //             self?.showCarPlayMessage(message)
        //             result(nil)
        //         } else {
        //             result(FlutterMethodNotImplemented)
        //         }
        //     }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
            os_log("Scene disconnected!")
            interfaceController = nil
            flutterViewController = nil
        }

    func application(_ application: UIApplication, didConnectCarInterfaceController interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        os_log("CarPlay InterfaceController connected.")

        // ***KEY CHANGE***: Check if the Flutter view is loaded
        if let flutterView = flutterViewController?.viewIfLoaded {
            os_log("Flutter View Loaded, Proceed with CarPlay Setup")
            // Proceed with CarPlay setup using 'flutterView' if needed.
            // You can now safely interact with the Flutter engine.
            // Example (if needed by your flutter_carplay plugin):
            // let channel = FlutterMethodChannel(name: "carplay_channel", binaryMessenger: flutterViewController!.binaryMessenger)
            // ... your channel setup ...
        } else {
            os_log("Flutter View NOT YET Loaded, Handling pending messages")
            // Flutter view isn't loaded yet. Queue messages or perform other actions.
            for message in pendingMessages {
                showCarPlayMessage(message)
            }
            pendingMessages.removeAll()
            // Consider setting a flag or using a notification to know when the view loads.
        }
    }

    func application(_ application: UIApplication, didDisconnectCarInterfaceController interfaceController: CPInterfaceController, from window: CPWindow) {
        self.interfaceController = nil
        os_log("CarPlay InterfaceController disconnected.")
    }

    func showCarPlayMessage(_ message: String) {
        guard let interfaceController = self.interfaceController else {
            os_log("InterfaceController is nil. Queuing message: %@", message)
            pendingMessages.append(message)
            return
        }

        if #available(iOS 14.0, *) {
            let alertTemplate = CPAlertTemplate(titleVariants: [message], actions: [])
            interfaceController.presentTemplate(alertTemplate, animated: true, completion: nil)
            os_log("Message displayed on CarPlay: %@", message)
        } else {
            os_log("CarPlay templates are not supported on iOS versions earlier than 14.0.")
        }
    }
    
}
