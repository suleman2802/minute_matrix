import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/user_auth_provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String routeName = "/forgetPassword";
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = "";
  showSnackBar(String messsage) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          messsage,
        ),
      ),
    );
  }

  void _validateUserEmail() async {
    final userProvider =
        await Provider.of<UserAuthProvider>(context, listen: false);
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      bool isRegistered = await userProvider.getUserByEmail(_userEmail);
      if (isRegistered) {
        FocusScope.of(context).unfocus();
        await userProvider
            .sendResetPassword(_userEmail)
            .then((value) => showSnackBar(value));
        Navigator.of(context).pushNamed("/");
      } else {
        showSnackBar(
            "Invalid Email!... Entered Email is not registered with our System");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: const Text(
          "Forget Password",
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 20,horizontal: 15,),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 185,
              child: Column(children: [
                const Text(
                  "Enter your Registered Email Address",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    key: const ValueKey("email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Enter a valid Email Address";
                      }
                    },
                    onSaved: (value) {
                      _userEmail = value!.trim();
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Enter Registered Email Address",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _validateUserEmail,
                    child: const Text(
                      "Forgot Password?",
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
