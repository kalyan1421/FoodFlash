import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/groceries_provider.dart';
import 'package:upi_india/upi_india.dart';

class Groceries_upi_payment extends StatefulWidget {
  Groceries_upi_payment({
    Key? key,
  }) : super(key: key);

  @override
  _Groceries_upi_paymentState createState() => _Groceries_upi_paymentState();
}

class _Groceries_upi_paymentState extends State<Groceries_upi_payment> {
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

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

  Future<UpiResponse> initiateTransaction(
      UpiApp app, double totalAmount) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId:
          "7396674546@axl", 
      receiverName: 'B Kalyan kumar',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: totalAmount,
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
                  final cartProvider =
                      Provider.of<GroceriesCart>(context, listen: false);
                  final totalAmount = cartProvider.GroceriesCalculateTotalPrice(
                      cartProvider.cartItems);

                  _transaction = initiateTransaction(app, totalAmount);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries UPI Payment'),
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
                      'Transaction Error: ${snapshot.error}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                if (snapshot.data != null) {
                  // Handle transaction status here.
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
