import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'prompts.dart';

final coachingServiceProvider = Provider<CoachingService>((ref) {
  return CoachingService();
});

class CoachingService {
  final Dio _dio = Dio();
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');

  /// Returns true when any network interface is available.
  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  Future<String> ask(String systemPrompt, String userMessage) async {
    if (apiKey.isEmpty) {
      return "Coaching unavailable: Gemini API key is missing. Please run with --dart-define=GEMINI_API_KEY=your_key";
    }

    // Graceful offline degradation (5.3)
    if (!await _isOnline()) {
      return "Coaching unavailable offline. Connect to the internet and try again.";
    }

    try {
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': userMessage}
              ]
            }
          ],
          'systemInstruction': {
            'parts': [
              {'text': systemPrompt}
            ]
          },
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 300,
          }
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          if (content != null) {
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts[0]['text'] as String?;
              return text?.trim() ?? "No response from coach.";
            }
          }
        }
        return "No response from coach.";
      } else {
        return "Coaching unavailable: API returned status ${response.statusCode}";
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return "Coaching request timed out. Check your connection and try again.";
      }
      return "Coaching unavailable offline.";
    } catch (e) {
      return "Coaching unavailable offline.";
    }
  }

  Future<String> getBestMoveTip({
    required String fen,
    required String bestMoveUci,
    required String playerMoveUci,
  }) async {
    const systemPrompt = AiPrompts.bestMoveTipSystem;
    final userMessage =
        "Position FEN: $fen\nPlayer played: $playerMoveUci\nSuggested best move: $bestMoveUci";
    return ask(systemPrompt, userMessage);
  }

  Future<String> explainMove(String fen, String moveUci) async {
    const systemPrompt = AiPrompts.magnusCarlsenSystem;
    final userMessage = "Position FEN: $fen\nMove selected: $moveUci";
    return ask(systemPrompt, userMessage);
  }

  Future<String> commentMove(
      String fen, String moveSan, String playerName) async {
    final systemPrompt = AiPrompts.commentatorSystem(playerName);
    final userMessage = "Position FEN: $fen\nMove played: $moveSan by $playerName";
    return ask(systemPrompt, userMessage);
  }
}

class BestMoveTipArg {
  final String fen;
  final String bestMoveUci;
  final String playerMoveUci;

  BestMoveTipArg({
    required this.fen,
    required this.bestMoveUci,
    required this.playerMoveUci,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BestMoveTipArg &&
          runtimeType == other.runtimeType &&
          fen == other.fen &&
          bestMoveUci == other.bestMoveUci &&
          playerMoveUci == other.playerMoveUci;

  @override
  int get hashCode => fen.hashCode ^ bestMoveUci.hashCode ^ playerMoveUci.hashCode;
}

final bestMoveTipProvider =
    FutureProvider.family<String, BestMoveTipArg>((ref, arg) async {
  final service = ref.read(coachingServiceProvider);
  return service.getBestMoveTip(
    fen: arg.fen,
    bestMoveUci: arg.bestMoveUci,
    playerMoveUci: arg.playerMoveUci,
  );
});
