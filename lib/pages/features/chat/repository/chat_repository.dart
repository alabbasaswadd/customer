import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat_message.dart';

class ChatRepository {
  static const _key = 'support_chat_v1';
  static const _maxMessages = 200;

  Future<List<ChatMessage>> loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final trimmed = messages.length > _maxMessages
          ? messages.sublist(messages.length - _maxMessages)
          : messages;
      await prefs.setString(
        _key,
        jsonEncode(trimmed.map((m) => m.toJson()).toList()),
      );
    } catch (_) {}
  }

  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
