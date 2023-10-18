import 'package:uber_eats/Auth/Auth_Methods/auth_methods.dart';
import 'package:uber_eats/model/user.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final Authmethods _authmethods = Authmethods();

  User? get getUser => _user;

  Future<void> referhUser() async {
    User? user = await _authmethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
