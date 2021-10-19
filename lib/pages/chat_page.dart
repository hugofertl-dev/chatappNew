import 'dart:io';

import 'package:chat_app/widgets/rs_custom_chatmesenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _inputText = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  final List<RsCustomChatMesenger> _lstmessage = [];

  @override
  void dispose() {
    for (RsCustomChatMesenger element in _lstmessage) {
      element.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: const [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blueAccent,
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text('Melissa Flores',
                style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
            itemCount: _lstmessage.length,
            itemBuilder: (_, i) => _lstmessage[i],
            reverse: true,
          )),
          const Divider(height: 1),
          Container(
            height: 90,
            color: Colors.white,
            child: _inputBox(),
          )
        ],
      ),
    );
  }

  Widget _inputBox() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _inputText,
              focusNode: _focusNode,
              onSubmitted: _onSubmitted,
              onChanged: (texto) {
                (texto.trim().isNotEmpty)
                    ? _estaEscribiendo = true
                    : _estaEscribiendo = false;
                setState(() {});
              },
              decoration:
                  const InputDecoration.collapsed(hintText: 'Ingrese el Texto'),
            ),
          ),
          Container(
            child: Platform.isIOS
                ? CupertinoButton(
                    child: const Text(
                      'Enviar',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: _estaEscribiendo
                        ? () => _onSubmitted(_inputText.text)
                        : null)
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _estaEscribiendo
                            ? () => _onSubmitted(_inputText.text)
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _onSubmitted(String texto) {
    if (texto.isEmpty) return;
    texto = texto.trim();
    final animaterController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    final newMessage = RsCustomChatMesenger(
        texto: texto, uid: '123', animationController: animaterController);
    _lstmessage.insert(0, newMessage);
    animaterController.forward();
    _focusNode.requestFocus();
    _inputText.clear();
    setState(() {
      _estaEscribiendo = false;
    });
  }
}
