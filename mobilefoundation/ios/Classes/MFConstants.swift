import Foundation

/// Holds all the constants related to MobileFoundation
public enum MFConstants {
    /* Error codes */
    public static var ERR_METHOD_NAME_CODE: String = "MF_ERR_METHOD_NAME" // The method name passed to the bridge is not identified
    public static var ERR_INCORRECT_ARGS_CODE: String = "MF_ERR_INCORRECT_ARGS" // Wrong arguments passed to the bridge method
    public static var ERR_ACCESS_TOKEN: String = "MF_ERR_ACCESS_TOKEN_FAILURE"
    public static var ERR_RESOURCE_REQUEST: String = "ERR_RESOURCE_REQUEST"
    public static var ERR_LOGIN: String = "MF_LOGIN_FAILURE"
    public static var ERR_LOGOUT: String = "MF_LOGOUT_FAILURE"
    public static var ERR_INVALID_URL: String = "MF_INVALID_URL"
    public static var ERR_DEVICE_DISPLAYNAME_FAILURE = "MF_DEVICE_DISPLAYNAME_FAILURE"

    /* Error messages */
    public static var ERR_METHOD_NAME_MESSAGE: String = "Method not implemented" // The method name passed to the bridge is not identified
    public static var ERR_INCORRECT_ARGS_MESSAGE: String = "Incorrect arguments passed to the bridge. Check your arguments" // Wrong arguments passed to the bridge method
    public static var ERR_INVALID_URL_MESSAGE: String = "URL is not valid"
}
