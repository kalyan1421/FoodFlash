// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../data/restarant_list_data.dart';

// ignore: camel_case_types
class Fav_Res extends StatelessWidget {
  // final ItemData itemData;

  const Fav_Res({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names, unused_local_variable
    late var Width = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names, unused_local_variable
    final Height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: 200, // Adjust the height according to your preference
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sampleData.length,
        itemBuilder: (context, index) {
          ItemData item = sampleData[index];
          return _buildRestaurantCard(item);
        },
      ),
    );
  }

  Widget _buildRestaurantCard(ItemData item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      width: 350,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(alignment: AlignmentDirectional.topStart, children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                width: 50,
                height: 25,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withOpacity(.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.alarm_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      item.text,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  item.time,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
