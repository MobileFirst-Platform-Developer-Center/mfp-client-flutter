import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Levels supported by the MFLogger class.
class MFLoggerLevel {
  static const String TRACE = "TRACE";
  static const String DEBUG = "DEBUG";
  static const String LOG = "LOG";
  static const String INFO = "INFO";
  static const String WARN = "WARN";
  static const String ERROR = "ERROR";
  static const String ANALYTICS = "ANALYTICS";

  /// @nodoc
  MFLoggerLevel();
}

/// MFLogger is a class for logging that provides some enhanced capability such as capturing log calls, package filtering,
/// and log level control at both global and individual package scope.
///
/// It also provides a method call to send captured logs to the IBM MobileFirst Platform server.
///
/// Log file data is sent to the IBM MobileFirst Platform server when this class's send() method is called and the accumulated log size is greater than zero.
/// When the log data is successfully uploaded, the persisted local log data is deleted.
///
/// When this Logger class's capture flag is turned on via setCapture(true) method call,
/// all messages passed through this class's log methods will be persisted to store in the following JSON object format:
///
/// ```
/// {
///   "timestamp"    : "17-02-2013 13:54:27:123",  // "dd-MM-yyyy hh:mm:ss:S"
///   "level"        : "ERROR",                    // FATAL || ERROR || WARN || INFO || LOG || DEBUG || TRACE
///   "package"      : "your_tag",                 // typically a class name, app name, or JavaScript object name
///   "msg"          : "the message",              // a helpful log message
///   "metadata"     : {"hi": "world"},            // (optional) additional JSON metadata, appended via doLog API call
///   "threadid"     : long                        // (optional) id of the current thread
/// }
/// ```
class MFLogger {
  static const MethodChannel _channel = const MethodChannel('logger');
  String packageName;

  // API calls
  /// @nodoc
  static const String LOGGER_TRACE = "trace";

  /// @nodoc
  static const String LOGGER_DEBUG = "debug";

  /// @nodoc
  static const String LOGGER_LOG = "log";

  /// @nodoc
  static const String LOGGER_INFO = "info";

  /// @nodoc
  static const String LOGGER_WARN = "warn";

  /// @nodoc
  static const String LOGGER_ERROR = "error";

  /// @nodoc
  static const String LOGGER_SETLEVEL = "setLevel";

  /// @nodoc
  static const String LOGGER_GETLEVEL = "getLevel";

  /// @nodoc
  static const String LOGGER_UPDATECONFIGFROMSERVER = "updateConfigFromServer";

  /// @nodoc
  static const String LOGGER_SEND = "send";

  /// @nodoc
  static const String LOGGER_SETCAPTURE = "setCapture";

  /// @nodoc
  static const String LOGGER_GETCAPTURE = "getCapture";

  /// @nodoc
  static const String LOGGER_SETMAXFILESIZE = "setMaxFileSize";

  /// @nodoc
  static const String LOGGER_GETMAXFILESIZE = "getMaxFileSize";

  /// @nodoc
  static const String LOGGER_ENTER = "enter";

  /// @nodoc
  static const String LOGGER_EXIT = "exit";

  //Arguments
  /// @nodoc
  static const String PACKAGE_NAME = "packageName";

  /// @nodoc
  static const String MESSAGE = "message";

  /// @nodoc
  static const String LEVEL = "level";

  /// @nodoc
  static const String BYTES = "bytes";

  /// @nodoc
  static const String FLAG = "flag";

  /// @nodoc
  static const String METADATA = "metadata";

  /// @nodoc
  static const String CLASSNAME = "className";

  /// @nodoc
  static const String METHODNAME = "methodName";

  /// @nodoc
  static const String DART = "Dart";

  /// Initializes logger with specified [packageName]
  ///
  /// ```
  /// MFLogger logger = new MFLogger(packageName: "FeedbackModule");
  /// logger.trace(message: "Log at trace level");
  /// ```
  MFLogger({String packageName}) {
    this.packageName = packageName;
  }

  /// Sets the level and above at which log messages should be saved/printed.
  static void setLevel({@required String level}) async {
    _channel.invokeMethod(LOGGER_SETLEVEL, <String, dynamic>{LEVEL: level});
  }

  /// Returns the current Logger level.
  static Future<String> getLevel() async {
    final String level = await _channel.invokeMethod(LOGGER_GETLEVEL);
    return level;
  }

  /// Reads the log configuration from the Mobile Foundation server and applies it to the logger.
  static void updateConfigFromServer() {
    _channel.invokeMethod(LOGGER_UPDATECONFIGFROMSERVER);
  }

  /// Sends the accumulated log data when the persistent log buffer exists and is not empty.
  static void send() {
    _channel.invokeMethod(LOGGER_SEND);
  }

  /// Turns logging on or off globally.
  static void setCapture({@required bool flag}) {
    _channel.invokeMethod(LOGGER_SETCAPTURE, <String, dynamic>{FLAG: flag});
  }

  /// Returns whether the Logging is enabled or not
  static Future<bool> getCapture() async {
    final bool capture = await _channel.invokeMethod(LOGGER_GETCAPTURE);
    return capture;
  }

  /// Sets the maximum size of the local log file.
  ///
  /// If logs are not sent before the maximum size is reached, the log file is then purged in favor of newer logs.
  static void setMaxFileSize({@required int bytes}) {
    _channel
        .invokeMethod(LOGGER_SETMAXFILESIZE, <String, dynamic>{BYTES: bytes});
  }

  /// Returns the current setting for the maximum file size threshold.
  static Future<int> getMaxFileSize() async {
    final int fileSize = await _channel.invokeMethod(LOGGER_GETMAXFILESIZE);
    return fileSize;
  }

  /// @nodoc
  static void enter(
      {@required String className,
      @required String methodName,
      @required String lineNumber}) {
    className = DART + "-" + className;
    methodName = methodName + "-" + lineNumber;
    _channel.invokeMethod(LOGGER_ENTER,
        <String, dynamic>{CLASSNAME: className, METHODNAME: methodName});
  }

  /// @nodoc
  static void exit(
      {@required String className,
      @required String methodName,
      @required String lineNumber}) {
    className = DART + "-" + className;
    methodName = methodName + "-" + lineNumber;
    _channel.invokeMethod(LOGGER_EXIT,
        <String, dynamic>{CLASSNAME: className, METHODNAME: methodName});
  }

  /// Logs the [message] at [TRACE] level with any optional [metadata]
  void trace({@required String message, Map metadata}) async {
    _channel.invokeMethod(LOGGER_TRACE, <String, dynamic>{
      PACKAGE_NAME: this.packageName,
      MESSAGE: message,
      METADATA: metadata
    });
  }

  /// Logs the [message] at [DEBUG] level with any optional [metadata]
  void debug({@required String message, Map metadata}) async {
    _channel.invokeMethod(LOGGER_DEBUG, <String, dynamic>{
      PACKAGE_NAME: this.packageName,
      MESSAGE: message,
      METADATA: metadata
    });
  }

  /// Logs the [message] at [VERBOSE] level with any optional [metadata]
  void log({@required String message, Map metadata}) async {
    _channel.invokeMethod(LOGGER_LOG, <String, dynamic>{
      PACKAGE_NAME: this.packageName,
      MESSAGE: message,
      METADATA: metadata
    });
  }

  /// Logs the [message] at [INFO] level with any optional [metadata]
  void info({@required String message, Map metadata}) async {
    _channel.invokeMethod(LOGGER_INFO, <String, dynamic>{
      PACKAGE_NAME: this.packageName,
      MESSAGE: message,
      METADATA: metadata
    });
  }

  /// Logs the [message] at [WARN] level with any optional [metadata]
  void warn({@required String message, Map metadata}) async {
    _channel.invokeMethod(LOGGER_INFO, <String, dynamic>{
      PACKAGE_NAME: this.packageName,
      MESSAGE: message,
      METADATA: metadata
    });
  }

  /// Logs the [message] at [ERROR] level with any optional [metadata]
  void error({@required String message, Map metadata}) async {
    _channel.invokeMethod(LOGGER_ERROR, <String, dynamic>{
      PACKAGE_NAME: this.packageName,
      MESSAGE: message,
      METADATA: metadata
    });
  }
}
