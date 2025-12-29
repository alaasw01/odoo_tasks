import 'package:odoo_task/constants/constants.dart';
import 'package:odoo_task/models/invoices.dart';
import 'package:odoo_task/services/partner_services.dart';

Future<List<Invoice>> getInvoices(int uId) async {
  final result = await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'account.move',
      'search_read',
      [],
      {
        'fields': [
          'id',
          'name',
          'invoice_partner_display_name',
          'invoice_date',
          'amount_untaxed_in_currency_signed',
          'amount_total_in_currency_signed',
          'status_in_payment',
          'invoice_line_ids',
        ],
        'limit': 20,
      },
    ],
  );

  return (result as List)
      .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<List<InvoiceLine>> getInvoiceLinesApi({
  required int uId,
  required List<int> lineIds,
}) async {
  if (lineIds.isEmpty) return [];

  final result = await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'account.move.line',
      'search_read',
      [
        [
          [
            'id',
            'in',
            lineIds,
          ], // Give me all records where the id is inside the list lineIds
        ],
      ],
      {
        'fields': ['id', 'name', 'quantity', 'price_unit', 'price_subtotal'],
      },
    ],
  );

  return (result as List).map((e) => InvoiceLine.fromJson(e)).toList();
}

Future<void> confirmInvoiceApi({
  required int uId,
  required int invoiceId,
}) async {
  await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'account.move',
      'action_post',
      [
        [invoiceId],
      ],
    ],
  );
}

Future<void> resetInvoiceToDraftApi({
  required int uId,
  required int invoiceId,
}) async {
  await api.callRpc(
    service: 'object',
    method: 'execute_kw',
    args: [
      database,
      uId,
      password,
      'account.move',
      'button_draft',
      [
        [invoiceId],
      ],
    ],
  );
}
