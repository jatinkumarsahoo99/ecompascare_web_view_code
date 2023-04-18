class Environments {
  static const String PRODUCTION = 'prod';
  static const String QAS = 'QAS';
  static const String DEV = 'dev';
  static const String LOCAL = 'local';
}

class ConfigEnvironments {
  static set currentEnvironments(env) => _currentEnvironments = env;

  static String _currentEnvironments = Environments.LOCAL;
  static final List<Map<String, dynamic>> _availableEnvironments = [
    {
      'env': Environments.LOCAL,
      'url': 'http://localhost:8080/api/',
      'api_logs': true,
    },
    {
      'env': Environments.DEV,
      'url':
          'https://craftercms-delivery-dev.skill-mine.com/mobile-homepage?is_app=true',
    },
    {
      'env': Environments.QAS,
      'url': '',
    },
    {
      'env': Environments.PRODUCTION,
      'url': '',
    },
  ];

  static Map<String, dynamic> get env {
    return _availableEnvironments.firstWhere(
      (d) => d['env'] == _currentEnvironments,
    );
  }
}
