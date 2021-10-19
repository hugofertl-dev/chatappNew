import 'package:flutter/material.dart';

class RsCustomButton extends StatelessWidget {
  final String texto;
  final Function()? onPressed;
  final Color? color;
  const RsCustomButton({
    Key? key,
    required this.texto,
    this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      shape: const StadiumBorder(),
      color: color ?? Colors.blue,
      elevation: 5,
      onPressed: onPressed,
      child: Center(
        child: Text(
          texto,
          style: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
