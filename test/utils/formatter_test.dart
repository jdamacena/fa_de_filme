import 'package:fa_de_filme/utils/formatter.dart';
import 'package:test/test.dart';

void main() {
  group('Runtime Formatter', () {
    test('runtime with less than an hour should print only minutes', () {
      var runtimeMins = 59;
      var expectedOutput = "59min";

      expect(Formatter.minutesToFormattedDuration(runtimeMins), expectedOutput);
    });

    test('runtime with whole hour should print zero minutes', () {
      var runtimeMins = 60;
      var expectedOutput = "1h 00m";

      expect(Formatter.minutesToFormattedDuration(runtimeMins), expectedOutput);
    });

    test('runtime with more than 60 minutes should print hours and minutes', () {
      var runtimeMins = 65;
      var expectedOutput = "1h 05m";

      expect(Formatter.minutesToFormattedDuration(runtimeMins), expectedOutput);
    });

    test('runtime with 1 digit minutes should pad it with zero to complete two digits', () {
      var runtimeMins = 5;
      var expectedOutput = "05min";

      expect(Formatter.minutesToFormattedDuration(runtimeMins), expectedOutput);
    });
  });
}
