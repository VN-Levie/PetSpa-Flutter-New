import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:petspa_flutter/app_const.dart';
import 'package:petspa_flutter/services/user_storage.dart';

class RestService {
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  // Hàm lấy token mới bằng refresh token
  static Future<String?> refreshToken() async {
    try {
      String? refreshToken = await UserStorage().getRefreshToken();
      if (refreshToken == null) return null;

      final response = await http.post(
        Uri.parse('${AppConst.apiEndpoint}/auth/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
        body: jsonEncode({
          'refresh_token': refreshToken
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = utf8.decode(response.bodyBytes);
        var data = jsonDecode(jsonResponse);
        var newToken = data;
        print('NewToken: $newToken');
        await UserStorage().saveToken(newToken, refreshToken);
        return newToken;
      }
    } catch (e) {
      print('RefreshToken_Error: $e');
    }
    return null;
  }

  // Phương thức GET
  static Future<ApiResponse> get(String endpoint, {Map<String, String>? headers}) async {
    return await _sendRequestWithTokenRetry(
      http.Request('GET', Uri.parse('${AppConst.apiEndpoint}$endpoint')),
      headers,
    );
  }

  // Phương thức POST
  static Future<ApiResponse> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    print('Uri.parse(${AppConst.apiEndpoint}$endpoint)');
    var request = http.Request('POST', Uri.parse('${AppConst.apiEndpoint}$endpoint'));
    request.body = json.encode(body);
    return await _sendRequestWithTokenRetry(request, headers);
  }

  // Phương thức PUT
  static Future<ApiResponse> put(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    var request = http.Request('PUT', Uri.parse('${AppConst.apiEndpoint}$endpoint'));
    request.body = json.encode(body);
    return await _sendRequestWithTokenRetry(request, headers);
  }

  // Phương thức DELETE
  static Future<ApiResponse> delete(String endpoint, {Map<String, String>? headers}) async {
    return await _sendRequestWithTokenRetry(
      http.Request('DELETE', Uri.parse('${AppConst.apiEndpoint}$endpoint')),
      headers,
    );
  }

  // Hàm chung xử lý request và refresh token
  static Future<ApiResponse> _sendRequestWithTokenRetry(http.Request request, Map<String, String>? headers) async {
    headers ??= {
      'Content-Type': 'application/json'
    };
    String? token = await storage.read(key: 'access_token');
    if (token != null) headers['Authorization'] = 'Bearer $token';
    request.headers.addAll(headers);

    try {
      http.StreamedResponse streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      String statusCode = streamedResponse.statusCode.toString();
      if (statusCode == 403) {
        // print('___statusCode: $statusCode');
        return ApiResponse(
          status: 403,
          message: 'Something went wrong. Please try again later.',
        );
      }
      String responseBody = await streamedResponse.stream.bytesToString();
      // print('_streamedResponse | statusCode: $statusCode \n responseBody: $responseBody');
      var decodedBody = utf8.decode(responseBody.runes.toList());
      // print('decodedBody: $decodedBody');
      final responseJson = jsonDecode(decodedBody);

      // Xử lý trường hợp 401
      if (streamedResponse.statusCode == 401 && !request.url.path.contains('/auth')) {
        String? newToken = await refreshToken();
        if (newToken != null) {
          request.headers['Authorization'] = 'Bearer $newToken';
          return await _sendRequestWithTokenRetry(request, headers);
        }
      }

      try {
        return ApiResponse.fromJson(streamedResponse.statusCode, responseJson);
      } catch (e) {
        print('_REST_Error: $e');
        return ApiResponse(
          status: 503,
          message: 'Server is busy. Please try again later!',
          errors: e.toString(),
        );
      }
    } catch (e) {
      print('REST_Error: $e');
      return ApiResponse(
        status: 503,
        message: 'Server is busy. Please try again later.',
        errors: e.toString(),
      );
    }
  }
}

// Class ApiResponse
class ApiResponse<T> {
  final int status; // HTTP Status code
  final String message; // Message từ server
  final T? data; // Dữ liệu từ server
  final dynamic errors; // Lỗi chi tiết

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
  });

  // Chuyển từ JSON sang ApiResponse
  factory ApiResponse.fromJson(int statusCode, Map<String, dynamic> json) {
    return ApiResponse(
      status: statusCode,
      message: json['message'] ?? '',
      data: json['data'],
      errors: json['errors'],
    );
  }

  @override
  String toString() {
    return 'ApiResponse(status: $status, message: $message, data: $data, errors: $errors)';
  }
}
