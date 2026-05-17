class ApiConstants {
  static const String apiBaseUrl =
      "http://network-isp-user-api.runasp.net/network-user-api/";

  static const String signin = "user-api/Account/SignIn";
  static const String complaint = "user-api/Complaint";

  // Connected devices endpoints
  static const String connectedDevices = "user-api/Network/ConnectedDevices";
  static const String dhcpLeases = "user-api/Network/DhcpLeases";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
