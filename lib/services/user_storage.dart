import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:petspa_flutter/model/user_model.dart';

class UserStorage {
  // Instance Singleton
  static final UserStorage _instance = UserStorage._internal();

  // Truy cập qua UserStorage.instance
  factory UserStorage() => _instance;

  // Constructor private
  UserStorage._internal();

  // Khởi tạo GetStorage
  final GetStorage _box = GetStorage();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Lấy thông tin User
  User? getUser() {
    Map<String, dynamic>? userData = _box.read('user');
    return userData != null ? User.fromJson(userData) : null;
  }

  /// Lưu thông tin User
  void saveUser(User user) {
    _box.write('user', user.toJson());
  }

  Future<void> saveUserDataAsync(User user) async {
    await _box.write('user', user.toJson());
  }

  Future<void> saveToken(String token, String refreshToken) async {
    await _secureStorage.write(key: 'access_token', value: token);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  // Lấy Access Token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  // Lấy Refresh Token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  /// Xóa thông tin User
  void deleteUser() {
    _box.remove('user');
    print("User removed.");
  }

  /// Kiểm tra xem có user hay không
  bool hasUser() {
    return getUser() != null;
  }

  //logout
  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    deleteUser();
    print("Logged out.");
  }
}
