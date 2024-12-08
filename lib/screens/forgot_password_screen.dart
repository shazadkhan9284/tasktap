import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Constant/size.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final responsive = Responsive(context); // Create an instance of Responsive

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: responsive.getWidth(1),
            height: responsive.getHeight(1),
            child: Image.asset(
              "images/fgt.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: responsive.getHeight(0.35),
            left: responsive.getWidth(0.05),
            right: responsive.getWidth(0.05),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: widget._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: responsive.getWidth(0.10),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.yellow,
                      controller: widget.emailTextEditingController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: 'Enter your email',
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    /*TextFormField(
                      controller: widget.emailTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),*/

                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (widget._formKey.currentState!.validate()) {
                          // Add logic to send password reset email
                          _sendPasswordResetEmail(
                              widget.emailTextEditingController.text.trim());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        minimumSize: Size(responsive.getWidth(1.0),
                            responsive.getHeight(0.06)),
                      ),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.pushReplacement(context,
                    //         MaterialPageRoute(builder: (c) => LoginScreen()));
                    //   },
                    //   child: Text(
                    //     'Already have an Account ? Login',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w900,
                    //       color: Colors.black,
                    //       fontSize: 12.0,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendPasswordResetEmail(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      Fluttertoast.showToast(msg: "Password reset email sent successfully");
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Failed to send password reset email: $error");
    });
  }
}
