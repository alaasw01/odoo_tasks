import 'package:odoo_task/constants/constants.dart';
import 'package:odoo_task/models/partners.dart';
import 'package:odoo_task/services/odoo_api_service.dart';

OdooApiService api = OdooApiService();
Future<List<Partner>> getInvoices(int uId) async {
  final result = await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'account.move',
      'search_read',
      [], // filter
      {
        'fields': [
          'id',
          'name',
          'invoice_partner_display_name',
          'invoice_date',
          'amount_untaxed_in_currency_signed',
          'invoice_line_ids',
          'amount_total_in_currency_signed',
          'status_in_payment',
        ],
        'limit': 20,
      },
    ],
  );

  return (result as List)
      .map((e) => Partner.fromJson(e as Map<String, dynamic>))
      .toList();
}
