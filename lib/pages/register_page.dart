import 'package:chat_app/bloc/autservice/authservice_bloc.dart';
import 'package:chat_app/bloc/socketservice/socketservice_bloc.dart';
import 'package:chat_app/widgets/rs_custom_button.dart';
import 'package:chat_app/widgets/rs_custom_input.dart';
import 'package:chat_app/widgets/rs_custom_labellogin.dart';
import 'package:chat_app/widgets/rs_custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                RsCustomLogo(
                    imageLogo: 'assets/tag-logo.png', tituloLogo: 'Registro'),
                _Form(),
                RsCustomLabelLogin(
                  titulo: 'ya tiene una Cuenta?',
                  textoAccion: 'Igrese con su Cuenta!',
                  ruta: 'login',
                ),
                Text(
                  'Tèrminos y condiciones de uso',
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final TextEditingController edtmail = TextEditingController();
  final TextEditingController edtpassWord = TextEditingController();
  final TextEditingController edtnombre = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          RsCustomInput(
            textEditingController: edtnombre,
            prefixIcon: Icons.person_add,
            isPassWord: false,
            hintText: 'Nombre',
          ),
          RsCustomInput(
            textEditingController: edtmail,
            prefixIcon: Icons.email,
            textInputType: TextInputType.emailAddress,
            isPassWord: false,
            hintText: 'Email',
          ),
          RsCustomInput(
            textEditingController: edtpassWord,
            prefixIcon: Icons.lock,
            isPassWord: true,
            hintText: 'Contraseña',
          ),
          const SizedBox(height: 20),
          BlocConsumer<AuthserviceBloc, AuthserviceState>(
            listener: (_, state) {
              if (!state.isWorking) {
                if (state.loginOk) {
                  context
                      .read<SocketserviceBloc>()
                      .add(OnConnectSocketService());
                  Navigator.popAndPushNamed(context, 'usuarios');
                } else {
                  const snackBar =
                      SnackBar(content: Text('Error de Registracion'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
            builder: (_, state) {
              return RsCustomButton(
                  texto: 'Guardar',
                  color: (state.isWorking) ? Colors.grey : Colors.blue,
                  onPressed: () {
                    if (!state.isWorking) {
                      context.read<AuthserviceBloc>().add(OnRegister(
                          edtnombre.text, edtmail.text, edtpassWord.text));
                    }
                  });
            },
          )
        ],
      ),
    );
  }
}
