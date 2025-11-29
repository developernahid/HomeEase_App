import 'package:flutter/material.dart';
import 'package:HomeEase/Models/user_model.dart';
import 'package:HomeEase/services/api_service.dart';

class AuthService {
  final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  final ValueNotifier<User?> currentUser = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(true);

  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<User?> login(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await ApiService.post('login', {
        'email': email,
        'password': password,
      });

      // The API returns the user object directly or nested?
      // Based on README: "Returns user object and sets session_token cookie."
      // Let's assume the body is the user object.

      if (response.isNotEmpty) {
        // Check if response is wrapped in 'user' key
        final userData =
            response.containsKey('user') ? response['user'] : response;
        final user = User.fromJson(userData);
        currentUser.value = user;
        isLoggedIn.value = true;
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      isLoggedIn.value = false;
      currentUser.value = null;
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> register(String username, String email, String password) async {
    try {
      isLoading.value = true;
      final response = await ApiService.post('register', {
        'username': username,
        'email': email,
        'password': password,
      });

      if (response.isNotEmpty) {
        final userData =
            response.containsKey('user') ? response['user'] : response;
        final user = User.fromJson(userData);
        currentUser.value = user;
        isLoggedIn.value = true;
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Registration error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.post('logout', {});
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      ApiService.setSessionToken(null);
      isLoggedIn.value = false;
      currentUser.value = null;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get('auth/me');
      if (response != null) {
        final userData =
            response.containsKey('user') ? response['user'] : response;
        final user = User.fromJson(userData);
        currentUser.value = user;
        isLoggedIn.value = true;
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Get current user error: $e');
      // If we fail to get user (e.g. 401), we are probably not logged in
      isLoggedIn.value = false;
      currentUser.value = null;
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> updateUser(Map<String, dynamic> data) async {
    data = {
      ...data,
      'id': currentUser.value?.id,
    };
    try {
      final response = await ApiService.put('auth/updateUser', data);
      if (response.isNotEmpty) {
        final userData =
            response.containsKey('user') ? response['user'] : response;
        final user = User.fromJson(userData);
        currentUser.value = user;
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Update user error: $e');
      return null;
    }
  }

  Future<List<User>> getAllVendors() async {
    try {
      final response = await ApiService.get('auth/allVendors');
      if (response != null && response is List) {
        return response.map((json) => User.fromJson(json)).toList();
      } else if (response != null && response['vendors'] != null) {
        return (response['vendors'] as List)
            .map((json) => User.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Get all vendors error: $e');
      return [];
    }
  }
}

final authService = AuthService();
