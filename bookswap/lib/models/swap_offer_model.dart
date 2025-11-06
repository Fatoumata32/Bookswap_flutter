// Model class for swap offers

import 'package:cloud_firestore/cloud_firestore.dart';

class SwapOffer {
  final String id;
  final String bookId;
  final String bookTitle;
  final String senderId;
  final String senderName;
  final String recipientId;
  final String recipientName;
  final String status; // pending, accepted, rejected
  final DateTime createdAt;

  SwapOffer({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.recipientName,
    this.status = 'pending',
    required this.createdAt,
  });

  factory SwapOffer.fromJson(Map<String, dynamic> json, String id) {
    return SwapOffer(
      id: id,
      bookId: json['bookId'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      recipientId: json['recipientId'] ?? '',
      recipientName: json['recipientName'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'senderId': senderId,
      'senderName': senderName,
      'recipientId': recipientId,
      'recipientName': recipientName,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}