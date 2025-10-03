class TouristAttraction {
  final int id;
  final String name;
  final String description;
  final String category;
  final String district;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? openingHours;
  final String? contactInfo;
  final String? website;
  final String? imageUrl;
  final double averageRating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  TouristAttraction({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.district,
    required this.address,
    this.latitude,
    this.longitude,
    this.openingHours,
    this.contactInfo,
    this.website,
    this.imageUrl,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TouristAttraction.fromJson(Map<String, dynamic> json) {
    return TouristAttraction(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      district: json['district'] as String,
      address: json['address'] as String,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      openingHours: json['opening_hours'] as String?,
      contactInfo: json['contact_info'] as String?,
      website: json['website'] as String?,
      imageUrl: json['image_url'] as String?,
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'district': district,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'opening_hours': openingHours,
      'contact_info': contactInfo,
      'website': website,
      'image_url': imageUrl,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Accommodation {
  final int id;
  final String name;
  final String description;
  final String accommodationType;
  final String address;
  final double? latitude;
  final double? longitude;
  final double pricePerNight;
  final String? contactInfo;
  final String? website;
  final String? imageUrl;
  final List<String> amenities;
  final double averageRating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Accommodation({
    required this.id,
    required this.name,
    required this.description,
    required this.accommodationType,
    required this.address,
    this.latitude,
    this.longitude,
    required this.pricePerNight,
    this.contactInfo,
    this.website,
    this.imageUrl,
    required this.amenities,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      accommodationType: json['accommodation_type'] as String,
      address: json['address'] as String,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      pricePerNight: (json['price_per_night'] ?? 0.0).toDouble(),
      contactInfo: json['contact_info'] as String?,
      website: json['website'] as String?,
      imageUrl: json['image_url'] as String?,
      amenities: List<String>.from(json['amenities'] ?? []),
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'accommodation_type': accommodationType,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'price_per_night': pricePerNight,
      'contact_info': contactInfo,
      'website': website,
      'image_url': imageUrl,
      'amenities': amenities,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class TourPackage {
  final int id;
  final String name;
  final String description;
  final double price;
  final int durationDays;
  final String itinerary;
  final String? imageUrl;
  final List<String> inclusions;
  final List<String> exclusions;
  final double averageRating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  TourPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.itinerary,
    this.imageUrl,
    required this.inclusions,
    required this.exclusions,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TourPackage.fromJson(Map<String, dynamic> json) {
    return TourPackage(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] ?? 0.0).toDouble(),
      durationDays: json['duration_days'] as int,
      itinerary: json['itinerary'] as String,
      imageUrl: json['image_url'] as String?,
      inclusions: List<String>.from(json['inclusions'] ?? []),
      exclusions: List<String>.from(json['exclusions'] ?? []),
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'itinerary': itinerary,
      'image_url': imageUrl,
      'inclusions': inclusions,
      'exclusions': exclusions,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Review {
  final int id;
  final int attractionId;
  final int userId;
  final String userFullName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.attractionId,
    required this.userId,
    required this.userFullName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      attractionId: json['attraction_id'] as int,
      userId: json['user_id'] as int,
      userFullName: json['user_full_name'] as String,
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attraction_id': attractionId,
      'user_id': userId,
      'user_full_name': userFullName,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(
      success: true,
      data: data,
      statusCode: 200,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}