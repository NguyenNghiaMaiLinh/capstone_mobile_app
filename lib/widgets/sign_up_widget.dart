import 'package:flutter/material.dart';
import 'package:solvequation/widgets/background_painter.dart';
import 'package:solvequation/widgets/facebook_signup_button.dart';
import 'package:solvequation/widgets/google_signup_button_widget.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          buildSignUp(),
        ],
      );

  Widget buildSignUp() => Column(
        children: [
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 250,
              child: Text(
                'Welcome Back To Solve Equation App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Spacer(),
          GoogleSignupButtonWidget(),
          FacebookSignupButtonWidget(),
          Spacer(),
        ],
      );
}
