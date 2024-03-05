import 'package:cloud_firestore/cloud_firestore.dart';

class CartSavedItem {
  final String itemId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String vegnoo;
  final double addonprice;
  final String weight;
  final String Restauranname;
  final String restaurantloaction;
  final String restaurantlatitude;
  final String restaurantlongtude;

  CartSavedItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.vegnoo,
    required this.addonprice,
    required this.weight,
    required this.Restauranname,
    required this.restaurantloaction,
    required this.restaurantlatitude,
    required this.restaurantlongtude,
  });

  factory CartSavedItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartSavedItem(
      itemId: doc.id,
      name: data['itemname'] ?? '',
      price: (data['itemprice'] ?? 0.0).toDouble(),
      quantity: data['quantity'] ?? 0,
      imageUrl: data['itemimage'] ?? '',
      vegnoo: data['vegnon'] ?? '',
      addonprice: (data['totalPrice'] ?? 0.0).toDouble(),
      weight: data['weight'] ?? '',
      Restauranname: data['Restauranname'] ?? '',
      restaurantloaction: data['restaurantloaction'],
      restaurantlatitude: data['restaurantlatitude'],
      restaurantlongtude: data['restaurantlongtude'],
    );
  }
}

class GroceriesCartItem {
  final String itemId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String weight;

  GroceriesCartItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.weight,
  });

  factory GroceriesCartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroceriesCartItem(
      itemId: doc.id,
      name: data['itemname'] ?? '',
      price: (data['itemprice'] ?? 0.0).toDouble(),
      quantity: data['quantity'] ?? 0,
      imageUrl: data['itemimage'] ?? '',
      weight: data['weight'],
    );
  }
}
