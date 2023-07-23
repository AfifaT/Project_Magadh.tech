import 'package:flutter/material.dart';
import 'userservice.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  UserDetailPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.teal,
      ),
      body: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.blueGrey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Name'),
                subtitle: Text(user.name),
              ),
              ListTile(
                title: Text('Email'),
                subtitle: Text(user.email),
              ),
              ListTile(
                title: Text('Id:'),
                subtitle: Text(user.id),
              ),
              ListTile(
                title: Text('Phone number'),
                subtitle: Text(user.phonenumber as String),
              ),
              ListTile(
                title: Text('Latitude'),
                subtitle: Text(user.latitude.toString()),
              ),
              ListTile(
                title: Text('Longitude'),
                subtitle: Text(user.longitude.toString()),
              ),
              ListTile(
                title: Text('Created At:'),
                subtitle: Text(user.createdat.toString()),
              ),
              ListTile(
                title: Text('Updated At:'),
                subtitle: Text(user.updatedat.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
