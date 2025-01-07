class CheckWebsite {
  final urlPattern = r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(:\d+)?(\/.*)?$';

  bool isWebsite(String text) {
    final regex = RegExp(urlPattern);
    return regex.hasMatch(text);
  }
}
