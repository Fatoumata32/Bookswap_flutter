// Model classes for chat functionality

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final String? bookId;
  final String? bookTitle;
  final String lastMessage;
  final DateTime lastMessageTime;

  Chat({
    required this.id,
    required this.participantIds,
    required this.participantNames,
    this.bookId,
    this.bookTitle,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory Chat.fromJson(Map<String, dynamic> json, String id) {
    return Chat(
      id: id,
      participantIds: List<String>.from(json['participantIds'] ?? []),
      participantNames: Map<String, String>.from(json['participantNames'] ?? {}),
      bookId: json['bookId'],
      bookTitle: json['bookTitle'],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: (json['lastMessageTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantIds': participantIds,
      'participantNames': participantNames,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
    };
  }
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json, String id) {
    return Message(
      id: id,
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}