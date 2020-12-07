import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pubgm_info/models/auth.dart';

enum authMode {
  signIn,
  signUp,
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  authMode currentAuthMode = authMode.signIn;
  var form = GlobalKey<FormState>();
  var userData = {"email": "", "password": ""};
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var tempPass = "";
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double height = 350;

  void toggleAuthMode() {
    setState(() {
      if (currentAuthMode == authMode.signIn) {
        setState(() {
          currentAuthMode = authMode.signUp;
          height = 450;
        });
      } else {
        setState(() {
          currentAuthMode = authMode.signIn;
          height = 350;
        });
      }
    });
  }

  String get authName {
    if (currentAuthMode == authMode.signIn) {
      return "Sign In";
    }
    return "Sign Up";
  }

  String get switchButtonName {
    if (currentAuthMode == authMode.signIn) {
      return "Sign Up";
    }
    return "Sign In";
  }

  bool isValid() {
    if (currentAuthMode == authMode.signIn) {
      return (passwordController.text.length >= 6) &&
          (emailController.text.contains("@"));
    }
    return passwordController.text == confirmPasswordController.text &&
        emailController.text.contains("@");
  }

  void saveForm() async {
    if (isValid()) {
      var authData = Provider.of<Auth>(context, listen: false);
      form.currentState.save();
      if (currentAuthMode == authMode.signUp) {
        var response =
            await authData.signUp(userData["email"], userData["password"]);
        if (response["status"]) {
          scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text("Sign Up Successful")));
          setState(() {
            currentAuthMode = authMode.signIn;
          });
        } else {
          if (response["other"]["message"] == "EMAIL_EXISTS") {
            scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Email already in use. Try Signing in")));
          } else if (response["other"]["message"] ==
              "TOO_MANY_ATTEMPTS_TRY_LATER") {
            scaffoldKey.currentState.showSnackBar(SnackBar(
                content:
                    Text("You are denied access due to unusual activity")));
          } else if (response["other"]["message"] == "INVALID_EMAIL") {
            scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text("Invalid Email")));
          }
        }
      } else {
        showDialog(
            context: context,
            builder: (ctx) => Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ));
        var response =
            await authData.signIn(userData["email"], userData["password"]);
        Navigator.of(context).pop();
        if (response["status"]) {
          scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text("Sign In Successful")));
        } else {
          if (response["other"]["message"] == "EMAIL_NOT_FOUND") {
            scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                    "No account is associated with this email. Try Signing up")));
          } else if (response["other"]["message"] == "INVALID_PASSWORD") {
            scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text("The password provided is invalid")));
          } else if (response["other"]["message"] == "USER_DISABLED") {
            scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("The account has been disabled by admin")));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.lightBlue[200],
                Colors.lightBlue[300],
                Colors.lightBlue[600],
                Colors.lightBlue[700],
                Colors.lightBlue[800],
                Colors.lightBlue[900],
                Colors.blue[900],
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
          ),
          AnimatedContainer(
            // height: currentAuthMode == authMode.signIn ? 350 : 450,
            duration: Duration(milliseconds: 600),
            curve: Curves.bounceInOut,
            width: 300,
            height: height,
            alignment: Alignment.center,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Colors.white,
              elevation: 20,
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: form,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            authName,
                            style: TextStyle(fontSize: 35),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter an email address";
                              }
                              if (!value.contains("@")) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              userData["email"] = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Password",
                            ),
                            validator: (value) {
                              if (value.length < 6) {
                                return "Passwords must be atleast six characters long";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              userData["password"] = value;
                            },
                          ),
                          currentAuthMode == authMode.signUp
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      onTap: () {
                                        tempPass = passwordController.text;
                                      },
                                      controller: confirmPasswordController,
                                      obscureText: true,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: "Confirm Password",
                                      ),
                                      validator: (value) {
                                        if (value != tempPass) {
                                          return "Both passwords do not match";
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {},
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              FlatButton(
                                  splashColor: Colors.blue[800],
                                  onPressed: toggleAuthMode,
                                  child: Text("$switchButtonName Instead")),
                              RaisedButton(
                                onPressed: saveForm,
                                //     () async{
                                //   if (isValid()) {
                                //     var authData = Provider.of<Auth>(context, listen: false);
                                //     form.currentState.save();
                                //     var response = await authData.signUp(userData["email"], userData["password"]);
                                //     if(response){
                                //       // Scaffold.of(context).showSnackBar(SnackBar(content: Text("Sign Up Successful")));
                                //       scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Sign up Successful")));
                                //     }
                                //   }
                                // },
                                child: Text(authName),
                                color: Colors.blue[800],
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
