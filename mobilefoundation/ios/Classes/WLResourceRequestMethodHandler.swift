import Flutter
import IBMMobileFirstPlatformFoundation
import UIKit

/// This is a MethodCallManager class for WLResourceRequest method calls
public class WLResourceRequestMethodHandler {
    static let shared = WLResourceRequestMethodHandler()
    
    private init()
    {
        // Set up API instance
    }
    
    var requestMap: [String: WLResourceRequest] = [String: WLResourceRequest]()
    
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method {
        case Methods.INIT:
            if  let uuid = args?[Arguments.UUID] as? String,
                let url = URL(string: args?[Arguments.URL] as! String),
                let method = args?[Arguments.METHOD] as? String,
                let timeout = args?[Arguments.TIMEOUT] as? Double,
                let scope = args?[Arguments.SCOPE] as? String,
                let backendService = args?[Arguments.BACKEND_SERVICE] as? String
            {
                var request : WLResourceRequest;
                if scope.isEmpty && backendService.isEmpty {
                    request = WLResourceRequest(url: url, method: method, timeout: timeout)
                } else if backendService.isEmpty {
                    request = WLResourceRequest(url: url, method: method, timeout: timeout, scope: scope)
                } else if backendService.isEmpty {
                    request = WLResourceRequest(url: url, method: method, backendServiceName: backendService, timeout: timeout)
                } else {
                    result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
                    return;
                }
                requestMap[uuid] = request
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.SEND:
            if  let uuid = args?[Arguments.UUID] as? String,
                let request = WLResourceRequestMethodHandler.shared.requestMap[uuid]
            {
                request.send { (response, error) in
                    if(error != nil) {
                        let mfResponse = NSMutableDictionary()
                        mfResponse.setValue(response?.status, forKey: Arguments.STATUS)
                        mfResponse.setValue(response?.headers, forKey: Arguments.HEADERS)
                        mfResponse.setValue(String ((error! as NSError).code), forKey: Arguments.ERROR_CODE)
                        mfResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                        result(mfResponse)
                    } else {
                        let mfResponse = NSMutableDictionary()
                        mfResponse.setValue(response?.status, forKey: Arguments.STATUS)
                        mfResponse.setValue(response?.responseJSON, forKey: Arguments.RESPONSE_JSON)
                        mfResponse.setValue(response?.responseText, forKey: Arguments.RESPONSE_TEXT)
                        mfResponse.setValue(response?.headers, forKey: Arguments.HEADERS)
                        result(mfResponse)
                    }
                }
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.SEND_JSON:
            if  let json = args?[Arguments.JSON] as? [AnyHashable: Any],
                let uuid = args?[Arguments.UUID] as? String,
                let request = WLResourceRequestMethodHandler.shared.requestMap[uuid]
            {
                request.send(withJSON: json) { (response, error) in
                    if(error != nil) {
                        let mfResponse = NSMutableDictionary()
                        mfResponse.setValue(response?.status, forKey: Arguments.STATUS)
                        mfResponse.setValue(response?.headers, forKey: Arguments.HEADERS)
                        mfResponse.setValue(String ((error! as NSError).code), forKey: Arguments.ERROR_CODE)
                        mfResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                        result(mfResponse)
                    } else {
                        let mfResponse = NSMutableDictionary()
                        mfResponse.setValue(response?.status, forKey: Arguments.STATUS)
                        mfResponse.setValue(response?.responseJSON, forKey: Arguments.RESPONSE_JSON)
                        mfResponse.setValue(response?.responseText, forKey: Arguments.RESPONSE_TEXT)
                        mfResponse.setValue(response?.headers, forKey: Arguments.HEADERS)
                        result(mfResponse)
                    }
                }
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.SEND_FORM_PARAMS:
            if  let params = args?[Arguments.PARAMETERS] as? [AnyHashable: Any],
                let uuid = args?[Arguments.UUID] as? String,
                let request = WLResourceRequestMethodHandler.shared.requestMap[uuid]
            {
                request.send(withFormParameters: params) { (response, error) in
                    if(error != nil) {
                        let mfResponse = NSMutableDictionary()
                        mfResponse.setValue(response?.status, forKey: Arguments.STATUS)
                        mfResponse.setValue(response?.headers, forKey: Arguments.HEADERS)
                        mfResponse.setValue(String ((error! as NSError).code), forKey: Arguments.ERROR_CODE)
                        mfResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                        result(mfResponse)
                    } else {
                        let mfResponse = NSMutableDictionary()
                        mfResponse.setValue(response?.status, forKey: Arguments.STATUS)
                        mfResponse.setValue(response?.responseJSON, forKey: Arguments.RESPONSE_JSON)
                        mfResponse.setValue(response?.responseText, forKey: Arguments.RESPONSE_TEXT)
                        mfResponse.setValue(response?.headers, forKey: Arguments.HEADERS)
                        result(mfResponse)
                    }
                }
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.SEND_REQUEST_BODY:
            if  let requestBody = args?[Arguments.BODY] as? String,
                let uuid = args?[Arguments.UUID] as? String,
                let request = WLResourceRequestMethodHandler.shared.requestMap[uuid]
            {
                request.send(withBody: requestBody) { (response, error) in
                    if(error != nil) {
                        let mfResponse = NSMutableDictionary()
                        mfResponse.setValue(response?.status, forKey: Arguments.STATUS)
                        mfResponse.setValue(response?.headers, forKey: Arguments.HEADERS)
                        mfResponse.setValue(String ((error! as NSError).code), forKey: Arguments.ERROR_CODE)
                        mfResponse.setValue((error! as NSError).localizedDescription, forKey: Arguments.ERROR_MSG)
                        result(mfResponse)
                    } else {
                        let mfResponse = NSMutableDictionary()
                        mfResponse.setValue(response?.status, forKey: Arguments.STATUS)
                        mfResponse.setValue(response?.responseJSON, forKey: Arguments.RESPONSE_JSON)
                        mfResponse.setValue(response?.responseText, forKey: Arguments.RESPONSE_TEXT)
                        mfResponse.setValue(response?.headers, forKey: Arguments.HEADERS)
                        result(mfResponse)
                    }
                }
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GET_METHOD:
            if  let uuid = args?[Arguments.UUID] as? String,
                let request = requestMap[uuid]
            {
                result(request.httpMethod)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.ADD_HEADER:
            if  let uuid = args?[Arguments.UUID] as? String,
                let headerName = args?[Arguments.HEADER_NAME] as? String,
                let headerValue = args?[Arguments.HEADER_VALUE] as? NSObject,
                let request = requestMap[uuid]
            {
                request.addHeaderValue(headerValue, forName: headerName)
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.SET_QUERY_PARAMS:
            if  let uuid = args?[Arguments.UUID] as? String,
                let paramName = args?[Arguments.PARAM_NAME] as? String,
                let paramValue = args?[Arguments.PARAM_VALUE] as? String,
                let request = requestMap[uuid]
            {
                request.setQueryParameterValue(paramValue, forName: paramName)
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GET_QUERY_PARAMS:
            if  let uuid = args?[Arguments.UUID] as? String,
                let request = requestMap[uuid]
            {
                result(request.queryParameters)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GET_QUERY_STRING:
            if  let uuid = args?[Arguments.UUID] as? String,
                let request = requestMap[uuid]
            {
                result(request.getQueryString())
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GET_ALL_HEADERS:
            if  let uuid = args?[Arguments.UUID] as? String,
                let request = requestMap[uuid]
            {
                var dict = [String: [Any]]()
                for index in request.headers {
                    let header = index as! NSObject
                    dict[header.value(forKey: "headerName") as! String] = request.headers(forName: header.value(forKey: "headerName") as? String)
                }
                result(dict)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GET_HEADERS:
            if  let uuid = args?[Arguments.UUID] as? String,
                let headerName = args?[Arguments.HEADER_NAME] as? String,
                let request = requestMap[uuid]
            {
                result(request.headers(forName: headerName))
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.SET_HEADERS:
            if  let uuid = args?[Arguments.UUID] as? String,
                let headers = args?[Arguments.HEADERS] as? NSMutableDictionary,
                let request = requestMap[uuid]
            {
                for (headerName, headerValue) in headers {
                    request.setHeaderValue(headerValue as? NSObject, forName: headerName as? String)
                }
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
        case Methods.REMOVE_HEADERS:
            if  let uuid = args?[Arguments.UUID] as? String,
                let headerName = args?[Arguments.HEADER_NAME] as? String,
                let request = requestMap[uuid]
            {
                request.removeHeaders(forName: headerName);
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.SET_TIMEOUT:
            if  let uuid = args?[Arguments.UUID] as? String,
                let timeout = args?[Arguments.TIMEOUT] as? TimeInterval,
                let request = requestMap[uuid]
            {
                request.timeoutInterval = timeout
                result(nil)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GET_TIMEOUT:
            if  let uuid = args?[Arguments.UUID] as? String,
                let request = requestMap[uuid]
            {
                result(Int(request.timeoutInterval))
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        case Methods.GET_URL:
            if  let uuid = args?[Arguments.UUID] as? String,
                let request = requestMap[uuid]
            {
                result(request.url.absoluteString)
            } else {
                result(FlutterError(code: MFConstants.ERR_INCORRECT_ARGS_CODE, message: MFConstants.ERR_INCORRECT_ARGS_MESSAGE, details: nil))
            }
            break
        default:
            result(FlutterError(code: MFConstants.ERR_METHOD_NAME_CODE, message: MFConstants.ERR_METHOD_NAME_MESSAGE, details: nil))
        }
    }
    
    private enum Methods{
        public static var INIT: String = "init"
        public static var SEND: String = "send"
        public static var SEND_JSON: String = "sendWithJSON"
        public static var SEND_FORM_PARAMS: String = "sendWithFormParameters"
        public static var SEND_REQUEST_BODY: String = "sendWithRequestBody"
        public static var GET_METHOD: String = "getMethod"
        public static var ADD_HEADER: String = "addHeader"
        public static var SET_QUERY_PARAMS: String = "setQueryParameters"
        public static var GET_QUERY_PARAMS: String = "getQueryParameters"
        public static var GET_QUERY_STRING: String = "getQueryString"
        public static var GET_ALL_HEADERS: String = "getAllHeaders"
        public static var GET_HEADERS: String = "getHeaders"
        public static var SET_HEADERS: String = "setHeaders"
        public static var REMOVE_HEADERS: String = "removeHeaders"
        public static var SET_TIMEOUT: String = "setTimeout"
        public static var GET_TIMEOUT: String = "getTimeout"
        public static var GET_URL: String = "getUrl"
    }
    
    private enum Arguments{
        public static var STATUS: String = "status"
        public static var RESPONSE_TEXT: String = "responseText"
        public static var RESPONSE_JSON: String = "responseJSON"
        public static var ERROR_CODE: String = "errorCode"
        public static var ERROR_MSG: String = "errorMsg"
        public static var HEADER_NAME: String = "headerName"
        public static var HEADER_VALUE = "headerValue"
        public static var PARAM_NAME: String = "paramName"
        public static var PARAM_VALUE = "paramValue"
        public static var SCOPE: String = "scope"
        public static var BACKEND_SERVICE: String = "backendServiceName"
        public static var SERVER_URL: String = "serverUrl"
        public static var UUID: String = "uuid"
        public static var URL: String = "url"
        public static var METHOD: String = "method"
        public static var TIMEOUT: String = "timeout"
        public static var JSON: String = "json"
        public static var PARAMETERS: String = "parameters"
        public static var BODY: String = "body"
        public static var HEADERS: String = "headers"
    }
}
