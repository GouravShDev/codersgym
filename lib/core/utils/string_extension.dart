extension StringExt on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String convertToTitleCase() {
    // Split the input string by hyphens
    List<String> parts = split('-');

    // Capitalize the first letter of each part
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        parts[i] = parts[i][0].toUpperCase() + parts[i].substring(1);
      }
    }

    // Join the parts with spaces
    return parts.join(' ');
  }
}
