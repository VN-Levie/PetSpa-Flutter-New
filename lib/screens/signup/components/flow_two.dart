import 'dart:async'; // Import Timer package
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:petspa_flutter/components/my_button.dart';
import 'package:petspa_flutter/controller/flow_controller.dart';
import 'package:petspa_flutter/controller/sign_up_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petspa_flutter/navigation_home_screen.dart';
import 'package:petspa_flutter/screens/login/login.dart';

class SignUpTwo extends StatefulWidget {
  const SignUpTwo({super.key});

  @override
  State<SignUpTwo> createState() => _SignUpTwoState();
}

class _SignUpTwoState extends State<SignUpTwo> {
  final otpController = TextEditingController().obs;
  final SignUpController signUpController = Get.put(SignUpController());
  final FlowController flowController = Get.put(FlowController());
  final int timeResend = 30; // Thời gian đợi để gửi lại OTP
  // Variables for Resend OTP
  bool isResendDisabled = false;
  bool isLoading = false; // Trạng thái loading
  bool isLoadingProcess = false; // Trạng thái loading
  int countdown = 30; // Countdown time in seconds
  Timer? resendTimer;
  Timer? verifyTimer; // Timer for email verification check

  @override
  void initState() {
    super.initState();
    startVerifyCheck(); // Start periodic check for email verification
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    verifyTimer?.cancel();
    super.dispose();
  }

  // Function to start the countdown for Resend OTP button
  void startCountdown() {
    if (mounted) {
      setState(() {
        isResendDisabled = true;
        countdown = timeResend; // Đếm ngược 30 giây
      });
      resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown > 0) {
          setState(() {
            countdown--;
          });
        } else {
          setState(() {
            isResendDisabled = false;
          });
          timer.cancel();
        }
      });
    }
  }

  // Hàm xử lý khi nhấn nút Resend OTP
  Future<void> onResendOTP() async {
    setState(() {
      isLoading = true; // Bắt đầu loading
      isResendDisabled = true; // Disable nút Resend
    });
    try {
      await signUpController.resendOTP(); // Gọi API gửi lại OTP
      startCountdown(); // Bắt đầu đếm ngược khi API thành công
    } catch (e) {
      Get.snackbar("Error", "Failed to resend OTP. Please try again.");
    } finally {
      setState(() {
        isLoading = false; // Kết thúc loading
        isResendDisabled = false; // Enable nút Resend
      });
    }
  }

  // Function to periodically check email verification
  bool isChecking = false; // Trạng thái đang gọi API

  void startVerifyCheck() {
    verifyTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (isChecking) return;

      if (flowController.currentFlow == 2) {
        isChecking = true;
        try {
          bool isVerified = await signUpController.checkEmailVerification();
          if (isVerified) {
            timer.cancel();
            Get.snackbar(
              "Success",
              "Verification successful!",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: EdgeInsets.all(10),
              borderRadius: 10,
              icon: Icon(Icons.check_circle, color: Colors.white),
              duration: Duration(seconds: 3),
            );
            // flowController.setFlow(1); // Chuyển đến trang thay đổi email
            flowController.setFlow(1);
            flowController.setSignUpSuccess(true); // Đặt trạng thái đăng ký thành công
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        } catch (e) {
          print("Error while checking verification: $e");
        } finally {
          isChecking = false;
        }
      } else {
        verifyTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (signUpController.userId == null) {
        Get.offAll(() => NavigationHomeScreen());
      }
    });
    setState(() {
      countdown = timeResend;
    });
    debugPrint(signUpController.userId.toString());
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          children: [
            Text(
              "Email Verification",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: HexColor("#4f4f4f"),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter OTP",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: signUpController.setOTP,
                    controller: otpController.value,
                    keyboardType: TextInputType.number,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "1234567890",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: MyButton(
                            onPressed: isResendDisabled ? null : onResendOTP,
                            buttonText: (isResendDisabled && isLoading && countdown >= 0) ? "${countdown}s" : "Resend",
                            isLoading: isLoading, // Hiển thị vòng tròn loading
                            isDisabled: isResendDisabled, // Disable nút khi đang đếm ngược
                            suffixIcon: FaIcon(
                              FontAwesomeIcons.solidPaperPlane,
                              size: 18,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(width: 10), // Khoảng cách giữa các nút
                      Expanded(
                        flex: 3,
                        child: MyButton(
                          onPressed: () async {
                            if (signUpController.otp != null && signUpController.otp!.length == 6) {
                              setState(() {
                                isLoadingProcess = true; // Hiển thị trạng thái loading
                                isResendDisabled = true; // Disable nút Resend
                              });
                              bool isVerified = await signUpController.verifyOTP(signUpController.email!, signUpController.otp!);
                              setState(() {
                                isLoadingProcess = false; // Tắt loading sau khi kiểm tra
                                isResendDisabled = false; // Disable nút Resend
                              });

                              if (isVerified) {
                                flowController.setFlow(1); // Chuyển đến trang thay đổi email
                                signUpController.resetState(); // Xóa OTP sau khi xác thực
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              }
                            } else {
                              Get.snackbar(
                                "Error",
                                "Please enter a valid 6-digit OTP.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(10),
                                borderRadius: 10,
                                icon: const Icon(Icons.error, color: Colors.white),
                                duration: const Duration(seconds: 3),
                              );
                            }
                          },
                          buttonText: 'Proceed',
                          isLoading: isLoadingProcess,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Thông báo OTP
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "An OTP has been sent to:\n",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      children: [
                        TextSpan(
                          text: signUpController.email ?? "example@mail.com",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#44564a"), // Màu đậm để nổi bật email
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nút Change Email
                  GestureDetector(
                    onTap: () {
                      flowController.setFlow(3); // Chuyển đến trang thay đổi email
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        "Change Email",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: HexColor("#44564a"), // Màu xanh đậm hơn
                          decoration: TextDecoration.underline,
                          decorationColor: HexColor("#44564a"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nút Change Email
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Help ID: ",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      children: [
                        TextSpan(
                          text: signUpController.userId.toString(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#44564a"), // Màu đậm để nổi bật email
                            fontSize: 15,
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
}
