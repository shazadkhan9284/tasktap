// Import required packages
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global.dart';

import 'forgot_password_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  File? _image; // Initialize to null
  final picker = ImagePicker();
  late FirebaseFirestore firestore;
  late SharedPreferences prefs;
  late String? photoUrl; // Variable to store photo URL

  @override
  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    initPrefs(); // Call initPrefs before fetchUserData
    fetchUserData();
  }


  // Initialize shared preferences
  // Initialize shared preferences
  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    setState(() {
      _image = File(imagePath!);
    });
    }


  // Fetch user data from Firestore
  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        DocumentReference userDocRef = firestore.collection('users').doc(uid);

        DocumentSnapshot snapshot = await userDocRef.get();

        if (snapshot.exists) {
          // Only initialize text controllers if data exists
          setState(() {
            nameTextEditingController.text = snapshot['name'];
            phoneTextEditingController.text = snapshot['phone'];
            addressTextEditingController.text = snapshot['address'];
            photoUrl = snapshot['photoUrl']; // Get photo URL from Firestore
            userModelCurrentinfo?.setPhotoUrl(photoUrl); // Set photoUrl in UserModel instance
          });
        }
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }


  // Update user profile
  // Inside _ProfileScreenState class

  Future<void> updateUserProfile() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;

        DocumentReference userDocRef = firestore.collection('users').doc(uid);

        // Initialize variables for the photo URL and user folder
        String photoUrl = '';
        String userFolder = 'user_photos/$uid'; // Folder name with user's UID

        // If image is selected, upload to Firebase Storage
        if (_image != null) {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference ref = FirebaseStorage.instance.ref().child('$userFolder/$fileName');
          UploadTask uploadTask = ref.putFile(_image!);
          await uploadTask.whenComplete(() async {
            photoUrl = await ref.getDownloadURL();
          });
        }

        // Update user data in Firestore
        await userDocRef.update({
          'name': nameTextEditingController.text.trim(),
          'phone': phoneTextEditingController.text.trim(),
          'address': addressTextEditingController.text.trim(),
          'photoUrl': photoUrl, // Set the photoUrl field
        });

        // Update the photoUrl field in the current user's UserModel instance
        userModelCurrentinfo?.photoUrl = photoUrl;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (error) {
      print("Error updating user profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update profile. Please try again later.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  // Select image from gallery
  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        prefs.setString('imagePath', pickedFile.path); // Save image path in shared preferences
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Pop the current route
            },
          ),
          backgroundColor: Color(0xff928883),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20), // Adjust the padding to reduce the size
                          width: 170, // Specify a smaller width for the container
                          height: 170, // Specify a smaller height for the container
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: _image == null
                              ? userModelCurrentinfo?.photoUrl != null
                              ? Image.network(userModelCurrentinfo!.photoUrl!, fit: BoxFit.cover)
                              : Icon(Icons.person, color: Colors.black)
                              : ClipOval(
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),

                        ),
                        SizedBox(height: 10),
                        Text(
                          'Upload Photo ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: nameTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.black), // Label text color
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Focused border color
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Action when edit icon is pressed
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phoneTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: Colors.black), // Label text color
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Focused border color
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Action when edit icon is pressed
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: addressTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(color: Colors.black), // Label text color
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow), // Focused border color
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Action when edit icon is pressed
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (c) => ForgotPasswordScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button color
                    ),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      updateUserProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Button color
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xff928883),
      ),
    );
  }
}
