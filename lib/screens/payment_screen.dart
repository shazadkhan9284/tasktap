import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'orders_screen.dart';


class DigitalPaymentScreen extends StatefulWidget {
  @override
  _DigitalPaymentScreenState createState() => _DigitalPaymentScreenState();
}

class _DigitalPaymentScreenState extends State<DigitalPaymentScreen> {
  late Razorpay _razorpay;
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Payment succeeded
    print("Payment successful: ${response.paymentId}");
    // Trigger a rebuild of the widget after the delay
    setState(() {
      // Navigate to OrdersPage after delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrdersPage()),
      );
    });
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    print("Payment error: ${response.code} - ${response.message}");
    // You can add further actions here, like showing an error message to the user
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selected
    print("External wallet: ${response.walletName}");
    // You can add further actions here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Digital Payment',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xff928883),
      ),
      backgroundColor: Color(0xff928883), // Background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _startPayment,
            child: Text(
              'Initiate Payment',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ), // Text color
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
            ),
          ),
          SizedBox(height: 200),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/ttlogo.png',
                width: 100,
                height: 100,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MSK Enterprises Pvt Ltd',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'All rights reserved @2003',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Copyright © 2003 MSK Enterprises Pvt Ltd',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startPayment() {
    String amountText = _amountController.text.trim();
    if (amountText.isNotEmpty) {
      int amount = int.tryParse(amountText) ?? 0; // Parse amount to integer
      if (amount > 0) {
        var options = {
          'key': 'rzp_test_IMdfOwAhqdZqK1',
          'amount': amount * 100, // Amount in paise
          'name': 'TaskTap',
          'description': 'Payment for service',
          'prefill': {
            'contact': '9529629498', // User's phone number
            'email': 'shazad9284khan@gmail.com', // User's email
          },
          'external': {
            'wallets': ['paytm'] // Payment wallets
          }
        };

        try {
          _razorpay.open(options);
        } catch (e) {
          print(e.toString());
        }
      } else {
        // Show error message if amount is not valid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid amount.'),
          ),
        );
      }
    } else {
      // Show error message if amount is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the amount.'),
        ),
      );
    }
  }
}
