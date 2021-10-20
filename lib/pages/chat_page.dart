import 'dart:io';

import 'package:chat_app/bloc/autservice/authservice_bloc.dart';
import 'package:chat_app/bloc/chatservice/chatservice_bloc.dart';
import 'package:chat_app/bloc/socketservice/socketservice_bloc.dart';
import 'package:chat_app/model/usuario.dart';
import 'package:chat_app/widgets/rs_custom_chatmesenger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _inputText = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;
  Usuario usuarioPara = Usuario();
  Usuario usuario = Usuario();
  final List<RsCustomChatMesenger> _lstmessage = [];

  @override
  void initState() {
    super.initState();
    usuario = BlocProvider.of<AuthserviceBloc>(context).state.usuario;
  }

  @override
  void dispose() {
    for (RsCustomChatMesenger element in _lstmessage) {
      element.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatserviceBloc, ChatserviceState>(
      buildWhen: (previous, currect) {
        if (currect.nuevoMensaje['de'] == usuarioPara.uid ||
            currect.nuevoMensaje['para'] == usuarioPara.uid) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        final animaterController = AnimationController(
            vsync: this, duration: const Duration(milliseconds: 400));
        _lstmessage.insert(
            0,
            RsCustomChatMesenger(
              texto: state.nuevoMensaje['mensaje'],
              uid: state.nuevoMensaje['de'],
              animationController: animaterController,
              usuarioLogeadoId: usuario.uid,
            ));
        animaterController.forward();
      },
      builder: (context, state) {
        usuarioPara = state.usuarioPara;
        return Scaffold(
          appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Column(
                children: [
                  CircleAvatar(
                    child: Text(
                        state.usuarioPara.nombre.substring(0, 2).toUpperCase(),
                        style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.blueAccent,
                    maxRadius: 14,
                  ),
                  const SizedBox(height: 3),
                  Text(state.usuarioPara.nombre,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 12)),
                ],
              )),
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
              ),
            ],
          ),
        );
      },
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
              onSubmitted: (value) => _onSubmitted(value, context),
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
                        ? () => _onSubmitted(_inputText.text, context)
                        : null)
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _estaEscribiendo
                            ? () => _onSubmitted(_inputText.text, context)
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _onSubmitted(String texto, BuildContext context) {
    if (texto.isEmpty) return;
    texto = texto.trim();
    final nuevoMensaje = {
      'de': usuario.uid,
      'para': usuarioPara.uid,
      'mensaje': texto
    };
    context.read<ChatserviceBloc>().add(OnNuevoMensaje(nuevoMensaje));
    _focusNode.requestFocus();
    _inputText.clear();
    context
        .read<SocketserviceBloc>()
        .add(OnEmitMensajeSocketService(nuevoMensaje));
  }
}
