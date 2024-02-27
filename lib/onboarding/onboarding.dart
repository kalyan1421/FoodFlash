import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';

class OnboardingOverview extends StatelessWidget {
  const OnboardingOverview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoOnboarding(
      onPressedOnLastPage: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => login_page(),
        ),
      ),
      pages: [
        WhatsNewPage(
          scrollPhysics: const BouncingScrollPhysics(),
          title: Text(""),
          features: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/onboarding_images/Food_ordering.json',
                    fit: BoxFit.cover,
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.3),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Text(
                  "Food Delivery at your door step",
                  style: TextStyle(
                      fontFamily: 'MonaSans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Get yummny deicious food at your",
                        style: TextStyle(
                          fontFamily: 'MonaSans',
                          fontSize: 16,
                        )),
                    Text("service in within less time",
                        style: TextStyle(
                          fontFamily: 'MonaSans',
                          fontSize: 16,
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
        WhatsNewPage(
          scrollPhysics: const BouncingScrollPhysics(),
          title: Text(""),
          features: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/onboarding_images/Grocery_ordering.json',
                    fit: BoxFit.cover,
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.3),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Text(
                  "Grocery & Essentials Delivery",
                  style: TextStyle(
                      fontFamily: 'MonaSans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Text("Effortless delivery of groceries and essentials",
                        style: TextStyle(
                          fontFamily: 'MonaSans',
                          fontSize: 16,
                        )),
                    Text("Swift grocery and essentials delivery",
                        style: TextStyle(
                          fontFamily: 'MonaSans',
                          fontSize: 16,
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
        WhatsNewPage(
          scrollPhysics: const BouncingScrollPhysics(),
          title: Text(""),
          features: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/onboarding_images/Order_tracking.json',
                    fit: BoxFit.cover,
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.3),
                SizedBox(height: 50),
                Text(
                  "Fast doorstep food delivery.",
                  style: TextStyle(
                      fontFamily: 'MonaSans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Text("Quickly enjoy doorstep delicacies, delivered fast.",
                        style: TextStyle(
                          fontFamily: 'MonaSans',
                          fontSize: 16,
                        )),
                    Text("Swift delivery of your package, right to your door.",
                        style: TextStyle(
                          fontFamily: 'MonaSans',
                          fontSize: 16,
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
