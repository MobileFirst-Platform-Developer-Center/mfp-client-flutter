package com.ibm.mobile.mobilefoundation;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.worklight.wlclient.api.WLAccessTokenListener;
import com.worklight.wlclient.api.WLAuthorizationManager;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLLoginResponseListener;
import com.worklight.wlclient.api.WLLogoutResponseListener;
import com.worklight.wlclient.auth.AccessToken;
import com.worklight.wlclient.auth.WLAuthorizationManagerInternal;

import org.json.JSONObject;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class WLAuthorizationManagerMethodHandler implements MethodChannel.MethodCallHandler {

    private static WLAuthorizationManagerMethodHandler instance;
    private final WLAuthorizationManager wlAuthorizationManager = WLAuthorizationManager.getInstance();
    private Activity activity;

    private WLAuthorizationManagerMethodHandler() {
    }

    public static WLAuthorizationManagerMethodHandler getInstance() {
        if (instance == null) {
            instance = new WLAuthorizationManagerMethodHandler();
        }
        return instance;
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final MethodChannel.Result result) {
        try {
            boolean isValid = MFBridgeValidator.getInstance().validateMethodCall(call);
            if (!isValid) {
                result.error(MFConstants.ERR_INCORRECT_ARGS_CODE, MFConstants.ERR_INCORRECT_ARGS_MESSAGE, call.method);
                return;
            }
        } catch (MFBridgeValidator.MethodNotImplementedException ex) {
            result.error(MFConstants.ERR_METHOD_NAME_CODE, MFConstants.ERR_METHOD_NAME_MESSAGE, call.method);
            return;
        }

        if (activity == null) {
            activity = MobilefoundationPlugin.getActivity();
        }

        switch (call.method) {
            case Methods.OBTAIN_ACCESS_TOKEN:
                wlAuthorizationManager.obtainAccessToken((String) call.argument(Arguments.SCOPE), new WLAccessTokenListener() {
                    @Override
                    public void onSuccess(final AccessToken accessToken) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Map<String, String> token = new HashMap<String, String>();
                                token.put(MFConstants.VALUE, accessToken.getValue());
                                token.put(MFConstants.SCOPE, accessToken.getScope());
                                token.put(MFConstants.AS_AUTHORIZATION_REQUEST_HEADER, accessToken.getAsAuthorizationRequestHeader());
                                token.put(MFConstants.AS_FORMENCODED_BODY_PARAMETER, accessToken.getAsFormEncodedBodyParameter());
                                result.success(token);
                            }
                        });
                    }

                    @Override
                    public void onFailure(final WLFailResponse wlFailResponse) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Map<String, Object> mfFailResponse = new HashMap();
                                mfFailResponse.put(Arguments.STATUS, wlFailResponse.getStatus());
                                mfFailResponse.put(Arguments.HEADERS, wlFailResponse.getHeaders());
                                mfFailResponse.put(Arguments.ERROR_CODE, wlFailResponse.getErrorStatusCode());
                                mfFailResponse.put(Arguments.ERROR_MSG, wlFailResponse.getErrorMsg());
                                result.success(mfFailResponse);
                            }
                        });
                    }
                });
                break;
            case Methods.WLAUTHORIZATIONMANAGER_CLEARACCESSTOKEN :
                String scope = ((HashMap<String, String>)call.argument(Arguments.ACCESSTOKEN)).get(MFConstants.SCOPE);
                WLAuthorizationManagerInternal.getInstance().removeTokenByScope(scope);
                result.success(null);
                break;

            case Methods.WLAUTHORIZATIONMANAGER_LOGIN:
                wlAuthorizationManager.login((String) call.argument(Arguments.SECURITYCHECK), new JSONObject(((HashMap<String, String>) call.argument(Arguments.CREDENTIALS))), new WLLoginResponseListener() {
                    @Override
                    public void onSuccess() {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(null);
                            }
                        });
                    }

                    @Override
                    public void onFailure(final WLFailResponse wlFailResponse) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Map<String, Object> mfFailResponse = new HashMap();
                                mfFailResponse.put(Arguments.STATUS, wlFailResponse.getStatus());
                                mfFailResponse.put(Arguments.HEADERS, wlFailResponse.getHeaders());
                                mfFailResponse.put(Arguments.ERROR_CODE, wlFailResponse.getErrorStatusCode());
                                mfFailResponse.put(Arguments.ERROR_MSG, wlFailResponse.getErrorMsg());
                                result.success(mfFailResponse);
                            }
                        });
                    }
                });
                break;

            case Methods.WLAUTHORIZATIONMANAGER_LOGOUT:
                wlAuthorizationManager.logout((String) call.argument(Arguments.SECURITYCHECK), new WLLogoutResponseListener() {
                    @Override
                    public void onSuccess() {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(null);
                            }
                        });
                    }

                    @Override
                    public void onFailure(final WLFailResponse wlFailResponse) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Map<String, Object> mfFailResponse = new HashMap();
                                mfFailResponse.put(Arguments.STATUS, wlFailResponse.getStatus());
                                mfFailResponse.put(Arguments.HEADERS, wlFailResponse.getHeaders());
                                mfFailResponse.put(Arguments.ERROR_CODE, wlFailResponse.getErrorStatusCode());
                                mfFailResponse.put(Arguments.ERROR_MSG, wlFailResponse.getErrorMsg());
                                result.success(mfFailResponse);
                            }
                        });
                    }
                });
                break;

            case Methods.WLAUTHORIZATIONMANAGER_SETLOGINTIMEOUT :
                wlAuthorizationManager.setLoginTimeout((int)call.argument(Arguments.TIMEOUT));
                result.success(null);
                break;

            default:
                result.error(MFConstants.ERR_METHOD_NAME_CODE, MFConstants.ERR_METHOD_NAME_MESSAGE, null);
        }
    }

    private static class Methods {
        public static final String OBTAIN_ACCESS_TOKEN = "obtainAccessToken";
        public static final String WLAUTHORIZATIONMANAGER_CLEARACCESSTOKEN = "clearAccessToken";
        public static final String WLAUTHORIZATIONMANAGER_LOGIN = "login";
        public static final String WLAUTHORIZATIONMANAGER_LOGOUT = "logout";
        public static final String WLAUTHORIZATIONMANAGER_SETLOGINTIMEOUT  = "setLoginTimeOut";
    }

    private static class Arguments {
        public static final String SCOPE = "scope";
        public static final String ACCESSTOKEN = "accessToken";
        public static final String SECURITYCHECK = "securityCheck";
        public static final String CREDENTIALS = "credentials";
        public static final String TIMEOUT = "timeOut";
        public static final String ERROR_CODE = "errorCode";
        public static final String ERROR_MSG  = "errorMsg";
        public static final String HEADERS = "headers";
        public static final String STATUS = "status";
    }
}
