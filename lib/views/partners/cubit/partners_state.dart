abstract class PartnerState {}

class PartnerInitial extends PartnerState {}

class PartnerLoading extends PartnerState {}

class PartnerLoaded extends PartnerState {}

class PartnerSuccess extends PartnerState {}

class PartnerError extends PartnerState {
  final String message;
  PartnerError(this.message);
}
