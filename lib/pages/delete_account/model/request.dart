class DeleteAccountRequest {
  DeleteAccountRequest({required this.authorization});

  final String authorization;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'authorization': authorization,
      };
}
