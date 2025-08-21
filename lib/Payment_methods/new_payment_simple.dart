import 'package:flutter/material.dart';
import 'package:uber_eats/model/cart.dart';

class upi_payment extends StatefulWidget {
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
  _upi_paymentState createState() => _upi_paymentState();
}

class _upi_paymentState extends State<upi_payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.payment,
                size: 80,
                color: Colors.orange,
              ),
              SizedBox(height: 20),
              Text(
                'Payment Options',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Total Amount: ₹${widget.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'UPI Payment temporarily unavailable',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Show payment options or redirect to alternative payment
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Payment feature will be available soon'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Continue with Alternative Payment',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
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
