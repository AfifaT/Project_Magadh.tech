import 'dart:convert';
import 'package:assignment_magadh/tokenservice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';

class OTPPage extends StatefulWidget {
  final String phoneNumber;
  final int receivedOTP;


  const OTPPage({required this.phoneNumber, required this.receivedOTP});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  LUser? thisuser;


  Future<String?> _verifyLogin() async {
    if (_formKey.currentState!.validate()) {
      final enteredOTP = _otpController.text;
      final phoneNumber = widget.phoneNumber;
      final receivedOTP = widget.receivedOTP;
      final apiUrl = 'https://flutter.magadh.co/api/v1/users/login-verify';
      print('ReceivedOTP: $receivedOTP');
      print('EnteredOTP: $enteredOTP');

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'phone': phoneNumber, 'otp': enteredOTP}),
        );

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          final message = responseBody['message'];
          // Check if the message is "OTP verified"
          if (message == 'OTP verified') {
            final user = responseBody['user'] ;
            final token = responseBody['token'] as String;
            // OTP verification successful
            print('OTP verification successful');
            print('Entered OTP: $enteredOTP');
            print('User: $user');
            print('Token: $token');

            thisuser = LUser(
              id: user['_id'],
              name: user['name'],
              email: user['email'],
              latitude: user['location']['latitude'],
              longitude: user['location']['longitude'],
              phone: user['phone'],
              createdat: user['createdAt'],
              updatedat: user['updatedAt'],
            );

            return token;
          } else {
            // OTP verification failed
            print('OTP verification failed');
          }
        }
       else {
          // OTP verification failed
          print('OTP verification failed');
        }

      } catch (e) {
        print('Error verifying OTP: $e');
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
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
            Text(
              'Enter OTP sent to ${widget.phoneNumber}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  prefixIcon: Icon(Icons.lock),fillColor: Colors.teal
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  if (value.length != 6) {
                    return 'Please enter a valid 6-digit OTP';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
    try {
    final token = await _verifyLogin();
    print('Toke: $token');

    if (await TokenService.verifyToken(token!)) {
    print('Token verification successful');
      //var thisuser;
      Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => DashboardScreenn(token: token, userProfile: thisuser!,),
    ),
    );
    } else {
    throw Exception('Token verification failed');
    }
    } catch (e) {
    print('Error: $e');
    }
    },
              child: Text('Verify OTP'),
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
class LUser {
  final String id;
  final String name;
  final String email;
  final num latitude;
  final num longitude;
  final String phone;
  final String createdat;
  final String updatedat;

  LUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.createdat,
    required this.updatedat,
  });
}