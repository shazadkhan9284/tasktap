// // import 'package:firebase_database/firebase_database.dart';
// //
// // class UserModel{
// //   String? phone;
// //   String? name;
// //   String? id;
// //   String? email;
// //   String? address;
// //
// // UserModel({
// //   this.name,
// //   this.phone,
// //   this.email,
// //   this.id,
// //   this.address,
// // });
// // UserModel.fromsnapshot(DataSnapshot snap){
// //   phone =(snap.value as dynamic)["phone"];
// //   name =(snap.value as dynamic)["name"];
// //   id=snap.key;
// //   email =(snap.value as dynamic)["email"];
// //   address =(snap.value as dynamic)["address"];
// //
// // }
// // }
// // // userModel.dart
// //
// //
// //
// // userModel.dart
//
// import 'package:firebase_database/firebase_database.dart';
//
// class UserModel {
//   String? phone;
//   String? name;
//   String? id;
//   String? email;
//   String? address;
//   String? photoUrl; // Add this field
//
//   UserModel({
//     this.name,
//     this.phone,
//     this.email,
//     this.id,
//     this.address,
//     this.photoUrl, // Initialize the photoUrl field
//   });
//
//   UserModel.fromSnapshot(DataSnapshot snap) {
//     phone = (snap.value as dynamic)["phone"];
//     name = (snap.value as dynamic)["name"];
//     id = snap.key;
//     email = (snap.value as dynamic)["email"];
//     address = (snap.value as dynamic)["address"];
//     photoUrl = (snap.value as dynamic)["photoUrl"]; // Assign photoUrl from snapshot
//   }
//
//   // Add getter for photoUrl
//   String? getPhotoUrl() {
//     return photoUrl;
//   }
//
//   // Add setter for photoUrl
//   void setPhotoUrl(String? url) {
//     photoUrl = url;
//   }
// }
import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? phone;
  String? name;
  String? id;
  String? email;
  String? address;
  String? photoUrl; // Add this field

  UserModel({
    this.name,
    this.phone,
    this.email,
    this.id,
    this.address,
      this.photoUrl, // Initialize the photoUrl field
  });

  UserModel.fromSnapshot(DataSnapshot snap) {
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
    address = (snap.value as dynamic)["address"];
    photoUrl = (snap.value as dynamic)["photoUrl"]; // Assign photoUrl from snapshot
  }

  // Add getter for photoUrl
  String? getPhotoUrl() {
    return photoUrl;
  }

    // Add setter for photoUrl
    void setPhotoUrl(String? url) {
      photoUrl = url;
    }
}
