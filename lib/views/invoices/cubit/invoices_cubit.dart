import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  InvoicesCubit() : super(InvoicesInitial());
}
