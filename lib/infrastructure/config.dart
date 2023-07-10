class Environments {
  static const String PRODUCTION = 'prod';
  static const String QAS = 'QAS';
  static const String DEV = 'dev';
}

class ConfigEnvironments {
  static set currentEnvironments(env) => _currentEnvironments = env;

  static String _currentEnvironments = Environments.QAS;
  static final List<Map<String, dynamic>> _availableEnvironments = [
    {
      'env': Environments.DEV,
      'url':
          'https://craftercms-delivery-dev.skill-mine.com/mobile-homepage?is_app=true',
      'domain': 'craftercms-delivery-dev.skill-mine.com',
      'baseAPI': 'https://ecompaascare-srv-dev.skill-mine.com/api',
      'OSAppId': '80786b47-31d8-4018-b284-5b5845b4bbb5',
      // 'cookiedomain': 'https://craftercms-delivery-dev.skill-mine.com',
      'cookiedomain': 'https://ecompaascare-react-dev.skill-mine.com',
    },
    {
      'env': Environments.PRODUCTION,
      'url': 'https://sterlingaccuris.com?is_app=true',
      'domain': 'sterlingaccuris.com',
      'baseAPI': 'https://api.sterlingaccuris.com/api',
      'OSAppId': 'ee1713d2-e9c2-4bf2-9613-7456d1dad45e',
      'cookiedomain': 'https://sterlingaccuris.com',
    },
    {
      'env': Environments.QAS,
      'url': '',
    },
  ];

  static Map<String, dynamic> get env {
    return _availableEnvironments.firstWhere(
      (d) => d['env'] == _currentEnvironments,
    );
  }
}
