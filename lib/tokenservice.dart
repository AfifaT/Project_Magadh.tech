import 'package:http/http.dart' as http;

class TokenService {
  static Future<bool> verifyToken(String token) async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users/verify-token';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
