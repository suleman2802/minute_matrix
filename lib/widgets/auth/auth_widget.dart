import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minute_matrix/Screens/demo_recording_screen.dart';
import 'package:provider/provider.dart';

import '../../Providers/user_provider.dart';
import '../auth/password_strength_checker.dart';
import '../../Screens/splash_screen.dart';
import '../../Providers/user_auth_provider.dart';
import '../../Screens/forget_password_screen.dart';

class AuthWidget extends StatefulWidget {
  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLogin = true;
  bool isloading = false;

  //String _userEmail = "";

  bool _passwordVisible = false;
  bool _cpasswordVisiible = false;
  bool _isStrong = false;

  void submitForm() async {
    final userProvider =
        await Provider.of<UserAuthProvider>(context, listen: false);
    try {
      setState(() {
        isloading = true;
      });
      if (_isLogin) {
        //login the user
        await userProvider
            .login(
                _emailController.text.trim(), _passwordController.text.trim())
            .then((value) =>
                Navigator.pushNamed(context, SplashScreen.routeName));
      } else {
        String userId = await Provider.of<UserProvider>(context, listen: false)
            .findUserByEmail(_emailController.text.trim());
        if (userId.isEmpty) {
          //create new user
          // await userProvider
          //     .createNewUser(
          //         _emailController.text.trim(),
          //         _passwordController.text.trim(),
          //         _usernameController.text.trim())
          //     .then((value) =>
              Navigator.pushNamed(
                  context, DemoRecordingScreen.routeName,
                  arguments: {
                    "username": _usernameController.text.trim(),
                    "email":_emailController.text.trim(),
                    "password":_passwordController.text.trim(),
                  });
    //);
        } else {
          setState(() {
            isloading = false;
          });
          showSnackbar("This email is already registered");
        }
      }
      //Navigator.pushNamed(context, SplashScreen.routeName);
    } on FirebaseAuthException catch (error) {
      setState(() {
        isloading = false;
      });
      print(
        "Error : ${error.code}",
      );
      showSnackbar(error.code.toString());
    }
  }

  showSnackbar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  bool trySubmit() {
    print("inside try submit");
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      return true;
      // submitForm();
      //submitbtn(_userEmail, _userName, _password, _isLogin, context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Welcome to MinuteMatrix",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    key: const ValueKey("email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Enter a valid Email Address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: "Email Address",
                        hintText: "e.g example@gmail.com"),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey("username"),
                      controller: _usernameController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return "Enter a valid Username of at least 3 character";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: "User name", hintText: "e.g ahmed"),
                    ),
                  TextFormField(
                    key: const ValueKey("password"),
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter password";
                      }
                    },
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "****",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  if (!_isLogin)
                    AnimatedBuilder(
                      animation: _passwordController,
                      builder: (context, child) {
                        final password = _passwordController.text;

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
                  if (_isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ForgetPasswordScreen.routeName);
                        },
                        child: const Text(
                          "Forgot Password?",
                        ),
                      ),
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey("confirm password"),
                      validator: (value) {
                        if (_passwordController.text.trim() != value!) {
                          return "Both password must be same";
                        } else {
                          return null;
                        }
                      },
                      obscureText: !_cpasswordVisiible,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "****",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _cpasswordVisiible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _cpasswordVisiible = !_cpasswordVisiible;
                            });
                          },
                        ),
                      ),
                    ),
                  !_isLogin
                      ? const SizedBox(
                          height: 8,
                        )
                      : const SizedBox(),
                  isloading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (trySubmit()) {
                                  if (_isLogin) {
                                    submitForm();
                                  } else {
                                    if (_isStrong) {
                                      submitForm();
                                    }
                                  }
                                }
                              },
                              child: Text(
                                _isLogin ? "Login" : "Sign up",
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? "Create new account"
                                    : "Already have an account",
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// validator: (value) {
//   if (!_isLogin) {
//     String pattern =
//         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//     RegExp regExp = new RegExp(pattern);
//     print("reg result :  ${regExp.hasMatch(value!)}");
//     if (!regExp.hasMatch(value!)) {
//       return "must have at least 1 Numeric,Capital and lower case letter";
//     } else {
//       if (value!.isEmpty || value.length < 7) {
//         return "Enter a password of at least length 7";
//       } else if (value!.isEmpty || value.length > 20) {
//         return "Enter a password of at least length 7 and less then 20 character";
//       } else {
//         null;
//       }
//     }
//   } else {
//     null;
//   }
// },
// onChanged: (value) => _password = value!.trim(),
// onSaved: (value) {
//   _password = value!.trim();
// },
