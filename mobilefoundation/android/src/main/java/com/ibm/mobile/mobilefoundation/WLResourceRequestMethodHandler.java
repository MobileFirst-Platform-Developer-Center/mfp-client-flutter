package com.ibm.mobile.mobilefoundation;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResourceRequest;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class WLResourceRequestMethodHandler implements MethodChannel.MethodCallHandler {
    private static Activity activity;
    private static WLResourceRequestMethodHandler instance;
    private HashMap<String, WLResourceRequest> requestMap = new HashMap<>();

    private WLResourceRequestMethodHandler() {

    }

    public static WLResourceRequestMethodHandler getInstance() {
        if (null == instance) {
            instance = new WLResourceRequestMethodHandler();
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

            case Methods.WLRESOURCEREQUEST_INIT:
                try {
                    WLResourceRequest wlResourceRequest;
                    String uuid = (String) call.argument(Arguments.UUID);
                    URI uri = new URI((String) call.argument(Arguments.URL));
                    String scope = (String) call.argument(Arguments.SCOPE);
                    String method = (String) call.argument(Arguments.METHOD);
                    int timeout = (int) call.argument(Arguments.TIMEOUT);
                    String backendServiceName = (String) call.argument(Arguments.BACKEND_SERVICE);

                    if (backendServiceName != null && !backendServiceName.isEmpty()) {
                        wlResourceRequest = new WLResourceRequest(uri, method, backendServiceName, timeout);
                    } else {
                        wlResourceRequest = new WLResourceRequest(uri, method, timeout, scope);
                    }
                    requestMap.put(uuid, wlResourceRequest);
                    result.success(null);
                } catch (Exception e) {
                    result.error("init", "WLResourceRequest init error :" + e.getMessage(), null);

                }
                break;

            case Methods.SEND:
                requestMap.get((String) call.argument(Arguments.UUID)).send(new WLResourceRequestListener(result));
                break;

            case Methods.SEND_JSON:
                requestMap.get((String) call.argument(Arguments.UUID)).send(new JSONObject((HashMap<String, String>) call.argument(Arguments.JSON)), new WLResourceRequestListener(result));
                break;

            case Methods.SEND_FORM_PARAMS:
                requestMap.get((String) call.argument(Arguments.UUID)).send((HashMap<String, String>) call.argument(Arguments.PARAMETERS), new WLResourceRequestListener(result));
                break;

            case Methods.SEND_REQUEST_BODY:
                requestMap.get((String) call.argument(Arguments.UUID)).send((String) call.argument(Arguments.BODY), new WLResourceRequestListener(result));
                break;

            case Methods.GET_METHOD:
                result.success(requestMap.get((String) call.argument(Arguments.UUID)).getMethod());
                break;

            case Methods.ADD_HEADER:
                requestMap.get((String) call.argument(Arguments.UUID)).addHeader((String) call.argument(Arguments.HEADER_NAME), (String) call.argument(Arguments.HEADER_VALUE));
                result.success(null);
                break;

            case Methods.SET_QUERY_PARAMS:
                requestMap.get((String) call.argument(Arguments.UUID)).setQueryParameter((String) call.argument(Arguments.PARAM_NAME), (String) call.argument(Arguments.PARAM_VALUE));
                result.success(null);
                break;

            case Methods.GET_QUERY_PARAMS:
                result.success(requestMap.get((String) call.argument(Arguments.UUID)).getQueryParameters());
                break;

            case Methods.GET_QUERY_STRING:
                result.success(requestMap.get((String) call.argument(Arguments.UUID)).getQueryString());
                break;

            case Methods.GET_ALL_HEADERS:
                result.success(requestMap.get((String) call.argument(Arguments.UUID)).getAllHeaders());
                break;

            case Methods.GET_HEADERS:
                result.success(requestMap.get((String) call.argument(Arguments.UUID)).getHeaders((String) call.argument(Arguments.HEADER_NAME)));
                break;

            case Methods.SET_HEADERS:
                requestMap.get((String) call.argument(Arguments.UUID)).setHeaders((HashMap<String, List<String>>) call.argument(Arguments.HEADERS));
                result.success(null);
                break;

            case Methods.REMOVE_HEADERS:
                requestMap.get((String) call.argument(Arguments.UUID)).removeHeaders((String) call.argument(Arguments.HEADER_NAME));
                result.success(null);
                break;

            case Methods.SET_TIMEOUT:
                requestMap.get((String) call.argument(Arguments.UUID)).setTimeout((int) call.argument(Arguments.TIMEOUT));
                result.success(null);
                break;

            case Methods.GET_TIMEOUT:
                result.success(requestMap.get((String) call.argument(Arguments.UUID)).getTimeout());
                break;

            case Methods.GET_URL:
                result.success(requestMap.get((String) call.argument(Arguments.UUID)).getUrl().toString());
                break;

            default:
                result.error(MFConstants.ERR_METHOD_NAME_CODE, MFConstants.ERR_METHOD_NAME_MESSAGE, null);

        }
    }


    private class WLResourceRequestListener implements WLResponseListener {
        final MethodChannel.Result result;

        public WLResourceRequestListener(final MethodChannel.Result result) {
            this.result = result;
        }

        public void onSuccess(final WLResponse response) {

            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Map<String, Object> mfResponse = new HashMap();
                    mfResponse.put(Arguments.STATUS, response.getStatus());
                    mfResponse.put(Arguments.RESPONSE_JSON, jsonToMap(response.getResponseJSON()));
                    mfResponse.put(Arguments.RESPONSE_TEXT, response.getResponseText());
                    mfResponse.put(Arguments.HEADERS, response.getHeaders());
                    result.success(mfResponse);
                }
            });
        }

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


        private  Map<String, Object> jsonToMap(JSONObject json){
            Map<String, Object> retMap = new HashMap<String, Object>();

            if (json != JSONObject.NULL) {
                retMap = toMap(json);
            }
            return retMap;
        }

        private  Map<String, Object> toMap(JSONObject object) {
            Map<String, Object> map = new HashMap<String, Object>();
            try {
                Iterator<String> keysItr = object.keys();
                while (keysItr.hasNext()) {
                    String key = keysItr.next();
                    Object value = object.get(key);

                    if (value instanceof JSONArray) {
                        value = toList((JSONArray) value);
                    } else if (value instanceof JSONObject) {
                        value = toMap((JSONObject) value);
                    }
                    map.put(key, value);
                }
            } catch (JSONException ex) {
                // Do nothing and fail silently
            }
            return map;
        }


        private  List<Object> toList(JSONArray array) {
            List<Object> list = new ArrayList<Object>();
            try {
                for (int i = 0; i < array.length(); i++) {
                    Object value = array.get(i);
                    if (value instanceof JSONArray) {
                        value = toList((JSONArray) value);
                    } else if (value instanceof JSONObject) {
                        value = toMap((JSONObject) value);
                    }
                    list.add(value);
                }
            } catch (JSONException ex) {
                // Do nothing and fail silently
            }
            return list;
        }
    }

    private static class Methods {

        public static final String WLRESOURCEREQUEST_INIT = "init";
        public static final String SEND = "send";
        public static final String SEND_JSON = "sendWithJSON";
        public static final String SEND_FORM_PARAMS = "sendWithFormParameters";
        public static final String SEND_REQUEST_BODY = "sendWithRequestBody";
        public static final String GET_METHOD = "getMethod";
        public static final String ADD_HEADER = "addHeader";
        public static final String SET_QUERY_PARAMS = "setQueryParameters";
        public static final String GET_QUERY_PARAMS = "getQueryParameters";
        public static final String GET_QUERY_STRING = "getQueryString";
        public static final String GET_ALL_HEADERS = "getAllHeaders";
        public static final String GET_HEADERS = "getHeaders";
        public static final String SET_HEADERS = "setHeaders";
        public static final String REMOVE_HEADERS = "removeHeaders";
        public static final String SET_TIMEOUT = "setTimeout";
        public static final String GET_TIMEOUT = "getTimeout";
        public static final String GET_URL = "getUrl";
    }

    private static class Arguments {

        public static final String UUID = "uuid";
        public static final String URL = "url";
        public static final String METHOD = "method";
        public static final String TIMEOUT = "timeout";
        public static final String SCOPE = "scope";
        public static final String BACKEND_SERVICE = "backendServiceName";
        public static final String STATUS = "status";
        public static final String RESPONSE_TEXT = "responseText";
        public static final String RESPONSE_JSON = "responseJSON";
        public static final String ERROR_CODE = "errorCode";
        public static final String ERROR_MSG  = "errorMsg";
        public static final String HEADER_NAME = "headerName";
        public static final String HEADER_VALUE = "headerValue";
        public static final String PARAM_NAME = "paramName";
        public static final String PARAM_VALUE = "paramValue";
        public static final String JSON = "json";
        public static final String PARAMETERS = "parameters";
        public static final String BODY = "body";
        public static final String HEADERS = "headers";

    }
}
