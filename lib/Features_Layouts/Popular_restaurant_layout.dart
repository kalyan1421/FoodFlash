// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:uber_eats/data/Popular_restaurants_data.dart';


class Popular extends StatelessWidget {
  
  // ignore: non_constant_identifier_names
  final Popular_ItemData popular_itemData;


  // ignore: non_constant_identifier_names
  const Popular({super.key, required this.popular_itemData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Image.network(
          popular_itemData.imageUrl,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
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
                    popular_itemData.rating.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            padding: const  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(136, 77, 77, 77),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(popular_itemData.title.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.alarm_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 0,
                        ),
                        Text(
                          popular_itemData.text,
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      popular_itemData.time,
                      style: const  TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
