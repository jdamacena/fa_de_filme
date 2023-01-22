class Formatter {
  static String minutesToFormattedDuration(int runtimeMins) {
    var hours = runtimeMins ~/ 60;
    var minutes = runtimeMins - (hours * 60);

    var paddedMinsString = minutes.toString().padLeft(2, '0');

    if (hours > 0) {
      return "${hours}h ${paddedMinsString}m";
    }

    return "${paddedMinsString}min";
  }
}
