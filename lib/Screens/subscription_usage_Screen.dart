import 'package:flutter/material.dart';
import 'package:minute_matrix/Screens/subscription_plans_screen.dart';
import '../widgets/drawer/drawer_widget.dart';
import '../widgets/subscription_usage/usage_detail_widget.dart';

class SubscriptionUsageScreen extends StatelessWidget {
  static const String routeName = "/subscriptionPlan";
  const SubscriptionUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: DarkThemeToggleWidget.isDarkMode
        //     ? Colors.black
        //     : Color.fromARGB(251, 245, 242, 242),
        //backgroundColor: Theme.of(context).canvasColor,
        //backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Subcription Usage Details"),
        ),
        drawer: DrawerWidget(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Container(
                height: 55,
                margin: EdgeInsets.all(5),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     color: DarkThemeToggleWidget.isDarkMode? Theme.of(context).cardColor :Colors.white),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subcription Plans",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              //color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      onTap: () => Navigator.of(context).pushNamed(SubscriptionPlansScreen.routeName),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              UsageDetailWidget(),
            ],
          ),
        ));
  }
}

//* The purpose of this method is to divide two number and return sum value
//? Return division result as output in (double datatype)
double divide_two_number(int dividend, int divisor) {
  //? The dividend variable take first argument as an dividend (whom will be divided)
  //? The divisor variable take second argument as an divisor (with which it divide)
  try {
    return dividend / divisor;
  } catch (error) {
    //! The divisor was zero which gives DivideByZeroException
    //! to compensate exception giving zero as output
    return 0.0;
  }
}
