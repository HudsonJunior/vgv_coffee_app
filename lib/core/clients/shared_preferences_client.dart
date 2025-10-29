import 'package:shared_preferences/shared_preferences.dart';

/// Client for interacting with SharedPreferences.
class SharedPreferencesClient {
  SharedPreferencesClient({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  /// Saves a list of strings with the given [key].
  Future<bool> setStringList(String key, List<String> value) {
    return _sharedPreferences.setStringList(key, value);
  }

  /// Retrieves a list of strings for the given [key].
  /// Returns an empty list if the key doesn't exist.
  Future<List<String>> getStringList(String key) async {
    return _sharedPreferences.getStringList(key) ?? [];
  }

  /// Removes the value associated with the given [key].
  Future<bool> remove(String key) {
    return _sharedPreferences.remove(key);
  }

  /// Clears all values from SharedPreferences.
  Future<bool> clear() {
    return _sharedPreferences.clear();
  }
}
