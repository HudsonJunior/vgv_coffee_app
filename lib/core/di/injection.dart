import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vgv_coffee_app/core/clients/api_client.dart';
import 'package:vgv_coffee_app/core/clients/shared_preferences_client.dart';
import 'package:vgv_coffee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:vgv_coffee_app/features/coffee/data/sources/coffee_remote_data_source.dart';
import 'package:vgv_coffee_app/features/favorites/core/repository/favorites_repository.dart';
import 'package:vgv_coffee_app/features/favorites/data/favorites_local_data_source.dart';

final getIt = GetIt.instance;

/// Initializes dependency injection.
Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // Clients
  getIt.registerLazySingleton(() => ApiClient());
  getIt.registerLazySingleton(
    () => SharedPreferencesClient(sharedPreferences: sharedPreferences),
  );

  // Coffee feature
  getIt.registerLazySingleton(() => CoffeeRemoteDataSource(apiClient: getIt()));
  getIt.registerLazySingleton(
    () => CoffeeRepository(remoteDataSource: getIt()),
  );

  // Favorites feature
  getIt.registerLazySingleton(
    () => FavoritesLocalDataSource(sharedPreferencesClient: getIt()),
  );
  getIt.registerLazySingleton(
    () => FavoritesRepository(localDataSource: getIt()),
  );
}
