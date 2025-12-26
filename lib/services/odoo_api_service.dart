import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:odoo_task/constants/constants.dart';

class OdooApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<dynamic> callRpc({
    required String service,
    required String method,
    required List args,
  }) async {
    final response = await dio.post(
      '/jsonrpc',
      data: {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {"service": service, "method": method, "args": args},
        "id": DateTime.now().millisecondsSinceEpoch,
      },
    );

    if (response.data['error'] != null) {
      debugPrint(response.data['error']['message']);
    }

    return response.data['result'];
  }

  Future<int> authenticate() async {
    final result = await callRpc(
      service: 'common',
      method: 'authenticate',
      args: [database, username, password, {}],
    );
    return result is int ? result : 0;
  }
}
