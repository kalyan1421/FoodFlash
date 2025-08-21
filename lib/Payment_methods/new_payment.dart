import 'package:flutter/material.dart';
import 'package:uber_eats/model/cart.dart';
import 'package:uber_eats/Payment_methods/cash_on_delivery.dart';

class upi_payment extends StatelessWidget {
  final double totalPrice;
  final double discountprice;
  final List<CartSavedItem> cartItems;

  const upi_payment({
    Key? key,
    required this.totalPrice,
    required this.discountprice,
    required this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Directly redirect to Cash on Delivery
    return CashOnDeliveryPayment(
      totalPrice: totalPrice,
      discountprice: discountprice,
      cartItems: cartItems,
    );
  }
}

// Placeholder for RazorpayDemo class
class RazorpayDemo extends StatefulWidget {
  @override
  _RazorpayDemoState createState() => _RazorpayDemoState();
}

class _RazorpayDemoState extends State<RazorpayDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Demo"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          'Payment Demo Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
