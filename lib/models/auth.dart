import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userEmail;
  String _refreshToken;
  String _expiry;
  String _userId;
  bool _isRegistered;
  bool triedAutoAuth = false;
  int _initCoins = 0;

  bool _currentAuthenticationStatus = false;

  bool get isAuthenticated {
    return _currentAuthenticationStatus;
  }

  String get userEmail {
    return _userEmail;
  }

  int get getCoins {
    return _initCoins;
  }

  Future restartAuthentication() async {
    if (!triedAutoAuth) {
      var restartPrefs = await SharedPreferences.getInstance();
      if (restartPrefs.containsKey("loggedUserData")) {
        var loggedUserData =
            jsonDecode(restartPrefs.getString("loggedUserData"));
        if (loggedUserData["isAuthenticated"]) {
          var tokenRefershUrl =
              "https://securetoken.googleapis.com/v1/token?key=AIzaSyD2ulylSD0eeWh9FnQeOe2lOOEGVvGUVbA";
          _refreshToken = loggedUserData["refreshToken"];
          var response = await http.post(tokenRefershUrl,
              body: jsonEncode({
                "grant_type": "refresh_token",
                "refresh_token": _refreshToken
              }));
          var decodedResponse = jsonDecode(response.body);
          _token = decodedResponse["access_token"];
          _userId = decodedResponse["user_id"];
          _refreshToken = decodedResponse["refresh_token"];
          _expiry = decodedResponse["expires_in"];
          _userEmail = loggedUserData["userEmail"];
          _currentAuthenticationStatus = true;
          triedAutoAuth = true;
          notifyListeners();
        }
      }
    }
  }

  Future<void> logOut() async {
    _token = "";
    _userEmail = "";
    _refreshToken = "";
    _expiry = "";
    _userId = "";
    _isRegistered = null;
    _currentAuthenticationStatus = false;
    var pref = await SharedPreferences.getInstance();
    var loggedUserData = jsonEncode({
      "isAuthenticated": _currentAuthenticationStatus,
      "userId": _userId,
      "refreshToken": _refreshToken
    });
    pref.setString("loggedUserData", loggedUserData);
    notifyListeners();
  }

  Future<Map> signUp(String email, String password) async {
    var url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD2ulylSD0eeWh9FnQeOe2lOOEGVvGUVbA";
    var response = await http
        .post(url,
            body: jsonEncode({
              "email": email,
              "password": password,
              "returnSecureToken": true
            }))
        .then((value) {
      var tempResp = jsonDecode(value.body);
      if (tempResp.keys.toList().contains("error")) {
        return {"status": false, "other": tempResp["error"]};
      }
      return {"status": true, "other": {}};
    });
    return response;
  }

  Future<Map> signIn(String email, String password) async {
    var url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD2ulylSD0eeWh9FnQeOe2lOOEGVvGUVbA";
    var response = await http
        .post(url,
            body: jsonEncode({
              "email": email,
              "password": password,
              "returnSecureToken": true
            }))
        .then((value) async {
      var response2 = jsonDecode(value.body);
      if (response2.keys.toList().contains("error")) {
        return {"status": false, "other": response2["error"]};
      }
      _token = response2["idToken"];
      _userEmail = response2["email"];
      _refreshToken = response2["refreshToken"];
      _expiry = response2["expiresIn"];
      _userId = response2["localId"];
      _isRegistered = response2["registered"];
      _currentAuthenticationStatus = true;
      var pref = await SharedPreferences.getInstance();
      var loggedUserData = jsonEncode({
        "isAuthenticated": _currentAuthenticationStatus,
        "userId": _userId,
        "refreshToken": _refreshToken,
        "userEmail": _userEmail
      });
      pref.setString("loggedUserData", loggedUserData);
      return {"status": true, "other": {}};
    });
    notifyListeners();
    return response;
  }
}
