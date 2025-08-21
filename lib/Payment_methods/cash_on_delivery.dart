import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/user_provider.dart';
import 'package:uber_eats/Tracking/order_traking.dart';
import 'package:uber_eats/model/cart.dart';

class CashOnDeliveryPayment extends StatefulWidget {
  final double totalPrice;
  final double discountprice;
  final List<CartSavedItem> cartItems;

  const CashOnDeliveryPayment({
    Key? key,
    required this.totalPrice,
    required this.discountprice,
    required this.cartItems,
  }) : super(key: key);

  @override
  _CashOnDeliveryPaymentState createState() => _CashOnDeliveryPaymentState();
}

class _CashOnDeliveryPaymentState extends State<CashOnDeliveryPayment> {
  bool _isProcessing = false;

  String generateOrderId() {
    return 'order_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _placeOrder() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await _saveOrderDetails();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to order tracking
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Order_tracking(),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _saveOrderDetails() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    try {
      final userId = userProvider.getUser?.uid ?? FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final String orderId = generateOrderId();
        final orderRef = firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .doc(orderId);

        final orderData = {
          'orderId': orderId,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending',
          'totalAmount': widget.totalPrice,
          'deliveryFee': 20,
          'paymentMethod': 'Cash on Delivery',
          'tax': 14,
          'discount': widget.discountprice,
          'items': widget.cartItems.map((item) {
            return {
              'itemName': item.name,
              'quantity': item.quantity,
              'price': item.price,
              'image': item.imageUrl,
              'itemId': item.itemId,
              'restaurantName': item.Restauranname,
              'restaurantLocation': item.restaurantloaction,
              'restaurantLatitude': item.restaurantlatitude,
              'restaurantLongitude': item.restaurantlongtude
            };
          }).toList(),
        };

        await orderRef.set(orderData);
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error saving order details: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash on Delivery'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal:', style: TextStyle(fontSize: 16)),
                        Text(
                          '₹${(widget.totalPrice - 20 - 14 + widget.discountprice).toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Fee:', style: TextStyle(fontSize: 16)),
                        Text('₹20.00', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tax & Fees:', style: TextStyle(fontSize: 16)),
                        Text('₹14.00', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    if (widget.discountprice > 0) ...[
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount:', style: TextStyle(fontSize: 16, color: Colors.green)),
                          Text(
                            '-₹${widget.discountprice.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                    Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${widget.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Payment Method Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.money,
                      size: 40,
                      color: Colors.green,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cash on Delivery',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pay when your order arrives',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            
            Spacer(),
            
            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Placing Order...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Place Order - ₹${widget.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Note
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange[800],
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please keep the exact amount ready for payment',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
