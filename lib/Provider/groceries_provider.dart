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
            .doc(itemData['id'])
            .get();

        if (existingCartItem.exists) {
          final currentQuantity = existingCartItem.data()!['quantity'] ?? 0;
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('GroceriesCart')
              .doc(itemData['id'])
              .update({
            'quantity': currentQuantity + quantityChange,
          });
        } else {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('GroceriesCart')
              .doc(itemData['id'])
              .set({
            'itemid': itemData['id'],
            'itemname': itemData['title'],
            'itemimage': itemData['image'],
            'itemprice': itemData['price'],
            'quantity': quantityChange,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        print('Item added to cart successfully!');
        notifyListeners(); // Notify listeners of the change
      } else {
        print('User is not authenticated. Cannot add to cart.');
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> updateCartItem(
    String itemId,
    int newQuantity,
  ) async {
    final user = _auth.currentUser;

    try {
      if (user != null) {
        if (newQuantity > 0) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('GroceriesCart')
              .doc(itemId)
              .update({
            'quantity': newQuantity,
          });
          print('Item in the cart updated successfully!');
        } else {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('GroceriesCart')
              .doc(itemId)
              .delete();
          print('Item in the cart Deleted successfully!');
        }

        notifyListeners(); // Notify listeners of the change
      } else {
        print('User is not authenticated. Cannot update item in cart.');
      }
    } catch (e) {
      print('Error updating item in cart: $e');
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

        _cartItems = snapshot.docs.map((doc) => doc.data()).toList();

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

  double GroceriesCalculateTotalPrice(List<Map<String, dynamic>> cartItems) {
    double totalPrice = 0;
    for (final cartItem in cartItems) {
      totalPrice +=
          (cartItem['itemprice'] ?? 0.0) * (cartItem['quantity'] ?? 0);
    }
    return totalPrice;
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class GroceriesCart extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   List<Map<String, dynamic>> _cartItems = [];

//   List<Map<String, dynamic>> get cartItems => _cartItems;
//     Future<List<Map<String, dynamic>>> fetchCartItems() async {
//     final user = _auth.currentUser;

//     if (user != null) {
//       try {
//         final snapshot = await _firestore
//             .collection('users')
//             .doc(user.uid)
//             .collection('GroceriesCart')
//             .get();

//         _cartItems = snapshot.docs
//             .map((doc) => doc.data())
//             .toList();

//         return _cartItems;
//       } catch (e) {
//         print('Error fetching cart items: $e');
//         return [];
//       }
//     } else {
//       print('User is not authenticated. Cannot fetch cart items.');
//       return [];
//     }
//   }

//   Future<void> addToCart(Map<String, dynamic> itemData, int quantityChange) async {
//     final user = _auth.currentUser;

//     try {
//       if (user != null) {
//         final existingCartItem = await _firestore
//             .collection('users')
//             .doc(user.uid)
//             .collection('GroceriesCart')
//             .doc(itemData['id'])
//             .get();

//         if (existingCartItem.exists) {
//           final currentQuantity = existingCartItem.data()!['quantity'] ?? 0;
//           await _firestore
//               .collection('users')
//               .doc(user.uid)
//               .collection('GroceriesCart')
//               .doc(itemData['id'])
//               .update({
//             'quantity': currentQuantity + quantityChange,
//           });
//         } else {
//           await _firestore
//               .collection('users')
//               .doc(user.uid)
//               .collection('GroceriesCart')
//               .doc(itemData['id'])
//               .set({
//             'itemname': itemData['title'],
//             'itemimage': itemData['image'],
//             'itemprice': itemData['price'],
//             'quantity': quantityChange,
//             'timestamp': FieldValue.serverTimestamp(),
//           });
//         }

//         print('Item added to cart successfully!');
//         notifyListeners(); // Notify listeners of the change
//       } else {
//         print('User is not authenticated. Cannot add to cart.');
//       }
//     } catch (e) {
//       print('Error adding item to cart: $e');
//     }
//   }

//   // Add the removeItem and clearCart methods here

//   double calculateTotalPrice() {
//     double totalPrice = 0;
//     for (final cartItem in _cartItems) {
//       totalPrice +=
//           (cartItem['itemprice'] ?? 0.0) * (cartItem['quantity'] ?? 0);
//     }
//     return totalPrice;
//   }

//   Future<void> fetchCartItems() async {
//     final user = _auth.currentUser;

//     if (user != null) {
//       try {
//         final snapshot = await _firestore
//             .collection('users')
//             .doc(user.uid)
//             .collection('GroceriesCart')
//             .get();

//         _cartItems = snapshot.docs.map((doc) => doc.data()).toList();

//         notifyListeners(); // Notify listeners of the change
//       } catch (e) {
//         print('Error fetching cart items: $e');
//       }
//     } else {
//       print('User is not authenticated. Cannot fetch cart items.');
//     }
//   }
// }
