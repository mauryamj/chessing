import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  group('Timezone initialization tests', () {
    test('should initialize timezone database and resolve local time', () {
      // Initialize using the optimized 10-year database
      expect(() => tz_data.initializeTimeZones(), returnsNormally);

      // Verify that the database has been initialized and contains timezones
      expect(tz.timeZoneDatabase.locations.isNotEmpty, isTrue);

      // Verify timezone lookup works (e.g. UTC, standard zones)
      final utcLocation = tz.getLocation('UTC');
      expect(utcLocation, isNotNull);
      expect(utcLocation.name, equals('UTC'));

      // Verify we can instantiate a TZDateTime in the local/UTC zone
      final now = tz.TZDateTime.now(utcLocation);
      expect(now, isNotNull);
      
      // Test future date instantiation (simulates scheduling)
      final futureDate = tz.TZDateTime(utcLocation, now.year, now.month, now.day + 1, 9, 0);
      expect(futureDate.isAfter(now), isTrue);
    });
  });
}
