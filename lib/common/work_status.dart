import 'package:flutter/material.dart';

@immutable
abstract class WorkStatus {
  const WorkStatus();
}

class Idle extends WorkStatus {
  const Idle();
}

class InProgress extends WorkStatus {}

class Success extends WorkStatus {}

class Failure extends WorkStatus {
  const Failure({
    this.exception,
    this.message,
  });

  final Exception? exception;
  final String? message;
}
