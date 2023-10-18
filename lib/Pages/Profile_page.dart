// ignore_for_file: file_names, use_build_context_synchronously, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';
import 'package:uber_eats/Features_Layouts/Add_restarant.dart';
import 'package:uber_eats/Features_Layouts/groceries_cart_Screen.dart';
import 'package:uber_eats/Screens/ordes_page.dart';
import 'package:uber_eats/model/user.dart' as model;
import '../Provider/user_provider.dart';

// ignore: camel_case_types
class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

// ignore: camel_case_types
class _Profile_PageState extends State<Profile_Page> {
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: Width,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade500),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: const DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                  "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.username,
                              style: GoogleFonts.abyssinicaSil(
                                  fontSize: 14, color: Colors.white),
                            ),
                            Text(
                              user.email,
                              style: GoogleFonts.abyssinicaSil(
                                  fontSize: 12, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                width: 120,
                                height: 40,
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit),
                                      Text("Edit Profile")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
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
                  onTap: () {},
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
                const Divider(
                  thickness: 3,
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GroceriesCartScreen()));
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
                              Ionicons.bookmark_outline,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Address Book",
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
                  onTap: () {},
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
                                style: GoogleFonts.leagueSpartan(fontSize: 25)),
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
                  onTap: () {},
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Ionicons.create_outline,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Send feedback",
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Restaurant_Form()));
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
                              Ionicons.reader_outline,
                              size: 25,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Add Restaurant",
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
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
