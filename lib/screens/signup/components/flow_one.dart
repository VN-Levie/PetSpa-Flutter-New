import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:email_validator/email_validator.dart';
import 'package:petspa_flutter/components/my_button.dart';
import 'package:petspa_flutter/controller/flow_controller.dart';
import 'package:petspa_flutter/controller/sign_up_controller.dart';
import 'package:petspa_flutter/navigation_home_screen.dart';
import 'package:petspa_flutter/screens/login/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<String> list = <String>[
  'Pembaca',
  'Penulis'
];

class SignUpOne extends StatefulWidget {
  const SignUpOne({super.key});

  @override
  State<SignUpOne> createState() => _SignUpOneState();
}

class _SignUpOneState extends State<SignUpOne> {
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final passwordController2 = TextEditingController().obs;
  SignUpController signUpController = Get.find();
  FlowController flowController = Get.find();

  String dropdownValue = list.first;
  String _errorMessage = "";
  bool isLoading = false; // Trạng thái loading
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.offAll(() => NavigationHomeScreen());
                  },
                  child: FaIcon(
                    FontAwesomeIcons.house,
                    size: 27,
                    // color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 67,
                ),
                Text(
                  "Sign Up",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#4f4f4f"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Input
                  Text(
                    "Name",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: nameController.value,
                    onChanged: (value) {
                      signUpController.setName(value);
                    },
                    onSubmitted: (value) {
                      signUpController.setName(value);
                    },
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "John Doe",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Email Input
                  Text(
                    "Email",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController.value,
                    onChanged: (value) {
                      validateEmail(value);
                      signUpController.setEmail(value);
                    },
                    onSubmitted: (value) {
                      signUpController.setEmail(value);
                    },
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "hello@gmail.com",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
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
                    height: 5,
                  ),
                  // Password Input
                  Text(
                    "Password",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    onChanged: (value) {
                      signUpController.setPassword(value);
                    },
                    onSubmitted: (value) {
                      signUpController.setPassword(value);
                    },
                    obscureText: true,
                    controller: passwordController.value,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "*************",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      focusColor: HexColor("#44564a"),
                    ),
                  ),
                  // Confirm Password Input
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Confirm Password",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    onChanged: (value) {
                      signUpController.setPassword2(value);
                    },
                    onSubmitted: (value) {
                      signUpController.setPassword2(value);
                    },
                    obscureText: true,
                    controller: passwordController2.value,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "*************",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      focusColor: HexColor("#44564a"),
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  // Proceed Button
                  MyButton(
                    isLoading: isLoading,
                    buttonText: 'Proceed',
                    onPressed: () async {
                      await processSignUp();
                    },
                  ),
                  // Login Navigation
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "Already have an account?",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: HexColor("#8d8d8d"),
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "Log In",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: HexColor("#44564a"),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
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
    );
  }

  Future<void> processSignUp() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (signUpController.name == null || signUpController.name!.isEmpty) {
        Get.snackbar(
          "Error",
          "Name cannot be empty!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 10,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
        );
        return;
      }
      if (signUpController.email == null || signUpController.email!.isEmpty) {
        Get.snackbar(
          "Error",
          "Email cannot be empty!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 10,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
        );
        return;
      }
      if (signUpController.password == null || signUpController.password!.isEmpty) {
        Get.snackbar(
          "Error",
          "Password cannot be empty!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 10,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
        );
        return;
      }
      if (signUpController.password2 == null || signUpController.password2!.isEmpty) {
        Get.snackbar(
          "Error",
          "Confirm Password cannot be empty!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 10,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
        );
        return;
      }
      //check if password and confirm password are same
      if (signUpController.password != signUpController.password2) {
        Get.snackbar(
          "Error",
          "Password and Confirm Password should be same",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 10,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
        );
        return;
      }

      bool isRegistered = await signUpController.registerUser(
        signUpController.name.toString(),
        signUpController.email.toString(),
        signUpController.password.toString(),
      );
      debugPrint(isRegistered.toString());
      if (isRegistered) {
        Get.snackbar(
          "Success",
          "An email has been sent to your email address. Please enter the OTP to proceed",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 10,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 3),
        );
        flowController.setFlow(2);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 10,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
}
