import 'package:flutter/foundation.dart';

/// This class represents an access token issued by the Mobile Foundation server for a particular scope to a device
class AccessToken {
  /// @nodoc
  String _value;

  /// @nodoc
  String _scope;

  /// @nodoc
  String _asAuthorizationRequestHeader;

  /// @nodoc
  String _asFormEncodedBodyParameter;

  /// @nodoc
  static const String VALUE = "value";

  /// @nodoc
  static const String SCOPE = "scope";

  /// @nodoc
  static const String AS_FORMENCODED_BODY_PARAMETER =
      "asFormEncodedBodyParameter";

  /// @nodoc
  static const String AS_AUTHORIZATION_REQUEST_HEADER =
      "asAuthorizationRequestHeader";

  /// Returns the value of the access token.
  String get value {
    return this._value;
  }

  /// Returns the scope for which access-token was provided.
  String get scope {
    return this._scope;
  }

  /// Returns thes value of the access token in the required format for an authorization header.
  String get asAuthorizationRequestHeader {
    return this._asAuthorizationRequestHeader;
  }

  /// Returns the value of the access token in the required format for the body of an HTTP-request entity.
  String get asFormEncodedBodyParameter {
    return this._asFormEncodedBodyParameter;
  }

  /// @nodoc
  AccessToken({@required Map accessToken}) {
    this._value = accessToken[VALUE];
    this._scope = accessToken[SCOPE];
    this._asFormEncodedBodyParameter =
        accessToken[AS_FORMENCODED_BODY_PARAMETER];
    this._asAuthorizationRequestHeader =
        accessToken[AS_AUTHORIZATION_REQUEST_HEADER];
  }

  /// @nodoc
  static Map getAccessTokenMap({@required AccessToken accessToken}) {
    var tokenMap = new Map();
    tokenMap[VALUE] = accessToken._value;
    tokenMap[SCOPE] = accessToken._scope;
    tokenMap[AS_FORMENCODED_BODY_PARAMETER] =
        accessToken._asFormEncodedBodyParameter;
    tokenMap[AS_AUTHORIZATION_REQUEST_HEADER] =
        accessToken._asAuthorizationRequestHeader;
    return tokenMap;
  }
}
