import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:provider/provider.dart';

// import './payment_screen.dart';
import '../widgets/subscription_plan/subcription_plan_widget.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  static const String routeName = "/subscriptionPlansScreen";

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  bool? isStandard;
  bool? isPlanStandard;
  dynamic paymentIntent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isStandard = true;
     isPlanStandard = true;

  }

  Future<void> upgradePlan() async {

    await Provider.of<UserProvider>(context,listen: false)
        .upgradeSubscriptionPlan()
        .then((value) => setState(() {
              isPlanStandard = false;
            }));
  }

  void getCurrentSubscriptionPlan() {
    String currentPlan =
        Provider.of<UserProvider>(context).userDetails.getSubscription_plan();
    if (currentPlan == "Standard") {
      isPlanStandard = true;
    }
    else{
      isPlanStandard = false;
    }
  }

  Widget? floatingButton(){
    String buttonText = "";
    if(isStandard! & isPlanStandard!){
      buttonText = "Currently Subscribed";
    }
    else if (!isStandard! & isPlanStandard!){
      buttonText = "Upgrade Plan";
    }
    else if (!isStandard! & !isPlanStandard!){
      buttonText = "Currently Subscribed";
    }
    else if(isStandard! & !isPlanStandard!){
      //buttonText = "Currently Subscribed";
      return null;
    }
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        print("on pressed");
        print(isStandard);
        print(isPlanStandard);
        if (!isStandard! & isPlanStandard!) {
          print("inside if of floating button");
          //Navigator.of(context).pushNamed(PaymentScreen.routeName);
          makePayment();
        }
      },
      label: Text(
        //need to work here
        buttonText,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent('70', 'USD');
      const billingDetails = BillingDetails(
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
      // print("Payment Intent : => " + paymentIntent.toString());
      // print("Payment Intent Client Secret : => " +
      //     paymentIntent["client_secret"]);
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
        'amount': "6999",
        'currency': currency,
        "payment_method_types[]": "card",
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
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                )).then((value) => upgradePlan());

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      //print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
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
      //print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    getCurrentSubscriptionPlan();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Plans"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: FittedBox(
                  child: Row(
                    children: [
                      Text(
                        "Currently you have subscribed ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        isPlanStandard! ? "Standard" : "Enterprise",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " plan",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Stack(
              children: [
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    // Toggle the isStandard argument based on the swipe direction
                    setState(() {
                      isStandard = direction != DismissDirection.endToStart;
                      //isStandard != isStandard;
                    });

                    // Remove the item from the data source
                  },

                  // Show a green background when swiping right, and a red background when swiping left
                  //background: Container(color: Colors.green),
                  //secondaryBackground: Container(color: Colors.red),
                  // Allow swipe gesture in both directions
                  direction: DismissDirection.horizontal,
                  child: SubscriptionPlanWidget(isStandard!),
                ),
                Positioned(
                  right: isStandard! ? 0.000001 : null,
                  left: !isStandard! ? 000001 : null,
                  // top: isStandard! ? 220 : 257,
                  top: 257,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isStandard!) {
                          isStandard = false;
                          //print(isStandard!.toString());
                        } else {
                          isStandard = true;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.6),
                      shape: const CircleBorder(),
                      fixedSize: const Size(1, 1),
                      //style: ButtonStyle(),
                    ),
                    child: Icon(isStandard!
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_back_ios),
                  ),
                  // FloatingActionButton.small(
                  //   onPressed: () {},
                  //   child: Icon(Icons.arrow_forward_ios_rounded),
                ),
                //),
              ],
            ),

            // Stack(
            //   children: [
            //     SubcriptionPlanWidget(isStandard),
            //     Positioned(
            //       right: 0.000001,
            //       top: 220,
            //       child: ElevatedButton(
            //         onPressed: () {},
            //         child: Icon(Icons.arrow_forward_ios),
            //         style: ElevatedButton.styleFrom(
            //           shape: CircleBorder(),

            //           fixedSize: Size(1, 1),
            //           //style: ButtonStyle(),
            //         ),
            //       ),
            //       // FloatingActionButton.small(
            //       //   onPressed: () {},
            //       //   child: Icon(Icons.arrow_forward_ios_rounded),
            //     ),
            //     //),
            //   ],
            // ),

            //Row(
            // children: [
            //SubscriptionPlanWidget(true),
            //IconButton.outlined(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded),),
            // Align(
            //     alignment: Alignment.centerRight,
            //     child: FloatingActionButton(
            //       onPressed: () {},
            //       child: Icon(Icons.arrow_forward_ios_rounded),
            //     )),
            // ],
            //  ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: floatingButton(),
    );
  }
}
