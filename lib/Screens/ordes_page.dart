// ignore_for_file: camel_case_types, unused_element
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class Orders_page extends StatefulWidget {
  const Orders_page({Key? key}) : super(key: key);

  @override
  State<Orders_page> createState() => _Orders_pageState();
}

class _Orders_pageState extends State<Orders_page> {
  List<double> ratings = [];

  String _getOrderTime(Timestamp timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      String formattedTime =
          DateFormat('dd MMM yyyy \'at\' hh:mm a').format(dateTime);
      return formattedTime;
    } else {
      return 'Unknown';
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('orders')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height - 117,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final orderDocument = snapshot.data!.docs[index];
                    final orderData =
                        orderDocument.data() as Map<String, dynamic>;
                    final orderItems = orderData['items'] as List<dynamic>;
                    ratings =
                        List<double>.filled(snapshot.data!.docs.length, 0.0);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey.shade300,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 2))
                            ]),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // SizedBox(width: 5),
                                        Text(
                                          "${orderItems[0]['item name']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.grey.shade300),
                                          width: 80,
                                          height: 30,
                                          child: Center(
                                            child: Text(
                                              "Delivered",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 2)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Quantity: ${orderItems[0]["quantity"].toString()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${_getOrderTime(orderData['timestamp'])}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          '₹${orderItems[0]["price"].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Rate",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.red),
                                        ),
                                        SizedBox(width: 5),
                                        RatingBar.builder(
                                          initialRating: ratings[index],
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 25,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star_border_purple500_rounded,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (value) {
                                            setState(() {
                                              ratings[index] = value;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );

          // },
          // );
        },
      ),
    );
  }
}
