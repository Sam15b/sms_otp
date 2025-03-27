import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://192.168.29.217:3000/api/";

  Future<Map<String, dynamic>> sendOtp(String phoneNo) async {
    print(phoneNo);
    print("${baseUrl}send-otp");
    final url =
        Uri.parse('${baseUrl}send-otp'); // assuming the endpoint is /sendOtp
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNo}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'msg': 'Failed to send OTP. Please try again later.'
        };
      }
    } catch (e) {
      return {'success': false, 'msg': 'Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(
            response.body); // This will catch the failure response message
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
