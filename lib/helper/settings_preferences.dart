import 'package:shared_preferences/shared_preferences.dart';

class SettingsPreferences {
  static SharedPreferences? _preferences;

  init() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }


  bool getNotificationsEnabled() {
    return _preferences!.getBool('notificationsEnabled') ?? false;
  }
  
  Future setNotificationsEnabled(bool notificationEnabled) {
    return _preferences!.setBool('notificationsEnabled', notificationEnabled);
  }

  bool getLookoutNotificationsEnabled() {
    return _preferences!.getBool('lookoutNotificationsEnabled') ?? false;
  }

  bool getChatNotificationsEnabled() {
    return _preferences!.getBool('chatNotificationsEnabled') ?? false;
  }

  Future setLookoutNotificationsEnabled(bool lookoutNotificationEnabled) {
    return _preferences!.setBool('lookoutNotificationsEnabled', lookoutNotificationEnabled);
  }

  int getLookoutDistance() {
    return _preferences!.getInt('lookoutDistance') ?? 1000;
  }

  Future setLookoutDistance(int lookoutDistance) {
    return _preferences!.setInt('lookoutDistance', lookoutDistance);
  }

  Future setChatNotificationsEnabled(bool chatNotificationEnabled) {
    return _preferences!.setBool('chatNotificationsEnabled', chatNotificationEnabled);
  }
}

final settingsPrefs = SettingsPreferences();