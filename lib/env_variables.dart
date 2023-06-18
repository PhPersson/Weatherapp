abstract class EnvVariables {
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'YOUR_API_KEY',
  );
}