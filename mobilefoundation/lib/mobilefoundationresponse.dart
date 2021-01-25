import 'package:flutter/foundation.dart';

class MFResponse {
  int _status;
  String _errorCode;
  String _responseText;
  String _errorMsg;
  Map _responseJSON;
  Map _headers;

  static const String STATUS = "status";
  static const String RESPONSE_TEXT = "responseText";
  static const String RESPONSE_JSON = "responseJSON";
  static const String HEADERS = "headers";
  static const String ERROR_CODE = "errorCode";
  static const String ERROR_MSG = "errorMsg";

  int get status {
    return this._status;
  }

  String get errorCode {
    return this._errorCode;
  }

  String get responseText {
    return this._responseText;
  }

  String get errorMsg {
    return this._errorMsg;
  }

  Map get responseJSON {
    return this._responseJSON;
  }

  Map get headers {
    return this._headers;
  }

  MFResponse({@required Map mfResponse}) {
    this._status = (mfResponse ?? const {})[STATUS] ?? -1;
    this._errorCode = (mfResponse ?? const {})[ERROR_CODE] ?? '';
    this._errorMsg = (mfResponse ?? const {})[ERROR_MSG] ?? '';
    this._responseText = (mfResponse ?? const {})[RESPONSE_TEXT] ?? '';
    this._responseJSON = (mfResponse ?? const {})[RESPONSE_JSON] ?? {};
    this._headers = (mfResponse ?? const {})[HEADERS] ?? {};
  }
}
