import 'package:flutter/services.dart';
import 'package:vibeus/bloc/authentication/authentication_bloc.dart';
import 'package:vibeus/bloc/blocDelegate.dart';
import 'package:vibeus/repositories/userRepository.dart';
import 'package:vibeus/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/authentication/authentication_event.dart';

void main() {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: _userRepository)
        ..add(AppStarted()),
      child: Home(userRepository: _userRepository)));

}


