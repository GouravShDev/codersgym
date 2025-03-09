import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// A service for fetching and managing Firebase Remote Configuration values.
class FirebaseRemoteConfigService {
  static final FirebaseRemoteConfigService _instance =
      FirebaseRemoteConfigService._internal();

  /// The singleton instance of the FirebaseRemoteConfigService.
  factory FirebaseRemoteConfigService() => _instance;

  FirebaseRemoteConfigService._internal();

  /// The Firebase Remote Config instance.
  late final FirebaseRemoteConfig _remoteConfig;

  /// Minimum fetch interval in seconds.
  int _minimumFetchInterval = 3600; // 1 hour by default

  /// Whether the config has been initialized.
  bool _initialized = false;

  /// Initialize the Firebase Remote Config service with default values and options.
  Future<void> initialize({
    Map<String, dynamic> defaults = const {},
    int minimumFetchInterval = 3600,
    bool fetchImmediately = true,
  }) async {
    _minimumFetchInterval = minimumFetchInterval;

    // Ensure Firebase is initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    // Get Remote Config instance
    _remoteConfig = FirebaseRemoteConfig.instance;

    // Set default parameters
    await _remoteConfig.setDefaults(_convertToRemoteConfigCompatible(defaults));

    // Set settings
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: Duration(seconds: _minimumFetchInterval),
    ));

    // Fetch and activate if requested
    if (fetchImmediately) {
      await fetchAndActivate();
    }

    _initialized = true;
  }

  /// Convert Dart Map to a format compatible with Firebase Remote Config defaults.
  Map<String, dynamic> _convertToRemoteConfigCompatible(
      Map<String, dynamic> defaults) {
    final result = <String, dynamic>{};

    defaults.forEach((key, value) {
      if (value is String) {
        result[key] = value;
      } else if (value is bool) {
        result[key] = value;
      } else if (value is int) {
        result[key] = value;
      } else if (value is double) {
        result[key] = value;
      } else {
        // For complex objects, convert to JSON string
        result[key] = value.toString();
      }
    });

    return result;
  }

  /// Fetch the latest configuration from Firebase and activate it.
  Future<bool> fetchAndActivate() async {

    try {
      // Fetch and activate
      bool updated = await _remoteConfig.fetchAndActivate();
      return updated;
    } catch (e) {
      print('Error fetching remote config: $e');
      return false;
    }
  }

  /// Set the minimum fetch interval in seconds.
  Future<void> setMinimumFetchInterval(int seconds) async {
    _ensureInitialized();
    _minimumFetchInterval = seconds;

    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: Duration(seconds: seconds),
    ));
  }

  /// Get a string value from the config.
  String getString(String key, {String defaultValue = ''}) {
    _ensureInitialized();
    return _remoteConfig.getString(key).isNotEmpty
        ? _remoteConfig.getString(key)
        : defaultValue;
  }

  /// Get a bool value from the config.
  bool getBool(String key, {bool defaultValue = false}) {
    _ensureInitialized();
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get an int value from the config.
  int getInt(String key, {int defaultValue = 0}) {
    _ensureInitialized();
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get a double value from the config.
  double getDouble(String key, {double defaultValue = 0.0}) {
    _ensureInitialized();
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get a value as a JSON object from the config.
  Map<String, dynamic>? getJson(String key) {
    _ensureInitialized();
    try {
      final value = _remoteConfig.getString(key);
      if (value.isNotEmpty) {
        return jsonDecode(value);
      }
      return null;
    } catch (e) {
      print('Error parsing JSON for key $key: $e');
      return null;
    }
  }

  /// Get all config parameters and their values.
  Map<String, RemoteConfigValue> getAll() {
    _ensureInitialized();
    return _remoteConfig.getAll();
  }

  /// Force a refresh of the config values from Firebase.
  Future<bool> forceRefresh() async {
    _ensureInitialized();
    try {
      // Force a fetch and activate
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration
            .zero, // This ensures we can fetch regardless of the last fetch time
      ));

      bool updated = await _remoteConfig.fetchAndActivate();

      // Reset the fetch interval
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration(seconds: _minimumFetchInterval),
      ));

      return updated;
    } catch (e) {
      print('Error forcing refresh of remote config: $e');
      return false;
    }
  }

  /// Get the last fetch status.
  RemoteConfigFetchStatus getLastFetchStatus() {
    _ensureInitialized();
    return _remoteConfig.lastFetchStatus;
  }

  /// Get the time of the last successful fetch.
  DateTime getLastFetchTime() {
    _ensureInitialized();
    return _remoteConfig.lastFetchTime;
  }

  /// Ensure the service has been initialized.
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
          'FirebaseRemoteConfigService must be initialized before use');
    }
  }
}
