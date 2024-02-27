// ignore_for_file: file_names, avoid_print, prefer_const_constructors, unused_field

import 'package:uber_eats/Cart/Food_cart_Screen.dart';
import 'package:uber_eats/Cart/groceries_cart_Screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/Food_icon.png",
                            scale: 3,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Food',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/Groceries_icon.png",
                            scale: 4,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Groceries',
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Food_Cart_screen(),
                      GroceriesCartScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
