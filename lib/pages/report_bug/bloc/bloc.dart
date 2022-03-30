import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ReportBugBloc extends Bloc<ReportBugEvent, ReportBugState> {
  ReportBugBloc() : super(ReportBugInitial()) {
    on<ReportBugEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
