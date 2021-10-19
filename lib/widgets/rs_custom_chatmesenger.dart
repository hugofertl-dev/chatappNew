import 'package:flutter/material.dart';

class RsCustomChatMesenger extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const RsCustomChatMesenger(
      {Key? key,
      required this.texto,
      required this.uid,
      required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: animationController,
        child: SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: animationController, curve: Curves.easeOut),
            child: Container(
                child: uid == '123' ? _myMessage() : _otherMessage())));
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.blue[300], borderRadius: BorderRadius.circular(80)),
        margin: const EdgeInsets.only(right: 5, left: 50, bottom: 5),
        child: Text(texto,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }

  Widget _otherMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.grey[400], borderRadius: BorderRadius.circular(80)),
        margin: const EdgeInsets.only(right: 50, left: 5, bottom: 5),
        child: Text(texto,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }
}
