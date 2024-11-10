import 'package:cloud_firestore/cloud_firestore.dart';

class HelpCenter {
  final String uid;
  final String name;
  final String category;
  final String contactNumber;
  final String address;
  final Map<String, double> coordinates;
  final String createdBy;
  final Map<String, Map<String, String>> openingHours;

  // Constructor
  HelpCenter({
    required this.uid,
    required this.name,
    required this.category,
    required this.contactNumber,
    required this.address,
    required this.coordinates,
    required this.createdBy,
    required this.openingHours,
  });

  // Factory method to create a HelpCenter from a Map (for JSON deserialization)
  factory HelpCenter.fromJson(Map<String, dynamic> json) {
    var openingHoursData = <String, Map<String, String>>{};
    if (json['opening_hours'] != null) {
      json['opening_hours'].forEach((key, value) {
        if (value is Map<String, dynamic>) {
          openingHoursData[key] = {
            'open': value['open'] ?? 'cerrado',
            'close': value['close'] ?? 'cerrado',
          };
        }
      });
    }

    // Parse coordinates as a map with 'latitude' and 'longitude'
    var coordinates = <String, double>{};
    if (json['location'] != null && json['location']['coordinates'] != null) {
      coordinates = {
        'latitude': json['location']['coordinates']['latitude'].toDouble() ?? 0.0,
        'longitude': json['location']['coordinates']['longitude'].toDouble() ?? 0.0,
      };
    }

    return HelpCenter(
      uid: json['uid'],
      name: json['name'],
      category: json['category'],
      contactNumber: json['contact_number'],
      address: json['location']['address'],
      coordinates: coordinates, // Now properly parsed
      createdBy: json['created_by'],
      openingHours: openingHoursData,
    );
  }

  // Method to convert a HelpCenter instance to a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'category': category,
      'contact_number': contactNumber,
      'location': {
        'address': address,
        'coordinates': {
          'latitude': coordinates['latitude'],
          'longitude': coordinates['longitude'],
        },
      },
      'created_by': createdBy,
      'opening_hours': openingHours,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HelpCenter &&
        other.uid == uid &&
        other.name == name &&
        other.category == category &&
        other.contactNumber == contactNumber &&
        other.address == address &&
        other.coordinates == coordinates &&
        other.createdBy == createdBy;
  }

  @override
  String toString() {
    return 'HelpCenter(uid: $uid, name: $name, category: $category, contactNumber: $contactNumber, address: $address, coordinates: $coordinates, createdBy: $createdBy)';
  }

  @override
  int get hashCode => uid.hashCode;
}

enum Categories {
  alimentacion,
  refugio,
  salud,
  vestimenta,
}
