import Flutter
import IBMMobileFirstPlatformFoundation
import UIKit

/// This is a MethodCallManager class for WLClient method calls
public class WLClientMethodHandler {
    static let shared = WLClientMethodHandler()
    static var eventSink: FlutterEventSink?
    var challengeHandlers: [String: MFSecurityCheckChallengeHandler] = [String: MFSecurityCheckChallengeHandler]()
    
    private init()
    {
        // Set up API instance
    }
    
    // This method is used to invoke the challenge handler methods in dart Layer
    // and gets called when the native methods of challenge handler is triggered.
    static func sendEvent(eventName: String, mapObject: [AnyHashable: Any]) {
        if (eventSink != nil) {
            //Send challenge handler method name and it's response data to dart layer.
            let event = NSMutableDictionary()
            event["challengeHandlerMethod"] = eventName
            event["mapObject"] = mapObject
            DispatchQueue.main.async {
                eventSink!(event)
            }
        }
    }
    
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            let isValid: Bool = try MFBridgeValidator.sharedInstance().validateMethodCall(call)
            if !isValid {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
                return
            }
        } catch {
            print("Error \(error)")
            result(FlutterError(code: MFConstants.ERR_METHOD_NAME_CODE, message: error.localizedDescription, details: nil))
            return
        }
        
        switch call.method {
        case Methods.ADDGLOBALHEADER:
            if let args = call.arguments as? [String: Any],
                let headerName = args[Arguments.HEADER_NAME] as? String,
                let headerValue = args[Arguments.HEADER_VALUE] as? String
            {
                WLClient.sharedInstance().addGlobalHeader(headerName, headerValue: headerValue)
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.REMOVEGLOBALHEADER:
            if let args = call.arguments as? [String: Any],
                let headerName = args[Arguments.HEADER_NAME] as? String
            {
                WLClient.sharedInstance()?.removeGlobalHeader(headerName)
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.SETSERVERURL:
            if let args = call.arguments as? [String: Any],
                let serverURL = args[Arguments.SERVER_URL] as? URL
            {
                WLClient.sharedInstance()?.setServerUrl(serverURL)
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GETSERVERURL:
            let serverURL: String = WLClient.sharedInstance()?.serverUrl()?.absoluteString ?? ""
            result(serverURL)
            break
        case Methods.SETDEVICE_DISPLAYNAME:
            if let args = call.arguments as? [String: Any],
                let displayName = args[Arguments.DEVICE_DISPLAYNAME] as? String
            {
                WLClient.sharedInstance()?.setDeviceDisplayName(displayName, withCompletionHandler:{(error) -> Void in
                    if(error != nil){
                        let mfFailResponse = NSMutableDictionary()
                        mfFailResponse.setValue(String ((error! as NSError).code) , forKey: Arguments.ERROR_CODE)
                        mfFailResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                        result(mfFailResponse)
                        return;
                    }
                    else{
                        result(nil);
                    }
                    
                } )
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GETDEVICE_DISPLAYNAME:
            WLClient.sharedInstance()?.getDeviceDisplayName(completionHandler:{(deviceDisplayName , error) -> Void in
                if(error != nil){
                    let mfFailResponse = NSMutableDictionary()
                    mfFailResponse.setValue(String ((error! as NSError).code) , forKey: Arguments.ERROR_CODE)
                    mfFailResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                    result(mfFailResponse)
                    return;
                }
                else{
                    if(deviceDisplayName == nil){
                        result("")
                        return
                    }
                    result(deviceDisplayName)
                }
            })
            break
        case Methods.SETHEARTBEAT_INTERVAL:
            if let args = call.arguments as? [String: Any],
                let interval = args[Arguments.HEARTBEAT_INTERVAL] as? Int
            {
                WLClient.sharedInstance()?.setHeartBeatInterval(interval);
                result(nil)
                return;
            }
            else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.CERTIFICATE_PINNING:
            if let args = call.arguments as? [String: Any],
                let certificates = args[Arguments.CERTIFICATE_FILENAMES] as? Array<String>
            {
                if(certificates.count == 1){
                    WLClient.sharedInstance()?.pinTrustedCertificatePublicKey(fromFile: certificates[0]);
                } else{
                    WLClient.sharedInstance()?.pinTrustedCertificatePublicKey(fromFiles: certificates);
                }
                result(nil)
            } else{
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.WLCLIENT_REGISTER_CHALLENGE_HANDLER:
            if let args = call.arguments as? [String: Any],
                let securityCheck = args[Arguments.SECURITYCHECK_NAME] as? String
            {
                let ch = MFSecurityCheckChallengeHandler(securityCheck: securityCheck)
                WLClient.sharedInstance().registerChallengeHandler(ch)
                challengeHandlers[securityCheck] = ch
                result(nil)
            } else{
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.WLCLIENT_SUBMIT_CHALLENGE_ANSWER:
            if let args = call.arguments as? [String: Any],
                let securityCheck = args[Arguments.SECURITYCHECK_NAME] as? String,
                let challengeAnswer = args[Arguments.ANSWER] as? [AnyHashable : Any]
            {
                let ch = challengeHandlers[securityCheck]
                ch?.submitChallengeAnswer(challengeAnswer)
                result(nil)
            } else{
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.WLCLIENT_CANCEL_CHALLENGE:
            if let args = call.arguments as? [String: Any],
                let securityCheck = args[Arguments.SECURITYCHECK_NAME] as? String
            {
                let ch = challengeHandlers[securityCheck]
                ch?.cancel()
                result(nil)
            } else{
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        default:
            result(FlutterError(code: MFConstants.ERR_METHOD_NAME_CODE, message: MFConstants.ERR_METHOD_NAME_MESSAGE, details: nil))
        }
    }
    
    private enum Methods{
        public static var ADDGLOBALHEADER: String = "addGlobalHeader"
        public static var REMOVEGLOBALHEADER: String = "removeGlobalHeader"
        public static var SETSERVERURL: String = "setServerUrl"
        public static var GETSERVERURL: String = "getServerUrl"
        public static var SETDEVICE_DISPLAYNAME: String = "setDeviceDisplayName"
        public static var GETDEVICE_DISPLAYNAME: String = "getDeviceDisplayName"
        public static var SETHEARTBEAT_INTERVAL: String = "setHeartbeatInterval"
        public static var CERTIFICATE_PINNING: String = "pinTrustedCertificatesPublicKey"
        public static var WLCLIENT_REGISTER_CHALLENGE_HANDLER: String = "registerChallengeHandler"
        public static var WLCLIENT_SUBMIT_CHALLENGE_ANSWER: String = "submitChallengeAnswer"
        public static var WLCLIENT_CANCEL_CHALLENGE: String = "cancelChallenge"
    }
    
    private enum Arguments{
        public static var HEADER_NAME: String = "headerName"
        public static var HEADER_VALUE = "headerValue"
        public static var SERVER_URL: String = "serverUrl"
        public static var DEVICE_DISPLAYNAME: String = "deviceDisplayName"
        public static var HEARTBEAT_INTERVAL: String = "heartbeatIntervalInSeconds"
        public static var CERTIFICATE_FILENAMES: String = "certificateFileNames"
        public static var SECURITYCHECK_NAME: String = "securityCheckName"
        public static var ANSWER: String = "answer"
        public static var ERROR_CODE: String = "errorCode"
        public static var ERROR_MSG: String = "errorMsg"
    }
    
}

public class ChallengeHandlerStreamHandler: NSObject, FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        WLClientMethodHandler.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        WLClientMethodHandler.eventSink = nil
        return nil
    }
}
