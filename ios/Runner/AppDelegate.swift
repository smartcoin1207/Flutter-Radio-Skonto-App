import UIKit
import Flutter
import flutter_downloader
import os.log
import CarPlay

// Create a shared Flutter Engine instance
let flutterEngine = FlutterEngine(name: "SharedEngine", project: nil, allowHeadlessExecution: true)

@main
@objc class AppDelegate: FlutterAppDelegate, CPApplicationDelegate {
    var flutterEngineOne: FlutterEngine?
    var interfaceController: CPInterfaceController?
    var pendingMessages: [String] = []  // Store messages for CarPlay

    // Application did finish launching
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Run the Flutter engine
        flutterEngine.run()
        
        // Store the flutter engine reference
        flutterEngineOne = flutterEngine
        
        // Register Flutter plugins
        GeneratedPluginRegistrant.register(with: flutterEngine)
        FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
        
        os_log("AppDelegate launched!")
        
        return true
    }

    // Handle CarPlay Interface Controller connection
    func application(_ application: UIApplication, didConnectCarInterfaceController interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        os_log("CarPlay InterfaceController connected.")

        // Show pending messages when CarPlay is connected
        for message in pendingMessages {
            showCarPlayMessage(message)
        }
        pendingMessages.removeAll()  // Clear pending messages
    }
    
    // Handle CarPlay Interface Controller disconnection
    func application(_ application: UIApplication, didDisconnectCarInterfaceController interfaceController: CPInterfaceController, from window: CPWindow) {
        self.interfaceController = nil
        os_log("CarPlay InterfaceController disconnected.")
    }

    // Show message on CarPlay
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

    // Handle application did become active (for CarPlay re-initialization)
    override func applicationDidBecomeActive(_ application: UIApplication) {
        if let controller = self.interfaceController {
            os_log("CarPlay InterfaceController is active: %@", controller)
        }
    }
}

// Plugin registration for Flutter Downloader
private func registerPlugins(registry: FlutterPluginRegistry) {
    // Register the FlutterDownloaderPlugin if not already registered
    if !registry.hasPlugin("FlutterDownloaderPlugin") {
        FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
