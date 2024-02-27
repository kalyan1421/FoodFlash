// ignore: depend_on_referenced_packages

// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/groceries_provider.dart';
import 'package:uber_eats/Provider/user_provider.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';
import 'package:uber_eats/Utils/no_internetPage.dart';
import 'package:uber_eats/onboarding/onboarding.dart';
import 'dash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final status = Permission.location.request();
//   await FlutterConfig.loadEnvVariables();
//   await Firebase.initializeApp();
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     ),
//   );
//   await Future.delayed(const Duration(seconds: 3), () async {
//     if (await status.isGranted) {
//       runApp(const MyApp());
//     } else if (await status.isDenied) {
//       runApp(const MyApp());
//     } else if (await status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   });
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
// double _continerWidth = 0.0;

// @override
// void initState() {
//   super.initState();
//   Future.delayed(const Duration(seconds: 1), () {
//     setState(() {
//       _continerWidth = 230;
//     });
//   });
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               BounceIn(
//                 child: Text(
//                   "Food",
//                   style: GoogleFonts.carterOne(
//                     fontSize: 50,
//                     color: Colors.indigo,
//                   ),
//                 ),
//               ),
//               BounceIn(
//                 // Animation effect
//                 child: Text(
//                   " Flash",
//                   style: GoogleFonts.carterOne(
//                     fontSize: 50,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           AnimatedContainer(
//             duration: const Duration(seconds: 2),
//             curve: Curves.easeInOut,
//             height: 5,
//             width: _continerWidth,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.indigo),
//           ),
//         ],
//       ),
//     ),
//   );
//   }
// }

// // ignore: must_be_immutable
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => UserProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => GroceriesCart(),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.active) {
//               if (snapshot.hasData) {
//                 return const MyHomePage();
//               } else if (snapshot.hasError) {
//                 return Center(
//                   child: Text('${snapshot.hasError}'),
//                 );
//               }
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return (const Center(
//                 child: CircularProgressIndicator(color: Colors.black),
//               ));
//             }
//             return const login_page();
//           },
//         ),
//       ),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: OnboardingOverview(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkFirstSeen();
//   }

//   Future<void> _checkFirstSeen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool _seen = (prefs.getBool('seen') ?? false);

//     if (_seen) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => LoginScreen(),
//         ),
//       );
//     } else {
//       await prefs.setBool('seen', true);
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => OnboardingOverview(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FlutterLogo(size: 200),
//       ),
//     );
//   }
// }

///////////////////////////////////////

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await FlutterConfig.loadEnvVariables();
//   await Firebase.initializeApp();

//   final status = await Permission.location.request();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => UserProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => GroceriesCart(),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: SplashScreen(),
//       ),
//     ),
//   );
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );

//     _animation = Tween<double>(begin: 0, end: 230).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     _animationController.forward();

//     _navigate();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _navigate() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isFirstInstall = prefs.getBool('isFirstInstall') ?? true;

//     await Future.delayed(const Duration(seconds: 3)); // Delay for 3 seconds

//     if (isFirstInstall) {
//       prefs.setBool('isFirstInstall', false);
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => OnboardingOverview()),
//       );
//     } else {
//       if (FirebaseAuth.instance.currentUser != null) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => Hometest()),
//         );
//       } else {
//         if (await Permission.location.isGranted) {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (_) => login_page()),
//           );
//         } else if (await Permission.location.isDenied) {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (_) => login_page()),
//           );
//         } else if (await Permission.location.isPermanentlyDenied) {
//           openAppSettings();
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FadeTransition(
//                   opacity: _animationController,
//                   child: Text(
//                     "Food",
//                     style: GoogleFonts.carterOne(
//                       fontSize: 50,
//                       color: Colors.indigo,
//                     ),
//                   ),
//                 ),
//                 FadeTransition(
//                   opacity: _animationController,
//                   child: Text(
//                     " Flash",
//                     style: GoogleFonts.carterOne(
//                       fontSize: 50,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return Container(
//                   height: 5,
//                   width: _animation.value,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.indigo,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final status = await Permission.location.request();
//   var connectivityResult = await Connectivity().checkConnectivity();
//   Widget initialWidget;
//   if (connectivityResult == ConnectivityResult.none) {
//     initialWidget = NoInternetPage();
//   } else {
//     initialWidget = SplashScreen();
//   }

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//         ChangeNotifierProvider(create: (context) => GroceriesCart()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: initialWidget,
//       ),
//     ),
//   );
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final status = await Permission.location.request();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (context) => GroceriesCart()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _buildHomeScreen(),
    );
  }

Widget _buildHomeScreen() {
  switch (_connectionStatus) {
    case ConnectivityResult.none:
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 300,
                ),
                Center(
                  child: Lottie.asset("assets/utiles/Internet_loading.json", repeat: true),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'You are offline. Please check your internet connection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    case ConnectivityResult.mobile:
    case ConnectivityResult.wifi:
        return SplashScreen();
    default:
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/utiles/Internet_loading.json", repeat: true),
            const Center(
              child: Text(
                'Failed to determine connectivity status.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
  }
}

}
class ConnectivityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      initialData: ConnectivityResult.none,
      builder: (context, snapshot) {
        final connectivityResult = snapshot.data;
        if (connectivityResult == ConnectivityResult.none) {
          return NoInternetPage();
        } else {
          return SplashScreen();
        }
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _initializeAnimation();
    _navigate();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 230).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (await _isFirstInstall()) {
      _handleFirstInstall();
    } else {
      _handleNonFirstInstall();
    }
  }

  Future<bool> _isFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstInstall') ?? true;
  }

  void _handleFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstInstall', false);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingOverview()));
  }

  void _handleNonFirstInstall() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MyHomePage(selectindex: 0,)));
    }

    // if (FirebaseAuth.instance.currentUser == null) {
    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (_) => login_page()));
    // } 
    else {
      if (await Permission.location.isGranted ||
          await Permission.location.isDenied) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => login_page()));
      } else if (await Permission.location.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _animationController,
                  child: Text(
                    "Food",
                    style: GoogleFonts.carterOne(
                      fontSize: 50,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _animationController,
                  child: Text(
                    " Flash",
                    style: GoogleFonts.carterOne(
                      fontSize: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: 5,
                  width: _animation.value,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.indigo,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}