// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field, duplicate_ignore, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';
import 'package:uber_eats/Pages/Dining_page.dart';
import 'package:uber_eats/Pages/Home_Page.dart';
import 'package:uber_eats/Pages/Profile_page.dart';
import 'package:uber_eats/Pages/groceries_1.dart';
import 'package:uber_eats/Provider/user_provider.dart';
import 'package:uber_eats/Pages/Cart_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // final Cart cart;
  // const MyHomePage({super.key, required this.cart});
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool itemsInOrder = false;

  @override
  void initState() {
    super.initState();
    addData();
    checkItemsInOrder();
    _user = _auth.currentUser;
  }

  Future<void> checkItemsInOrder() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.getUser?.uid; // Replace with the actual user ID
    final orderCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders');

    final orderQuery = await orderCollection.limit(1).get();
    if (orderQuery.docs.isNotEmpty) {
      setState(() {
        itemsInOrder = true;
      });
    }
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.referhUser();
  }

  int PresentIndex = 0;

  final List<Widget> _screens = [
    const RestaurantList(),
    const Dining_page(),
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
      body: _screens[PresentIndex],
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
            selectedIndex: PresentIndex,
            onTabChange: (index) {
              setState(
                () {
                  PresentIndex = index;
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
                icon: Icons.delivery_dining,
                text: "Delivery",
                iconColor: Colors.grey,
              ),
              GButton(
                icon: Icons.dining_sharp,
                text: "Dining",
                iconColor: Colors.grey,
              ),
              GButton(
                icon: Icons.dining_sharp,
                text: "Dining",
                iconColor: Colors.grey,
              ),
              GButton(
                icon: Icons.shopping_cart,
                text: "Cart",
                iconColor: Colors.grey,
              ),
              GButton(
                icon: Icons.person,
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
