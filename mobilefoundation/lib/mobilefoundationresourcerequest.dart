import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:mobilefoundation/mobilefoundationresponse.dart';

class MFResourceRequest {
  static const MethodChannel _channel =
      const MethodChannel('wlresourcerequest');
  //  Generates a unique identifier for every class instance and creates a mapping between native and dart MFResourceRequest class instances. This identifier is used to retrieve the specific class instance from the native layer during the invocation of native-specific class instance methods.
  final String _uuid = Uuid().v4();

  // List of API calls
  static const String WLRESOURCEREQUEST_INIT = "init";
  static const String WLRESOURCEREQUEST_SEND = "send";
  static const String WLRESOURCEREQUEST_SEND_JSON = "sendWithJSON";
  static const String WLRESOURCEREQUEST_SEND_FORM_PARAMS =
      "sendWithFormParameters";
  static const String WLRESOURCEREQUEST_SEND_REQUEST_BODY =
      "sendWithRequestBody";
  static const String WLRESOURCEREQUEST_GET_METHOD = "getMethod";
  static const String WLRESOURCEREQUEST_ADD_HEADER = "addHeader";
  static const String WLRESOURCEREQUEST_SET_QUERY_PARAMS = "setQueryParameters";
  static const String WLRESOURCEREQUEST_GET_QUERY_PARAMS = "getQueryParameters";
  static const String WLRESOURCEREQUEST_GET_QUERY_STRING = "getQueryString";
  static const String WLRESOURCEREQUEST_GET_ALL_HEADERS = "getAllHeaders";
  static const String WLRESOURCEREQUEST_GET_HEADERS = "getHeaders";
  static const String WLRESOURCEREQUEST_SET_HEADERS = "setHeaders";
  static const String WLRESOURCEREQUEST_REMOVE_HEADERS = "removeHeaders";
  static const String WLRESOURCEREQUEST_SET_TIMEOUT = "setTimeout";
  static const String WLRESOURCEREQUEST_GET_TIMEOUT = "getTimeout";
  static const String WLRESOURCEREQUEST_GET_URL = "getUrl";

  //List of arguments
  static const String HEADER_NAME = "headerName";
  static const String HEADER_VALUE = "headerValue";
  static const String PARAM_NAME = "paramName";
  static const String PARAM_VALUE = "paramValue";
  static const String UUID = "uuid";
  static const String URL = "url";
  static const String METHOD = "method";
  static const String TIMEOUT = "timeout";
  static const String SCOPE = "scope";
  static const String JSON = "json";
  static const String PARAMETERS = "parameters";
  static const String BODY = "body";
  static const String HEADERS = "headers";
  static const String BACKEND_SERVICE = "backendServiceName";

  /* Constants */

  static const String POST = "POST";
  static const String GET = "GET";
  static const String HEAD = "HEAD";
  static const String PUT = "PUT";
  static const String DELETE = "DELETE";
  static const String OPTIONS = "OPTIONS";
  static const String TRACE = "TRACE";

  Future<String> get method async {
    final String method = await _channel.invokeMethod(
        WLRESOURCEREQUEST_GET_METHOD, <String, dynamic>{UUID: _uuid});
    return method;
  }

  Future<String> get url async {
    final String url = await _channel.invokeMethod(
        WLRESOURCEREQUEST_GET_URL, <String, dynamic>{UUID: _uuid});
    return url;
  }

  Future<Map> get queryParameters async {
    final Map params = await _channel.invokeMethod(
        WLRESOURCEREQUEST_GET_QUERY_PARAMS, <String, dynamic>{UUID: _uuid});
    return params;
  }

  Future<Map> get headers async {
    final Map headers = await _channel.invokeMethod(
        WLRESOURCEREQUEST_GET_ALL_HEADERS, <String, dynamic>{UUID: _uuid});
    return headers;
  }

  Future<String> get queryString async {
    final String queryString = await _channel.invokeMethod(
        WLRESOURCEREQUEST_GET_QUERY_STRING, <String, dynamic>{UUID: _uuid});
    return queryString;
  }

  Future<int> get timeout async {
    final int timeout = await _channel.invokeMethod(
        WLRESOURCEREQUEST_GET_TIMEOUT, <String, dynamic>{UUID: _uuid});
    return timeout;
  }

  MFResourceRequest(String url, String method,
      {int timeout = 30000,
      String scope = "",
      String backendServiceName = ""}) {
    if(Platform.isIOS){
      timeout = (timeout/1000).round();
    }
    _channel.invokeMethod(WLRESOURCEREQUEST_INIT, <String, dynamic>{
      UUID: _uuid,
      URL: url,
      METHOD: method,
      TIMEOUT: timeout,
      SCOPE: scope,
      BACKEND_SERVICE: backendServiceName
    });
  }

  Future<MFResponse> send(
      {Map json, Map formParameters, String requestBody}) async {
    Map response;
    if (json != null) {
      response = await _channel.invokeMethod(WLRESOURCEREQUEST_SEND_JSON,
          <String, dynamic>{UUID: _uuid, JSON: json});
    } else if (formParameters != null) {
      response = await _channel.invokeMethod(WLRESOURCEREQUEST_SEND_FORM_PARAMS,
          <String, dynamic>{UUID: _uuid, PARAMETERS: formParameters});
    } else if (requestBody != null) {
      response = await _channel.invokeMethod(
          WLRESOURCEREQUEST_SEND_REQUEST_BODY,
          <String, dynamic>{UUID: _uuid, BODY: requestBody});
    } else {
      response = await _channel
          .invokeMethod(WLRESOURCEREQUEST_SEND, <String, dynamic>{UUID: _uuid});
    }

    final MFResponse mfResponse = MFResponse(mfResponse: response);
    if ((mfResponse.errorMsg?.isEmpty ?? true) ||
        (mfResponse.errorCode?.isEmpty ?? true)) {
      return mfResponse;
    } else {
      throw mfResponse;
    }
  }

  Future<void> addHeader(
      {@required String headerName, @required String headerValue}) async {
    await _channel.invokeMethod(WLRESOURCEREQUEST_ADD_HEADER, <String, dynamic>{
      UUID: _uuid,
      HEADER_NAME: headerName,
      HEADER_VALUE: headerValue
    });
  }

  Future<void> setQueryParameters(
      {@required String paramName, @required String paramValue}) async {
    await _channel.invokeMethod(
        WLRESOURCEREQUEST_SET_QUERY_PARAMS, <String, dynamic>{
      UUID: _uuid,
      PARAM_NAME: paramName,
      PARAM_VALUE: paramValue
    });
  }

  Future<List> getHeaders({@required String headerName}) async {
    final List headers = await _channel.invokeMethod(
        WLRESOURCEREQUEST_GET_HEADERS,
        <String, dynamic>{UUID: _uuid, HEADER_NAME: headerName});
    return headers;
  }

  Future<void> setHeaders({@required Map headers}) async {
    await _channel.invokeMethod(WLRESOURCEREQUEST_SET_HEADERS,
        <String, dynamic>{UUID: _uuid, HEADERS: headers});
  }

  Future<void> removeHeaders({@required String headerName}) async {
    await _channel.invokeMethod(WLRESOURCEREQUEST_REMOVE_HEADERS,
        <String, dynamic>{UUID: _uuid, HEADER_NAME: headerName});
  }

  Future<void> setTimeout({@required int timeout}) async {
    await _channel.invokeMethod(WLRESOURCEREQUEST_SET_TIMEOUT,
        <String, dynamic>{UUID: _uuid, TIMEOUT: timeout});
  }
}
