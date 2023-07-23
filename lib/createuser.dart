import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dashboard.dart';
class RegistrationScreen extends StatefulWidget {
  final String token;
  RegistrationScreen({required this.token});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  final phoneRegex = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () => _registerButtonPressed(context),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerButtonPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;
      final latitude = int.parse(_latitudeController.text);
      final longitude = int.parse(_longitudeController.text);

      final apiUrl = 'https://flutter.magadh.co/api/v1/users';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
          body: json.encode({
            'name': name,
            'email': email,
            'phone': phone,
            'location': {
              'latitude': latitude,
              'longitude': longitude,
            },
          }),
        );
        print(response.statusCode);
        print('Token: ${widget.token}');

        if (response.statusCode == 200) {
          print('User created');
          final responseBody = json.decode(response.body);
          final newUser = NewUser(
            id: responseBody['user']['_id'],
            name: responseBody['user']['name'],
            email: responseBody['user']['email'],
            phone: responseBody['user']['phone'],
            latitude: responseBody['user']['location']['latitude'],
            longitude: responseBody['user']['location']['longitude'],
          );
          print('ID: ${newUser.id}');
          print('Name: ${newUser.name}');
          print('Email: ${newUser.email}');

          Navigator.pop(context, newUser);
        } else {
          print('Creating user unsuccessful: ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Error creating user: $e');
      }
    }
  }
}

class NewUser {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final int? latitude;
  final int? longitude;

  NewUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}
