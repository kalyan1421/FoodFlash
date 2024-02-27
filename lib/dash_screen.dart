// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field, duplicate_ignore, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';
import 'package:uber_eats/Pages/Food_page.dart';
import 'package:uber_eats/Pages/Home_Page.dart';
import 'package:uber_eats/Pages/Profile_page.dart';
import 'package:uber_eats/Pages/Groceries_page.dart';
import 'package:uber_eats/Provider/user_provider.dart';
import 'package:uber_eats/Pages/Cart_page.dart';

class MyHomePage extends StatefulWidget {
  int selectindex;
   MyHomePage({Key? key, required this.selectindex}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) => 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => login_page(),
        ),
      ),);
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool itemsInOrder = false;

  @override
  void initState() {
    super.initState();
    addData();
    // checkItemsInOrder();
    _user = _auth.currentUser;
  }

  // Future<void> checkItemsInOrder() async {
  //   final UserProvider userProvider =
  //       Provider.of<UserProvider>(context, listen: false);
  //   final userId = userProvider.getUser?.uid; // Replace with the actual user ID
  //   final orderCollection = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('orders');

  //   final orderQuery = await orderCollection.limit(1).get();
  //   if (orderQuery.docs.isNotEmpty) {
  //     setState(() {
  //       itemsInOrder = true;
  //     });
  //   }
  // }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.referhUser();
  }

  int PresentIndex = 0;

  final List<Widget> _screens = [
    const RestaurantList(),
    Food_page(),
    const CategoryScreen(),
    const CartScreen(),
    const Profile_Page(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: itemsInOrder
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           // Handle the FAB tap when items are present in the order collection
      //           // For example, navigate to the order tracking screen
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => Order_tracking()));
      //         },
      //         child: Icon(Icons.shopping_cart),
      //       )
      //     : null,
      body: _screens[widget.selectindex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: GNav(
            selectedIndex: widget.selectindex,
            onTabChange: (index) {
              setState(
                () {
                  widget.selectindex = index;
                },
              );
            },
            // rippleColor: Colors.black,
            duration: const Duration(milliseconds: 500),
            backgroundColor: Colors.white,
            color: Colors.white,
            activeColor: Colors.black,

            tabBackgroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            // },
            gap: 10,
            tabs: const [
              GButton(
                icon: Ionicons.home_outline,
                text: "Home",
                iconColor: Colors.grey,
              ),
              GButton(
                icon: Ionicons.fast_food_outline,
                text: "Delivery",
                iconColor: Colors.grey,
              ),
              // GButton(
              //   icon: Icons.local_dining_outlined,
              //   text: "DineOut",
              //   iconColor: Colors.grey,
              // ),
              GButton(
                icon: Ionicons.storefront_outline,
                text: "Instamart",
                iconColor: Colors.grey,
              ),
              GButton(
                icon: Ionicons.bag_outline,
                text: "Cart",
                iconColor: Colors.grey,
              ),
              GButton(
                icon: Ionicons.person_outline,
                text: "Profile",
                iconColor: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
