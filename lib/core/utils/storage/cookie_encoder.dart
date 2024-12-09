class CookieEncoder {
  static String encode(Map<String, dynamic> cookie) {
    return cookie.entries.map((e) => '${e.key}=${e.value}').join('; ');
  }
}
