package com.ibm.mobile.mobilefoundation;

import com.worklight.common.Logger;

import androidx.annotation.NonNull;
import org.json.JSONObject;
import java.util.Map;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LoggerMethodHandler implements MethodChannel.MethodCallHandler {

    private static LoggerMethodHandler instance;

    private LoggerMethodHandler(){}

    public static LoggerMethodHandler getInstance() {
        if(instance == null){
            instance = new LoggerMethodHandler();
        }
        return instance;
    }

    // Converting String Level received from Dart layer to Logger.LEVEL
    public Logger.LEVEL getLoggerLevel(String level){
        switch (level) {
            case LogLevels.TRACE:
                return Logger.LEVEL.TRACE;
            case LogLevels.DEBUG:
                return Logger.LEVEL.DEBUG;
            case LogLevels.LOG:
                return Logger.LEVEL.LOG;
            case LogLevels.INFO:
                return Logger.LEVEL.INFO;
            case LogLevels.WARN:
                return Logger.LEVEL.WARN;
            case LogLevels.ERROR:
                return Logger.LEVEL.ERROR;
            case LogLevels.FATAL:
                return Logger.LEVEL.FATAL;
            case LogLevels.ANALYTICS:
                return Logger.LEVEL.ANALYTICS;
            default:
                return Logger.LEVEL.DEBUG;
        }
    }

    // Converting Logger.LEVEL to String for sending it to dart layer
    public String getLoggerString(Logger.LEVEL level){
        switch (level){
            case ANALYTICS:
                return LogLevels.ANALYTICS;
            case FATAL:
                return LogLevels.FATAL;
            case ERROR:
                return LogLevels.ERROR;
            case WARN:
                return LogLevels.WARN;
            case INFO:
                return LogLevels.INFO;
            case LOG:
                return LogLevels.LOG;
            case DEBUG:
                return LogLevels.DEBUG;
            case TRACE:
                return LogLevels.TRACE;
            default:
                return LogLevels.DEBUG;
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch ( call.method ) {
            case Methods.SETLEVEL:
                Logger.setLevel(getLoggerLevel((String) call.argument(Arguments.LEVEL)));
                result.success(null);
                break;
            case Methods.GETLEVEL:
                Logger.LEVEL level = Logger.getLevel();
                result.success(getLoggerString(level));
                break;
            case Methods.UPDATECONFIGFROMSERVER:
                Logger.updateConfigFromServer();
                result.success(null);
                break;
            case Methods.SEND:
                Logger.send();
                result.success(null);
                break;
            case Methods.SETCAPTURE:
                Logger.setCapture((boolean) call.argument(Arguments.FLAG));
                result.success(null);
                break;
            case Methods.GETCAPTURE:
                boolean getCapture = Logger.getCapture();
                result.success(getCapture);
                break;
            case Methods.SETMAXFILESIZE:
                Logger.setMaxFileSize((int) call.argument(Arguments.BYTES));
                result.success(null);
                break;
            case Methods.GETMAXFILESIZE:
                int fileSize = Logger.getMaxFileSize();
                result.success(fileSize);
                break;
            case Methods.ENTER:
                Logger.enter((String) call.argument(Arguments.CLASSNAME),(String) call.argument(Arguments.METHODNAME));
                result.success(null);
                break;
            case Methods.EXIT:
                Logger.exit((String) call.argument(Arguments.CLASSNAME),(String) call.argument(Arguments.METHODNAME));
                result.success(null);
                break;
            case Methods.TRACE:
                if(call.argument(Arguments.METADATA) == null){
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).trace((String) call.argument(Arguments.MESSAGE));
                }
                else{
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).trace((String) call.argument(Arguments.MESSAGE),new JSONObject((Map) call.argument(Arguments.METADATA)));
                }
                result.success(null);
                break;
            case Methods.DEBUG:
                if(call.argument(Arguments.METADATA) == null){
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).debug((String) call.argument(Arguments.MESSAGE));
                }
                else{
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).debug((String) call.argument(Arguments.MESSAGE),new JSONObject((Map) call.argument(Arguments.METADATA)));
                }
                result.success(null);
                break;
            case Methods.LOG:
                if(call.argument(Arguments.METADATA) == null){
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).log((String) call.argument(Arguments.MESSAGE));
                }
                else{
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).log((String) call.argument(Arguments.MESSAGE),new JSONObject((Map) call.argument(Arguments.METADATA)));
                }
                result.success(null);
                break;
            case Methods.INFO:
                if(call.argument(Arguments.METADATA) == null){
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).info((String) call.argument(Arguments.MESSAGE));
                }
                else{
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).info((String) call.argument(Arguments.MESSAGE),new JSONObject((Map) call.argument(Arguments.METADATA)));
                }
                result.success(null);
                break;
            case Methods.WARN:
                if(call.argument(Arguments.METADATA) == null){
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).warn((String) call.argument(Arguments.MESSAGE));
                }
                else{
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).warn((String) call.argument(Arguments.MESSAGE),new JSONObject((Map) call.argument(Arguments.METADATA)));
                }
                result.success(null);
                break;
            case Methods.ERROR:
                if(call.argument(Arguments.METADATA) == null){
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).error((String) call.argument(Arguments.MESSAGE));
                }
                else{
                    Logger.getInstance((String) call.argument(Arguments.PACKAGE_NAME)).error((String) call.argument(Arguments.MESSAGE),new JSONObject((Map) call.argument(Arguments.METADATA)));
                }
                result.success(null);
                break;
        }
    }

    /* Method Names */
    private static class Methods {
        public static final String TRACE = "trace";
        public static final String DEBUG = "debug";
        public static final String LOG = "log";
        public static final String INFO = "info";
        public static final String WARN = "warn";
        public static final String ERROR = "error";
        public static final String FATAL = "fatal";
        public static final String SETLEVEL = "setLevel";
        public static final String GETLEVEL = "getLevel";
        public static final String UPDATECONFIGFROMSERVER = "updateConfigFromServer";
        public static final String SEND = "send";
        public static final String SETCAPTURE = "setCapture";
        public static final String GETCAPTURE = "getCapture";
        public static final String SETMAXFILESIZE = "setMaxFileSize";
        public static final String GETMAXFILESIZE = "getMaxFileSize";
        public static final String ENTER = "enter";
        public static final String EXIT = "exit";
    }

    /* Method Arguments */
    private static class Arguments {
        public static final String LEVEL = "level";
        public static final String MESSAGE = "message";
        public static final String PACKAGE_NAME = "packageName";
        public static final String BYTES = "bytes";
        public static final String FLAG = "flag";
        public static final String METADATA = "metadata";
        public static final String CLASSNAME = "className";
        public static final String METHODNAME = "methodName";
    }

    /* Log Levels */
    private static class LogLevels{
        public static final String TRACE = "TRACE";
        public static final String DEBUG = "DEBUG";
        public static final String LOG = "LOG";
        public static final String INFO = "INFO";
        public static final String WARN = "WARN";
        public static final String ERROR = "ERROR";
        public static final String FATAL = "FATAL";
        public static final String ANALYTICS = "ANALYTICS";
    }
}
