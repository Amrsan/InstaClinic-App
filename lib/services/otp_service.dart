import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPService {
  static const String _baseUrl = 'https://apis.cequens.com/sms/v1';
  final String _apiKey;
  final String _senderId;

  OTPService({
    String apiKey = '090ebcac-232a-445e-b949-0b93d7d0f4b0',
    // Using Cequens default test sender ID
    String senderId = '20726'
  }) : _apiKey = apiKey,
       _senderId = senderId;

  Future<bool> sendOTP(String phoneNumber) async {
    try {
      // Generate a random 6-digit OTP code
      final otpCode = _generateOTP();
      
      // Format phone number to international format if needed
      final formattedPhone = phoneNumber.startsWith('+') ? phoneNumber : '+20$phoneNumber';
      
      // Print debug information
      print('Sending request to: $_baseUrl/messages');
      print('Using sender ID: $_senderId');
      print('Phone number: ${formattedPhone.replaceAll('+', '')}');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/messages'),
        headers: {
          'apikey': _apiKey,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'senderName': _senderId,
          'recipients': [formattedPhone.replaceAll('+', '')],
          'messageText': 'Your InstaClinics verification code is: $otpCode',
          'messageType': 'text',
          'acknowledgement': 1,
          'validityPeriod': 5,
          'flash': 0,
          'clientMessageId': DateTime.now().millisecondsSinceEpoch.toString(),
        }),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');
      print('Request Headers: ${response.request?.headers}');

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        // Store the OTP code for verification
        _storedOTP = otpCode;
        _storedPhoneNumber = formattedPhone;
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['replyMessage'] ?? errorData['message'] ?? response.body;
        throw Exception('Failed to send OTP: $errorMessage');
      }
    } catch (e) {
      print('Error details: $e'); // Debug log
      throw Exception('Error sending OTP: $e');
    }
  }

  // Store OTP temporarily for verification
  String? _storedOTP;
  String? _storedPhoneNumber;

  Future<bool> verifyOTP(String phoneNumber, String code) async {
    try {
      // Format phone number consistently
      final formattedPhone = phoneNumber.startsWith('+') ? phoneNumber : '+20$phoneNumber';
      
      if (_storedOTP == null || _storedPhoneNumber != formattedPhone) {
        throw Exception('OTP not found or expired');
      }

      final isVerified = _storedOTP == code;
      
      // Clear stored OTP after verification attempt
      _storedOTP = null;
      _storedPhoneNumber = null;

      return isVerified;
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }

  String _generateOTP() {
    // Generate a random 6-digit number
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = now.toString().substring(now.toString().length - 6);
    return random;
  }
} 