import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilefoundation/mobilefoundationresponse.dart';
import 'package:mobilefoundation/securitycheckchallengehander.dart';

/// This class exposes methods that you use to communicate with the IBM MobileFirst Platform Server.
class MFClient {
  /// @nodoc
  static const MethodChannel _channel = const MethodChannel('wlclient');

  // List of API calls
  /// @nodoc
  static const String WLCLIENT_ADDGLOBALHEADER = "addGlobalHeader";

  /// @nodoc
  static const String WLCLIENT_REMOVEGLOBALHEADER = "removeGlobalHeader";

  /// @nodoc
  static const String WLCLIENT_SETSERVERURL = "setServerUrl";

  /// @nodoc
  static const String WLCLIENT_GETSERVERURL = "getServerUrl";
  static const String WLCLIENT_SETDEVICE_DISPLAYNAME = "setDeviceDisplayName";
  static const String WLCLIENT_GETDEVICE_DISPLAYNAME = "getDeviceDisplayName";
  static const String WLCLIENT_SETHEARTBEAT_INTERVAL = "setHeartbeatInterval";
  static const String WLCLIENT_CERTIFICATE_PINNING =
      "pinTrustedCertificatesPublicKey";
  static const String WLCLIENT_REGISTER_CHALLENGEHANDLER =
      "registerChallengeHandler";

  //List of arguments
  /// @nodoc
  static const String HEADER_NAME = "headerName";

  /// @nodoc
  static const String HEADER_VALUE = "headerValue";

  /// @nodoc
  static const String SERVER_URL = "serverUrl";
  static const String DEVICE_DISPLAYNAME = "deviceDisplayName";
  static const String HEARTBEAT_INTERVAL = "heartbeatIntervalInSeconds";
  static const String CERTIFICATE_FILENAMES = "certificateFileNames";
  static const String SECURITY_CHECKNAME = "securityCheckName";
  static const String ANSWER = "answer";

  /// Adds a header with name [headerName] and value [headerValue] to all calls
  /// made by this package.
  ///
  /// This is a non blocking call and can be `await`ed
  Future<void> addGlobalHeader(
      {@required String headerName, @required String headerValue}) async {
    return await _channel.invokeMethod(WLCLIENT_ADDGLOBALHEADER,
        <String, dynamic>{HEADER_NAME: headerName, HEADER_VALUE: headerValue});
  }

  /// Removes a header that was previously added by the [addGlobalHeader] method
  ///
  /// This is a non blocking call and can be `await`ed
  Future<void> removeGlobalHeader({@required String headerName}) async {
    return await _channel.invokeMethod(WLCLIENT_REMOVEGLOBALHEADER,
        <String, dynamic>{HEADER_NAME: headerName});
  }

  /// Modifies the URL of the Mobile Foundation server during runtime to
  /// [serverUrl]. Calling this method clears the client context and the app is
  /// no longer logged in to any Mobile Foundation server. Subsequent calls to
  /// the Mobile Foundation server will cause a new device registration.
  /// Verifying the validity of the new URL is on the developer.
  ///
  /// [serverUrl] must be of the format `http://mobilefoundationserver.domain.com:port/mfp`
  ///
  /// This is a non blocking call and can be `await`ed
  Future<void> setServerUrl({@required String serverUrl}) async {
    return await _channel.invokeMethod(
        WLCLIENT_SETSERVERURL, <String, dynamic>{SERVER_URL: serverUrl});
  }

  /// Returns the URL of the Mobile Foundation server.
  ///
  /// This is a non blocking call and can be `await`ed
  Future<String> getServerUrl() async {
    final String serverUrl = await _channel.invokeMethod(WLCLIENT_GETSERVERURL);
    return serverUrl;
  }

  /// Sets the display name of the device.
  /// The [deviceDisplayName] is stored in the MobileFirst Server registration data.
  Future<void> setDeviceDisplayName(
      {@required String deviceDisplayName}) async {
    final dynamic response = await _channel.invokeMethod(WLCLIENT_SETDEVICE_DISPLAYNAME,
        <String, dynamic>{DEVICE_DISPLAYNAME: deviceDisplayName});
        if(response is String){
      return response;
    }else{
      final MFResponse mfResponse = MFResponse(mfResponse: response);
      throw mfResponse;
    }
  }

  /// Returns the display name of the device. The display name is retrieved from the MobileFirst Server registration data.
  Future<String> getDeviceDisplayName() async {
    final dynamic response =
        await _channel.invokeMethod(WLCLIENT_GETDEVICE_DISPLAYNAME);
    if(response is String){
      return response;
    }else{
      final MFResponse mfResponse = MFResponse(mfResponse: response);
      throw mfResponse;
    }
  }

  /// The number of seconds([heartbeatIntervalInSeconds]) between which a heartbeat request is sent to the MobileFirst server to keep the connection alive.
  /// The default interval is 7 minutes or 420 seconds. Heartbeats are sent only when the app is in the foreground.
  ///
  /// This is a non blocking call and can be `await`ed
  Future<void> setHeartbeatInterval(
      {@required int heartbeatIntervalInSeconds}) async {
    return _channel.invokeMethod(WLCLIENT_SETHEARTBEAT_INTERVAL,
        <String, dynamic>{HEARTBEAT_INTERVAL: heartbeatIntervalInSeconds});
  }

  /// Pins the host X509 certificate public key to the client application.
  /// Secured calls to the pinned remote host will be checked for a public key match.
  /// Secured calls to other hosts containing other certificates will be rejected.
  /// Some mobile operating systems might cache the certificate validation check results.
  /// Your app must call the certificate pinning method before making a secured request.
  /// Calling this method a second time overrides any previous pinning operation.
  /// The certificates must be in DER format. When multiple certificates are pinned, a secured call is checked for a match with any one of the certificates
  Future<void> pinTrustedCertificatesPublicKey(
      {@required List<String> certificateFileNames}) async {
    final Map response = await _channel.invokeMethod(WLCLIENT_CERTIFICATE_PINNING,
        <String, dynamic>{CERTIFICATE_FILENAMES: certificateFileNames});
    final MFResponse mfResponse = MFResponse(mfResponse: response);
    if ((mfResponse.errorMsg?.isEmpty ?? true) ||
        (mfResponse.errorCode?.isEmpty ?? true)) {
      return mfResponse;
    } else {
      throw mfResponse;
    }
  }

  /// Register a security check challenge handler [challengeHandler] to handle the challenges recieved for a given security check.
  registerChallengeHandler(
      {@required SecurityCheckChallengeHandler challengeHandler}) {
    // Listen to the 'challengeHandlerEvent' events to receive challenge handler method from bridge layer to invoke corresponding challenge handler method in dart.
    // A 'challengeHandlerEvent' event is sent when bridge layer recieves the challenges for the registered challenge handler [challengeHandler].
    // For example when a user try to access a resource protected by a security check, one of the challenge handler methods (handleChallenge, handleSuccess and handleFailure) of a registered challenge handler class will be called in bridge layer.
    // The called challenge handler method in bridge layer is then sent to dart layer.

    void _listener(dynamic event) {
      // The  _challengeEvent map stores the keys 'challengeHandlerMethod' containing challange handler method and 'mapObject' containing challange handler method's argument map object.
      final Map<dynamic, dynamic> _challengeEvent = event;

      // Validates recieved '_challengeEvent' map data to invoke corresponding challenge handler method in dart.
      if (_challengeEvent['challengeHandlerMethod'] ==
          'handleChallengeEvent' + challengeHandler.securityCheck) {
        challengeHandler.handleChallenge(_challengeEvent['mapObject']);
      } else if (_challengeEvent['challengeHandlerMethod'] ==
          'challengeSuccessEvent' + challengeHandler.securityCheck) {
        challengeHandler.handleSuccess(_challengeEvent['mapObject']);
      } else if (_challengeEvent['challengeHandlerMethod'] ==
          'challengeFailureEvent' + challengeHandler.securityCheck) {
        challengeHandler.handleFailure(_challengeEvent['mapObject']);
      }
    }

    // The 'challengeHandlerEvent' event channel is used to receive challenges for the registered challenge handler from bridge layer.
    // The corresponding 'challengeHandlerEvent' event channel in bridge layer will also be implemented to send events.
    EventChannel('challengeHandlerEvent')
        .receiveBroadcastStream()
        .listen(_listener);

    _channel.invokeMethod(WLCLIENT_REGISTER_CHALLENGEHANDLER,
        <String, dynamic>{SECURITY_CHECKNAME: challengeHandler.securityCheck});
  }
}
