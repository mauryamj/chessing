import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  final String role; // 'user' or 'coach'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });
}

class CoachPersonaChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String gameContextPgn;

  CoachPersonaChatState({
    required this.messages,
    this.isLoading = false,
    this.gameContextPgn = '',
  });

  CoachPersonaChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? gameContextPgn,
  }) {
    return CoachPersonaChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      gameContextPgn: gameContextPgn ?? this.gameContextPgn,
    );
  }
}

class CoachPersonaChatNotifier extends StateNotifier<CoachPersonaChatState> {
  CoachPersonaChatNotifier()
      : super(CoachPersonaChatState(
          messages: [
            ChatMessage(
              role: 'coach',
              content:
                  "Hello! I am your Grandmaster Chess Coach. I can help you analyze your games, explain positional concepts, or answer any strategic questions you have. Feel free to load a game PGN from your history so we can review it together!",
              timestamp: DateTime.now(),
            ),
          ],
        ));

  void addMessage(ChatMessage msg) {
    state = state.copyWith(messages: [...state.messages, msg]);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setGameContext(String pgn, String result) {
    final welcomeMsg = ChatMessage(
      role: 'coach',
      content:
          "Excellent! I have loaded that match (Result: $result). What would you like to know about it? We can review key moments, blunders, or general strategy.",
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      gameContextPgn: pgn,
      messages: [...state.messages, welcomeMsg],
    );
  }

  void clearGameContext() {
    state = state.copyWith(gameContextPgn: '');
  }

  void clearChat() {
    state = CoachPersonaChatState(
      messages: [
        ChatMessage(
          role: 'coach',
          content:
              "Hello! I am your Grandmaster Chess Coach. I can help you analyze your games, explain positional concepts, or answer any strategic questions you have. Feel free to load a game PGN from your history so we can review it together!",
          timestamp: DateTime.now(),
        ),
      ],
    );
  }
}

final coachPersonaChatProvider =
    StateNotifierProvider<CoachPersonaChatNotifier, CoachPersonaChatState>((ref) {
  return CoachPersonaChatNotifier();
});
