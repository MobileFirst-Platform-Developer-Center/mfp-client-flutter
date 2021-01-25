import Flutter
import IBMMobileFirstPlatformFoundation
import UIKit

/// This is a MethodCallManager class for WLAuthorizationManager method calls
public class WLAuthorizationManagerMethodHandler {
    static let shared = WLAuthorizationManagerMethodHandler()
    
    private init()
    {
        // Set up API instance
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
        let args = call.arguments as? [String: Any]
        switch call.method {
        case Methods.OBTAINACCESSTOKEN:
            let scope = args?[Arguments.SCOPE] as? String
            WLAuthorizationManager.sharedInstance()?.obtainAccessToken(forScope: scope, withCompletionHandler: { (token, error) -> Void in
                if error != nil {
                    let mfFailResponse = NSMutableDictionary()
                    mfFailResponse.setValue(String ((error! as NSError).code) , forKey: Arguments.ERROR_CODE)
                    mfFailResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                    result(mfFailResponse)
                } else {
                    // Token is of AccessToken class -> converting it to a dictionary so that it can accessed as a MAP/Object in the dart layer.
                    let dictionary = NSMutableDictionary()
                    dictionary.setValue(token?.value, forKey: Arguments.VALUE)
                    dictionary.setValue(token?.asAuthorizationRequestHeaderField, forKey: Arguments.AS_AUTHORIZATION_REQUEST_HEADER)
                    dictionary.setValue(token?.asFormEncodedBodyParameter, forKey: Arguments.AS_FORMENCODED_BODY_PARAMETER)
                    dictionary.setValue(token?.scope, forKey: Arguments.SCOPE)
                    result(dictionary)
                }
            })
            break
        case Methods.CLEARACCESSTOKEN:
            let accessToken = args?[Arguments.ACCESSTOKEN] as? NSMutableDictionary
            let tokenToRemove = AccessToken(token: Arguments.ACCESSTOKEN, withExpiration: 0, forScope: accessToken?[Arguments.SCOPE] as? String)
            WLAuthorizationManager.sharedInstance()?.clear(tokenToRemove)
            result(nil)
            break
        case Methods.LOGIN:
            let securityCheck = args?[Arguments.SECURITYCHECK] as? String
            let credentials = args?[Arguments.CREDENTIALS] as? [AnyHashable: Any]
            WLAuthorizationManager.sharedInstance()?.login(securityCheck, withCredentials: credentials, withCompletionHandler: { (error) -> Void in
                if error != nil {
                    let mfFailResponse = NSMutableDictionary()
                    mfFailResponse.setValue(String ((error! as NSError).code) , forKey: Arguments.ERROR_CODE)
                    mfFailResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                    result(mfFailResponse)
                } else {
                    result(nil)
                }
            })
            break
        case Methods.LOGOUT:
            let securityCheck = args?[Arguments.SECURITYCHECK] as? String
            WLAuthorizationManager.sharedInstance()?.logout(securityCheck, withCompletionHandler: { (error) -> Void in
                if error != nil {
                    let mfFailResponse = NSMutableDictionary()
                    mfFailResponse.setValue(String ((error! as NSError).code) , forKey: Arguments.ERROR_CODE)
                    mfFailResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                    result(mfFailResponse)
                } else {
                    result(nil)
                }
            })
            break
        case Methods.SETLOGINTIMEOUT:
            let timeOut = args?[Arguments.TIMEOUT] as? NSNumber
            WLAuthorizationManager.sharedInstance()?.setLoginTimeout(timeOut)
            result(nil)
            break
        default:
            result(FlutterError(code: MFConstants.ERR_METHOD_NAME_CODE, message: MFConstants.ERR_METHOD_NAME_MESSAGE, details: nil))
        }
    }
    
    private enum Methods{
        public static var OBTAINACCESSTOKEN: String = "obtainAccessToken"
        public static var CLEARACCESSTOKEN: String = "clearAccessToken"
        public static var LOGIN: String = "login"
        public static var LOGOUT: String = "logout"
        public static var SETLOGINTIMEOUT: String = "setLoginTimeOut"
    }
    
    private enum Arguments{
        public static var STATUS: String = "status"
        public static var HEADERS: String = "headers"
        public static var ERROR_CODE: String = "errorCode"
        public static var ERROR_MSG: String = "errorMsg"
        public static var SCOPE: String = "scope"
        public static var ACCESSTOKEN: String = "accessToken"
        public static var VALUE: String = "value"
        public static var AS_AUTHORIZATION_REQUEST_HEADER: String = "asAuthorizationRequestHeader"
        public static var AS_FORMENCODED_BODY_PARAMETER: String = "asFormEncodedBodyParameter"
        public static var SECURITYCHECK: String = "securityCheck"
        public static var CREDENTIALS: String = "credentials"
        public static var TIMEOUT: String = "timeOut"
    }
}
