/// Key of APP ID
const keyAppId = 'ceefa807c04644ae8218be87a351e935';

/// Key of Channel ID
const keyChannelId = '1';

/// Key of token
const keyToken =
    '007eJxTYOAUcGyZeOwVP989ff/DklFLnh3qYmPKrq6955Kyq5fZ86sCQ3JqalqihYF5soGJmYlJYqqFkaFFUqqFeaKxqWGqpbHphkt7UxsCGRlyeUxZGBkgEMRnZDBkYAAAdI4cVQ==';

ExampleConfigOverride? _gConfigOverride;

/// This class allow override the config(appId/channelId/token) in the example.
class ExampleConfigOverride {
  ExampleConfigOverride._();

  factory ExampleConfigOverride() {
    _gConfigOverride = _gConfigOverride ?? ExampleConfigOverride._();
    return _gConfigOverride!;
  }
  final Map<String, String> _overridedConfig = {};

  /// Get the expected APP ID
  String getAppId() {
    return _overridedConfig[keyAppId] ??
        // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
        const String.fromEnvironment(keyAppId,
            defaultValue: 'ceefa807c04644ae8218be87a351e935');
  }

  /// Get the expected Channel ID
  String getChannelId() {
    return _overridedConfig[keyChannelId] ??
        // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
        const String.fromEnvironment(keyChannelId, defaultValue: '1');
  }

  /// Get the expected Token
  String getToken() {
    return _overridedConfig[keyToken] ??
        // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
        const String.fromEnvironment(keyToken,
            defaultValue:
                '007eJxTYFh0xGhz/eND73cuXiR2rGqnq9M5pSYN723L447zley6kjpZgSE5NTUt0cLAPNnAxMzEJDHVwsjQIinVwjzR2NQw1dLY9MDH3akNgYwMk18/YWJkgEAQn5HBkIEBALpMIXg=');
  }

  /// Override the config(appId/channelId/token)
  void set(String name, String value) {
    _overridedConfig[name] = value;
  }
}
