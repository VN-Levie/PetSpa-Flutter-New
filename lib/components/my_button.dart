import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonText;
  final bool isLoading;
  final bool isDisabled;
  final Color? enabledColor; // Màu nền khi nút hoạt động
  final Color? disabledColor; // Màu nền khi nút disable
  final Color? textColor; // Màu chữ
  final Widget? prefixIcon; // Biểu tượng bên trái
  final Widget? suffixIcon; // Biểu tượng bên phải

  const MyButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
    this.isDisabled = false,
    this.enabledColor, // Màu sắc trạng thái Enable
    this.disabledColor, // Màu sắc trạng thái Disable
    this.textColor, // Màu chữ
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled || isLoading ? null : onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 55,
          width: double.infinity, // Sử dụng chiều rộng linh hoạt
          decoration: BoxDecoration(
            color: isDisabled
                ? disabledColor ?? Colors.grey.shade400 // Màu disable
                : enabledColor ?? HexColor('#44564a'), // Màu mặc định
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Kích thước tối thiểu cho Row
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 8), // Khoảng cách giữa icon và text
              ],
              isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: textColor ?? Colors.white, // Màu chữ
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8), // Khoảng cách giữa text và icon
                suffixIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
