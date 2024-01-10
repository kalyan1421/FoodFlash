// ignore_for_file: file_names, use_build_context_synchronously, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';
import 'package:uber_eats/Screens/ordes_page.dart';
import 'package:uber_eats/Utils/utils.dart';
import 'package:uber_eats/model/user.dart' as model;
import '../Provider/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';

// ignore: camel_case_types
class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

// ignore: camel_case_types
class _Profile_PageState extends State<Profile_Page> {
  _launchURL() async {
    const url = 'https://mywebsite-da9a2.web.app/#/';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const login_page(),
        ),
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    // ignore: non_constant_identifier_names, unused_local_variable
    final Width = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names, unused_local_variable
    final Height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Profile ",
                  style: GoogleFonts.abyssinicaSil(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(width: 8, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 5)),
                        BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(2, 1)),
                      ]),
                  child: Center(
                    child: Image.asset(
                      "assets/utiles/profile_ani.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  user?.username ?? 'Default Username',
                  style: GoogleFonts.abyssinicaSil(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? 'Default Username',
                  style: GoogleFonts.abyssinicaSil(
                      fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Divider(thickness: 1),
          SizedBox(height: 30),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Orders_page()));
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Ionicons.bag_outline),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Orders",
                                style: GoogleFonts.leagueSpartan(fontSize: 25),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showCustomSnackBar(context, "Not Favorites");
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite_border,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Favorite",
                                style: GoogleFonts.leagueSpartan(fontSize: 25),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _launchURL();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Ionicons.alert_circle_outline,
                                size: 25,
                              ),
                              const SizedBox(width: 15),
                              Text("About",
                                  style:
                                      GoogleFonts.leagueSpartan(fontSize: 25)),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AppSettings.openAppSettings();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Ionicons.settings_outline,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Settings",
                                style: GoogleFonts.leagueSpartan(fontSize: 25),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => logout(context),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Ionicons.power_outline,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Log out",
                                style: GoogleFonts.leagueSpartan(fontSize: 25),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
