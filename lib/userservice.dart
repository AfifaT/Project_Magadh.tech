import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String? phonenumber;
  final String? createdat;
  final String? updatedat;
  final num latitude;
  final num longitude;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phonenumber,
    required this.latitude,
    required this.longitude,
    required this.createdat,
    required this.updatedat,
  });
}

class UserService {
  static Future<List<User>> fetchUserList(String token) async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final userList = (responseBody['users'] as List<dynamic>)
            .map((userJson) => User(
          id: userJson['_id'],
          name: userJson['name'],
          email: userJson['email'],
          phonenumber: userJson['phone'],
          latitude: userJson['location']['latitude'],
          longitude: userJson['location']['longitude'],
          createdat: userJson['createdAt'],
          updatedat: userJson['updatedAt']
        ))
            .toList();
        return userList;
      } else {
        throw Exception('Failed to fetch user list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
