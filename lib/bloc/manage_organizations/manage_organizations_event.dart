part of 'manage_organizations_bloc.dart';

@immutable
abstract class ManageOrganizationsEvent {}

class GetAllOrganizationEvent extends ManageOrganizationsEvent {
  final String? query;

  GetAllOrganizationEvent({
    this.query,
  });
}

class PayOrganizationEvent extends ManageOrganizationsEvent {
  final int id, amount;

  PayOrganizationEvent({
    required this.id,
    required this.amount,
  });
}

class ReportOrganizationEvent extends ManageOrganizationsEvent {
  final int id;
  final String reason;

  ReportOrganizationEvent({
    required this.id,
    required this.reason,
  });
}
