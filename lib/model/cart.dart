import 'package:cloud_firestore/cloud_firestore.dart';

class CartSavedItem {
  final String itemId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  CartSavedItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory CartSavedItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartSavedItem(
      itemId: doc.id,
      name: data['itemname'] ?? '',
      price: (data['itemprice'] ?? 0.0).toDouble(),
      quantity: data['quantity'] ?? 0,
      imageUrl: data['itemimage'] ?? '',
    );
  }
}
