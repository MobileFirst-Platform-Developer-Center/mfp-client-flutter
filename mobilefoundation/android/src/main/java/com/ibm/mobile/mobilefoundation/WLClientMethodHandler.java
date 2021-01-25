package com.ibm.mobile.mobilefoundation;

import android.app.Activity;
import androidx.annotation.NonNull;

import com.worklight.wlclient.WLRequestListener;
import com.worklight.wlclient.api.DeviceDisplayNameListener;
import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;

import org.json.JSONObject;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.BinaryMessenger;


public class WLClientMethodHandler implements MethodChannel.MethodCallHandler {


    private final  WLClient wlClient;
    private static Activity activity;
    private static WLClientMethodHandler instance;
    private static EventChannel.EventSink eventSink;
    private static final String CHALLENGEHANDLER_EVENT = "challengeHandlerEvent";
    Map<String, MFSecurityCheckChallengeHandler> challengeHandlers = new HashMap<String, MFSecurityCheckChallengeHandler>();



    private WLClientMethodHandler() {
        wlClient = WLClient.createInstance(MobilefoundationPlugin.getContext());

        /*Implement a "challengeHandlerEvent" EventChannel to send challenge handler method to dart platform when one of the challenge handler methods of MFSecurityCheckChallengeHandler class is called.
         *The corresponding "challengeHandlerEvent" EventChannel will also be implemented in dart platform for handling received events.
         */
        new EventChannel(MobilefoundationPlugin.getBinaryMessenger(), CHALLENGEHANDLER_EVENT)
                .setStreamHandler(
                        new EventChannel.StreamHandler() {
                            @Override
                            public void onListen(Object arguments, EventChannel.EventSink sink) {
                                eventSink = sink;
                            }

                            @Override
                            public void onCancel(Object arguments) {
                                eventSink = null;
                            }
                        });
    }

    /*This method is used to send challenge handler method to dart layer using "challengeHandlerEvent" EventChannel in native bridge.
     *This method is called when one of the challenge handler method of MFSecurityCheckChallengeHandler.java class is called to send called challenger handler method to dart platform.
     *The corresponding "challengeHandlerEvent" EventChannel in dart platform receives this data to invoke corresponding challenge handler method in dart.
     */
    static void sendEvent(String eventName, Map mapObject) {
        activity = MobilefoundationPlugin.getActivity();
        if (eventSink == null) {
            return;
        }
        final Map<Object, Object> event = new HashMap<>();
        //Send challenge handler method name and it's response data to dart layer.
        event.put("challengeHandlerMethod", eventName);
        event.put("mapObject", mapObject);
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                eventSink.success(event);
            }
        });
    }

    public static WLClientMethodHandler getInstance() {
        if (instance == null) {
            instance = new WLClientMethodHandler();
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
            case Methods.ADD_GLOBAL_HEADER:
                wlClient.addGlobalHeader((String) call.argument(Arguments.HEADER_NAME),
                        (String) call.argument(Arguments.HEADER_VALUE));
                result.success(null);
                break;
            case Methods.REMOVE_GLOBAL_HEADER:
                wlClient.removeGlobalHeader((String) call.argument(Arguments.HEADER_NAME));
                result.success(null);
                break;

            case Methods.SET_SERVER_URL:
                try {
                    wlClient.setServerUrl(new URL((String) call.argument(Arguments.SERVER_URL)));
                    result.success(null);
                } catch (MalformedURLException e) {
                    result.error(Arguments.SERVER_URL, "Exception setting server URL: " + e.getMessage(), null);
                }
                break;

            case Methods.GET_SERVER_URL:
                result.success(wlClient.getServerUrl().toString());
                break;

            case Methods.WLCLIENT_SETDEVICE_DISPLAYNAME:
                setDeviceDisplayName((String) call.argument(Arguments.DEVICE_DISPLAYNAME), result);
                break;

            case Methods.WLCLIENT_GETDEVICE_DISPLAYNAME:
                getDeviceDisplayName(result);
                break;

            case Methods.WLCLIENT_SETHEARTBEAT_INTERVAL:
                wlClient.setHeartBeatInterval((int) call.argument(Arguments.HEARTBEAT_INTERVAL));
                result.success(null);
                break;

            case Methods.WLCLIENT_CERTIFICATE_PINNING:
                pinTrustedCertificatePublicKey((List<String>) call.argument(Arguments.CERTIFICATE_FILENAMES), result);
                break;

            case Methods.WLCLIENT_REGISTER_CHALLENGEHANDLER:
                MFSecurityCheckChallengeHandler ch = new MFSecurityCheckChallengeHandler((String) call.argument(Arguments.SECURITYCHECK_NAME));
                wlClient.registerChallengeHandler(ch);
                challengeHandlers.put((String) call.argument(Arguments.SECURITYCHECK_NAME), ch);
                result.success(null);
                break;

            case Methods.WLCLIENT_SUBMIT_CHALLENGEANSWER:
                MFSecurityCheckChallengeHandler submitCh = challengeHandlers.get((String) call.argument(Arguments.SECURITYCHECK_NAME));
                submitCh.submitChallengeAnswer(new JSONObject(((HashMap<String, String>) call.argument(Arguments.ANSWER))));
                result.success(null);
                break;

            case Methods.WLCLIENT_CANCEL_CHALLENGE:
                MFSecurityCheckChallengeHandler cancelCh = challengeHandlers.get((String) call.argument(Arguments.SECURITYCHECK_NAME));
                cancelCh.cancel();
                result.success(null);
                break;

            default:
                result.error(MFConstants.ERR_METHOD_NAME_CODE, MFConstants.ERR_METHOD_NAME_MESSAGE, null);

        }
    }

    private void setDeviceDisplayName(String deviceDisplayName, final MethodChannel.Result result) {
        wlClient.setDeviceDisplayName(deviceDisplayName, new WLRequestListener() {
            @Override
            public void onSuccess(final WLResponse wlResponse) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        result.success(wlResponse.getResponseText());
                    }
                });
            }

            @Override
            public void onFailure(final WLFailResponse wlFailResponse) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        result.error(wlFailResponse.getErrorStatusCode(), wlFailResponse.getErrorMsg(), wlFailResponse.toString());
                    }
                });
            }
        });
    }

    private void getDeviceDisplayName(final MethodChannel.Result result) {
        wlClient.getDeviceDisplayName(new DeviceDisplayNameListener() {
            @Override
            public void onSuccess(final String deviceDisplayName) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        result.success(deviceDisplayName);
                    }
                });

            }

            @Override
            public void onFailure(final WLFailResponse wlFailResponse) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        result.error(wlFailResponse.getErrorStatusCode(), wlFailResponse.getErrorMsg(), wlFailResponse.toString());
                    }
                });
            }
        });
    }

    private void pinTrustedCertificatePublicKey(List<String> certificateFileNames, MethodChannel.Result result) {
        try {
            if (null != certificateFileNames) {
                if (certificateFileNames.size() == 1) {
                    wlClient.pinTrustedCertificatePublicKey(certificateFileNames.get(0));
                } else {
                    String certificateNames[] = new String[certificateFileNames.size()];
                    for (int j = 0; j < certificateFileNames.size(); j++) {
                        certificateNames[j] = certificateFileNames.get(j);
                    }

                    wlClient.pinTrustedCertificatePublicKey(certificateNames);
                    result.success(null);
                }
            }
        } catch (Exception e) {
            result.error("pinTrustedCertificatesPublicKey", "Certificate pinning error :" + e.getMessage(), null);
        }
    }

    private static class Methods {
        public static final String ADD_GLOBAL_HEADER = "addGlobalHeader";
        public static final String REMOVE_GLOBAL_HEADER = "removeGlobalHeader";
        public static final String SET_SERVER_URL = "setServerUrl";
        public static final String GET_SERVER_URL = "getServerUrl";
        public static final String WLCLIENT_SETDEVICE_DISPLAYNAME = "setDeviceDisplayName";
        public static final String WLCLIENT_GETDEVICE_DISPLAYNAME = "getDeviceDisplayName";
        public static final String WLCLIENT_SETHEARTBEAT_INTERVAL = "setHeartbeatInterval";
        public static final String WLCLIENT_CERTIFICATE_PINNING = "pinTrustedCertificatesPublicKey";
        public static final String WLCLIENT_REGISTER_CHALLENGEHANDLER = "registerChallengeHandler";
        public static final String WLCLIENT_SUBMIT_CHALLENGEANSWER = "submitChallengeAnswer";
        public static final String WLCLIENT_CANCEL_CHALLENGE = "cancelChallenge";
    }

    private static class Arguments {
        public static final String HEADER_NAME = "headerName";
        public static final String HEADER_VALUE = "headerValue";
        public static final String SERVER_URL = "serverUrl";
        public static final String DEVICE_DISPLAYNAME = "deviceDisplayName";
        public static final String HEARTBEAT_INTERVAL = "heartbeatIntervalInSeconds";
        public static final String CERTIFICATE_FILENAMES = "certificateFileNames";
        public static final String SECURITYCHECK_NAME = "securityCheckName";
        public static final String ANSWER = "answer";
    }
}
