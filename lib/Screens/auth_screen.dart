import 'package:flutter/material.dart';
import '../widgets/auth/auth_widget.dart';

class AuthScreen extends StatelessWidget {
  static String routeName = "/AuthScreen";

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5F60B9),
      body: Expanded(
        flex: 20,
        child: SizedBox(
           //color: Colors.red,
          child: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                //color: Colors.blue,
                child: AuthWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
