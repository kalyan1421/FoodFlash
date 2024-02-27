// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:provider/provider.dart';
// import 'package:uber_eats/Auth/UI/Login_UI.dart';
// import 'package:uber_eats/Features_Layouts/add_grocery.dart';
// import 'package:uber_eats/Screens/ordes_page.dart';
// import 'package:uber_eats/model/user.dart' as model;
// import '../Provider/user_provider.dart';
// import 'package:app_settings/app_settings.dart';

// class Profile_Page extends StatefulWidget {
//   const Profile_Page({super.key});

//   @override
//   State<Profile_Page> createState() => _Profile_PageState();
// }

// // ignore: camel_case_types
// class _Profile_PageState extends State<Profile_Page> {
//   Map<String, dynamic>? userData;

//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }

//   Future<void> _getUserData() async {
//     Map<String, dynamic>? data = await getUserData();
//     setState(() {
//       userData = data;
//     });
//   }

//   Future<void> logout(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => login_page(),
//         ),
//       );
//     } catch (e) {
//       print("Error logging out: $e");
//     }
//   }

//   Future<Map<String, dynamic>?> getUserData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
//           .instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//       return userData.data();
//     } else {
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // model.User? user = Provider.of<UserProvider>(context).getUser;
//     // ignore: non_constant_identifier_names, unused_local_variable
//     final Width = MediaQuery.of(context).size.width;
//     // ignore: non_constant_identifier_names, unused_local_variable
//     final Height = MediaQuery.of(context).size.height;
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(
//             height: 40,
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Text(
//               "Profile ",
//               style: TextStyle(
//                   fontSize: MediaQuery.of(context).size.width * 0.08,
//                   color: Colors.black,
//                   fontFamily: "League-SemiBold",
//                   fontWeight: FontWeight.w400),
//             ),
//           ),
//           Row(
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     userData!['username'] ?? 'No Username',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width * 0.08,
//                         color: Colors.black,
//                         fontFamily: "League-SemiBold",
//                         fontWeight: FontWeight.w400),
//                   ),
//                   Text(
//                     userData!['username'] ?? 'No Username',
//                     style: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width * 0.08,
//                         color: Colors.black,
//                         fontFamily: "League-SemiBold",
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "Profile ",
//                   style: TextStyle(
//                       fontSize: MediaQuery.of(context).size.width * 0.08,
//                       color: Colors.black,
//                       fontFamily: "League-extrabold",
//                       fontWeight: FontWeight.w400),
//                 ),
//                 SizedBox(height: 30),
//                 Container(
//                   alignment: Alignment.center,
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                       color: Colors.indigo.shade300,
//                       shape: BoxShape.circle,
//                       border: Border.all(width: 8, color: Colors.white),
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.grey.shade300,
//                             spreadRadius: 2,
//                             blurRadius: 2,
//                             offset: Offset(0, 5)),
//                         BoxShadow(
//                             color: Colors.grey.shade300,
//                             spreadRadius: 1,
//                             blurRadius: 1,
//                             offset: Offset(2, 1)),
//                       ]),
//                   child: Center(
//                     child: Image.asset(
//                       "assets/utiles/profile_ani.png",
//                       width: 100,
//                       height: 100,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   userData!['username'] ?? 'Default Username',
//                   style: GoogleFonts.abyssinicaSil(
//                       fontSize: 16, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           // Divider(thickness: 1),
//           SizedBox(height: 30),
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   SizedBox(height: 20),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const Orders_page()));
//                     },
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 60,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Ionicons.bag_outline),
//                               const SizedBox(
//                                 width: 15,
//                               ),
//                               Text(
//                                 "Orders",
//                                 style: GoogleFonts.leagueSpartan(fontSize: 25),
//                               ),
//                             ],
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 25,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // showCustomSnackBar(context, "Not Favorites");
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddGroceryScreen(),
//                         ),
//                       );
//                     },
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 60,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.favorite_border,
//                                 size: 25,
//                               ),
//                               const SizedBox(
//                                 width: 15,
//                               ),
//                               Text(
//                                 "Favorite",
//                                 style: GoogleFonts.leagueSpartan(fontSize: 25),
//                               ),
//                             ],
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 25,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       // _launchURL();
//                     },
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 60,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Ionicons.alert_circle_outline,
//                                 size: 25,
//                               ),
//                               const SizedBox(width: 15),
//                               Text("About",
//                                   style:
//                                       GoogleFonts.leagueSpartan(fontSize: 25)),
//                             ],
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 25,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       AppSettings.openAppSettings();
//                     },
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 60,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Ionicons.settings_outline,
//                                 size: 25,
//                               ),
//                               const SizedBox(
//                                 width: 15,
//                               ),
//                               Text(
//                                 "Settings",
//                                 style: GoogleFonts.leagueSpartan(fontSize: 25),
//                               ),
//                             ],
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 25,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () => logout(context),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 60,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Ionicons.power_outline,
//                                 size: 25,
//                               ),
//                               const SizedBox(
//                                 width: 15,
//                               ),
//                               Text(
//                                 "Log out",
//                                 style: GoogleFonts.leagueSpartan(fontSize: 25),
//                               ),
//                             ],
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 25,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 80),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';

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

  // String capitalizeFirstLetter(String text) {
  //   return text.substring(0, 1).toUpperCase() + text.substring(1);
  // }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: SizedBox()),
                  Text(
                    "Profile ",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      color: Colors.black,
                      fontFamily: "League-SemiBold",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      logout(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.logout),
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
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            color: Colors.black,
                            fontFamily: "League-SemiBold",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          userData!['phoneNumber'] ?? 'No mobile number',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.040,
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
              SizedBox(height: 10),
              Divider(
                thickness: 1,
                color: Colors.grey.shade200,
              ),
              SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 200,
              //     decoration: BoxDecoration(
              //         color: Colors.blue.shade300,
              //         borderRadius: BorderRadius.circular(10)),
              //     child: Stack(
              //       children: [
              //         Positioned(
              //           right: 0,
              //           bottom: -10,
              //           child: Container(
              //             height: 50,
              //             width: 150,
              //             decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.only(
              //                 topLeft: Radius.circular(50),
              //                 bottomLeft: Radius.circular(20),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text(
              //         userData!['username'] ?? 'No user name ',
              //         style: TextStyle(
              //           fontSize: MediaQuery.of(context).size.width * 0.08,
              //           color: Colors.black,
              //           fontFamily: "League-SemiBold",
              //           fontWeight: FontWeight.w400,
              //         ),
              //       ),
              //       SizedBox(height: 30),
              //       Container(
              //         alignment: Alignment.center,
              //         width: 150,
              //         height: 150,
              //         decoration: BoxDecoration(
              //           color: Colors.indigo.shade300,
              //           shape: BoxShape.circle,
              //           border: Border.all(width: 8, color: Colors.white),
              //         ),
              //         child: Center(
              //           child: Image.asset(
              //             "assets/utiles/profile_ani.png",
              //             width: 100,
              //             height: 100,
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: 10),
              //       Text(
              //         userData!['username'] ?? 'Default Username',
              //         style: TextStyle(fontSize: 16, color: Colors.grey),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 30),
            ],
          ),
        ),
      );
    }
  }
}
