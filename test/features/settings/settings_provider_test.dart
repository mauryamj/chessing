import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chessing/core/ai/coaching_service.dart';
import 'package:chessing/features/settings/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('Gemini API Key in Settings', () {
    test('Default AppSettings has empty Gemini API key', () {
      const settings = AppSettings();
      expect(settings.geminiApiKey, isEmpty);
      expect(settings.hasCustomGeminiApiKey, isFalse);
    });

    test('CoachingService effectiveApiKey is empty when no key is set', () {
      final coachEmpty = CoachingService();
      expect(coachEmpty.effectiveApiKey, isEmpty);

      final coachWhitespace = CoachingService(customApiKey: '   ');
      expect(coachWhitespace.effectiveApiKey, isEmpty);
    });

    test('CoachingService effectiveApiKey returns custom key from settings', () {
      final coach = CoachingService(customApiKey: 'AIzaSyTestKey123');
      expect(coach.effectiveApiKey, equals('AIzaSyTestKey123'));
    });

    test('SettingsNotifier loads empty key and updates key securely', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialSettings = await container.read(settingsProvider.future);
      expect(initialSettings.geminiApiKey, isEmpty);
      expect(initialSettings.hasCustomGeminiApiKey, isFalse);

      final notifier = container.read(settingsProvider.notifier);
      await notifier.setGeminiApiKey('AIzaSyNewCustomKey');

      final updated = container.read(settingsProvider).value;
      expect(updated?.geminiApiKey, equals('AIzaSyNewCustomKey'));
      expect(updated?.hasCustomGeminiApiKey, isTrue);

      // Clear key
      await notifier.setGeminiApiKey('');
      final cleared = container.read(settingsProvider).value;
      expect(cleared?.geminiApiKey, isEmpty);
      expect(cleared?.hasCustomGeminiApiKey, isFalse);
    });
  });
}
