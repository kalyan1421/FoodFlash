// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroceriesCart extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  Future<void> addToCart(
      Map<String, dynamic> itemData, int quantityChange) async {
    final user = _auth.currentUser;

    try {
      if (user != null) {
        final existingCartItem = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('GroceriesCart')
            .doc(itemData['itemId'])
            .get();

        if (existingCartItem.exists) {
          // If the item is already in the cart, update the quantity
          final currentQuantity = existingCartItem.data()!['quantity'] ?? 0;
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('GroceriesCart')
              .doc(itemData['itemId'])
              .update({
            'quantity': currentQuantity + quantityChange,
          });
        } else {
          // If the item is not in the cart, add it with the quantity
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('GroceriesCart')
              .doc(itemData['itemId'])
              .set({
            'itemname': itemData['title'],
            'itemimage': itemData['image'],
            'itemprice': itemData['price'],
            'quantity': quantityChange,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        print('Item added to cart successfully!');
      } else {
        print('User is not authenticated. Cannot add to cart.');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> removeFromCart(String itemId) async {
    final user = _auth.currentUser;

    try {
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('GroceriesCart')
            .doc(itemId)
            .delete();

        print('Item removed from cart successfully!');
      } else {
        print('User is not authenticated. Cannot remove from cart.');
      }
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  Future<void> clearCart() async {
    final user = _auth.currentUser;

    try {
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('GroceriesCart')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        print('Cart cleared successfully!');
      } else {
        print('User is not authenticated. Cannot clear the cart.');
      }
    } catch (e) {
      print('Error clearing the cart: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final user = _auth.currentUser;

    if (user != null) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('GroceriesCart')
            .get();

        _cartItems = snapshot.docs
            .map((doc) => doc.data())
            .toList();

        return _cartItems;
      } catch (e) {
        print('Error fetching cart items: $e');
        return [];
      }
    } else {
      print('User is not authenticated. Cannot fetch cart items.');
      return [];
    }
  }
}
