// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'main_screen.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Manpower Services',
//       home: OrdersPage(),
//     );
//   }
// }
//
// class OrdersPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     String? userId = FirebaseAuth.instance.currentUser?.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Orders Page',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Color(0xff928883),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (c) => MainScreen()));
//           },
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection('user_work_data')
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           // return ListView(
//           //   padding: EdgeInsets.all(16.0),
//           //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
//           //     Map<String, dynamic> data =
//           //     document.data() as Map<String, dynamic>;
//           //     DateTime? date = data['selectedDate'] != null
//           //         ? (data['selectedDate'] as Timestamp).toDate()
//           //         : null;
//           //     String formattedDate = date != null
//           //         ? DateFormat('yyyy-MM-dd').format(date)
//           //         : '';
//           //
//           //     return Card(
//           //       margin: EdgeInsets.symmetric(vertical: 8.0),
//           //       child: Padding(
//           //         padding: EdgeInsets.all(12.0),
//           //         child: Column(
//           //           crossAxisAlignment: CrossAxisAlignment.start,
//           //           children: [
//           //             Row(
//           //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //               children: [
//           //                 Text(
//           //                   'Work Details',
//           //                   style: TextStyle(
//           //                     fontSize: 18.0,
//           //                     fontWeight: FontWeight.bold,
//           //                   ),
//           //                 ),
//           //                 Text(
//           //                   'Status: ${data['status'] ?? 'Pending'}',
//           //                   style: TextStyle(
//           //                     fontSize: 16.0,
//           //                     fontWeight: FontWeight.bold,
//           //                   ),
//           //                 ),
//           //               ],
//           //             ),
//           //             SizedBox(height: 8.0),
//           //             Text('Address: ${data['fullAddress']}'),
//           //             Text('Landmark: ${data['landmark']}'),
//           //             Text('Pincode: ${data['pincode']}'),
//           //             Text('District: ${data['district']}'),
//           //             Text('State: ${data['state']}'),
//           //             Text('Task: ${data['task']}'),
//           //             Text('Phone Number: ${data['phoneNumber']}'),
//           //             Text('Hours: ${data['selectedHours']}'),
//           //             Text('Amount: ${data['paymentAmount']}'),
//           //             SizedBox(height: 8.0),
//           //             Text(
//           //               'Date: $formattedDate',
//           //               style: TextStyle(fontStyle: FontStyle.italic),
//           //             ),
//           //             SizedBox(height: 8.0),
//           //             ElevatedButton(
//           //               onPressed: () {
//           //                 _showCancelDialog(context, document, userId!);
//           //               },
//           //               child: Text('Cancel Task'),
//           //               style: ElevatedButton.styleFrom(
//           //                 backgroundColor: Colors.red,
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     );
//           //   }).toList(),
//           // );
//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//               DateTime? date = data['selectedDate'] != null
//                   ? (data['selectedDate'] as Timestamp).toDate()
//                   : null;
//               String formattedDate = date != null
//                   ? DateFormat('yyyy-MM-dd').format(date)
//                   : '';
//
//               // Extract partner's details
//               Map<String, dynamic>? partnerDetails = data['partnerDetails'];
//
//               return Card(
//                 margin: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Padding(
//                   padding: EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Work Details',
//                             style: TextStyle(
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             'Status: ${data['status'] ?? 'Pending'}',
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8.0),
//                       Text('Address: ${data['fullAddress']}'),
//                       Text('Landmark: ${data['landmark']}'),
//                       Text('Pincode: ${data['pincode']}'),
//                       Text('District: ${data['district']}'),
//                       Text('State: ${data['state']}'),
//                       Text('Task: ${data['task']}'),
//                       Text('Phone Number: ${data['phoneNumber']}'),
//                       Text('Hours: ${data['selectedHours']}'),
//                       Text('Amount: ${data['paymentAmount']}'),
//                       SizedBox(height: 8.0),
//                       Text(
//                         'Date: $formattedDate',
//                         style: TextStyle(fontStyle: FontStyle.italic),
//                       ),
//                       SizedBox(height: 8.0),
//                       // Display worker's details if available
//                       if (data.containsKey('workerName')) Text('Worker Name: ${data['workerName']}'),
//                       if (data.containsKey('workerPhone')) Text('Worker Phone: ${data['workerPhone']}'),
//                       if (data.containsKey('workerEmail')) Text('Worker Email: ${data['workerEmail']}'),
//                       SizedBox(height: 8.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           if (data['status'] != 'Completed') // Only show Cancel button if status is not Completed
//                             ElevatedButton(
//                               onPressed: () {
//                                 _showCancelDialog(context, document, userId!);
//                               },
//                               child: Text('Cancel Task'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                               ),
//                             ),
//                           if (data['status'] == 'accepted')
//                             ElevatedButton(
//                               onPressed: () {
//                                 _markAsCompleted(document, userId!);
//                               },
//                               child: Text('Complete Task'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//
//
//
//
//         },
//       ),
//       backgroundColor: Color(0xff928883),
//     );
//   }
//   void _markAsCompleted(DocumentSnapshot document, String userId) async {
//     try {
//       // Update status to 'Completed' in Firestore
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('user_work_data')
//           .doc(document.id)
//           .update({'status': 'Completed'});
//
//       Fluttertoast.showToast(
//         msg: "Task completed successfully",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//       );
//     } catch (error) {
//       // Show error message
//       Fluttertoast.showToast(
//         msg: "Error occurred: $error",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//       );
//     }
//   }
//
//
//   void _showCancelDialog(
//       BuildContext context, DocumentSnapshot document, String userId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Cancel Task'),
//           content: TextField(
//             decoration: InputDecoration(labelText: 'Reason for cancellation'),
//             onChanged: (value) {},
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Confirm'),
//               onPressed: () async {
//                 try {
//                   // Delete the task from the 'task' collection
//                   await FirebaseFirestore.instance
//                       .collection('task')
//                       .doc(document.id)
//                       .delete();
//
//                   // Delete the task from the 'user_work_data' collection
//                   await FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(userId)
//                       .collection('user_work_data')
//                       .doc(document.id)
//                       .delete();
//
//                   Fluttertoast.showToast(
//                     msg: "Task deleted successfully",
//                     toastLength: Toast.LENGTH_SHORT,
//                     gravity: ToastGravity.BOTTOM,
//                     backgroundColor: Colors.black,
//                     textColor: Colors.white,
//                   );
//                   Navigator.of(context).pop();
//                 } catch (error) {
//                   // Show error message
//                   Fluttertoast.showToast(
//                     msg: "Error occurred: $error",
//                     toastLength: Toast.LENGTH_SHORT,
//                     gravity: ToastGravity.BOTTOM,
//                     backgroundColor: Colors.black,
//                     textColor: Colors.white,
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
// }
import 'package:catalog/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manpower Services',
      home: OrdersPage(),
    );
  }
}

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String? _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff928883),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => MainScreen()));
          },
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter,
            items: [
              DropdownMenuItem(child: Text('All'), value: 'All'),
              DropdownMenuItem(child: Text('Pending'), value: 'Pending'),
              DropdownMenuItem(child: Text('accepted'), value: 'accepted'),
              DropdownMenuItem(child: Text('Completed'), value: 'Completed'),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('user_work_data')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Filter documents based on the selected status
          // Filter documents based on the selected status
          var filteredDocs = snapshot.data!.docs.where((doc) {
            var data = doc.data();
            if (data is Map<String, dynamic>) {
              if (_selectedFilter == 'All') {
                return true;
              } else {
                return data['status'] == _selectedFilter;
              }
            }
            return false;
          }).toList();


          return ListView(
            padding: EdgeInsets.all(16.0),
            children: filteredDocs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              DateTime? date = data['selectedDate'] != null
                  ? (data['selectedDate'] as Timestamp).toDate()
                  : null;
              String formattedDate = date != null
                  ? DateFormat('yyyy-MM-dd').format(date)
                  : '';

              // Extract partner's details
              Map<String, dynamic>? partnerDetails = data['partnerDetails'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Work Details',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Status: ${data['status'] ?? 'Pending'}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text('Address: ${data['fullAddress']}'),
                      Text('Landmark: ${data['landmark']}'),
                      Text('Pincode: ${data['pincode']}'),
                      Text('District: ${data['district']}'),
                      Text('State: ${data['state']}'),
                      Text('Task: ${data['task']}'),
                      Text('Phone Number: ${data['phoneNumber']}'),
                      Text('Hours: ${data['selectedHours']}'),
                      Text('Amount: ${data['paymentAmount']}'),
                      SizedBox(height: 8.0),
                      Text(
                        'Date: $formattedDate',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 8.0),
                      // Display worker's details if available
                      if (data.containsKey('workerName')) Text('Worker Name: ${data['workerName']}'),
                      if (data.containsKey('workerPhone'))
                        Row(
                          children: [
                            Text('Worker Phone: ${data['workerPhone']}'),
                            IconButton(
                              icon: Icon(Icons.phone),
                              onPressed: () async {
                                String workerPhoneNumber = 'tel:${data['workerPhone']}';
                                if (await canLaunch(workerPhoneNumber)) {
                                  await launch(workerPhoneNumber);
                                } else {
                                  throw 'Could not launch $workerPhoneNumber';
                                }
                              },
                            ),
                          ],
                        ),

                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (data['status'] != 'Completed') // Only show Cancel button if status is not Completed
                            ElevatedButton(
                              onPressed: () {
                                _showCancelDialog(context, document, userId!);
                              },
                              child: Text('Cancel Task'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          if (data['status'] == 'accepted')
                            ElevatedButton(
                              onPressed: () {
                                _markAsCompleted(document, userId!);
                              },
                              child: Text('Complete Task'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      backgroundColor: Color(0xff928883),
    );
  }

  void _markAsCompleted(DocumentSnapshot document, String userId) async {
    try {
      // Update status to 'Completed' in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('user_work_data')
          .doc(document.id)
          .update({'status': 'Completed'});

      // Show dialog to choose payment method
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose Payment Method'),
            content: Text('Please select your preferred payment method:'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate to cash payment screen
                  Fluttertoast.showToast(
                    msg: "Please pay the  Total Amount to the Partner",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.yellow,
                  );
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Cash Payment'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to digital payment screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DigitalPaymentScreen(),
                    ),
                  );

                },
                child: Text('Digital Payment'),
              ),
            ],
          );
        },
      );

      Fluttertoast.showToast(
        msg: "Task completed successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.yellow,
      );
    } catch (error) {
      // Show error message
      Fluttertoast.showToast(
        msg: "Error occurred: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }





  void _showCancelDialog(
      BuildContext context, DocumentSnapshot document, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Task'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Reason for cancellation'),
            onChanged: (value) {},
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                try {
                  // Delete the task from the 'task' collection
                  await FirebaseFirestore.instance
                      .collection('task')
                      .doc(document.id)
                      .delete();

                  // Delete the task from the 'user_work_data' collection
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('user_work_data')
                      .doc(document.id)
                      .delete();

                  Fluttertoast.showToast(
                    msg: "Task deleted successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  );
                  Navigator.of(context).pop();
                } catch (error) {
                  // Show error message
                  Fluttertoast.showToast(
                    msg: "Error occurred: $error",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
