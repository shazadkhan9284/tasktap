import 'package:catalog/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/user_model.dart';

class AssistantsMethods{
  static void readCurrentOnlineUsInfo() async{
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
    .ref()
    .child("user")
    .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentinfo = UserModel.fromSnapshot(snap.snapshot);

      }
    });
  }
}