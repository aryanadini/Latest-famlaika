import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://www.famlaika.com';
  String? accessToken;
  Future<void> handle403Error(BuildContext context) async {
    // Handle the 403 error by redirecting to login or showing an appropriate message
    // For example:
    print('403 Forbidden - Redirecting to login');

    // Show a dialog or snackbar message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Expired'),
          content: Text('Your session has expired. Please log in again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Redirect to the login page
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }




  Future<Map<String, dynamic>> generateOtp(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/generate_otp?mobile=$phoneNumber');
    print('Generate OTP for $phoneNumber at $url');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('OTP generated successfully for $phoneNumber');
        return json.decode(response.body);
      } else if (response.statusCode == 422) {
        return {
          'error': 'Invalid phone number format or other validation error'
        };
      } else if (response.statusCode == 405) {
        return {'error': 'Method Not Allowed'};
      } else {
        throw Exception('Failed to generate OTP: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to generate OTP: $error');
      throw Exception('Failed to generate OTP: $error');
    }
  }

  Future<http.Response> post(String endpoint,
      {required String body, required Map<String, String> headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = authService.getAccessToken();
    final combinedHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      ...headers,
    };
    print('POST request to $url with body: $body');
    return await http.post(url, headers: combinedHeaders, body: body);



  }
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await authService.getAccessToken();
    final combinedHeaders = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      if (headers != null) ...headers,
    };
    print('GET request to $url');
    try {
      final response = await http.get(url, headers: combinedHeaders);

      if (response.statusCode == 200) {
        print('GET response from $url: ${response.statusCode}');
        return json.decode(response.body);
      } else {
        // Handle non-200 responses
        print('Failed to fetch data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw Exception('Error fetching data: $error');
    }
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final url = Uri.parse('$baseUrl/profile');
    final token = await AuthService().getAccessToken();

    if (token == null) {
      print('No access token available for fetching profile.');
      throw Exception('No access token available');
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('Fetching profile from $url');
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('Profile fetched successfully.');
        final data = jsonDecode(response.body);
        return data['data']; // Adjust based on API response structure
      } else {
        final errorResponse = jsonDecode(response.body);

        throw Exception('Failed to fetch profile: ${errorResponse['detail']}');
      }
    } catch (error) {

      throw Exception('Failed to fetch profile: $error');
    }
  }

  Future<List<dynamic>> fetchSentRequests() async {
    final url = Uri.parse('$baseUrl/sent_requests');
    final token = await AuthService().getAccessToken();
    if (token == null) {
      print('No access token available for fetching sent requests.');
      throw Exception('No access token available');
    }
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('Fetching sent requests from $url');
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('Sent requests fetched successfully.');
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        return data;
      } else {
        final errorResponse = jsonDecode(response.body);
        print('Failed to fetch sent requests: ${errorResponse['detail']}');
        throw Exception('Failed to fetch sent requests: ${errorResponse['detail']}');
      }
    } catch (error) {
      print('Failed to fetch sent requests: $error');
      throw Exception('Failed to fetch sent requests: $error');
    }
  }

  Future<List<dynamic>>  fetchRequests() async {
    final url = Uri.parse('$baseUrl/received_requests');
    final token = await AuthService().getAccessToken();

    if (token == null) {
      print('No access token available for fetching profile.');
      throw Exception('No access token available');
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('Fetching profile from $url');
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('Profile fetched successfully.');
        final data = jsonDecode(response.body);
        return data['data']; // Adjust based on API response structure
      } else {
        final errorResponse = jsonDecode(response.body);

        throw Exception('Failed to load requests: ${errorResponse['detail']}');
      }
    } catch (error) {

      throw Exception('Failed to load requests: $error');
    }
  }




  Future<void> uploadProfilePhoto(File image) async {
    if (!image.existsSync()) {
      throw Exception('File does not exist');
    }
    final url = Uri.parse('$baseUrl/profile_photo');
    final mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';
    final mediaType = MediaType.parse(mimeType);

    final request = http.MultipartRequest('POST', url)
      ..headers['Accept'] = 'application/json'
      ..headers['Content-Type'] = 'multipart/form-data'
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
          contentType: mediaType, // Adjust based on image type
        ),
      );

    // Add the authentication token if available
    final token = await AuthService().getAccessToken(); // Assuming AuthService handles token storage
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    } else {
      print('No access token available.');
      throw Exception('No access token available');
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Handle success
        print('Profile photo updated successfully.');
        return;
      } else {
        // Handle error
        final errorResponse = jsonDecode(responseBody);
        print('Error: ${errorResponse['detail']}');
        throw Exception('Error: ${errorResponse['detail']}');
      }
    } catch (error) {
      print('Failed to update profile photo: $error');
      throw error;
    }
  }
    Future<bool> updateProfile(String fullName, String gender,
        String dateOfBirth, {required String accessToken}) async {
      final accessToken = await authService.getAccessToken();
      if (accessToken == null) {
        // Handle case where token is not available
        print('Access token is missing.');
        return false;
      }
      String? formattedDate;
      if (dateOfBirth.isNotEmpty) {
        try {
          // Ensure the date is in the correct format
          DateFormat inputFormat = DateFormat('dd/MM/yyyy');
          DateTime parsedDate = inputFormat.parse(dateOfBirth);
         // DateFormat outputFormat = DateFormat('yyyy-MM-dd');
          formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate); // Convert to yyyy-MM-dd format
        } catch (e) {
          print('Error parsing date: $e');
          return false;
        }
      }

      // Construct the URL with query parameters
      final queryParameters = {
        'name': fullName,
        'gender': gender,
        if (formattedDate != null) 'date_of_birth': formattedDate,
      };
      // Construct the URL with query parameters
      final url = Uri.parse(
          '$baseUrl/profile').replace(queryParameters: queryParameters);

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      print('Updating profile at $url with data: $queryParameters');
      try{
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        print('Profile updated successfully.');
        return true;
        // Navigate to the next page

      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    }catch (error) {
        print('Failed to update profile: $error');
        return false;
      }
    }

  static Future<Map<String, dynamic>> addMember({
    required String name,
    required int gender,
    required int relation,
    required String mobile,
    required String dateOfBirth,
    required bool noMobile,
     File? profilePhoto,
    required String accessToken,
  }) async {
    final accessToken = await authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token is null');
    }
    try {
      final queryParameters = {
        'name': name,
        'gender': gender.toString(),
        'relation': relation.toString(),
        'mobile': mobile,
        'no_mobile': noMobile ? '1' : '0',
      };
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        queryParameters['date_of_birth'] = dateOfBirth;
      }
      final uri = Uri.parse('$baseUrl/members').replace(queryParameters: queryParameters);
      print('Request URI: $uri');
      print('Request URI: $uri');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $accessToken';

      if (profilePhoto != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_photo', profilePhoto.path));
      } else {
        // Optionally, if your server expects the key to be present even if null,
        // you can add a key with an empty value
        request.fields['profile_photo'] = ''; // Optional if the server requires the key to be present
      }


      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseData');

      if (response.statusCode == 200) {
        return {'status': 200, 'message': 'Relation added successfully',
          'data': responseData
        };
        //final responseData = await response.stream.bytesToString();
        // return json.decode(responseData);
      } else {
        final responseData  = await response.stream.bytesToString();
        print('Error Status Code: ${response.statusCode}');
        print('Response Body: $responseData');
        return {
          'status': response.statusCode,
          'message': 'Failed to add member',
          'data': response.reasonPhrase
        };
      }
    } catch (e) {
      return {'status': 500, 'message': 'Error occurred', 'data': e.toString()};
    }
  }
  static Future<void> acceptRequest(String requestId, String relationId,String status) async {
    final url = Uri.parse('$baseUrl/accept_requests/$requestId?relation_id=$relationId');
    final accessToken = await authService.getAccessToken();
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('Request accepted successfully');
    } else {
      throw Exception('Failed to accept request');
    }
  }

  static Future<bool> deleteRequest(int relation_id) async {
    final url = '$baseUrl/delete_requests/$relation_id';
    final accessToken = await authService.getAccessToken();
   try{
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // Replace with actual token
      },
    );
    if (response.statusCode == 200) {
      return true;

      print('Member deleted successfully!');
    } else {
      print('Failed to delete member. Status code: ${response.statusCode}');
      return false; // Indicate failure
    }
  }catch(error){
  print('Error during API call: $error');
  return false;
  }


  }

  Future<List<Map<String, dynamic>>> fetchFamilyTree({String? userId}) async {
    final token = await AuthService().getAccessToken();

    // Build the URL with user_id if provided
    final url = Uri.parse('$baseUrl/tree').replace(queryParameters: {
      if (userId != null) 'user_id': userId,
    });
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load family tree');
    }
  }



  }



