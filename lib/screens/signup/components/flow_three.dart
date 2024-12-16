import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:petspa_flutter/components/my_button.dart';
import 'package:petspa_flutter/controller/flow_controller.dart';
import 'package:petspa_flutter/controller/sign_up_controller.dart';

class SignUpThree extends StatefulWidget {
  const SignUpThree({super.key});

  @override
  State<SignUpThree> createState() => _SignUpThreeState();
}

class _SignUpThreeState extends State<SignUpThree> {
  final SignUpController signUpController = Get.put(SignUpController());
  final FlowController flowController = Get.put(FlowController());

  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.text = signUpController.email ?? ""; // Điền giá trị email hiện tại
  }

  Future<void> updateEmail() async {
    setState(() {
      isLoading = true; // Hiển thị trạng thái loading
    });
    try {
      // Gọi API cập nhật email
      bool success = await signUpController.updateEmail(emailController.text);
      if (success) {
        String text = "Email updated successfully! Please check your email to verify.";
        Get.snackbar("Success", text, snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
        flowController.setFlow(2); // Quay lại bước xác thực email
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update email: $e", snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        isLoading = false; // Tắt trạng thái loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    flowController.setFlow(2);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                const SizedBox(width: 67),
                Text(
                  "Edit Email",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#4f4f4f"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Enter Correct Email",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: HexColor("#8d8d8d"),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: HexColor("#4f4f4f"),
              decoration: InputDecoration(
                hintText: "example@mail.com",
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
            const SizedBox(height: 20),
            MyButton(
              onPressed: updateEmail,
              buttonText: "Update Email",
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
