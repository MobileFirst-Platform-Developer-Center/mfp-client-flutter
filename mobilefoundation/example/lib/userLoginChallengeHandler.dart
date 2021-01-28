import 'package:mobilefoundation/security_check_challenge_handler.dart';

class UserLoginChallengeHandler extends SecurityCheckChallengeHandler {
  /// Constructs an SecurityCheckChallengeHandler for a specific security check.
  UserLoginChallengeHandler() : super(securityCheck: 'UserLogin');

  @override
  void handleChallenge(Map challenge) {
    // Handle challenge
    Map credentials = new Map();
    credentials['username'] = 'admin';
    credentials['password'] = 'admin';
    if (credentials != null) {
      this.submitChallengeAnswer(answer: credentials);
    } else {
      this.cancel();
    }
  }

  @override
  void handleSuccess(Map success) {
    // Handle success. Perhaps show a success message or do nothing.
    print(success);
  }

  @override
  void handleFailure(Map error) {
    // Handle failure. Perhaps, show a failure message or ask for credentials again.
    print(error);
  }
}
