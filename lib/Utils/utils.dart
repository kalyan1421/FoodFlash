import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


const String GOOGLE_MAPS_API_KEY= "AIzaSyBHgv6qWJ_ADWU9jTNcKa5vMpThbfAlgns";
showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

// ignore: non_constant_identifier_names
void show_AlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Alert"),
        content: const Text("Now this Feature is not Avaiable"),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

void showCustomSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.indigo.shade600,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'UNDO',
      disabledTextColor: Colors.white,
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

List<Color> colorizeColors = [
  const Color.fromARGB(210, 233, 199, 10),
  Colors.yellow,
  Colors.indigo,
  const Color.fromARGB(255, 80, 131, 233)
];

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String locationInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getLocationInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getLocationInfo() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address = '${placemark.subLocality}';
        setState(() {
          locationInfo = address;
        });
      } else {
        setState(() {
          locationInfo = 'Address not found';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        locationInfo = 'Error fetching location data: \n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      locationInfo,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

class location_insta extends StatefulWidget {
  const location_insta({super.key});

  @override
  State<location_insta> createState() => _location_instaState();
}

class _location_instaState extends State<location_insta> {
  String locationInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getLocationInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getLocationInfo() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}';
        setState(() {
          locationInfo = address;
        });
      } else {
        setState(() {
          locationInfo = 'Address not found';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        locationInfo = 'Error fetching location data ';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Image.asset(
              "assets/Location_cross_icon.png",
              scale: 20,
            ),
            // const Icon(
            // Icons.location_on_rounded,
            // color: Colors.red,
            // size: 40,
            // ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text("Home",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Icon(Icons.keyboard_arrow_down_sharp)
                  ],
                ),
                Text(locationInfo)
                // location()
              ],
            ),
          ],
        ),
        Expanded(child: SizedBox()),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            width: 50,
            // height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/utiles/profile_ani.png"),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
