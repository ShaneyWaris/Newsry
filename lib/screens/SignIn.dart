import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_management_system/Constants.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = "";
  String password = "";
  bool isLoading = false;
  bool _isObsecuredText = true;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();


  late FocusNode _passwordfocusnode;
  @override
  void initState(){
    _passwordfocusnode = FocusNode();
    super.initState();
  }
  @override
  void dispose(){
    _passwordfocusnode.dispose();
    super.dispose();
  }


  // Alert Dialog to display some errors!
  Future<void> _alertDialogBuilder(what, value) async {
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$what"),
            content: Container(
              child: Text("$value"),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                  child: Text("Close Dialog"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 35, left: 35, right: 35, bottom: 20),
              child: Text(
                "Welcome to...\nNewsZilla",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black, letterSpacing: 2, wordSpacing: 10),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text("Your Personalized News App", style: TextStyle(fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
            ),

            Form(
              key: formkey,
              child: Column(
                children: [
                  // Email.
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (value) {
                        email = value;
                        print("Email = $email");
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value){
                        _passwordfocusnode.requestFocus();
                      },
                      autovalidate: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required"),
                        EmailValidator(errorText: "Invalid Email!")
                      ]),
                      style: Constants.regularDarkText,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,),
                          focusColor: Color(0xFFF2F2F2),
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 20.0,
                          )),
                    ),
                  ),
                  // Password.
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      onChanged: (value) {
                        password = value;
                        print("Password = $password");
                      },
                      obscureText: _isObsecuredText,
                      focusNode: _passwordfocusnode,
                      autovalidate: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required"),
                        MinLengthValidator(6,
                            errorText: "Minimum 6 characters!"),
                        MaxLengthValidator(15,
                            errorText: "Maximum 15 characters!"),
                      ]),
                      style: Constants.regularDarkText,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,),
                          suffixIcon: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              splashColor: Colors.grey,
                              onTap: (){
                                setState(() {
                                  _isObsecuredText = _isObsecuredText? false : true;
                                });
                              },
                              child: _isObsecuredText? Icon(Icons.visibility_off): Icon(Icons.visibility,),
                          ),
                          focusColor: Color(0xFFF2F2F2),
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 20.0,
                          )),
                    ),
                  ),
                  // Login Button.
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: MaterialButton(
                      elevation: 10,
                      disabledElevation: 0,
                      splashColor: Colors.white,
                      color: Colors.black,
                      height: 65,
                      minWidth: 360,
                      padding: EdgeInsets.all(15),
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          print("Validated!");
                          setState(() {
                            isLoading = true;
                          });

                          print("come!");

                          // firbase start
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                            // take the email and extract the username of that user here too!
                            Navigator.pushNamed(context, '/HomePage');
                            await _alertDialogBuilder("Great!", "You have succesfully logged in!");
                          }
                          on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              _alertDialogBuilder("Error:", 'No user found for that email.');
                            }
                            else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              _alertDialogBuilder("Error:", 'Wrong password provided for that user.');
                            }
                          }

                          setState(() {
                            isLoading = false;
                          });

                        } else {
                          print("Not Validated!");
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [

                          Visibility(
                              visible: isLoading,
                              child: Center(child: CircularProgressIndicator(color: Colors.white,))
                          ),

                          Visibility(
                            visible: isLoading? false : true,
                            child: Center(
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Create a New Acccount.
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
              child: MaterialButton(
                elevation: 10,
                disabledElevation: 0,
                splashColor: Colors.black,
                color: Colors.white,
                height: 65,
                minWidth: 360,
                padding: EdgeInsets.all(15),
                onPressed: () {
                  Navigator.pushNamed(context, '/SignUp');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(width: 1.0, color: Colors.black)),
                child: Text(
                  "Create a New Account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
