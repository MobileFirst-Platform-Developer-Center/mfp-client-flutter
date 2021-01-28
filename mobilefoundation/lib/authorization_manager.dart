import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilefoundation/accesstoken.dart';
import 'package:mobilefoundation/mobilefoundation_response.dart';

/// This class manages the OAuth interaction between the device and the authorization server.
class MFAuthorizationManager {
  /// @nodoc
  static const MethodChannel _channel =
      const MethodChannel('wlauthorizationmanager');

  /// @nodoc
  static const String MFAUTHORIZATIONMANAGER = "MFAuthorizationManager";

  // API calls
  /// @nodoc
  static const String WLAUTHORIZATIONMANAGER_OBTAINACCESSTOKEN =
      "obtainAccessToken";

  /// @nodoc
  static const String WLAUTHORIZATIONMANAGER_CLEARACCESSTOKEN =
      "clearAccessToken";

  /// @nodoc
  static const String WLAUTHORIZATIONMANAGER_LOGIN = "login";

  /// @nodoc
  static const String WLAUTHORIZATIONMANAGER_LOGOUT = "logout";

  /// @nodoc
  static const String WLAUTHORIZATIONMANAGER_SETLOGINTIMEOUT =
      "setLoginTimeOut";

  // Argument names
  /// @nodoc
  static const String SCOPE = "scope";

  /// @nodoc
  static const String ACCESSTOKEN = "accessToken";

  /// @nodoc
  static const String SECURITYCHECK = "securityCheck";

  /// @nodoc
  static const String CREDENTIALS = "credentials";

  /// @nodoc
  static const String TIMEOUT = "timeOut";

  /// Obtains an access token for the specified resource [scope] from the MobileFirst authorization server.
  /// Returns an [AccessToken] for the [scope] provided.
  /// If an error occurs, an object of type [MFResponse] is returned.
  Future<dynamic> obtainAccessToken({String scope}) async {
    final Map response = await _channel.invokeMethod(
        WLAUTHORIZATIONMANAGER_OBTAINACCESSTOKEN,
        <String, dynamic>{SCOPE: scope});
    final MFResponse mfResponse = MFResponse(mfResponse: response);
    if ((mfResponse.errorMsg?.isEmpty ?? true) ||
        (mfResponse.errorCode?.isEmpty ?? true)) {
      return AccessToken(accessToken: response);
    } else {
      throw mfResponse;
    }
  }

  /// Clears the provided [accessToken].
  ///
  /// Note: When failing to access a resource with an obtained token,
  /// call the clearAccessToken method to clear the invalid token before calling WLAuthorizationManager.obtainAccessToken to obtain a new access token.
  /// This is a non blocking call and can be `await`ed
  Future<void> clearAccessToken({@required AccessToken accessToken}) async {
    var accessTokenMap =
        AccessToken.getAccessTokenMap(accessToken: accessToken);
    _channel.invokeMethod(WLAUTHORIZATIONMANAGER_CLEARACCESSTOKEN,
        <String, dynamic>{ACCESSTOKEN: accessTokenMap});
  }

  /// Logs in to the specified [securityCheck] using the [credentials] provided.
  /// If an error occurs, an object of type [MFResponse] is returned.
  Future<MFResponse> login(
      {@required String securityCheck, @required Map credentials}) async {
    final Map response = await _channel.invokeMethod(
        WLAUTHORIZATIONMANAGER_LOGIN, <String, dynamic>{
      SECURITYCHECK: securityCheck,
      CREDENTIALS: credentials
    });

    final MFResponse mfResponse = MFResponse(mfResponse: response);
    if ((mfResponse.errorMsg?.isEmpty ?? true) ||
        (mfResponse.errorCode?.isEmpty ?? true)) {
      return mfResponse;
    } else {
      throw mfResponse;
    }
  }

  /// Logs out of a specified [securityCheck]
  /// If an error occurs, an object of type [MFResponse] is returned.
  Future<MFResponse> logout({@required String securityCheck}) async {
    final Map response = await _channel.invokeMethod(
        WLAUTHORIZATIONMANAGER_LOGOUT,
        <String, dynamic>{SECURITYCHECK: securityCheck});

    final MFResponse mfResponse = MFResponse(mfResponse: response);
    if ((mfResponse.errorMsg?.isEmpty ?? true) ||
        (mfResponse.errorCode?.isEmpty ?? true)) {
      return mfResponse;
    } else {
      throw mfResponse;
    }
  }

  /// Sets the timeout for the authorization flow. The default value is 10 seconds.
  ///
  /// This is a non blocking call and can be `await`ed
  Future<void> setLoginTimeOut({@required int loginTimeout}) async {
    return await _channel.invokeMethod(WLAUTHORIZATIONMANAGER_SETLOGINTIMEOUT,
        <String, dynamic>{TIMEOUT: loginTimeout});
  }
}
