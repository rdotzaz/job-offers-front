import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oferty_pracy/controller/sign_up_in/controller.dart';
import 'package:oferty_pracy/controller/submit_button_bloc.dart';
import 'package:oferty_pracy/view/widgets/async_widget.dart';

class SignUpInPage extends StatelessWidget {
  const SignUpInPage(
      {super.key, required this.width, required this.isLoggedIn});

  final double width;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        width: width * 0.8,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                child: SignInForm(isLoggedIn: isLoggedIn), width: width / 3),
            SizedBox(
              child: SignUpForm(isLoggedIn: isLoggedIn),
              width: width / 3,
            )
          ],
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _controller = SignInController();

  @override
  void initState() {
    _controller.loginController.addListener(() {
      _controller.loginErrorTest =
          _notEmptyValidation(_controller.loginController.text);
    });

    _controller.passwordController.addListener(() {
      _controller.passwordErrorTest =
          _notEmptyValidation(_controller.passwordController.text);
    });
    super.initState();
  }

  String? _notEmptyValidation(String text) {
    if (text.isEmpty) {
      return "Pole nie moze być puste";
    }
    return null;
  }

  final List<FocusNode> _focusNodes = List.generate(2, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = widget.isLoggedIn;
    return BlocProvider(
      create: (_) => _controller.getSubmitBloc(),
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Logowanie',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _controller.loginController,
              enabled: !isLoggedIn,
              focusNode: _focusNodes[0],
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_focusNodes[1]),
              decoration: InputDecoration(
                  labelText: "Podaj login",
                  errorText: _controller.loginErrorTest,
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _controller.passwordController,
              obscureText: true,
              enabled: !isLoggedIn,
              focusNode: _focusNodes[1],
              decoration: InputDecoration(
                  labelText: "Podaj hasłow",
                  errorText: _controller.passwordErrorTest,
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 15,
            ),
            Center(child: SubmitButton(controller: _controller))
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _controller = SignUpController();

  @override
  void initState() {
    _controller.loginController.addListener(() {
      _controller.loginErrorTest =
          _notEmptyValidation(_controller.loginController.text);
    });

    _controller.passwordController.addListener(() {
      _controller.passwordErrorTest =
          _notEmptyValidation(_controller.passwordController.text);
    });
    super.initState();
  }

  String? _notEmptyValidation(String text) {
    if (text.isEmpty) {
      return "Pole nie moze być puste";
    }
    return null;
  }

  final List<FocusNode> _focusNodes = List.generate(2, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = widget.isLoggedIn;
    return BlocProvider(
      create: (_) => _controller.getSubmitBloc(),
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Utwórz nowe konto',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _controller.loginController,
              enabled: !isLoggedIn,
              focusNode: _focusNodes[0],
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_focusNodes[1]),
              decoration: InputDecoration(
                  labelText: "Podaj login",
                  errorText: _controller.loginErrorTest,
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _controller.passwordController,
              enabled: !isLoggedIn,
              obscureText: true,
              focusNode: _focusNodes[1],
              decoration: InputDecoration(
                  labelText: "Podaj hasło",
                  errorText: _controller.passwordErrorTest,
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
                child: SubmitButton(
              controller: _controller,
            ))
          ],
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  SubmitButton({
    super.key,
    required this.controller,
  });

  final BaseLoginController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => controller.getSubmitBloc(),
      child: BlocBuilder<SubmitButtonBloc, SubmitButtonState>(
        builder: (_, state) => AsyncWidget(
          asyncAction: controller.waitingButtonAction(state),
          onWaiting: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: controller.getColor(state)),
              onPressed: () {},
              child: Text(
                controller.getWaitingText(state),
                style: TextStyle(color: Colors.white),
              )),
          onSuccess: (_) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.getColor(state),
              ),
              onPressed: () => controller.perform(context),
              child: Text(controller.getWaitingText(state),
                  style: TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}
