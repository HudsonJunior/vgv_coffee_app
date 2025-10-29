import 'package:dartz/dartz.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/coffee/data/models/coffee.dart';
import 'package:vgv_coffee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

/// Repository for managing coffee data.
/// Orchestrates data from both remote and local sources.
class CoffeeRepository {
  CoffeeRepository({
    required CoffeeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CoffeeRemoteDataSource _remoteDataSource;

  /// Fetches a new coffee image from the remote API and caches it locally.
  Future<Either<Failure, Coffee>> fetchCoffee() =>
      _remoteDataSource.fetchCoffee();
}
