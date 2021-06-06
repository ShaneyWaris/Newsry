import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_management_system/Constants.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String username = "";
  String email = "";
  String password = "";
  bool isLoading = false;
  bool isObsecureText = true;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late FocusNode _passwordfocusnode;
  late FocusNode _emailfocusnode;

  @override
  void initState() {
    _passwordfocusnode = FocusNode();
    _emailfocusnode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordfocusnode.dispose();
    _emailfocusnode.dispose();
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
              padding: const EdgeInsets.all(35),
              child: Text(
                "Create a New Account!",
                style: Constants.boldHeading,
                textAlign: TextAlign.center,
              ),
            ),

            Form(
              key: formkey,
              child: Column(
                children: [
                  // Username
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        _emailfocusnode.requestFocus();
                      },
                      onChanged: (value) {
                        username = value;
                        print("username = $username");
                      },
                      autovalidate: true,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "Required & Must be Unique."),
                        LengthRangeValidator(
                            min: 3,
                            max: 25,
                            errorText:
                                "Atleast 3 & Atmost 25 characters only!"),
                      ]),
                      style: Constants.regularDarkText,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                          focusColor: Color(0xFFF2F2F2),
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          )),
                    ),
                  ),
                  // Email
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      focusNode: _emailfocusnode,
                      onFieldSubmitted: (value) {
                        _passwordfocusnode.requestFocus();
                      },
                      onChanged: (value) {
                        email = value;
                        print("Email = $email");
                      },
                      autovalidate: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required"),
                        EmailValidator(errorText: "Invalid Email!")
                      ]),
                      style: Constants.regularDarkText,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                          focusColor: Color(0xFFF2F2F2),
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          )),
                    ),
                  ),
                  // Password
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: isObsecureText,
                      onChanged: (value) {
                        password = value;
                        print("Password = $password");
                      },
                      focusNode: _passwordfocusnode,
                      // autovalidate: true,
                      autovalidateMode: AutovalidateMode.always,
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
                              isObsecureText = isObsecureText? false : true;
                            });
                            },
                            child: isObsecureText? Icon(Icons.visibility_off): Icon(Icons.visibility,),
                        ),
                          focusColor: Color(0xFFF2F2F2),
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          )),
                    ),
                  ),
                  // Create Account Button.
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
                          try {
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                            FirebaseAuth.instance.currentUser!.updateProfile(displayName: username);
                            await _alertDialogBuilder('Great!', 'Congratulations $username! Your account has been created & you are redirecting to your account directly!');
                            Navigator.pushNamed(context, '/HomePage');
                          }
                          on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                              _alertDialogBuilder('Error:', 'The password provided is too weak.');
                            }
                            else if (e.code == 'email-already-in-use') {
                              print('The account already exists for that email.');
                              _alertDialogBuilder('Error:', 'The account already exists for that email.');
                            }
                          }
                          catch (e) {
                            print(e);
                            _alertDialogBuilder('Error:', e);
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
                                "Create a New Account",
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
            // Back to login button.
            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
              child: MaterialButton(
                elevation: 10,
                disabledElevation: 0,
                splashColor: Colors.black,
                color: Colors.white,
                height: 65,
                minWidth: 360,
                padding: EdgeInsets.all(15),
                onPressed: () {
                  Navigator.pushNamed(context, '/SignIn');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(width: 1.0, color: Colors.black)),
                child: Text(
                  "<  Back To LogIn",
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
