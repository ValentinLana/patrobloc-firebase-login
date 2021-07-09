import 'dart:async';

import 'package:patronbloc/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

/* LOS BEHAVIOR SUBJECT REMPLAZAN A LOS STREAM CONTROLLER
LOS STREAM CONTROLLER NO SON CONOCIDOS EN RXDART
  final _emailController    = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast(); */

// REcuperar los datos del Stream

  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

// ESTO COMBINA LOS STREAM PARA DESPUEES DETERMINAR SI LOS DOS ESTAN BIEN
  Stream<bool> get formValidStream =>
      Observable.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insar valores al stream
  //
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // OBTENER EL ULTIMO VALOR INGRESADO A LOS STREAMS
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
