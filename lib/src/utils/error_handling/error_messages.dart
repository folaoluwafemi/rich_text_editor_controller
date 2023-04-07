abstract class ErrorMessages {
  static const String connectionTimeOut = 'Connection TimeOut';
  static const String requestCancelled = 'Request canceled';
  static const String sendTimeOut = 'Send TimeOut';
  static const String receiveTimeOut = 'Receive TimeOut';
  static const String usernameAlreadyExists = 'Username already exist';

  static const String couldNotFetchData = 'Could Not Fetch Data';
  static const String anErrorOccurred = 'An Error Occurred';
  static const String unknownErrorRetry = 'Something went wrong, '
      'please try again';
  static const String requestUnsuccessful = 'Request unsuccessful';
  static const String nullToken = 'Null Token';

  static const String updatePhoneNumberWithOld = 'New phone number must be '
      'different from the current one';

  static const String updateLocationWithOld = 'New address must be '
      'different from the current one';
  static const String passcodeLogin = 'Unable to login with passcode!';
  static const String nullAuthInfo = 'invalid info, try a fresh login';
  static const String invalidPasscode = 'Invalid Passcode';
  static const String biometricAuthFailed = 'biometric authentication failed';
  static const String biometricAuthFailedRetry = 'biometric authentication '
      'failed, Please use Passcode instead';

  static const String localNoteSyncFailure = 'Local-Note-Sync-Failure';
  static const String networkNoteSyncFailure = 'Network-Note-Sync-Failure';
  static const String serverError = 'Server Error';
  static const String clientError = 'Client Error';
}
