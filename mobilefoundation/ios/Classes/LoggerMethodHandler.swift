import Flutter
import IBMMobileFirstPlatformFoundation
import UIKit

// OCLogger extension for accessing the native Logger in swift
extension OCLogger {
//Log methods with no metadata

func logTraceWithMessages(message:String, _ args: CVarArg...) {
    log(withLevel: OCLogger_TRACE, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
}

func logDebugWithMessages(message:String, _ args: CVarArg...) {
    log(withLevel: OCLogger_DEBUG, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
}

func logInfoWithMessages(message:String, _ args: CVarArg...) {
    log(withLevel: OCLogger_INFO, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
}

func logWarnWithMessages(message:String, _ args: CVarArg...) {
    log(withLevel: OCLogger_WARN, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
}

func logErrorWithMessages(message:String, _ args: CVarArg...) {
    log(withLevel: OCLogger_ERROR, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
}

func logFatalWithMessages(message:String, _ args: CVarArg...) {
    log(withLevel: OCLogger_FATAL, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
}

func logAnalyticsWithMessages(message:String, _ args: CVarArg...) {
    log(withLevel: OCLogger_ANALYTICS, message: message, args:getVaList(args), userInfo:Dictionary<String, String>())
}
}

/// This is a MethodCallManager class for WLClient method calls
public class LoggerMethodHandler {
    static let shared = LoggerMethodHandler()
    
    private init()
    {
        // Set up API instance
    }
    
    func getLoggerLevel(level: String) -> OCLogType {
        switch level {
        case LogLevels.TRACE:
            return OCLogger_TRACE
        case LogLevels.DEBUG:
            return OCLogger_DEBUG;
        case LogLevels.LOG:
            return OCLogger_LOG;
        case LogLevels.INFO:
            return OCLogger_INFO;
        case LogLevels.WARN:
            return OCLogger_WARN;
        case LogLevels.ERROR:
            return OCLogger_ERROR;
        case LogLevels.FATAL:
            return OCLogger_FATAL;
        case LogLevels.ANALYTICS:
            return OCLogger_ANALYTICS;
        default:
            return OCLogger_DEBUG;
        }
    }
    
    func getLoggerString(level: OCLogType) -> String{
        switch (level){
            case OCLogger_ANALYTICS:
                return LogLevels.ANALYTICS;
            case OCLogger_FATAL:
                return LogLevels.FATAL;
            case OCLogger_ERROR:
                return LogLevels.ERROR;
            case OCLogger_WARN:
                return LogLevels.WARN;
            case OCLogger_INFO:
                return LogLevels.INFO;
            case OCLogger_LOG:
                return LogLevels.LOG;
            case OCLogger_DEBUG:
                return LogLevels.DEBUG;
            case OCLogger_TRACE:
                return LogLevels.TRACE;
            default:
                return LogLevels.DEBUG;
        }
    }

    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method {
        case Methods.SETLEVEL:
            let level = args?[Arguments.LEVEL] as? String
            OCLogger.setLevel(LoggerMethodHandler.shared.getLoggerLevel(level: level!));
            break;
        case Methods.GETLEVEL:
            let level = OCLogger.getLevel();
            result(getLoggerString(level: level));
            break;
        case Methods.UPDATECONFIGFROMSERVER:
            OCLogger.updateConfigFromServer();
            result(nil);
            break
        case Methods.SEND:
            OCLogger.send()
            result(nil);
            break;
        case Methods.SETCAPTURE:
            let flag = args?[Arguments.FLAG] as! Bool
            OCLogger.setCapture(flag)
            result(nil);
            break;
        case Methods.GETCAPTURE:
            result(OCLogger.getCapture());
            break;
        case Methods.SETMAXFILESIZE:
            let size = args?[Arguments.BYTES] as! Int32
            OCLogger.setMaxFileSize(size)
            result(nil);
            break;
        case Methods.GETMAXFILESIZE:
            result(OCLogger.getMaxFileSize());
            break;
        case Methods.TRACE:
            let package = args?[Arguments.PACKAGE_NAME] as? String
            guard let message = args?[Arguments.MESSAGE] as? String else {
                result(nil)
                break;
            }
            let metadata = args?[Arguments.METADATA] as? NSDictionary
            if(metadata == nil){
                OCLogger.getInstanceWithPackage(package)?.logTraceWithMessages(message: message);
            } else{
                OCLogger.getInstanceWithPackage(package)?.log(withLevel: OCLogger_TRACE, message: message, args: getVaList([]), userInfo: (metadata as! [AnyHashable : Any]));
            }
            result(nil)
            break
        case Methods.LOG:
            let package = args?[Arguments.PACKAGE_NAME] as? String
            guard let message = args?[Arguments.MESSAGE] as? String else {
                result(nil)
                break;
            }
            let metadata = args?[Arguments.METADATA] as? NSDictionary
            if(metadata == nil){
                OCLogger.getInstanceWithPackage(package)?.log(withLevel: OCLogger_LOG, message: message, args: getVaList([]), userInfo: Dictionary<String, String>());
            } else {
                OCLogger.getInstanceWithPackage(package)?.log(withLevel: OCLogger_LOG, message: message, args: getVaList([]), userInfo: (metadata as! [AnyHashable : Any]));
            }
            result(nil)
            break
        case Methods.DEBUG:
            let package = args?[Arguments.PACKAGE_NAME] as? String
            guard let message = args?[Arguments.MESSAGE] as? String else {
                result(nil)
                break;
            }
            let metadata = args?[Arguments.METADATA] as? NSDictionary
            if(metadata == nil){
                OCLogger.getInstanceWithPackage(package)?.logDebugWithMessages(message: message);
            } else{
                OCLogger.getInstanceWithPackage(package)?.log(withLevel: OCLogger_DEBUG, message: message, args: getVaList([]), userInfo: (metadata as! [AnyHashable : Any]));
            }
            result(nil)
            break
        case Methods.INFO:
            let package = args?[Arguments.PACKAGE_NAME] as? String
            guard let message = args?[Arguments.MESSAGE] as? String else {
                result(nil)
                break;
            }
            let metadata = args?[Arguments.METADATA] as? NSDictionary
            if(metadata == nil){
                OCLogger.getInstanceWithPackage(package)?.logInfoWithMessages(message: message);
            } else{
                OCLogger.getInstanceWithPackage(package)?.log(withLevel: OCLogger_INFO, message: message, args: getVaList([]), userInfo: (metadata as! [AnyHashable : Any]));
            }
            result(nil)
            break
        case Methods.WARN:
            let package = args?[Arguments.PACKAGE_NAME] as? String
            guard let message = args?[Arguments.MESSAGE] as? String else {
                result(nil)
                break;
            }
            let metadata = args?[Arguments.METADATA] as? NSDictionary
            if(metadata == nil){
                OCLogger.getInstanceWithPackage(package)?.logWarnWithMessages(message: message);
            } else{
                OCLogger.getInstanceWithPackage(package)?.log(withLevel: OCLogger_WARN, message: message, args: getVaList([]), userInfo: (metadata as! [AnyHashable : Any]));
            }
            
            result(nil)
            break
        case Methods.ERROR:
            let package = args?[Arguments.PACKAGE_NAME] as? String
            guard let message = args?[Arguments.MESSAGE] as? String else {
                result(nil)
                break;
            }
            let metadata = args?[Arguments.METADATA] as? NSDictionary
            if(metadata == nil){
                OCLogger.getInstanceWithPackage(package)?.logErrorWithMessages(message: message);
            } else{
                OCLogger.getInstanceWithPackage(package)?.log(withLevel: OCLogger_ERROR, message: message, args: getVaList([]), userInfo: (metadata as! [AnyHashable : Any]));
            }
            result(nil)
            break
        default:
            result(FlutterError(code: MFConstants.ERR_METHOD_NAME_CODE, message: MFConstants.ERR_METHOD_NAME_MESSAGE, details: nil))
        }
    }
    
    private enum Methods{
        public static var TRACE: String = "trace"
        public static var DEBUG: String = "debug"
        public static var LOG: String = "log"
        public static var INFO: String = "info"
        public static var WARN: String = "warn"
        public static var ERROR: String = "error"
        public static var FATAL: String = "fatal"
        public static var SETLEVEL: String = "setLevel"
        public static var GETLEVEL: String = "getLevel"
        public static var UPDATECONFIGFROMSERVER: String = "updateConfigFromServer"
        public static var SEND: String = "send"
        public static var SETCAPTURE: String = "setCapture";
        public static var GETCAPTURE: String = "getCapture";
        public static var SETMAXFILESIZE: String = "setMaxFileSize";
        public static var GETMAXFILESIZE: String = "getMaxFileSize";
        public static var ENTER: String = "enter";
        public static var EXIT: String = "exit"
    }
    
    private enum Arguments{
        public static var LEVEL: String = "level"
        public static var MESSAGE: String = "message"
        public static var PACKAGE_NAME: String = "packageName"
        public static var BYTES: String = "bytes"
        public static var FLAG: String = "flag"
        public static var METADATA: String = "metadata"
        public static var CLASSNAME: String = "className"
        public static var METHODNAME: String = "methodName"
    }
    
    private enum LogLevels{
        public static var TRACE: String = "TRACE"
        public static var DEBUG: String = "DEBUG"
        public static var LOG: String = "LOG"
        public static var INFO: String = "INFO"
        public static var WARN: String = "WARN"
        public static var ERROR: String = "ERROR"
        public static var FATAL: String = "FATAL"
        public static var ANALYTICS: String = "ANALYTICS"
    }
    
}
