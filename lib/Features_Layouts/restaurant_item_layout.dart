import 'package:flutter/material.dart';
import '../data/Restaurants_items_data.dart';

class FourItemContainersLayout extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final BurgerKingItem rest_item;

  // ignore: non_constant_identifier_names
  const FourItemContainersLayout({super.key, required this.rest_item});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final Width = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    final Height = MediaQuery.of(context).size.height;
    return Container(
      width: Width / 1.5,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: Height / 3,
      child: Stack(alignment: AlignmentDirectional.topStart, children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(rest_item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 5,
          child: Text(rest_item.name.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        Positioned(
            top: 6,
            right: 6,
            child: Text(
              "\$${rest_item.price.toString()}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
      ]),
    );
  }
}
