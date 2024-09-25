import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../Common/snackbar.dart';
import '../Config/shared_prif.dart';

class HttpService {


  //TODO
  static Future<dynamic> getRequest({required String url,required BuildContext context}) async {
    try {
      final result = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      final parse = jsonDecode(result.body);
      if (result.statusCode != 200) {

        snackbar(context, parse['message']);

        return null;
      }

      return parse;
    }on SocketException{
      snackbar;
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getWithHeaderRequest({required String url,Map<String,String>? headers, required BuildContext context}) async {
    try {
      final result = await http.get(Uri.parse(url),headers: headers).timeout(Duration(seconds: 15));
      print(result.statusCode);
      final parse = jsonDecode(result.body) ;
      if (result.statusCode == 200) {
        return parse;
      }else if(result.statusCode == 500){

        snackbar(context, "${result.statusCode} Server Error");

      }
      snackbar(context, parse['message']);


      //print(parse);
      return null;
    } on SocketException {
      // toast(context,"");
      throw const SocketException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', url);
    } on FetchDataException catch(e) {
      final String error = 'error caught: $e';
      //print(error);
      throw FetchDataException('FetchDataException', url);
    }catch (e) {
      return null;
    }
  }

  static Future<dynamic> postRequest<model>({required String url,required  body, Map<String,String>? headers,required BuildContext context}) async {
    try {

      final result = await http.post(Uri.parse(url),body: body,headers: headers);

      final parse = jsonDecode(result.body);

      if (result.statusCode == 200) {

        return parse;
      }else{

        snackbar(context, parse['message']);

        return null;
      }

    }on SocketException{
      snackbar(context,"Network error");
      return null;
    }catch (e) {
      return null;
    }
  }

}

//
//
class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url]) : super(message, 'Bad Request', url);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url]) : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url]) : super(message, 'Api not responded in time', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url]) : super(message, 'UnAuthorized request', url);
}



/// Single format for api calling



class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'ApiException: $message (Status code: $statusCode)';
  }
}

Future<dynamic> makeRequest(
    String endpoint, String method, Map<String, dynamic> body,
    {int timeoutInSeconds = 10,
      int retryCount = 3,
      bool isMultipart = false,
      List<http.MultipartFile>? files}) async {
  String token =
      SharedStorage.localStorage?.getString(SharedStorage.token) ?? "";


  // var headers = {
  //   'Authorization': 'Bearer $token',
  //   'Cookie': 'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'
  // };

  final headers = token.isEmpty
      ? {
    'Content-Type': isMultipart ? 'multipart/form-data' : 'application/json',
    'Cookie': 'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'

  } : {
    'Authorization': 'Bearer $token',
    'Content-Type':
    isMultipart ? 'multipart/form-data' : 'application/json',
    'Cookie': 'wordpress_logged_in_2d7fbb42f5498576f9870e84d2c1cf6a=kk%20test%7C1724666669%7C6dWXRMB2sFx7jKf54H2D5Fg23r277w47unCd5KBB8Sh%7Cbea0a0e236e3eb77bf942020308acd1d30b66ce732354c7aafaf858e04d0b873'

  };

  final jsonBody = jsonEncode(body);

  int retries = 0;

  while (retries < retryCount) {
    try {
      http.Response response;

      if (isMultipart &&
          (method.toUpperCase() == 'POST' || method.toUpperCase() == 'PUT')) {
        // Handle multipart request
        var request =
        http.MultipartRequest(method.toUpperCase(), Uri.parse(endpoint))
          ..headers.addAll(headers)
          ..fields.addAll(
              body.map((key, value) => MapEntry(key, value.toString())));

        if (files != null) {
          request.files.addAll(files);
        }

        var streamedResponse =
        await request.send().timeout(Duration(seconds: timeoutInSeconds));
        response = await http.Response.fromStream(streamedResponse);
      } else {
        switch (method.toUpperCase()) {
          case 'POST':
            response = await http
                .post(
              Uri.parse(endpoint),
              headers: headers,
              body: jsonBody,
            )
                .timeout(Duration(seconds: timeoutInSeconds));
            break;
          case 'PUT':
            response = await http
                .put(
              Uri.parse(endpoint),
              headers: headers,
              body: jsonBody,
            )
                .timeout(Duration(seconds: timeoutInSeconds));
            break;
          case 'PATCH':
            response = await http
                .patch(
              Uri.parse(endpoint),
              headers: headers,
              body: jsonBody,
            )
                .timeout(Duration(seconds: timeoutInSeconds));
            break;
          case 'DELETE':
            response = await http
                .delete(
              Uri.parse(endpoint),
              headers: headers,
            )
                .timeout(Duration(seconds: timeoutInSeconds));
            break;
          case 'GET':
          default:
            response = await http
                .get(
              Uri.parse(endpoint),
              headers: headers,
            )
                .timeout(Duration(seconds: timeoutInSeconds));
            break;
        }
      }

      // Handle successful responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        throw ApiException('Request failed with status: ${response.statusCode}',
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (e) {
      retries++;
      print('Request timed out. Retrying... ($retries/$retryCount)');
      if (retries >= retryCount) {
        throw ApiException(
            'Request timed out after $timeoutInSeconds seconds. Retries exhausted.');
      }
    } on http.ClientException catch (e) {
      throw ApiException('HTTP Client Exception: ${e.message}');
    } catch (e) {
      throw ApiException('Unexpected error occurred: $e');
    }
  }

  throw ApiException('Request failed after $retryCount attempts.');
}