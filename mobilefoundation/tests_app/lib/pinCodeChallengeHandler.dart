import 'package:mobilefoundation/securitycheckchallengehander.dart';

class PinCodeChallengeHandler extends SecurityCheckChallengeHandler {
  PinCodeChallengeHandler() : super(securityCheck: 'PinCodeAttempts');

  @override
  void handleChallenge(Map challenge) {
    // TODO: implement handleChallenge

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
    // TODO: implement handleFailure
    print(error);
  }

  @override
  void handleSuccess(Map identity) {
    // TODO: implement handleSuccess
    print(identity);
  }
}
