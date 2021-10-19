import 'package:flutter/material.dart';

class RsCustomLabelLogin extends StatelessWidget {
  final String titulo;
  final String textoAccion;
  final String ruta;

  const RsCustomLabelLogin(
      {Key? key,
      required this.titulo,
      required this.textoAccion,
      required this.ruta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          titulo,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black54),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, ruta);
          },
          child: Text(
            textoAccion,
            style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        )
      ],
    );
  }
}
