import 'package:mobilefoundation/security_check_challenge_handler.dart';

class PinCodeChallengeHandler extends SecurityCheckChallengeHandler {
  PinCodeChallengeHandler() : super(securityCheck: 'PinCodeAttempts');

  @override
  void handleChallenge(Map challenge) {
    Map credentials = new Map();
    credentials['pin'] = '1234';
    if (credentials != null) {
      this.submitChallengeAnswer(answer: credentials);
    } else {
      this.cancel();
    }
  }

  @override
  void handleFailure(Map error) {
    print(error);
  }

  @override
  void handleSuccess(Map identity) {
    print(identity);
  }
}
