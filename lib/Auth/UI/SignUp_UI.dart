// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:uber_eats/Auth/Auth_Methods/auth_methods.dart';
import 'package:uber_eats/Auth/UI/Login_UI.dart';
import 'package:uber_eats/Utils/utils.dart';

import '../../dash_screen.dart';

// ignore: camel_case_types
class SignUp_UI extends StatefulWidget {
  const SignUp_UI({super.key});

  @override
  State<SignUp_UI> createState() => _SignUp_UIState();
}

// ignore: camel_case_types
class _SignUp_UIState extends State<SignUp_UI> {
  bool _islooading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  Future<bool> signUpUser() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      showCustomSnackBar(context, "Please fill all fields.");
      return false;
    }
    setState(() {
      _islooading = true;
    });
    String res = await Authmethods().SignupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text);
    setState(() {
      _islooading = false;
    });
    return res == "Success";
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
            height: 120,
          ),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Uber",
                        style: GoogleFonts.carterOne(
                            fontSize: 40, color: Colors.blue)),
                    Text(" Eats",
                        style: GoogleFonts.carterOne(
                            fontSize: 40, color: Colors.black)),
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
                      "Usename ",
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
                          controller: _usernameController,
                          // obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Enter Your User name",
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
                          // obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "chosse your password",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          // signUpUser();
                          bool success = await signUpUser();
                          if (success) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(),
                              ),
                            );
                          } else {
                            showCustomSnackBar(context,
                                "Kindly validate the accuracy of the entered information.");
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
                                    "Sign up",
                                    style: GoogleFonts.alegreyaSansSc(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const login_page()));
                          },
                          child: Text('Already a User?  Login ',
                              style: GoogleFonts.alegreyaSans(
                                  color: Colors.black, fontSize: 20))),
                    )
                  ])),
        ])));
  }
}
