import 'package:flutter/material.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:minute_matrix/widgets/general/otp_dialog_widget.dart';
import 'package:provider/provider.dart';
import './profile_screen.dart';

class ChangeUsernameScreen extends StatelessWidget {
  static const String routeName = "/changeUsernameScreen";
  final _usernameController = TextEditingController();
  String _oldUsername = "";
  final _formKey = GlobalKey<FormState>();

  void getUserName(BuildContext context) async {
    _oldUsername =
        Provider.of<UserProvider>(context, listen: false).userDetails.getName();
  }

  @override
  Widget build(BuildContext context) {
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

    Future<void> changeUsername() async {
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .changeUsername(_usernameController.text.trim())
            .then(
          (value) {
            showSnackBar("The Username updated successfully");
            Navigator.of(context).pushNamed(ProfileScreen.routeName);
          },
        );
      } catch (error) {
        showSnackBar(error.toString());
        print("Error => " + error.toString());
      }
    }

    getUserName(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _oldUsername,
        ),
      ),
      body: SizedBox(
        height: 255,
        child: Card(
          elevation: 10,
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Change Username",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    key: const ValueKey("username"),
                    controller: _usernameController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return "Enter a new Username of at least 4 character";
                      }
                      if (value == _oldUsername) {
                        return "Old and New username are same";
                      } else {
                        null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "New Username", hintText: _oldUsername),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      FocusScope.of(context).unfocus();

                      if (isValid) {
                        _formKey.currentState!.save();
                        showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return OtpDialogWidget(changeUsername);
                            });
                      } else {
                        null;
                      }
                    },
                    child: const Text(
                      "Change",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
