import 'package:equatable/equatable.dart';

/// Represents a coffee image from the API.
class Coffee extends Equatable {
  final String imageUrl;

  const Coffee({required this.imageUrl});

  /// Creates a Coffee instance from JSON.
  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      imageUrl: json['file'] as String,
    );
  }

  /// Converts this Coffee instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'file': imageUrl,
    };
  }

  @override
  List<Object?> get props => [imageUrl];
}
