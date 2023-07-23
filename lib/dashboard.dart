import 'package:assignment_magadh/createuser.dart';
import 'package:assignment_magadh/userdetailpage.dart';
import 'package:flutter/material.dart';
import 'loginpage2.dart';
import 'myprofile.dart';
import 'userservice.dart';

class DashboardScreenn extends StatefulWidget {
  final String token;
  final LUser userProfile;


  DashboardScreenn({required this.token, required this.userProfile});

  @override
  _DashboardScreennState createState() => _DashboardScreennState();
}

class _DashboardScreennState extends State<DashboardScreenn> {
  List<User> users = []; // List of users

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  // Function to fetch the user list from the API
  Future<void> _fetchUserList() async {
    try {
      final userList = await UserService.fetchUserList(widget.token);
      setState(() {
        users = userList;
      });
    } catch (e) {
      print('Error fetching user list: $e');
    }
  }

  User _convertToUser(NewUser newUser) {
    return User(
      id: newUser.id ?? '',
      name: newUser.name!,
      email: newUser.email!,
      latitude: newUser.latitude!,
      longitude: newUser.longitude!,
      phonenumber: newUser.phone,
      createdat: '', updatedat: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('User List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userProfile: widget.userProfile, token: widget.token),
                ),
              );
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: users.isEmpty
          ? Center(
        child: Text('No users found.'),
      )
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Icon(Icons.arrow_forward, color: Colors.teal,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailPage(user: user),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          final newUser = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationScreen(token: widget.token),
            ),
          );
          if (newUser != null) {
            final user = _convertToUser(newUser);

            setState(() {
              users.add(user);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}








