import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_task/models/invoices.dart';
import 'package:odoo_task/services/invoices_api_services.dart';
import 'package:odoo_task/services/odoo_api_service.dart';
part 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  InvoicesCubit(this.api) : super(InvoicesInitial());
  final OdooApiService api;
  List<Invoice> invoices = [];
  int? uid;
  Future<void> fetchInvoices() async {
    try {
      emit(InvoicesLoading());

      uid = await api.authenticate();
      if (uid == 0) {
        debugPrint('Authentication failed');
      }
      invoices = await getInvoices(uid ?? 0);
      emit(InvoicesSuccess());
    } catch (e) {
      emit(InvoicesError(e.toString()));
    }
  }

  Future<void> fetchInvoiceLines(int invoiceIndex) async {
    try {
      final invoice = invoices[invoiceIndex];
      if (invoice.lines?.isNotEmpty == true) return;
      var lines = await getInvoiceLinesApi(uId: uid!, lineIds: invoice.lineIds);
      invoice.lines = lines;
      emit(InvoicesSuccess());
    } catch (e) {
      emit(InvoicesError(e.toString()));
    }
  }

  Future<void> confirmInvoice(int invoiceIndex) async {
    try {
      final invoice = invoices[invoiceIndex];

      await confirmInvoiceApi(uId: uid ?? 0, invoiceId: invoice.id);

      // refresh
      await fetchInvoices();
    } catch (e) {
      emit(InvoicesError(e.toString()));
    }
  }

  Future<void> resetToDraft(int invoiceIndex) async {
    try {
      final invoice = invoices[invoiceIndex];

      await resetInvoiceToDraftApi(uId: uid ?? 0, invoiceId: invoice.id);

      await fetchInvoices();
    } catch (e) {
      emit(InvoicesError(e.toString()));
    }
  }
}
