import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petspa_flutter/services/rest_service.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  int? _userId; // Kiểu int thay cho long
  String? _name;

  String? _email;

  String? _password;
  //password2
  String? _password2;
  String? _OTP;

  String? get email => _email;
  String? get name => _name;
  String? get otp => _OTP;

  String? get password => _password;
  String? get password2 => _password2;
  int? get userId => _userId;

  // Function to check email verification status
  Future<bool> checkEmailVerification() async {
    // bool idTest = true;
    // if (idTest) {
    //   return false;
    // }
    try {
      //is-verified
      ApiResponse response = await RestService.get('/auth/is-verified?email=$email');
      if (response.status == 200) {
        if (response.data['verified'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future postSignUpDetails() async {
    print("Name: $name");
    print("Email: $email");
    print("Password: $password");
    print("MobileNumber: $otp");

    // print("ImageFile: ${imageFile!.filename}");
    // print("ResumeFile: ${resumeFile!.filename}");
  }
  Future<bool> registerUser(String name, String email, String password) async {
    // Gọi API bằng RestService và nhận kết quả trả về dưới dạng ApiResponse
    ApiResponse response = await RestService.post(
      '/auth/register',
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    // Kiểm tra status và xử lý kết quả
    if (response.status == 201 || response.status == 200) {
      setUserId(response.data['userId']); // Lưu ID người dùng
      return true; // Đăng ký thành công
    } else {
      Get.snackbar(
        "Error",
        response.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 10,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
      );
      return false;
    }
  }

  // Function to resend OTP
  Future<void> resendOTP() async {
    try {
      ApiResponse response = await RestService.post('/auth/resend-otp?email=$email', {
        'email': email,
      });
      print("Response: ${response}");
      if (response.status == 200) {
        Get.snackbar("Success", "OTP sent successfully!");
      } else {
        Get.snackbar("Error", "Failed to resend OTP.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
  //reset state
  void resetState() {
    _userId = null;
    _name = null;
    _email = null;
    _password = null;
    _password2 = null;
    _OTP = null;
    update();
  }
  void setEmail(String? text) {
    _email = text;
    debugPrint("Updated email: $email");
    update();
  }

  void setName(String? text) {
    _name = text;
    debugPrint("Updated name: $name");
    update();
  }

  void setOTP(String? text) {
    _OTP = text;
    debugPrint("Updated mobileNumber: $otp");
    update();
  }

  void setPassword(String? text) {
    _password = text;
    debugPrint("Updated password: $password");
    update();
  }

  void setPassword2(String? text) {
    _password2 = text;
    debugPrint("Updated password2: $password2");
    update();
  }

  void setUserId(int? id) {
    _userId = id;
    debugPrint("Updated userId: $_userId");
    update();
  }

  @override
  String toString() {
    return 'SignUpController(userId: $_userId, name: $_name, email: $_email, password: $_password, password2: $_password2, OTP: $_OTP)';
  }

  Future<bool> updateEmail(String newEmail) async {
    try {
      printInfo(info: "Updating email to $newEmail | Current email: $_email | User ID: $_userId");
      ApiResponse response = await RestService.post(
        '/auth/update-email',
        {
          'userId': _userId,
          'email': newEmail,
          'verified': false,
        },
      );

      if (response.status == 200) {
        _email = newEmail; // Cập nhật email mới
        update(); // Cập nhật UI
        return true;
      } else {
        Get.snackbar("Error", response.message, snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 4));
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  // Function to verify OTP
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      ApiResponse response = await RestService.post(
        '/auth/verify-otp?email=$email&otp=$otp',
        {
          'email': email,
          'otp': otp,
        },
      );

      if (response.status == 200) {
        // OTP chính xác và xác minh thành công
        Get.snackbar(
          "Success",
          response.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        return true;
      } else {
        // OTP không hợp lệ hoặc gặp lỗi
        Get.snackbar(
          "Error",
          response.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          borderRadius: 10,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      // Lỗi không xác định
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }
}
