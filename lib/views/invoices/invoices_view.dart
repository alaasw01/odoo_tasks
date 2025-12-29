import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_task/services/odoo_api_service.dart';
import 'package:odoo_task/views/invoices/cubit/invoices_cubit.dart';

class InvoicesView extends StatelessWidget {
  const InvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('invoices')),
      body: BlocProvider(
        create: (context) => InvoicesCubit(OdooApiService()),
        child: BlocBuilder<InvoicesCubit, InvoicesState>(
          builder: (context, state) {
            var cubit = context.read<InvoicesCubit>();
            if (state is InvoicesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is InvoicesSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cubit.invoices.length,
                      itemBuilder: (context, index) {
                        final invoice = cubit.invoices[index];
                        return ExpansionTile(
                          title: Text(invoice.name),
                          subtitle: Text(
                            invoice.partnerName,
                            style: TextStyle(color: Colors.blue),
                          ),
                          trailing: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.18,
                            child: Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  invoice.paymentStatus == 'draft'
                                      ? Icons.drafts_rounded
                                      : Icons.check_circle,
                                  color: invoice.paymentStatus == 'draft'
                                      ? Colors.red
                                      : Colors.green,
                                  size: 20,
                                ),
                                Text(
                                  invoice.paymentStatus,
                                  style: TextStyle(
                                    color: invoice.paymentStatus == 'draft'
                                        ? Colors.red
                                        : Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onExpansionChanged: (expanded) {
                            if (expanded) {
                              cubit.fetchInvoiceLines(index);
                            }
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  if (invoice.paymentStatus == 'draft') ...[
                                    ElevatedButton(
                                      onPressed: () {
                                        cubit.confirmInvoice(index);
                                      },

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ] else ...[
                                    ElevatedButton(
                                      onPressed: () {
                                        cubit.resetToDraft(index);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                      ),
                                      child: const Text(
                                        'Reset to Draft',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // const Divider(),

                            // 🔹 INVOICE LINES
                            if (invoice.lines?.isEmpty == true)
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(),
                              )
                            else
                              ...invoice.lines?.map((line) {
                                    return ListTile(
                                      title: Text(line.name),
                                      subtitle: Text(
                                        'Qty: ${line.quantity} × ${line.priceUnit}',
                                      ),
                                      trailing: Text(line.subtotal.toString()),
                                    );
                                  }) ??
                                  [],
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is InvoicesError) {
              return Center(child: Text(state.message));
            }

            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<InvoicesCubit>().fetchInvoices();
                },
                child: const Text('Load invoices'),
              ),
            );
          },
        ),
      ),
    );
  }
}
