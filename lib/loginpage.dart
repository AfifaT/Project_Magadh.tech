import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loginpage2.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();

  Future<void> _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = _phoneNumberController.text;
      final apiUrl = 'https://flutter.magadh.co/api/v1/users/login-request';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'phone': phoneNumber}),
        );


        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          final message = responseBody['message'];
          final otp = responseBody['otp'];

          // OTP sent successfully
          print(message);
          print('OTP: $otp');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPPage(phoneNumber: phoneNumber, receivedOTP: otp,),
            ),
          );
        } else {
          // OTP sending failed
          print('Failed to send OTP');
        }
      } catch (e) {
        print('Error sending OTP: $e');
      }
    }
  }


  @override
  void dispose() {
    _phoneNumberController.dispose();
    //_otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/reading-book.png',
              height: 150,
            ),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      prefixIcon: Icon(Icons.phone),fillColor: Colors.teal
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Phone number can only contain digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _sendOTP,
              child: Text('Send OTP'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}

