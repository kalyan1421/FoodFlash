import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uber_eats/Provider/groceries_provider.dart';
import 'package:uber_eats/Provider/user_provider.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'dash_screen.dart';
import 'package:flutter_config/flutter_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final status = Permission.location.request();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),  
    ),
  );
  await Future.delayed(const Duration(seconds: 3), () async {
    if (await status.isGranted) {
      runApp(const MyApp());
    } else if (await status.isDenied) {
      runApp(const MyApp());
    } else if (await status.isPermanentlyDenied) {
      openAppSettings();
    }
  });
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _continerWidth = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _continerWidth = 230;
      });
    });
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
                BounceIn(
                  child: Text(
                    "Uber",
                    style: GoogleFonts.carterOne(
                      fontSize: 50,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                BounceIn(
                  // Animation effect
                  child: Text(
                    " Eats",
                    style: GoogleFonts.carterOne(
                      fontSize: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              height: 5,
              width: _continerWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GroceriesCart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const MyHomePage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.hasError}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return (const Center(
                child: CircularProgressIndicator(color: Colors.black),
              ));
            }
            return const login_page();
          },
        ),
      ),
    );
  }
}
