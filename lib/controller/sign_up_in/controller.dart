import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oferty_pracy/controller/login_bloc.dart';
import 'package:oferty_pracy/controller/submit_button_bloc.dart';
import 'package:oferty_pracy/model/user.dart';
import 'package:oferty_pracy/utils/server_wrapper.dart';
import 'package:oferty_pracy/view/home.dart';

class BaseLoginController {
  final _serverWrapper = ServerWrapper();
  final _submitButtonBloc = SubmitButtonBloc();

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  String? loginErrorTest;
  String? passwordErrorTest;

  Future<void> perform(BuildContext context) async {
    final validationResult =
        loginErrorTest == null && passwordErrorTest == null;

    final areFiedsNotEmpty =
        loginController.text.isNotEmpty && passwordController.text.isNotEmpty;

    return await _performAction(context, validationResult, areFiedsNotEmpty);
  }

  Future<void> _performAction(BuildContext context, bool validationResult,
      bool areFiedsNotEmpty) async {}

  Future<int> waitingButtonAction(SubmitButtonState state) async {
    if (state == SubmitButtonState.notClicked) return 0;
    Future.delayed(const Duration(seconds: 2), () {
      _submitButtonBloc.add(NotClickedEvent());
      return 1;
    });
    return 2;
  }

  SubmitButtonBloc getSubmitBloc() => _submitButtonBloc;

  String getWaitingText(SubmitButtonState state) => "";

  Color getColor(SubmitButtonState state) {
    return switch (state) {
      SubmitButtonState.notClicked => Colors.blueAccent.shade100,
      SubmitButtonState.success => Colors.greenAccent,
      _ => Colors.redAccent.shade100
    };
  }
}

class SignInController extends BaseLoginController {
  @override
  String getWaitingText(SubmitButtonState state) {
    return switch (state) {
      SubmitButtonState.notClicked => "Zaloguj się",
      SubmitButtonState.success => "Pomyślne logowanie",
      _ => "Logowanie nieudane"
    };
  }

  @override
  Future<void> _performAction(BuildContext context, bool validationResult,
      bool areFiedsNotEmpty) async {
    if (!validationResult || !areFiedsNotEmpty) {
      _submitButtonBloc.add(FailedEvent());
    }

    final user = User(loginController.text, passwordController.text);
    final apiKey = await _serverWrapper.logIn(user);
    if (apiKey.isNotEmpty) {
      _submitButtonBloc.add(SuccessEvent());
      context.read<LoginBloc>().add(LoggedInEvent(apiKey: apiKey));
    } else {
      _submitButtonBloc.add(FailedEvent());
    }
  }
}

class SignUpController extends BaseLoginController {
  @override
  String getWaitingText(SubmitButtonState state) {
    return switch (state) {
      SubmitButtonState.notClicked => "Zarejestruj się",
      SubmitButtonState.success => "Rejestracja pomyślna",
      _ => "Rejestracja nieudana"
    };
  }

  @override
  Future<void> _performAction(BuildContext context, bool validationResult,
      bool areFiedsNotEmpty) async {
    if (!validationResult || !areFiedsNotEmpty) {
      _submitButtonBloc.add(FailedEvent());
    }

    final user = User(loginController.text, passwordController.text);
    final success = await _serverWrapper.register(user);
    if (success) {
      _submitButtonBloc.add(SuccessEvent());
    } else {
      _submitButtonBloc.add(FailedEvent());
    }
  }
}
