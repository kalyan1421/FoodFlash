import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';
import 'package:sign_button/sign_button.dart';
import 'package:uber_eats/Add_address/pick_address.dart';
import 'package:uber_eats/dash_screen.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
  FocusNode _phoneNumberFocusNode = FocusNode();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _codeSending = false;
  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      _codeSending = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          print("Automatic verification completed");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification Failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code Sent");
          // Reset _codeSending to false when code is sent
          setState(() {
            _codeSending = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerification(
                verificationId: verificationId,
                phoneNumber: "$phoneNumber",
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code Auto Retrieval Timeout");
        },
      );
    } catch (e) {
      print("Error during phone number verification: $e");
      setState(() {
        _codeSending = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final userExists = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get()
          .then((doc) => doc.exists);

      if (userExists) {
        print("userExits");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Dash_board(selectindex: 0)));
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': userCredential.user!.email,
        'username': userCredential.user!.displayName,
        'photoURL': userCredential.user!.photoURL,
        "uid": userCredential.user!.uid
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PickLocation(),
        ),
      );
    } on Exception catch (e) {
      print('exception->$e');
      print("object");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height * 0.1,
                //   child: Lottie.asset(
                //     'assets/onboarding_images/Login_Animation.json',
                //     fit: BoxFit.cover,
                //   ),
                // ),
                SizedBox(height: 50),
                Center(
                  child: Image.asset(
                    "assets/onboarding_images/Login_vector.jpg",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.30,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Almost There!",
                  style: TextStyle(
                      fontFamily: 'Quicksand-Bold',
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  " Please sign in to continue",
                  style: TextStyle(
                      fontFamily: 'Quicksand-SemiBold',
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  "Mobile number",
                  style: TextStyle(
                      fontFamily: 'Quicksand-SemiBold',
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    maxLength: 10,
                    cursorColor: Colors.purple,
                    controller: _phoneNumberController,
                    focusNode: _phoneNumberFocusNode,
                    style: const TextStyle(
                      fontFamily: 'Quicksand-SemiBold',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onFieldSubmitted: (value) {
                      if (value.length == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter mobile number'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (value.length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                ' Mobile number must be at least 10 digits'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (_phoneNumberController.text.length == 10) {
                        String stringphoneNumber =
                            _phoneNumberController.text.trim();
                        String phoneNumber =
                            '+${selectedCountry.phoneCode}$stringphoneNumber';
                        _verifyPhoneNumber(phoneNumber);
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        _phoneNumberController.text = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "10 digit mobile number",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 550,
                              ),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              },
                            );
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: _phoneNumberController.text.length > 9
                          ? Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      if (value.length < 10) {
                        return 'Phone number must be at least 10 digits';
                      }
                      return null; // Return null if the validation is successful
                    },
                  ),
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      if (_phoneNumberController.text.length == 10) {
                        String stringphoneNumber =
                            _phoneNumberController.text.trim();
                        String phoneNumber =
                            '+${selectedCountry.phoneCode}$stringphoneNumber';
                        _verifyPhoneNumber(phoneNumber);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Phone number must be at least 10 digits'),
                            duration: Duration(
                                seconds: 2), // Adjust duration as needed
                          ),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 55,
                      child: _codeSending
                          ? CircularProgressIndicator() // Show loading indicator if _codeSending is true
                          : Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Quicksand-Bold",
                                  fontWeight: FontWeight.w500),
                            ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(1, 5),
                                spreadRadius: 3,
                                blurRadius: 10,
                                color: Colors.grey.shade300)
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                    alignment: Alignment.center,
                    child: Text("Or sign in with ")),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignInButton.mini(
                        buttonSize: ButtonSize.large,
                        buttonType: ButtonType.google,
                        onPressed: () {
                          signInWithGoogle();
                        }),
                    // SignInButton.mini(
                    //     buttonSize: ButtonSize.large,
                    //     buttonType: ButtonType.mail,
                    //     btnColor: Colors.white,
                    //     onPressed: () {
                    //       Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => SignUp_UI(),
                    //       ),
                    //     );
                    //     }),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "By clicking, I accept the ",
                      style: TextStyle(
                        fontFamily: 'MonaSans',
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Terms and conditions & Privacy policy",
                        style: TextStyle(
                            fontFamily: 'MonaSans',
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpVerification extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OtpVerification({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool codeVerify = false;

  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = Duration(seconds: 15);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft -= Duration(seconds: 1);
        } else {
          _timer.cancel();
          // Enable the resend button and change its color to green
          setState(() {
            _resendButtonEnabled = true;
          });
        }
      });
    });
  }

  bool _resendButtonEnabled = false;

  Future<void> _resendOtp() async {
    _timeLeft = Duration(seconds: 15);
    setState(() {
      _resendButtonEnabled = false;
    });
    _startTimer();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Error resending OTP: $e");
    }
  }

  // Function to sign in with credential
  Future<void> _signInWithCredential(String verificationId, String code) async {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    try {
      setState(() {
        codeVerify = true;
      });
      UserCredential authResult = await _auth.signInWithCredential(credential);
      final userExists = await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .get()
          .then((doc) => doc.exists);
      if (userExists) {
        print("User exists");
        setState(() {
          codeVerify = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Dash_board(selectindex: 0)));
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'phoneNumber': widget.phoneNumber,
        'email': "",
        "username": "",
        "photoURL": "",
        "uid": authResult.user!.uid
      });
      setState(() {
        codeVerify = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PickLocation()),
      );
    } catch (e) {
      setState(() {
        controller.clear();
        codeVerify = false;
      });
      print("Error verifying phone number: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect code. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const length = 6;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Colors.white;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Verify your details",
                  style: TextStyle(
                      fontFamily: 'Quicksand-Bold',
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 20),
              // Phone number display
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(
                      "Enter OTP sent to ",
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "${widget.phoneNumber} ",
                      style: TextStyle(
                          fontFamily: 'Quicksand-Bold',
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "via SMS",
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Enter OTP label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Enter OTP",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 68,
                child: Pinput(
                  length: length,
                  controller: controller,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  // Callback when pin is completed
                  onCompleted: (pin) {
                    print(pin);
                    String verificationId = widget.verificationId;
                    _signInWithCredential(verificationId, pin);
                  },
                  onSubmitted: (pin) {
                    if (pin.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter OTP'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (pin.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter full OTP'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  // Focused pin theme
                  focusedPinTheme: defaultPinTheme.copyWith(
                    height: 68,
                    width: 64,
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                  // Error pin theme
                  errorPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  autofocus: true,
                ),
              ),
              SizedBox(height: 15),
              // Resend OTP option
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(
                      "Didn't receive OTP? ",
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: _resendButtonEnabled ? _resendOtp : null,
                      child: Text(
                        "Resend",
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                            color: _resendButtonEnabled
                                ? Colors.green
                                : Colors
                                    .grey, // Change color based on button enable state
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      '${_timeLeft.inMinutes}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              // Verify & Continue Button
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    if (controller.text.isNotEmpty) {
                      String verificationId = widget.verificationId;
                      _signInWithCredential(verificationId, controller.text);
                    }
                    if (controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter OTP'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (controller.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter full OTP'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Code should be entered'),
                          duration:
                              Duration(seconds: 2), // Adjust duration as needed
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: BorderRadius.circular(10)),
                    child: codeVerify
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Verify & Continue",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: "Quicksand-Bold",
                                fontWeight: FontWeight.w500),
                          ),
                    // decoration: BoxDecoration(
                    //     boxShadow: [
                    //       BoxShadow(
                    //           offset: Offset(1, 5),
                    //           spreadRadius: 3,
                    //           blurRadius: 10,
                    //           color: Colors.grey.shade300)
                    //     ],
                    //     borderRadius: BorderRadius.circular(15),
                    //     color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              )
            ],
          ),
        ),
      ),
    );
  }
}
