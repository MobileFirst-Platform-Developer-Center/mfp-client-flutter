import Flutter
import UIKit

/// This is a singleton class that loads the methodMapJSON containing information on all the native methods that are interfaced by this bridge plugin.
public class MFBridgeValidator {
    /// :nodoc:
    private static var shared: MFBridgeValidator?
    
    /// :nodoc:
    private var methodMap: NSMutableArray
    
    // A private constructor for initializing the Bridge Validator.
    /// :nodoc:
    private init() {
        let methodData = MethodMap.methodMapJSON.data(using: String.Encoding.utf8)
        do {
            // Converting JSON String to JSONObject
            let array: AnyObject = try JSONSerialization.jsonObject(with: methodData!, options: [.mutableContainers]) as AnyObject
            methodMap = array as! NSMutableArray // Converting to NSMutableArray inoder to iterate
        } catch {
            methodMap = NSMutableArray() // Initializing empty array if there is an error parsing JSON
            print("Error accessing the methodMap JSON")
        }
    }
    
    /**
     This method returns the shared instance of MFBridgeValidator.
     */
    public static func sharedInstance() -> MFBridgeValidator {
        if shared == nil {
            shared = MFBridgeValidator()
        }
        return shared ?? MFBridgeValidator()
    }
    
    /**
     This method validates the method and aguments before calling the API
     */
    public func validateMethodCall(_ call: FlutterMethodCall) throws -> Bool {
        do {
            let validMethod = try isValidMethod(call: call)
            if validMethod {
                return true
            }
        } catch {
            throw error
        }
        return false
    }
    
    // Private method that validates the method called
    /// :nodoc:
    private func isValidMethod(call: FlutterMethodCall) throws -> Bool {
        let methodName = call.method
        for method: AnyObject in methodMap as [AnyObject] {
            let name = method["methodName"] as! String
            if methodName.elementsEqual(name) {
                // Method exists, validate the arguments
                let methodArgs = method["arguments"] as! [AnyObject]
                if (methodArgs.count == 0 || hasValidArguments(callArgs: call.arguments as! NSDictionary, methodArgs: methodArgs)) {
                    // Arguments successfully validated
                    return true
                } else {
                    // Arguments validation failed
                    return false
                }
            }
        }
        throw MethodNotImplementedException(MFConstants.ERR_METHOD_NAME_MESSAGE)
    }
    
    // Provate method that validates the arguments passed
    /// :nodoc:
    private func hasValidArguments(callArgs: NSDictionary, methodArgs: [AnyObject]) -> Bool {
        for argument: AnyObject in methodArgs {
            let argumentKey = argument["argumentName"]
            if callArgs[argumentKey as Any] == nil {
                return false
            }
        }
        return true
    }
    
    // Custom iOS Error for Method not found
    /// :nodoc:
    struct MethodNotImplementedException: Error {
        let message: String
        
        init(_ message: String) {
            self.message = message
        }
        
        public var localizedDescription: String {
            return message
        }
    }
}
