part of 'invoices_cubit.dart';

@immutable
sealed class InvoicesState {}

final class InvoicesInitial extends InvoicesState {}

final class InvoicesLoading extends InvoicesState {}

final class InvoicesSuccess extends InvoicesState {}

final class InvoicesError extends InvoicesState {
  final String message;

  InvoicesError(this.message);
}
