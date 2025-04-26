class ApiHeaders {
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'X-Stack-Access-Type': 'client',
    'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
    'X-Stack-Publishable-Client-Key':
        'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
  };

  static Map<String, String> getAuthHeaders(String token) => {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

  static Map<String, String> getRefreshHeaders(String refreshToken) => {
        ...defaultHeaders,
        'X-Stack-Refresh-Token': refreshToken,
      };
  static Map<String, String> getLogoutHeaders(
          String token, String refreshToken) =>
      {
        ...defaultHeaders,
        'X-Stack-Refresh-Token': refreshToken,
        'Authorization': 'Bearer $token',
      };
  static Map<String, String> getAIChatHeaders(String? guid, String token) => {
        "Content-Type": "application/json",
        'x-jarvis-guid': guid ?? '',
        'Authorization': 'Bearer $token',
      };
  static Map<String, String> getHeadersWithFile(String? guid, String token) => {
        "Content-Type": "multipart/form-data",
        'x-jarvis-guid': guid ?? '',
        'Authorization': 'Bearer $token',
      };
}
