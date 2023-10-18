// ignore_for_file: curly_braces_in_flow_control_structures, camel_case_types, library_private_types_in_public_api, prefer_const_constructors, unused_field, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Pages/Cart_page.dart';
import 'package:uber_eats/Provider/user_provider.dart';
import 'package:uber_eats/Tracking/order_traking.dart';
import 'package:uber_eats/model/cart.dart';
import 'package:upi_india/upi_india.dart';

class upi_payment extends StatefulWidget {
  final double totalPrice;
  final List<CartSavedItem> cartItems;

  const upi_payment({
    Key? key,
    required this.totalPrice,
    required this.cartItems,
  }) : super(key: key);

  @override
  _upi_paymentState createState() => _upi_paymentState();
}

class _upi_paymentState extends State<upi_payment> {
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  double _calculateTotalPrice(List<CartSavedItem> cartItems) {
    double totalPrice = 0;
    for (final cartItem in cartItems) {
      totalPrice += cartItem.price * cartItem.quantity;
    }
    return totalPrice;
  }

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    double totalAmount = _calculateTotalPrice(widget.cartItems);
    return _upiIndia.startTransaction(
      app: app,
      // receiverUpiId: "9676364171@paytm",
      receiverUpiId: "7396674546@axl",

      // receiverUpiId: "9398949407@paytm",
      receiverName: 'B Kalyan kumar',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: (totalAmount),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  void _handleTransactionStatus(String status) {
    // if (status == 'success') {
      if (status == 'failure') {
      saveOrderDetails().then((_) {
        Future.delayed(const Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Payment Successful'),
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Order_tracking(),
            ),
          );
        });
      });
    } else if (status == 'failure') {
      print("Payment Failed");

      Future.delayed(const Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment Failed'),
        ));
        Navigator.pop(context);
    
      });
    } else {
      print("Payment Error");

      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment akjvbavbaav Failed'),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CartScreen(),
          ),
        );
      });
    }
  }

  Future<void> saveOrderDetails() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    try {
      final userId = userProvider.getUser?.uid;

      if (userId != null) {
        final orderRef = firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .doc();

        final orderData = {
          'timestamp': FieldValue.serverTimestamp(),
          'totalAmount': widget.totalPrice,
          'items': widget.cartItems.map((item) {
            return {
              'item name': item.name,
              'quantity': item.quantity,
              'price': item.price,
            };
          }).toList(),
        };
        

        await orderRef.set(orderData);
      }
    } catch (e) {
      print('Error saving order details: $e');
    }
  }

  String _upiErrorHandler(dynamic error) {
    if (error is UpiIndiaAppNotInstalledException) {
      return 'Requested app not installed on device';
    } else if (error is UpiIndiaUserCancelledException) {
      return 'You cancelled the transaction';
    } else if (error is UpiIndiaNullResponseException) {
      return 'Requested app didn\'t return any response';
    } else if (error is UpiIndiaInvalidParametersException) {
      return 'Requested app cannot handle the transaction';
    } else {
      return 'An Unknown error has occurred';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          FutureBuilder(
            future: _transaction,
            builder:
                (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      _upiErrorHandler(snapshot.error.runtimeType),
                      style: header,
                    ),
                  );
                }

                if (snapshot.data != null) {
                  UpiResponse upiResponse = snapshot.data!;
                  String status = upiResponse.status ?? 'N/A';
                  Text(upiResponse.transactionId.toString());
                  _handleTransactionStatus(status);

                  // Rest of your code...
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text("");
            },
          )
        ],
      ),
    );
  }
}
