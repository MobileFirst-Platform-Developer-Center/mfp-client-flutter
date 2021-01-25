import Flutter
import IBMMobileFirstPlatformFoundation
import UIKit

public class SwiftMobilefoundationPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let wlClientChannel = FlutterMethodChannel(name: "wlclient", binaryMessenger: registrar.messenger())
        let wlAuthorizationManagerChannel = FlutterMethodChannel(name: "wlauthorizationmanager", binaryMessenger: registrar.messenger())
        let wlResourceRequestChannel = FlutterMethodChannel(name: "wlresourcerequest", binaryMessenger: registrar.messenger())
        let loggerChannel = FlutterMethodChannel(name:"logger",binaryMessenger:registrar.messenger())
        
        // Implement a "challengeHandlerEvent" EventChannel to invoke challenge handler methods in dart platform when one of the challenge handler methods of MFSecurityCheckChallengeHandler class is been called.
        let eventChannel = FlutterEventChannel(name: "challengeHandlerEvent", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(ChallengeHandlerStreamHandler())
        
        wlClientChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            WLClientMethodHandler.shared.handle(call: call, result: result)
        })
        wlAuthorizationManagerChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            WLAuthorizationManagerMethodHandler.shared.handle(call: call, result: result)
        })
        wlResourceRequestChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            WLResourceRequestMethodHandler.shared.handle(call: call, result: result)
        })
        loggerChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            LoggerMethodHandler.shared.handle(call:call, result: result)
        })
    }
}
