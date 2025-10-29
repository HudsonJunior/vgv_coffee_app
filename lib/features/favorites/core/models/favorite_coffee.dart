import 'package:equatable/equatable.dart';

/// Represents a favorite coffee with its image URL and timestamp.
class FavoriteCoffee extends Equatable {
  final String imageUrl;
  final DateTime savedAt;

  const FavoriteCoffee({
    required this.imageUrl,
    required this.savedAt,
  });

  /// Creates a FavoriteCoffee instance from JSON.
  factory FavoriteCoffee.fromJson(Map<String, dynamic> json) {
    return FavoriteCoffee(
      imageUrl: json['imageUrl'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }

  /// Converts this FavoriteCoffee instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [imageUrl, savedAt];
}
