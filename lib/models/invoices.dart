class Invoice {
  final int id;
  final String name;
  final String partnerName;
  final String? invoiceDate;
  final num untaxedAmount;
  final num totalAmount;
  final String paymentStatus;
  final List<int> lineIds;
  List<InvoiceLine>? lines;
  Invoice({
    required this.id,
    required this.name,
    required this.partnerName,
    required this.invoiceDate,
    required this.untaxedAmount,
    required this.totalAmount,
    required this.paymentStatus,
    required this.lineIds,
    this.lines,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      name: json['name'] ?? '',
      partnerName: json['invoice_partner_display_name'] ?? '',
      invoiceDate: json['invoice_date'],
      untaxedAmount: json['amount_untaxed_in_currency_signed'],
      totalAmount: json['amount_total_in_currency_signed'],
      paymentStatus: json['status_in_payment'] ?? '',
      lineIds: List<int>.from(json['invoice_line_ids'] ?? []),
    );
  }
}

class InvoiceLine {
  final int id;
  final String name;
  final num quantity;
  final num priceUnit;
  final num subtotal;

  InvoiceLine({
    required this.id,
    required this.name,
    required this.quantity,
    required this.priceUnit,
    required this.subtotal,
  });

  factory InvoiceLine.fromJson(Map<String, dynamic> json) {
    return InvoiceLine(
      id: json['id'],
      name: json['name'] ?? '',
      quantity: json['quantity'],
      priceUnit: json['price_unit'],
      subtotal: json['price_subtotal'],
    );
  }
}
