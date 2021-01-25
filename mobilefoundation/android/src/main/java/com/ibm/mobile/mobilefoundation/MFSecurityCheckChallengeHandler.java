package com.ibm.mobile.mobilefoundation;

import com.worklight.wlclient.api.challengehandler.SecurityCheckChallengeHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;


public class MFSecurityCheckChallengeHandler extends SecurityCheckChallengeHandler {

    private final String HANDLE_CHALLENGE_EVENT = "handleChallengeEvent";
    private final String CHALLENGE_SUCCESS_EVENT = "challengeSuccessEvent";
    private final String CHALLENGE_FAILURE_EVENT = "challengeFailureEvent";


    public MFSecurityCheckChallengeHandler(String securityCheckName) {
        super(securityCheckName);
    }


    @Override
    public void handleChallenge(JSONObject jsonObject) {
        WLClientMethodHandler.getInstance().sendEvent(HANDLE_CHALLENGE_EVENT + getHandlerName(), jsonToMap(jsonObject));
    }


    @Override
    public void handleSuccess(JSONObject identity) {
        WLClientMethodHandler.getInstance().sendEvent(CHALLENGE_SUCCESS_EVENT + getHandlerName(), jsonToMap(identity));
    }

    @Override
    public void handleFailure(JSONObject error) {
        WLClientMethodHandler.getInstance().sendEvent(CHALLENGE_FAILURE_EVENT + getHandlerName(), jsonToMap(error));
    }

    private static Map<String, Object> jsonToMap(JSONObject json){
        Map<String, Object> retMap = new HashMap<String, Object>();

        if (json != JSONObject.NULL) {
            retMap = toMap(json);
        }
        return retMap;
    }

    private static Map<String, Object> toMap(JSONObject object) {
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

    private static List<Object> toList(JSONArray array) {
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
