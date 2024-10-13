import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  static const String routeName = "./paymentScreen";

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  dynamic paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit Card Payment"),
      ),
      body: SafeArea(
        child:
        // child: Column(
        //   children: [
        //     CreditCardWidget(
        //       cardNumber: cardNumber,
        //       expiryDate: expiryDate,
        //       cardHolderName: cardHolderName,
        //       cvvCode: cvvCode,
        //       isHolderNameVisible: true,
        //       cardBgColor: Theme.of(context).primaryColor,
        //       showBackView: isCvvFocused,
        //       //true when you want to show cvv(back) view
        //       onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
        //       customCardTypeIcons: <CustomCardTypeIcon>[
        //         CustomCardTypeIcon(
        //           cardType: CardType.mastercard,
        //           cardImage: Image.asset(
        //             'assets/images.png',
        //             height: 60,
        //             width: 60,
        //           ),
        //         ),
        //       ],
        //     ),
        //     Expanded(
        //       child: SingleChildScrollView(
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 6),
        //           child: CreditCardForm(
        //             formKey: formKey,
        //             // Required
        //             cardNumber: cardNumber,
        //             // Required
        //             expiryDate: expiryDate,
        //             // Required
        //             cardHolderName: cardHolderName,
        //             // Required
        //             cvvCode: cvvCode,
        //             // Required
        //             // cardNumberKey: cardNumberKey,
        //             // cvvCodeKey: cvvCodeKey,
        //             // expiryDateKey: expiryDateKey,
        //             // cardHolderKey: cardHolderKey,
        //             onCreditCardModelChange: onCreditCardModel,
        //             //(CreditCardModel data) {},
        //             // Required
        //             obscureCvv: true,
        //             obscureNumber: false,
        //             isHolderNameVisible: true,
        //             isCardNumberVisible: true,
        //             isExpiryDateVisible: true,
        //             enableCvv: true,
        //             cvvValidationMessage: 'Please input a valid CVV',
        //             dateValidationMessage: 'Please input a valid date',
        //             numberValidationMessage: 'Please input a valid number',
        //             cardNumberValidator: (String? cardNumber) {},
        //             expiryDateValidator: (String? expiryDate) {},
        //             cvvValidator: (String? cvv) {},
        //             cardHolderValidator: (String? cardHolderName) {},
        //             onFormComplete: () {
        //               // callback to execute at the end of filling card data
        //               if (formKey.currentState!.validate()) {
        //                 _showValidDialog(context);
        //                 print('valid!');
        //               } else {
        //                 print('invalid!');
        //               }
        //             },
        //             autovalidateMode: AutovalidateMode.always,
        //             disableCardNumberAutoFillHints: false,
        //             inputConfiguration: const InputConfiguration(
        //               cardNumberDecoration: InputDecoration(
        //                 border: OutlineInputBorder(),
        //                 labelText: 'Number',
        //                 hintText: 'XXXX XXXX XXXX XXXX',
        //               ),
        //               expiryDateDecoration: InputDecoration(
        //                 border: OutlineInputBorder(),
        //                 labelText: 'Expired Date',
        //                 hintText: 'MM/YY',
        //               ),
        //               cvvCodeDecoration: InputDecoration(
        //                 border: OutlineInputBorder(),
        //                 labelText: 'CVV',
        //                 hintText: 'XXX',
        //               ),
        //               cardHolderDecoration: InputDecoration(
        //                 border: OutlineInputBorder(),
        //                 labelText: 'Card Holder',
        //               ),
        //               cardNumberTextStyle: TextStyle(
        //                 fontSize: 14,
        //                 //color: Colors.black,
        //               ),
        //               cardHolderTextStyle: TextStyle(
        //                 fontSize: 14,
        //                 //color: Colors.black,
        //               ),
        //               expiryDateTextStyle: TextStyle(
        //                 fontSize: 14,
        //                 //color: Colors.black,
        //               ),
        //               cvvCodeTextStyle: TextStyle(
        //                 fontSize: 14,
        //                 //color: Colors.black,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
            GestureDetector(
              onTap: () {
               // if (formKey.currentState!.validate()) {
                  //_showValidDialog(context);
                  makePayment();
                //  print('valid!');
               // } else {
                //  print('invalid!');
               // }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Validate',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'halter',
                    fontSize: 14,
                    package: 'flutter_credit_card',
                  ),
                ),
              ),
            ),
          //],
       // ),
      ),
    );
  }

  _showValidDialog(
      BuildContext context,
      ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Valid",style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          content: Text("Your card successfully valid !!!",style: TextStyle(color: Theme.of(context).primaryColor),),
          actions: [
            TextButton(
                child: const Text(
                  "Ok",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  // void onCreditCardModel(CreditCardModel? creditCardModel) {
  //   setState(() {
  //     cardNumber = creditCardModel!.cardNumber;
  //     expiryDate = creditCardModel.expiryDate;
  //     cardHolderName = creditCardModel.cardHolderName;
  //     cvvCode = creditCardModel.cvvCode;
  //     isCvvFocused = creditCardModel.isCvvFocused;
  //   });
  // }

  //STRIPE PAYMENT

  Future<void> makePayment() async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent('70', 'USD');
      final billingDetails = BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      );
      // response getting
      print("Payment Intent : => "+paymentIntent.toString());
      print("Payment Intent Client Secret : => "+paymentIntent["client_secret"]);
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetails: billingDetails,
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();


    } catch (err) {
      throw Exception(err);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': "70",
        'currency': currency,
        "payment_method_types[]":"card",

      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text("Payment Successful!"),
                ],
              ),
            ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }


}
