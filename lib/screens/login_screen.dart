import 'package:catalog/screens/register_screen.dart';
import 'package:catalog/splashScreen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Constant/size.dart';
import '../global/global.dart';
import 'forgot_password_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  bool _passwordVisible = false;

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        );

        final userRef = FirebaseFirestore.instance.collection("users");
        final snapshot = await userRef.doc(authResult.user!.uid).get();

        if (snapshot.exists) {
          await Fluttertoast.showToast(msg: "Successfully Logged In");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          await Fluttertoast.showToast(msg: "No record exists with this email");
          firebaseAuth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Error occurred: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context); // Create an instance of Responsive

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: responsive.getWidth(1),
              height: responsive.getHeight(1),
              child: Image.asset(
                darkTheme ? 'images/rbgl.png' : 'images/rbgl.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: responsive.getHeight(0.35),
              left: responsive.getWidth(0.05),
              right: responsive.getWidth(0.05),
              child: Padding(
                padding:EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: widget._formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                            height: responsive.getWidth(0.10),
                          ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email:",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextFormField(
                            style: TextStyle(
                              color: Colors.black
                            ),
                            cursorColor: Colors.yellow,
                            controller: widget.emailTextEditingController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email,color: Colors.grey,),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.getHeight(0.02)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password:",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextFormField(
                            style: TextStyle(
                              color: Colors.black
                            ),
                            cursorColor: Colors.yellow,
                            controller: widget.passwordTextEditingController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,color: Colors.grey,),
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'password',
                              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                            icon: Icon(widget._passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,color: Colors.grey,),
                            onPressed: () {
                              setState(() {
                                widget._passwordVisible = !widget._passwordVisible;
                              });
                            },
                          ),
                            ),
                            obscureText: !widget._passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            
                          ),
                          SizedBox(
                            height: responsive.getHeight(0.01),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                              onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (c) => ForgotPasswordScreen()));
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                      ),
                      SizedBox(height: responsive.getHeight(0.03)),
                      ElevatedButton(
                        onPressed: () {
                          widget._submit(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          minimumSize: Size(responsive.getWidth(1.0), responsive.getHeight(0.06)),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                        ),
                      ),
                      SizedBox(height: responsive.getHeight(0.01)),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("don't have an account?",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(width: 2,),
                        GestureDetector(
                          onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => RegisterScreen()));
                        },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w900,
                              color:Colors.yellow),
                          ),
                        ),
                      ],
                     )
                    ],
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
