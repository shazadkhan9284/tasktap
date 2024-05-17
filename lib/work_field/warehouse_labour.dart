import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import '../screens/main_screen.dart';



class WharehouseLabourPage extends StatefulWidget {
  const WharehouseLabourPage({Key? key}) : super(key: key);

  @override
  _WharehouseLabourPage createState() => _WharehouseLabourPage();
}

class _WharehouseLabourPage extends State<WharehouseLabourPage> {
  final _formKey = GlobalKey<FormState>();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final fullAddressController = TextEditingController();
  final pincodeController = TextEditingController();
  final landmarkController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final paymentController = TextEditingController();
  String selectedTask = 'loading/unloading';
  late DateTime? selectedDate = null; // Initializing selectedDate to null
  final TimeOfDay selectedStartTime = TimeOfDay.now();
  late int selectedHours = 1;





  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }



  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get the currently authenticated user
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          String uid = currentUser.uid;

          // Convert selectedDate to Firestore Timestamp
          Timestamp selectedDateTimestamp = Timestamp.fromDate(selectedDate!);

          // Generate a unique taskId
          String taskId = FirebaseFirestore.instance.collection('task').doc().id;

          // Reference to the collection for the current user
          CollectionReference userCollRef =
          FirebaseFirestore.instance.collection('users').doc(uid).collection('user_work_data');

          // Data to be saved
          Map<String, dynamic> taskData = {
            'fullAddress': fullAddressController.text,
            'pincode': pincodeController.text,
            'landmark': landmarkController.text,
            'district': districtController.text,
            'state': stateController.text,
            'task': selectedTask,
            'phoneNumber': phoneTextEditingController.text,
            'selectedDate': selectedDateTimestamp,
            'selectedHours': selectedHours,
            'paymentAmount': paymentController.text,
            'userId': uid, // Add current user's ID
            'taskId': taskId, // Add the taskId within the same document
            'status': 'Pending', // Initial status set to 'pending'
          };

          // Save the data to Firestore under the task collection with the generated taskId
          await FirebaseFirestore.instance.collection('task').doc(taskId).set(taskData);

          // Save the same data to Firestore under the user's user_work_data collection with the same taskId
          await userCollRef.doc(taskId).set(taskData);

          // Show success message
          await Fluttertoast.showToast(msg: "Successfully Request Submitted");

          // Navigate back to the main screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => MainScreen()),
          );
        } else {
          Fluttertoast.showToast(msg: "User not logged in");
        }
      } catch (error) {
        // Show error message
        await Fluttertoast.showToast(msg: "Error occurred: $error");
      }
    } else {
      // Show validation error message
      Fluttertoast.showToast(msg: "Not all Fields are valid");
    }
  }




  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.yellow,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen())),
          ),
          title: Text(
            'Enter Wharehouse Labour Details ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xff928883),
        ),
        body: Stack(
          children: [
            // Background Image
            Image.asset(
              "images/bg.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      controller: fullAddressController,
                      decoration: InputDecoration(
                        labelText: 'Full Address',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full address';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                      controller: landmarkController,
                      decoration: InputDecoration(
                        labelText: 'Landmark',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter landmark';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: pincodeController,
                      keyboardType: TextInputType.number, // This restricts input to numeric only
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly // This ensures only digits are entered
                      ],
                      decoration: InputDecoration(
                        labelText: 'Pincode',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pincode';
                        } else if (value.length < 6) {
                          return 'Pincode should be at least 6 digits';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                      controller: districtController,
                      decoration: InputDecoration(
                        labelText: 'District',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter district';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                      controller: stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter State';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                      controller: phoneTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedTask,
                      onChanged: (value) {
                        setState(() {
                          selectedTask = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'packing',
                          child: Text('Packing'),
                        ),
                        DropdownMenuItem(
                          value: 'sorting',
                          child: Text('Sorting'),
                        ),
                        DropdownMenuItem(
                          value: 'loading/unloading',
                          child: Text('Loading/Unloading'),
                        ),
                        DropdownMenuItem(
                          value: 'cleaner',
                          child: Text('Cleaner'),
                        ),
                        DropdownMenuItem(
                          value: 'inventory management',
                          child: Text('Inventory Management'),
                        ),
                        // Add more tasks as needed
                      ],
                      decoration: InputDecoration(
                        labelText: 'Select Task',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                    ),


                    SizedBox(height: 10),
                    selectedDate == null
                        ? ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                    )
                        : Text(
                      'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: selectedHours,
                      onChanged: (value) {
                        setState(() {
                          selectedHours = value!;
                        });
                      },
                      items: List.generate(
                          8,
                              (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1} Hours'),
                          )),
                      decoration: InputDecoration(
                        labelText: 'Total Hours',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: paymentController,
                      decoration: InputDecoration(
                        labelText: 'Amount Paying',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Paying Amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
