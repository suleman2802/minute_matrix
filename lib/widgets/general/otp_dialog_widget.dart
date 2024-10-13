import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_otp/email_otp.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class OtpDialogWidget extends StatefulWidget {
  final changeUsername;
  OtpDialogWidget(this.changeUsername);

  @override
  State<OtpDialogWidget> createState() => _OtpDialogWidgetState();
}

class _OtpDialogWidgetState extends State<OtpDialogWidget> {
  EmailOTP? myauth;
  
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myauth = EmailOTP();
    
    setUp();
  }

  Dispose() {
    otp1.clear();
    otp2.clear();
    otp3.clear();
    otp4.clear();
  }

  Future<void> validateOtp() async {
    final enteredOtp = (otp1.text.trim() +
        otp2.text.trim() +
        otp3.text.trim() +
        otp4.text.trim());

    bool isValid = await myauth!.verifyOTP(otp: enteredOtp);
    if (isValid) {
      showSnackBar("Otp Verified");
      Navigator.of(context).pop();
      widget.changeUsername();
    } else {
      showSnackBar("Wrong Otp! Retry again...");
    }
  }

  void setUp()async {
    try {
      // myauth!.setSMTP(
      //   host: "smtp.rohitchouhan.com",
      //   auth: true,
      //   username: "email-otp@rohitchouhan.com",
      //   password: "*************",
      //   secure: "TLS",
      //   port: 576
      // );
      // var template = "";
      // myauth!.setTemplate(render: template);
      final userEmail =  Provider.of<UserProvider>(context, listen: false).userDetails.getEmail();
      print("Email : $userEmail");
      myauth!.setConfig(
        appEmail: "minuteMatrix@gmail.com",
        appName: "MinuteMatrix",
        userEmail: userEmail,
        otpLength: 4,
        otpType: OTPType.digitsOnly,
      );
    } catch (error) {
      print("Error :: " + error.toString());
    }
  }

  Future<void> sendOtp() async {
    try {
      final result = await myauth!.sendOTP();
      if (result == true) {
        showSnackBar("OTP has been sent");
      } else {
        showSnackBar("Unable to send OTP");
      }
    } catch (error) {
      print("Error => " + error.toString());
      showSnackBar("Unable to send OTP");
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(
          seconds: 2,
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

  @override
  Widget build(BuildContext context) {
    sendOtp();
    return Center(
      child: SizedBox(
        height: 250,
        child: Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Enter OTP",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        height: 70,
                        width: 50,
                        child: TextFormField(
                          key: Key("o1"),
                          controller: otp1,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            //otp1 += value.trim();
                            FocusScope.of(context).nextFocus();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 26,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        height: 70,
                        width: 50,
                        child: TextFormField(
                          key: Key("o2"),
                          controller: otp2,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            //otp2 += value.trim();
                            FocusScope.of(context).nextFocus();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 26,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        height: 70,
                        width: 50,
                        child: TextFormField(
                          key: Key("o3"),
                          controller: otp3,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            //otp3 += value.trim();
                            FocusScope.of(context).nextFocus();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 26,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        height: 70,
                        width: 50,
                        child: TextFormField(
                          key: Key("o4"),
                          controller: otp4,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            //otp4 += value.trim();
                            FocusScope.of(context).nextFocus();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 26,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Resend Otp",
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "cancel",
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: validateOtp,
                      child: const Text("Ok"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
