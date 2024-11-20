import 'package:flutter/material.dart';

class AsyncWidget<T> extends StatelessWidget {
  const AsyncWidget(
      {super.key,
      required this.asyncAction,
      required this.onWaiting,
      required this.onSuccess});

  final Future<T> asyncAction;
  final Widget onWaiting;
  final Function(T) onSuccess;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: asyncAction,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return onWaiting;
          } else if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data != null
                ? onSuccess(snapshot.data!)
                : _errorWidget("Null");
          }
          return _errorWidget(snapshot.error.toString());
        });
  }

  Widget _errorWidget(String errorMessage) {
    return Container(
      color: Colors.red,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.all(30),
            child: Icon(Icons.error, color: Colors.white)),
        Text(errorMessage),
      ]),
    );
  }
}
