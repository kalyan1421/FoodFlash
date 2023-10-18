// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/groceries_provider.dart';

class GroceriesCartScreen extends StatelessWidget {
  const GroceriesCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<GroceriesCart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: FutureBuilder(
        future: cartProvider
            .fetchCartItems(), 
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Your cart is empty.'),
            );
          } else {
            List<Map<String, dynamic>> cartItems = snapshot.data!;

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> cartItem = cartItems[index];
                return ListTile(
                  title: Text(cartItem['itemname']),
                  subtitle: Text('Price: ₹${cartItem['itemprice']}'),
                  trailing: Text('Quantity: ${cartItem['quantity']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
