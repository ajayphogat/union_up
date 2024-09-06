import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Common/snackbar.dart';

class HttpService {
  static serverError (error,context)=> showError(
      context:context,
      title: "Server Issue",
      description: "Unable Fetch Data with $error");

  static  networkError(context) => showError(
      context:context,
      title: "Internet Issue",
      description: "Please Check Network Connection");

  //TODO
  static Future<dynamic> getRequest({required String url,required BuildContext context}) async {
    try {
      final result = await http.get(Uri.parse(url));
      if (result.statusCode != 200) {
        serverError(result.statusCode,context);
        return null;
      }
      final parse = jsonDecode(result.body);
      //print(parse);
      return parse;
    }on SocketException{
      networkError;
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getWithHeaderRequest({required String url,Map<String,String>? headers, required BuildContext context}) async {
    try {
      final result = await http.get(Uri.parse(url),headers: headers);
      print(result.statusCode);
      if (result.statusCode == 200) {
        final parse = jsonDecode(result.body) ;

        return parse;
      }else if(result.statusCode == 500){
        serverError(result.statusCode, context,);
      }

      serverError("${result.statusCode} Server Error", context);
      //print(parse);
      return null;
    } on SocketException {
      networkError(context);
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
      print(body);
      print(headers);
      final result = await http.post(Uri.parse(url),body: body,headers: headers);
      print(result.statusCode);
      print(result.body);
      final parse = jsonDecode(result.body);
      print(parse['message']);

      if (result.statusCode == 200) {

        return parse;
      }else{
        serverError(parse['message'], context);
        return null;
      }

    }on SocketException{
      networkError;
      return null;
    }catch (e) {
      return null;
    }
  }
/*  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 201:
        var responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 400:
        throw BadRequestException(jsonDecode(response.body), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(jsonDecode(response.body), response.request!.url.toString());
      case 422:
        throw BadRequestException(jsonDecode(response.body), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException('Error occured with code : ${response.statusCode}', response.request!.url.toString());
    }
  }*/
}



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
