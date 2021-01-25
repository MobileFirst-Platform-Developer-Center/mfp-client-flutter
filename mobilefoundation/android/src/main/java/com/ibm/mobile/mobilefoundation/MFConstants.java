package com.ibm.mobile.mobilefoundation;

public class MFConstants{

    /* Arguments */
    public static final String HEADER_NAME = "headerName" ;
    public static final String HEADER_VALUE = "headerValue" ;
    public static final String SCOPE = "scope" ;
    public static final String VALUE = "value";
    public static final String AS_AUTHORIZATION_REQUEST_HEADER = "asAuthorizationRequestHeader";
    public static final String AS_FORMENCODED_BODY_PARAMETER = "asFormEncodedBodyParameter";
    public static final String SERVER_URL = "serverUrl";

    /* Error codes */
    public static final String ERR_METHOD_NAME_CODE = "MF_ERR_METHOD_NAME" ; // The method name passed to the bridge is not identified
    public static final String ERR_INCORRECT_ARGS_CODE = "MF_ERR_INCORRECT_ARGS" ; // Wrong arguments passed to the bridge method
    public static final String ERR_INVALID_CERT = "MF_ERR_INVALID_CERT"; //Invalid certificate for certificate pinning

    /* Error messages */
    public static final String ERR_METHOD_NAME_MESSAGE = "Method not implemented" ; // The method name passed to the bridge is not identified
    public static final String ERR_INCORRECT_ARGS_MESSAGE = "Incorrect arguments passed to the bridge. Check your arguments" ; // Wrong arguments passed to the bridge method
}