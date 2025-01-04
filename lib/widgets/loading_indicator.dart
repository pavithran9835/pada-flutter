import 'package:flutter/material.dart';


class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (ctx) => Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
            child: const Center(child: CircularProgressIndicator())));
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class Prog {
  show(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context1) {
          return const AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            elevation: 0,
            content: SizedBox(
              height: 35,
              width: 35,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
          );
        });
  }

  hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
