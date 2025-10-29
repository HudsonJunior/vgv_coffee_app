import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vgv_coffee_app/core/clients/api_client.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/coffee/data/models/coffee.dart';

/// Data source for fetching coffee images from the remote API.
class CoffeeRemoteDataSource {
  CoffeeRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  static const _coffeeApiUrl = 'https://coffee.alexflipnote.dev/random.json';

  /// Fetches a random coffee image from the API.
  Future<Either<Failure, Coffee>> fetchCoffee() async {
    try {
      final response = await _apiClient.get(_coffeeApiUrl);
      final coffee = Coffee.fromJson(response);
      return Right(coffee);
    } on DioException catch (e) {
      return Left(
        NetworkFailure(
          message: e.message ?? 'Failed to fetch coffee image',
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(message: 'An unexpected error occurred: $e'),
      );
    }
  }
}
