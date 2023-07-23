import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'currentlocation.dart';
import 'loginpage2.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final LUser userProfile;
  final String token;

  ProfilePage({required this.userProfile, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;

  Future<void> _getImageFromCamera() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> _getImageFromGallery() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrentLocationScreen(),
                ),
              );
            },
            icon: Icon(Icons.camera_alt),
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[100],
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.blueGrey[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.teal, // Border color
                              width: 3.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey,
                            child: _imageFile != null
                                ? ClipOval(
                              child: Image.file(
                                File(_imageFile!.path),
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
                            )
                                : Image.asset(
                              'assets/images/profile.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Select Image'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.camera),
                                          title: Text('Take Photo'),
                                          onTap: () {
                                            _getImageFromCamera();
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo_library),
                                          title: Text('Choose from Gallery'),
                                          onTap: () {
                                            _getImageFromGallery();
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.camera_alt),
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    tileColor: Colors.white,
                    title: Text('Name',style: TextStyle(color: Colors.teal),),
                    subtitle: Text(widget.userProfile.name),
                  ),
                  Divider(),
                  ListTile(
                    tileColor: Colors.white,
                    title: Text('Email',style: TextStyle(color: Colors.teal),),
                    subtitle: Text(widget.userProfile.email),
                  ),
                  Divider(),
                  ListTile(
                    tileColor: Colors.white,
                    title: Text('ID',style: TextStyle(color: Colors.teal),),
                    subtitle: Text(widget.userProfile.id),
                  ),
                  Divider(),

                  ListTile(
                    tileColor: Colors.white,
                    title: Text('Latitude',style: TextStyle(color: Colors.teal),),
                    subtitle: Text(widget.userProfile.latitude.toString()),
                  ),

                  ListTile(
                    tileColor: Colors.white,
                    title: Text('Longitude',style: TextStyle(color: Colors.teal),),
                    subtitle: Text(widget.userProfile.longitude.toString()),
                  ),
                  Divider(),

                  ListTile(
                    tileColor: Colors.white,
                    title: Text('Phone',style: TextStyle(color: Colors.teal),),
                    subtitle: Text(widget.userProfile.phone),
                  ),
                  Divider(),

                  ListTile(
                    tileColor: Colors.white,
                    title: Text('Created At',style: TextStyle(color: Colors.teal),),
                    subtitle: Text(widget.userProfile.createdat),
                  ),
                  Divider(),

                  ListTile(
                    tileColor: Colors.white,
                    title: Text('Updated At',style: TextStyle(color: Colors.teal),),
                    subtitle: Text(widget.userProfile.updatedat),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
