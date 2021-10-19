import 'package:flutter/material.dart';

class RsCustomInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final IconData? prefixIcon;
  final TextInputType? textInputType;
  final String hintText;
  final bool isPassWord;

  const RsCustomInput(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      this.prefixIcon,
      this.textInputType,
      required this.isPassWord})
      : super(key: key);

  @override
  State<RsCustomInput> createState() => _RsCustomInputState();
}

class _RsCustomInputState extends State<RsCustomInput> {
  bool obscureTextON = false;

  @override
  void initState() {
    super.initState();
    if (widget.isPassWord) {
      obscureTextON = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]),
      child: TextField(
        controller: widget.textEditingController,
        keyboardType: widget.textInputType ?? TextInputType.text,
        obscureText: (obscureTextON),
        decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: Icon(widget.prefixIcon ?? Icons.input_outlined),
            suffixIcon: (widget.isPassWord)
                ? GestureDetector(
                    onTap: () {
                      obscureTextON = !obscureTextON;
                      setState(() {});
                    },
                    child: (obscureTextON)
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility))
                : null,
            border: InputBorder.none),
      ),
    );
  }
}
