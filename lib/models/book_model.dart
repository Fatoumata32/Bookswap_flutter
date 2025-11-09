// Model class representing a book listing in the marketplace

import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String condition; // New, Like New, Good, Used
  final String swapFor;
  final String imageUrl;
  final String ownerId;
  final String ownerName;
  final DateTime createdAt;
  final String status; // available, pending, swapped

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    required this.swapFor,
    required this.imageUrl,
    required this.ownerId,
    required this.ownerName,
    required this.createdAt,
    this.status = 'available',
  });

  factory Book.fromJson(Map<String, dynamic> json, String id) {
    return Book(
      id: id,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      condition: json['condition'] ?? 'Used',
      swapFor: json['swapFor'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      status: json['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'condition': condition,
      'swapFor': swapFor,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? condition,
    String? swapFor,
    String? imageUrl,
    String? ownerId,
    String? ownerName,
    DateTime? createdAt,
    String? status,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      condition: condition ?? this.condition,
      swapFor: swapFor ?? this.swapFor,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}