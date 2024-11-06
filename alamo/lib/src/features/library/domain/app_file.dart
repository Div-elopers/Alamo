import 'package:cloud_firestore/cloud_firestore.dart';

class AppFile {
  final String id;
  final String name;
  final String type;
  final DateTime createdAt;
  final String fileURL;
  final String createdBy;
  final int views;

  AppFile({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.fileURL,
    required this.createdBy,
    this.views = 0,
  });

  // Factory constructor to create a FileItem instance from JSON data
  factory AppFile.fromJson(Map<String, dynamic> json) {
    return AppFile(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      fileURL: json['fileURL'] as String,
      createdBy: json['createdBy'] as String,
      views: json['views'] as int? ?? 0,
    );
  }

  // Method to convert an instance of FileItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'fileURL': fileURL,
      'createdBy': createdBy,
      'views': views,
    };
  }

  AppFile copyWith({
    String? id,
    String? name,
    String? type,
    DateTime? createdAt,
    String? fileURL,
    String? createdBy,
    int? views,
  }) {
    return AppFile(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      fileURL: fileURL ?? this.fileURL,
      createdBy: createdBy ?? this.createdBy,
      views: views ?? this.views,
    );
  }
}
