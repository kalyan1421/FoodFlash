// ignore_for_file: file_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_eats/Auth/UI/SignUp_UI.dart';

import '../../Utils/utils.dart';
import '../../dash_screen.dart';
import '../Auth_Methods/auth_methods.dart';

// ignore: camel_case_types
class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

// ignore: camel_case_types
class _login_pageState extends State<login_page> {
  bool _islooading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  // ignore: non_constant_identifier_names
  Future<bool> Login__User() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showCustomSnackBar(context, "Please fill all fields");
      return false;
    }

    if (!_isDisposed) {
      setState(() {
        _islooading = true;
      });
    }

    String res = await Authmethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (!_isDisposed) {
      setState(() {
        _islooading = false;
      });
    }

    if (res == "Success") {
      // Password is correct
      return true;
    } else {
      // Password is incorrect
      if (!_isDisposed) {
        showCustomSnackBar(context, "Incorrect username or password");
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          const SizedBox(
            height: 200,
          ),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Foodie",
                        style: GoogleFonts.carterOne(
                            fontSize: 40, color: Colors.blue)),
                    Text(
                      " Flash",
                      style: GoogleFonts.carterOne(
                          fontSize: 40, color: Colors.black),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  width: 200,
                  height: 5,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email ",
                      style: GoogleFonts.alegreyaSansSc(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 218, 212, 212)
                                .withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 5,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: "Enter Your Email",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Password ",
                      style: GoogleFonts.alegreyaSansSc(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 218, 212, 212)
                                .withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 5,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Enter your password",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          bool success = await Login__User();
                          if (success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                    // cart: Cart(),
                                    ),
                              ),
                            );
                          }
                        },
                        child: _islooading
                            ? Container(
                                width: 400,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black),
                                child: const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                )),
                              )
                            : Container(
                                width: 400,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.alegreyaSansSc(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp_UI()));
                        },
                        child: Text(
                          "Create a account?  signup",
                          style: GoogleFonts.alegreyaSans(
                              color: Colors.black, fontSize: 20),
                        ),
                      ),
                    )
                  ])),
        ])));
  }
}
