import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// Failures represent errors that can occur during operations.
abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure that occurs when a network request fails.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Failure that occurs when a cache operation fails.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure that occurs for unknown or unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
