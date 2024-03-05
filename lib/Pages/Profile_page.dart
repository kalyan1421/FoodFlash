import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';
import 'package:uber_eats/Profile/Setting_page.dart';
import 'package:uber_eats/Profile/accounts_page.dart';
import 'package:uber_eats/Profile/address_page.dart';
import 'package:uber_eats/Profile/favourites_page.dart';
import 'package:uber_eats/Profile/order_page.dart';
import 'package:uber_eats/Profile/payment_page.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({Key? key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    Map<String, dynamic>? data = await getUserData();
    setState(() {
      userData = data;
    });
  }

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData.data();
    } else {
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => login_page(),
        ),
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Profile ",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        color: Colors.black,
                        fontFamily: "League-SemiBold",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //  " Kalyan Kumar Bedugam ",
                            // capitalizeFirstLetter(
                            userData!['username'] ?? 'No user name ',
                            // ),
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              color: Colors.black,
                              fontFamily: "League-SemiBold",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            userData!['phoneNumber'] ?? 'No mobile number',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.040,
                              color: Colors.grey.shade600,
                              fontFamily: "League-Regular",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      if (userData!['photoURL'].toString() == '')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.08,
                            backgroundColor:
                                Colors.grey.shade200.withOpacity(0.8),
                            child: Icon(Icons.person_outline,
                                color: Colors.black,
                                size: MediaQuery.of(context).size.width * 0.1),
                          ),
                        ),
                      if (userData!['photoURL'] != '')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    userData!['photoURL'].toString()),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Color(0xffFFEFD4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              Text(
                                "Gold Membership ",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                    color: Color(0xff65668D),
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Free Delivery for all orders",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    color: Color(0xff65668D),
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 5),
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Color(0xff65668D),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Know more",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.040,
                                      color: Colors.white,
                                      fontFamily: "MonaSans",
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Lottie.asset(
                          "assets/utiles/gift_card.json",
                          fit: BoxFit.fitHeight,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                ReusableItemWidget(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Accounts_page(),
                      ),
                    );
                  },
                  icon: Ionicons.person_outline,
                  text: "My Accounts",
                ),
                SizedBox(height: 20),
                ReusableItemWidget(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => My_Order(),
                      ),
                    );
                  },
                  icon: Ionicons.bag_check_outline,
                  text: "My Orders",
                ),
                // SizedBox(height: 20),
                // ReusableItemWidget(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Payment_page(),
                //       ),
                //     );
                //   },
                //   icon: Ionicons.card_outline,
                //   text: "Payment",
                // ),
                SizedBox(height: 20),
                ReusableItemWidget(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Address_page(),
                      ),
                    );
                  },
                  icon: Ionicons.location_outline,
                  text: "Address",
                ),
                SizedBox(height: 20),
                ReusableItemWidget(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favourites_page(),
                      ),
                    );
                  },
                  icon: Ionicons.heart_outline,
                  text: "Favourites",
                ),
                SizedBox(height: 20),
                ReusableItemWidget(
                  onTap: () {
                    openAppSettings();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Setting_page(),
                    //   ),
                    // );
                  },
                  icon: Ionicons.settings_outline,
                  text: "Settings",
                ),
                SizedBox(height: 20),
                ReusableItemWidget(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Accounts_page(),
                      ),
                    );
                  },
                  icon: Ionicons.help_circle_outline,
                  text: "Help",
                ),
                SizedBox(height: 20),
                ReusableItemWidget(
                  onTap: () {
                    logout(context);
                  },
                  icon: Ionicons.log_out_outline,
                  text: "Logout",
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class ReusableItemWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onTap;

  const ReusableItemWidget({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                color: Colors.black,
                fontFamily: "League-Regular",
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Icon(
              Ionicons.chevron_forward_outline,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
