
package com.ibm.mobile.mobilefoundation;

import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;

import com.google.gson.Gson;

import io.flutter.plugin.common.MethodCall;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/* This is a singleton class that loads the method_map.json file containing information on all the native methods
 * that are interfaced by this bridge plugin.
 */
public class MFBridgeValidator {

    private static MFBridgeValidator _this = null;

    private MethodMap methodMap;

    /* Initialize the Bridge Validator by loading the method_map.json file. */
    private MFBridgeValidator(){
        try {
            Context context = MobilefoundationPlugin.getContext();
            int methodMapId = context.getResources().getIdentifier("method_map", "raw" , context.getPackageName()) ;
            InputStreamReader isr = new InputStreamReader(context.getResources().openRawResource(methodMapId));
            methodMap = new Gson().fromJson(isr, MethodMap.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static MFBridgeValidator getInstance(){
        if (_this == null) {
            _this = new MFBridgeValidator();
        }
        return _this;
    }

    public boolean validateMethodCall(MethodCall call) throws MethodNotImplementedException {
        try {
            MFMethod thisMethod = methodMap.getMethod(call.method);
            /* Check if all the required methods are present */
            List<MFArgument> arguments = thisMethod.arguments;
            for (int i=0; i < arguments.size() ; i++) {
                if (! call.hasArgument(arguments.get(i).getArgumentName() ) ) {
                    /* One of the required arguments is missing. Return false */
                    return false;
                }
            }
            return true;
        }catch(MethodNotImplementedException ex) {
            throw ex;
        }
    }

    class MethodMap {
        private ArrayList<MFMethod> methodMap;

        public MFMethod getMethod (String methodName) throws MethodNotImplementedException{
            if (methodMap != null) {
                Iterator<MFMethod> iterator = methodMap.iterator();
                while (iterator.hasNext()) {
                    MFMethod thisMethod = iterator.next();
                    if( thisMethod.getMethodName().equals(methodName) ){
                        return thisMethod;
                    }
                }
                throw new MethodNotImplementedException("Method not found in the map");
            }else {
                throw new MethodNotImplementedException("Unable to load method map from JSON");
            }
        }
    }

    class MethodNotImplementedException extends Exception {

        public MethodNotImplementedException(String message) {
            super(message) ;
        }

    }
    class MFMethod {
        private String methodName;

        private ArrayList<MFArgument> arguments;

        public String getMethodName(){
            return methodName;
        }
    }

    class MFArgument {
        private String argumentName;
        private String argumentType;

        public String getArgumentName(){
            return argumentName;
        }

        public String getArgumentType(){
            return argumentType;
        }
    }

}