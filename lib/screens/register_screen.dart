import 'package:catalog/Constant/validator.dart';
import 'package:catalog/widgets/snackbar.dart';
import 'package:catalog/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constant/size.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      //registration logic here...
      try {
        final authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        );

        final currentUser = authResult.user;

        if (currentUser != null) {
          Map<String, dynamic> userMap = {
            "id": currentUser.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
            "role": "user",
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .set(userMap);
          showCustomSnackbar(context, "Registration successful!",
              isError: false);
          // await Fluttertoast.showToast(msg: "Successfully Registered");

          Navigator.push(
              context, MaterialPageRoute(builder: (c) => MainScreen()));
        }
      } catch (error) {
        // Fluttertoast.showToast(msg: "Error occurred: $error");
        showCustomSnackbar(context, "Registeration Failed!", isError: true);
      }
    } else {
      showCustomSnackbar(context, "Please fix the errors in the form.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context); // Create an instance of Responsive

    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(children: [
              Container(
                width: double.infinity,
                child: Image.asset(
                  darkTheme ? 'images/rbg.png' : 'images/rbg.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 250.0,
                left: 15.0,
                right: 15.0,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal:10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          txtColor: Colors.black,
                          controller: nameTextEditingController,
                          hintText: "Name",
                          validator: (value) => customValidator(
                            value: value,
                            fieldName: "Name",
                            minLength: 2,
                            maxLength: 40,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          txtColor: Colors.black,
                          controller: emailTextEditingController,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => customValidator(
                            value: value,
                            fieldName: "Email",
                            isEmail: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          txtColor: Colors.black,
                          controller: phoneTextEditingController,
                          hintText: "Phone Number",
                          keyboardType: TextInputType.phone,
                          validator: (value) => customValidator(
                            value: value,
                            fieldName: "Phone Number",
                            isPhone: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          txtColor: Colors.black,
                          controller: addressTextEditingController,
                          hintText: "Address",
                          // keyboardType: TextInputType.emailAddress,
                          validator: (value) => customValidator(
                            value: value,
                            fieldName: "Address",
                            isEmail: true,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          txtColor: Colors.black,
                          controller: passwordTextEditingController,
                          hintText: "Password",
                          obscureText:!_passwordVisible,
                          validator: (value) => customValidator(
                            value: value,
                            fieldName: "Password",
                            isPassword: true,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,color: Colors.grey,),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          txtColor: Colors.black,
                          controller: confirmTextEditingController,
                          hintText: "Confirm Password",
                          obscureText: !_confirmPasswordVisible,
                          validator: (value) {
                            if (value != passwordTextEditingController.text) {
                              return "Passwords do not match.";
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                              icon: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,color: Colors.grey,),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible = !_confirmPasswordVisible;
                                });
                              },
                            ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15.0),
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Register"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have account?',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => LoginScreen()));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                   decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.yellow),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}



/*
import 'package:catalog/screens/login_screen.dart';
import 'package:catalog/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Constant/size.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        );

        final currentUser = authResult.user;

        if (currentUser != null) {
          Map<String, dynamic> userMap = {
            "id": currentUser.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
            "role": "user",
          };

          await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set(userMap);

          await Fluttertoast.showToast(msg: "Successfully Registered");

          Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
        }
      } catch (error) {
        Fluttertoast.showToast(msg: "Error occurred: $error");
      }
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context); // Create an instance of Responsive

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                child: Image.asset(
                  darkTheme ? 'images/rbg.png' : 'images/rbg.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 250.0,
                left: 15.0,
                right: 15.0,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Name can\'t be empty';
                          }
                          if (text.length < 2) {
                            return 'Please enter a valid name';
                          }
                          if (text.length > 40) {
                            return 'Name can\'t be more than 40 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      
                      TextFormField(
                        controller: emailTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Email can\'t be empty';
                          }
                          if (!text.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: phoneTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Phone number can\'t be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: addressTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Address can\'t be empty';
                          }
                          return null;
                        },
                        maxLines: 2,
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: passwordTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Password can\'t be empty';
                          }
                          if (text.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: confirmTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Confirm Password can\'t be empty';
                          }
                          if (text != passwordTextEditingController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          minimumSize: Size(responsive.getWidth(1.0), responsive.getHeight(0.06)),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextButton(
                        child: Text(
                          'Have an account? Sign In',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/
