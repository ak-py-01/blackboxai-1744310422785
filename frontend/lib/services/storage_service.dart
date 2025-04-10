import 'package:get_storage/get_storage.dart';

class StorageService {
  final _storage = GetStorage();

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _selectedCompanyKey = 'selected_company';
  static const String _themeKey = 'theme_mode';
  static const String _settingsKey = 'app_settings';

  // Auth Token
  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _storage.read(_tokenKey);
  }

  Future<void> removeToken() async {
    await _storage.remove(_tokenKey);
  }

  // User Data
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(_userKey, userData);
  }

  Future<Map<String, dynamic>?> getUser() async {
    return _storage.read(_userKey);
  }

  Future<void> removeUser() async {
    await _storage.remove(_userKey);
  }

  // Selected Company
  Future<void> saveSelectedCompany(Map<String, dynamic> companyData) async {
    await _storage.write(_selectedCompanyKey, companyData);
  }

  Future<Map<String, dynamic>?> getSelectedCompany() async {
    return _storage.read(_selectedCompanyKey);
  }

  Future<void> removeSelectedCompany() async {
    await _storage.remove(_selectedCompanyKey);
  }

  // Theme Mode
  Future<void> saveThemeMode(String themeMode) async {
    await _storage.write(_themeKey, themeMode);
  }

  Future<String?> getThemeMode() async {
    return _storage.read(_themeKey);
  }

  // App Settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _storage.write(_settingsKey, settings);
  }

  Future<Map<String, dynamic>?> getSettings() async {
    return _storage.read(_settingsKey);
  }

  // Clear All Data
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Initialize Storage
  static Future<void> init() async {
    await GetStorage.init();
  }
}
