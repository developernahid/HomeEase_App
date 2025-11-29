import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:3000/api';
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static String? _sessionToken;

  static void setSessionToken(String? token) {
    _sessionToken = token;
    if (token != null) {
      _headers['Cookie'] = 'session_token=$token';
    } else {
      _headers.remove('Cookie');
    }
  }

  static String? get sessionToken => _sessionToken;

  // Generic GET request
  static Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    print(uri);
    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load data from $endpoint: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to $endpoint: $e');
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.post(
        uri,
        headers: _headers,
        body: json.encode(data),
      );

      _updateCookie(response);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {};
        }
      } else {
        throw Exception(
          'Failed to post data to $endpoint: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to $endpoint: $e');
    }
  }

  // Generic PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.put(
        uri,
        headers: _headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {};
        }
      } else {
        throw Exception(
          'Failed to put data to $endpoint: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to $endpoint: $e');
    }
  }

  // Generic DELETE request
  static Future<void> delete(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.delete(
        uri,
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to delete data from $endpoint: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to $endpoint: $e');
    }
  }

  static void _updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      String cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      if (cookie.startsWith('session_token=')) {
        String token = cookie.substring('session_token='.length);
        setSessionToken(token);
      }
    }
  }
}
