import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oferty_pracy/controller/new_offer/submit_button_bloc.dart';
import 'package:oferty_pracy/model/offer.dart';
import 'package:oferty_pracy/server/server_wrapper.dart';

class NewOfferPageController {
  final _submitButtonBloc = SubmitButtonBloc();
  final _serverWrapper = ServerWrapper();

  final positionController = TextEditingController();
  final companyController = TextEditingController();
  final cityController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  String? positionErrorTest;
  String? companyErrorTest;
  String? cityErrorTest;
  String? descriptionErrorTest;
  String? phoneNumberErrorTest;
  String? emailErrorTest;
  String? endDateErrorTest;

  Future<int> waitingButtonAction(SubmitButtonState state) async {
    if (state == SubmitButtonState.notClicked) return 0;
    Future.delayed(const Duration(seconds: 2), () {
      _submitButtonBloc.add(NotClickedEvent());
      return 1;
    });
    return 2;
  }

  SubmitButtonBloc getSubmitBloc() => _submitButtonBloc;

  String getWaitingText(SubmitButtonState state) {
    return switch (state) {
      SubmitButtonState.notClicked => "Dodaj nową ofertę",
      SubmitButtonState.success => "Nowa oferta dodana pomyślnie",
      _ => "Nowa oferta nie została dodana"
    };
  }

  Future<void> addNewOffer() async {
    if (_submitButtonBloc.state != SubmitButtonState.notClicked) return;

    final validationResult = positionErrorTest == null &&
        companyErrorTest == null &&
        cityErrorTest == null &&
        descriptionErrorTest == null &&
        phoneNumberErrorTest == null;

    final areFiedsNotEmpty = positionController.text.isNotEmpty &&
        companyController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        emailController.text.isNotEmpty;

    if (!validationResult || !areFiedsNotEmpty) {
      _submitButtonBloc.add(FailedEvent());
      return;
    }

    final newOffer = Offer(
        id: 'id',
        position: positionController.text,
        company: companyController.text,
        city: cityController.text,
        description: descriptionController.text,
        phoneNumber: phoneNumberController.text,
        email: emailController.text,
        creationDate: DateTime.now(),
        endDate: DateTime.now()); // TODO - Make proper setting of end date)

    final addedOffer = await _serverWrapper.addNewOffer(newOffer);
    if (addedOffer != null && addedOffer.id != "id") {
      _submitButtonBloc.add(SuccessEvent());
    } else {
      _submitButtonBloc.add(FailedEvent());
    }
  }

  Color getColor(SubmitButtonState state) {
    return switch (state) {
      SubmitButtonState.notClicked => Colors.blueAccent.shade100,
      SubmitButtonState.success => Colors.greenAccent,
      _ => Colors.redAccent.shade100
    };
  }
}
