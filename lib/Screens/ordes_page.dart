// ignore_for_file: camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/user_provider.dart';

class Orders_page extends StatefulWidget {
  const Orders_page({super.key});

  @override
  State<Orders_page> createState() => _Orders_pageState();
}

class _Orders_pageState extends State<Orders_page> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.getUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId) // Replace with the actual user ID
            .collection('orders')
            .orderBy('timestamp',
                descending: true) // Order by timestamp in descending order
            .limit(1) // Limit to the most recent order
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child:  Text('No orders found.'));
          }

          final orderDocument = snapshot.data!.docs.first;
          final orderData = orderDocument.data() as Map<String, dynamic>;
          final orderItems = orderData['items'] as List<dynamic>;

          return ListView.builder(
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              final item = orderItems[index];

              return ListTile(
                title: Text('${item['item name']}'),
                subtitle: Text(
                    'Quantity: ${item['quantity']} - Price: ${item['price']}'),
              );
            },
          );
        },
      ),
    );
  }
}
