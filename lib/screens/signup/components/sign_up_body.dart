import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:petspa_flutter/app_theme.dart';
import 'package:petspa_flutter/controller/flow_controller.dart';

import 'flow_one.dart';
import 'flow_three.dart';
import 'flow_two.dart';

class SignUpBodyScreen extends StatefulWidget {
  const SignUpBodyScreen({super.key});

  @override
  State<SignUpBodyScreen> createState() => _SignUpBodyScreenState();
}

class _SignUpBodyScreenState extends State<SignUpBodyScreen> {
  FlowController flowController = Get.put(FlowController());
  late int _currentFlow;

  @override
  void initState() {
    _currentFlow = FlowController().currentFlow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Logic khi nhấn back hoặc vuốt trở lại
          if (_currentFlow > 1) {
            // flowController.setFlow(flowController.currentFlow - 1);
            // flowController.setFlow(1);
            //hủy quá trình đăng ký và quay lại màn hình chính
            // Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop(result); // Cho phép quay lại màn hình trước với kết quả
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppTheme.dismissibleBackground,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
            shrinkWrap: false,
            reverse: false,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 700,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: HexColor("#ffffff"),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: GetBuilder<FlowController>(
                          builder: (context) {
                            if (flowController.currentFlow == 1) {
                              return const SignUpOne();
                            } else if (flowController.currentFlow == 2) {
                              return const SignUpTwo();
                            } else {
                              return const SignUpThree();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
