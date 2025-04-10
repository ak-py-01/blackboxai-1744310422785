import 'package:get/get.dart';
import 'package:sm_erp/services/api_client.dart';
import 'package:sm_erp/services/storage_service.dart';

class AuthService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  final Rx<bool> isLoading = false.obs;
  final Rx<String?> error = Rx<String?>(null);

  // User state
  final Rx<Map<String, dynamic>?> currentUser = Rx<Map<String, dynamic>?>(null);
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final token = await _storage.getToken();
      if (token != null) {
        final userData = await _storage.getUser();
        if (userData != null) {
          currentUser.value = userData;
          isAuthenticated.value = true;
        }
      }
    } catch (e) {
      print('Error checking auth status: $e');
      await logout();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiClient.post(
        '/auth/token',
        body: {
          'username': email,
          'password': password,
        },
        requiresAuth: false,
      );

      if (response != null && response['access_token'] != null) {
        await _storage.saveToken(response['access_token']);
        
        // Get user details
        final userResponse = await _apiClient.get('/auth/me');
        if (userResponse != null) {
          await _storage.saveUser(userResponse);
          currentUser.value = userResponse;
          isAuthenticated.value = true;
        }

        return true;
      }

      error.value = 'Invalid credentials';
      return false;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiClient.post(
        '/auth/register',
        body: userData,
        requiresAuth: false,
      );

      if (response != null) {
        // Automatically login after successful registration
        return await login(userData['email'], userData['password']);
      }

      error.value = 'Registration failed';
      return false;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiClient.post(
        '/auth/change-password',
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response != null) {
        return true;
      }

      error.value = 'Password change failed';
      return false;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.clearAll();
      currentUser.value = null;
      isAuthenticated.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<void> refreshUserData() async {
    try {
      final userResponse = await _apiClient.get('/auth/me');
      if (userResponse != null) {
        await _storage.saveUser(userResponse);
        currentUser.value = userResponse;
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

  // Helper methods
  String? get userEmail => currentUser.value?['email'];
  String? get userName => currentUser.value?['full_name'];
  bool get isAdmin => currentUser.value?['is_superuser'] ?? false;
}
