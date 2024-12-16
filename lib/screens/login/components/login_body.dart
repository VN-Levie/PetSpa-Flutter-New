import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:petspa_flutter/app_theme.dart';
import 'package:petspa_flutter/components/my_button.dart';
import 'package:petspa_flutter/components/my_textfield.dart';
import 'package:get/get.dart';
import 'package:petspa_flutter/controller/flow_controller.dart';
import 'package:petspa_flutter/controller/sign_up_controller.dart';
import 'package:petspa_flutter/model/user_model.dart';
import 'package:petspa_flutter/navigation_home_screen.dart';
import 'package:petspa_flutter/screens/signup/sign_up.dart';
import 'package:petspa_flutter/services/rest_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petspa_flutter/services/user_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginBodyScreen extends StatefulWidget {
  const LoginBodyScreen({super.key});

  @override
  State<LoginBodyScreen> createState() => _LoginBodyScreenState();
}

class _LoginBodyScreenState extends State<LoginBodyScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  void showErrorMessage(String message) {
    Get.snackbar("Error", message, snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 4));
  }

// Khởi tạo GetStorage và SecureStorage
  final box = GetStorage();
  final secureStorage = FlutterSecureStorage();

  void signUserIn() async {
    // Set loading state
    setState(() {
      isLoading = true;
    });

    // Check if email and password is empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorMessage("Email and password cannot be empty");
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Check if email is valid
    if (emailController.text.isNotEmpty) {
      validateEmail(emailController.text);
      if (_errorMessage.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    try {
      ApiResponse response = await RestService.post(
        '/auth/login',
        {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print("Response: ${response.status} | ${response.data}");
      // Kiểm tra status và xử lý kết quả
      if (response.status == 200) {
        setState(() {
          isLoading = false;
        });
        await UserStorage().saveUserDataAsync(User.fromJson(response.data));
        await UserStorage().saveToken(response.data['token'], response.data['refreshToken']);
        Get.offAll(() => NavigationHomeScreen());
        return;
      } else if (response.status == 401) {
        if (response.data != null && response.data['verified'] == false) {
          showErrorMessage(response.message);
          SignUpController signUpController = Get.find();
          FlowController flowController = Get.find();
          signUpController.setEmail(response.data['email']);
          signUpController.setUserId(response.data['userId']);
          flowController.setFlow(2);
          Get.to(() => SignUpScreen());
          return;
        } else {
          showErrorMessage(response.message);
        }
      } else {
        showErrorMessage(response.message);
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  String _errorMessage = "";

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.drawerHeader,
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 535,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: HexColor("#ffffff"),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.offAll(() => NavigationHomeScreen());
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.house,
                                    size: 26,
                                    // color: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  width: 67,
                                ),
                                Text(
                                  "Sign In",
                                  style: GoogleFonts.poppins(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#4f4f4f"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: HexColor("#8d8d8d"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MyTextField(
                                    onChanged: (() {
                                      validateEmail(emailController.text);
                                    }),
                                    controller: emailController,
                                    hintText: "Email",
                                    obscureText: false,
                                    prefixIcon: const Icon(Icons.mail_outline),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Text(
                                      _errorMessage,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Password",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: HexColor("#8d8d8d"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MyTextField(
                                    controller: passwordController,
                                    hintText: "**************",
                                    obscureText: true,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  MyButton(
                                    isLoading: isLoading,
                                    onPressed: signUserIn,
                                    buttonText: 'Submit',
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text("Don't have an account? ",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: HexColor("#8d8d8d"),
                                            )),
                                        TextButton(
                                          child: Text(
                                            "Sign Up",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: HexColor("#44564a"),
                                            ),
                                          ),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SignUpScreen(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Transform.translate(
                    //   offset: const Offset(0, -253),
                    //   child: Image.asset(
                    //     'assets/images/plants2.png',
                    //     scale: 1.5,
                    //     width: double.infinity,
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
