import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyBackendUrl = 'backend_url';
  static const String _keyGmailUser = 'gmail_user';
  static const String _keyGmailPassword = 'gmail_password';
  static const String _keySendMode = 'send_mode'; // 'backend' or 'smtp'

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService._(prefs);
  }

  final SharedPreferences _prefs;
  PreferencesService._(this._prefs);

  String get backendUrl => _prefs.getString(_keyBackendUrl) ?? 'http://10.0.2.2:3000';
  set backendUrl(String value) => _prefs.setString(_keyBackendUrl, value);

  String get gmailUser => _prefs.getString(_keyGmailUser) ?? 'sanjuantony01@gmail.com';
  set gmailUser(String value) => _prefs.setString(_keyGmailUser, value);

  String get gmailPassword => _prefs.getString(_keyGmailPassword) ?? '';
  set gmailPassword(String value) => _prefs.setString(_keyGmailPassword, value);

  String get sendMode => _prefs.getString(_keySendMode) ?? 'backend';
  set sendMode(String value) => _prefs.setString(_keySendMode, value);
}
