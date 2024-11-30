import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oferty_pracy/controller/new_offer/controller.dart';
import 'package:oferty_pracy/controller/submit_button_bloc.dart';
import 'package:oferty_pracy/view/widgets/async_widget.dart';

class NewOfferPage extends StatelessWidget {
  const NewOfferPage(
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
        child: Column(
          children: [const NewOfferLabel(), NewOfferForm()],
        ),
      ),
    );
  }
}

class NewOfferLabel extends StatelessWidget {
  const NewOfferLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(
        'Dodaj nową ofertę',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NewOfferForm extends StatefulWidget {
  const NewOfferForm({super.key});

  @override
  State<NewOfferForm> createState() => _NewOfferFormState();
}

class _NewOfferFormState extends State<NewOfferForm> {
  final _controller = NewOfferPageController();

  @override
  void initState() {
    _controller.positionController.addListener(() {
      setState(() {
        _controller.positionErrorTest =
            _notEmptyValidation(_controller.positionController.text);
      });
    });
    _controller.companyController.addListener(() {
      setState(() {
        _controller.companyErrorTest =
            _notEmptyValidation(_controller.companyController.text);
      });
    });
    _controller.cityController.addListener(() {
      setState(() {
        _controller.cityErrorTest =
            _notEmptyValidation(_controller.cityController.text);
      });
    });
    _controller.descriptionController.addListener(() {
      setState(() {
        _controller.descriptionErrorTest =
            _notEmptyValidation(_controller.descriptionController.text);
      });
    });
    _controller.phoneNumberController.addListener(() {
      setState(() {
        _controller.phoneNumberErrorTest =
            _phoneNumerValidation(_controller.phoneNumberController.text);
      });
    });
    super.initState();
  }

  String? _notEmptyValidation(String text) {
    if (text.isEmpty) {
      return "Pole nie moze być puste";
    }
    return null;
  }

  String? _phoneNumerValidation(String text) {
    if (text.isEmpty) {
      return "Pole nie moze być puste";
    }
    final RegExp phoneNumberRegex = RegExp(r'^\+\d+$');
    if (!phoneNumberRegex.hasMatch(text)) {
      return "Niepoprawny format numeru telefonu";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller.positionController,
          decoration: InputDecoration(
              labelText: "Podaj nazwę pozycji",
              errorText: _controller.positionErrorTest,
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: _controller.companyController,
          decoration: InputDecoration(
              errorText: _controller.companyErrorTest,
              labelText: "Podaj nazwę firmy",
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: _controller.cityController,
          decoration: InputDecoration(
              errorText: _controller.cityErrorTest,
              labelText: "Podaj miasto",
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: _controller.descriptionController,
          minLines: 4,
          maxLines: 20,
          decoration: InputDecoration(
              errorText: _controller.descriptionErrorTest,
              labelText: "Podaj opis stanowiska",
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: _controller.phoneNumberController,
          decoration: InputDecoration(
              errorText: _controller.phoneNumberErrorTest,
              labelText: "Podaj numer telefonu",
              border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: _controller.emailController,
          decoration: const InputDecoration(
              labelText: "Podaj adres email", border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: SubmitButton(controller: _controller),
        )
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  SubmitButton({
    super.key,
    required this.controller,
  });

  final NewOfferPageController controller;

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
              onPressed: () => controller.addNewOffer(),
              child: Text(controller.getWaitingText(state),
                  style: TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}
