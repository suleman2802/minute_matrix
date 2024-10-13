import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/user_auth_provider.dart';
import '../Providers/user_provider.dart';
import '../widgets/auth/password_strength_checker.dart';
import '../widgets/general/otp_dialog_widget.dart';
import './profile_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = "/changePasswordScreen";

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPassword = TextEditingController();

  final newPassword = TextEditingController();

  final confirmPassword = TextEditingController();
  bool _newPasswordVisible = false;
  bool _cPasswordVisible = false;
  bool _oldPasswordVisible = false;
  bool _isStrong = false;
  String _oldUsername = "";

  final _formKey = GlobalKey<FormState>();

  void getUserName() async {
    _oldUsername =
        Provider.of<UserProvider>(context, listen: false).userDetails.getName();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(
          seconds: 3,
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    String email = await Provider.of<UserProvider>(context, listen: false)
        .userDetails
        .getEmail();
    Provider.of<UserAuthProvider>(context, listen: false)
        .changePassword(newPassword.text.trim(), oldPassword.text.trim(), email)
        .then((value) {
      if (value == "") {
        showSnackBar("Password updation failed!.. Try again later");
      } else if (value == "successful") {
        showSnackBar("Password updated successfully...");
        Navigator.of(context).pushNamed(ProfileScreen.routeName);
      } else {
        showSnackBar("Password updation failed!.. Try again later");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    oldPassword.clear();
    newPassword.clear();
    confirmPassword.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _oldUsername,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          // height: MediaQuery.of(context).size.height * 0.57,
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Change Password",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: const ValueKey("old password"),
                          controller: oldPassword,
                          obscureText: !_oldPasswordVisible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your old password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Old Password",
                            hintText: "****",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _oldPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _oldPasswordVisible = !_oldPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        TextFormField(
                          key: const ValueKey("new password"),
                          controller: newPassword,
                          obscureText: !_newPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            hintText: "****",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _newPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _newPasswordVisible = !_newPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: newPassword,
                          builder: (context, child) {
                            final password = newPassword.text;

                            return PasswordStrengthChecker(
                              onStrengthChanged: (bool value) {
                                setState(() {
                                  _isStrong = value;
                                });
                              },
                              password: password,
                            );
                          },
                        ),
                        TextFormField(
                          key: const ValueKey("confirm password"),
                          validator: (value) {
                            if (newPassword.text.trim() != value!) {
                              return "Both password must be same";
                            } else {
                              null;
                            }
                          },
                          obscureText: !_cPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "****",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _cPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _cPasswordVisible = !_cPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // changePassword();
                          final isValid = _formKey.currentState!.validate();
                          FocusScope.of(context).unfocus();
                          if (_isStrong & isValid) {
                            _formKey.currentState!.save();
                            showAdaptiveDialog(
                                context: context,
                                builder: (context) {
                                  return OtpDialogWidget(changePassword);
                                });
                          } else {
                            null;
                          }
                        },
                        child: const Text(
                          "Change",
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
