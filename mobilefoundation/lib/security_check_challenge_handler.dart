import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Abstract base class for the IBM MobileFirst Platform security check challenge handler.
/// You must extend it to handle challenges sent by a security check.
///
/// Example registering [UserLoginCH] challenge handler class for a [UserLogin] security check:
///
/// class UserLoginChallengeHandler extends SecurityCheckChallengeHandler {
///
///   UserLoginChallengeHandler() : super(securityCheck: 'UserLogin');
///
///   @override
///   void handleChallenge(Map challenge) {
///     // Handle challenge
///     Map credentials = new Map();
///     credentials['username'] = 'admin';
///     credentials['password'] = 'admin';
///     if (credentials != null) {
///       this.submitChallengeAnswer(answer: credentials);
///     } else {
///       this.cancel();
///     }
///   }
///
///   @override
///   void handleSuccess(Map success) {
///     // Handle success. Perhaps show a success message or do nothing.
///   }
///
///   @override
///   void handleFailure(Map error) {
///     // Handle failure. Perhaps, show a failure message or ask for credentials again.
///   }
/// }
///
///  UserLoginChallengeHandler ch = new UserLoginChallengeHandler();
///  client.registerChallengeHandler(challengeHandler: ch);

abstract class SecurityCheckChallengeHandler {
  /// @nodoc
  static const MethodChannel _channel = const MethodChannel('wlclient');

  /// @nodoc
  static const String WLCLIENT_SUBMIT_CHALLENGEANSWER = "submitChallengeAnswer";

  /// @nodoc
  static const String WLCLIENT_CANCEL_CHALLENGE = "cancelChallenge";

  /// @nodoc
  static const String SECURITY_CHECKNAME = "securityCheckName";

  /// @nodoc
  static const String ANSWER = "answer";

  /// @nodoc
  String _securityCheck;

  /// Returns the name of the security check
  String get securityCheck {
    return this._securityCheck;
  }

  /// Constructs an SecurityCheckChallengeHandler for a specific security check.
  SecurityCheckChallengeHandler({@required String securityCheck}) {
    this._securityCheck = securityCheck;
  }

  /// Send an [answer] back to the security check that triggered this challenge.
  /// The answer must be in Map format. For ex:
  /// var answer = new Map();
  /// answer['username'] = 'admin';
  /// answer['password'] = 'admin';
  submitChallengeAnswer({@required Map answer}) {
    _channel.invokeMethod(WLCLIENT_SUBMIT_CHALLENGEANSWER,
        <String, dynamic>{SECURITY_CHECKNAME: securityCheck, ANSWER: answer});
  }

  /// Calling this method tells MobileFirst Platform that the challenge that you no longer want to take any actions to attempt to resolve the challenge.
  /// This method returns control to MobileFirst Platform for further handling. For example, call this method when the user clicks on a cancel button.
  cancel() {
    _channel.invokeMethod(WLCLIENT_CANCEL_CHALLENGE,
        <String, dynamic>{SECURITY_CHECKNAME: securityCheck});
  }

  /// You must implement this method to handle the challenge logic, for example to display the login screen.
  /// The framework will only call this method with [challenge] if it is determined that this challenge handler is a match for this challenge.
  void handleChallenge(Map challenge);

  /// This method is called when the MobileFirst Platform Server reports an authentication success.
  void handleSuccess(Map identity);

  /// This method is called when the MobileFirst Platform Server reports an authentication failure.
  void handleFailure(Map error);
}
