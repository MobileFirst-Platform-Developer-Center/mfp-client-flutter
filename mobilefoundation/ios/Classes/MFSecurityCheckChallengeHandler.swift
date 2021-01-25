import Foundation
import IBMMobileFirstPlatformFoundation

class MFSecurityCheckChallengeHandler : SecurityCheckChallengeHandler {
    
    override func handleChallenge(_ challenge: [AnyHashable: Any]!) {
        WLClientMethodHandler.sendEvent(eventName: Constants.HANDLE_CHALLENGE_EVENT + self.securityCheck, mapObject: challenge)
    }
    
    override func handleFailure(_ failure: [AnyHashable: Any]!) {
        WLClientMethodHandler.sendEvent(eventName: Constants.CHALLENGE_FAILURE_EVENT + self.securityCheck, mapObject: failure)
    }
    
    override func handleSuccess(_ success: [AnyHashable: Any]!) {
        WLClientMethodHandler.sendEvent(eventName: Constants.CHALLENGE_SUCCESS_EVENT + self.securityCheck, mapObject: success)
    }
    
    private enum Constants{
        public static var HANDLE_CHALLENGE_EVENT: String = "handleChallengeEvent"
        public static var CHALLENGE_SUCCESS_EVENT = "challengeSuccessEvent"
        public static var CHALLENGE_FAILURE_EVENT: String = "challengeFailureEvent"
    }
}
