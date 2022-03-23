part of 'bloc.dart';

class DeleteAccountState {
  DeleteAccountState({
    this.formStatus = const InitialFormStatus(),
  });
  final FormSubmissionStatus formStatus;

  DeleteAccountState copyWith({
    FormSubmissionStatus? formStatus,
  }) {
    return DeleteAccountState(
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
