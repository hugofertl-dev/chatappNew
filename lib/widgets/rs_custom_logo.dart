import 'package:flutter/material.dart';

class RsCustomLogo extends StatelessWidget {
  final String imageLogo;
  final String tituloLogo;

  const RsCustomLogo(
      {Key? key, required this.imageLogo, required this.tituloLogo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: _height * 0.005),
        width: _width * .5,
        child: Column(
          children: [
            Image.asset(imageLogo),
            SizedBox(height: _height * 0.02),
            Text(
              tituloLogo,
              style: TextStyle(fontSize: _height * 0.02),
            )
          ],
        ),
      ),
    );
  }
}
