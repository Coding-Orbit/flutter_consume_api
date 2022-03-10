import 'package:flutter/cupertino.dart';
import 'package:flutter_consume_api/network/network_helper.dart';
import 'package:http/http.dart' as http;

enum RequestType { get, put, post }

class NetworkService{
  const NetworkService._();

  static Map<String, String> _getHeaders() => {
    'Content-Type': 'application/json',
  };


  static Future<http.Response>? _createRequest({
    required RequestType requestType,
    required Uri uri,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    }){
    if(requestType == RequestType.get){
      return http.get(uri, headers: headers);
    }
    return null;
  }

  static Future<http.Response?>? sendRequest({
    required RequestType requestType,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? queryParam,
  }) async {
    try{
      final _header = _getHeaders();
      final _url = NetworkHelper.concatUrlQP(url, queryParam);

      final response = await _createRequest(
          requestType: requestType,
          uri: Uri.parse(_url),
          headers: _header,
          body: body
      );

      debugPrint('Response : ${response?.headers}');

      return response;
    } catch (e){
      debugPrint('Error - $e');
      return null;
    }
  }
}