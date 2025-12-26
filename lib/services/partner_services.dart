import 'package:odoo_task/constants/constants.dart';
import 'package:odoo_task/models/partners.dart';
import 'package:odoo_task/services/odoo_api_service.dart';

OdooApiService api = OdooApiService();
Future<List<Partner>> getPartners(int uId) async {
  final result = await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'res.partner',
      'search_read',
      [], // filter
      {
        'fields': ['id', 'name', 'email', 'phone', 'country_id'],
        'limit': 20,
      },
    ],
  );

  return (result as List)
      .map((e) => Partner.fromJson(e as Map<String, dynamic>))
      .toList();
}

//create always returns the new record ID
Future<int> createPartnerApi({
  required int uId, // auth
  // dto
  required String name,
  String? email,
  String? phone,
  int? countryId,
}) async {
  final result = await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'res.partner',
      'create',
      [
        {'name': name, 'email': email, 'phone': phone}, // values
      ],
    ],
  );

  return result is int ? result : 0;
}

Future<bool> updatePartnerApi({
  required int uId,
  required int partnerId,
  String? name,
  String? email,
  String? phone,
  int? countryId,
}) async {
  final result = await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'res.partner',
      'write',
      [
        [partnerId], // MUST be a list
        {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          if (countryId != null) 'country_id': countryId,
        },
      ],
    ],
  );

  return result == true;
}

Future<bool> deletePartnerApi({
  required int uId,
  required int partnerId,
}) async {
  final result = await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'res.partner',
      'unlink',
      [
        [partnerId], // MUST be a list
      ],
    ],
  );

  return result == true;
}
