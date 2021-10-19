import 'package:chat_app/bloc/autservice/authservice_bloc.dart';
import 'package:chat_app/bloc/socketservice/socketservice_bloc.dart';
import 'package:chat_app/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> lstUsuarios = [
    Usuario(
        email: 'hugo@test.com', nombre: 'Hugo Fertl', online: true, uid: '1'),
    Usuario(
        email: 'natalia@test.com',
        nombre: 'Natalia Ruez',
        online: true,
        uid: '2'),
    Usuario(
        email: 'juan@test.com',
        nombre: 'Juan de los Palotes',
        online: false,
        uid: '3'),
  ];

  @override
  Widget build(BuildContext context) {
    final usuarioAuth = BlocProvider.of<AuthserviceBloc>(context).state.usuario;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                context
                    .read<SocketserviceBloc>()
                    .add(OnDisconnectSocketService());
                context.read<AuthserviceBloc>().add(OnLogOut());
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: const Icon(Icons.exit_to_app)),
          title: Text(usuarioAuth.nombre),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: BlocBuilder<SocketserviceBloc, SocketserviceState>(
                  builder: (_, state) {
                    return Icon(
                      (state.serverStatus == ServerStatus.online)
                          ? Icons.check_circle
                          : Icons.offline_bolt,
                      color: (state.serverStatus == ServerStatus.online)
                          ? Colors.green.shade400
                          : Colors.red,
                    );
                  },
                ))
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, i) => _itemBuilder(lstUsuarios[i]),
              separatorBuilder: (_, i) => const Divider(),
              itemCount: lstUsuarios.length),
        ));
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {});
    }
  }

  ListTile _itemBuilder(Usuario usuario) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Center(
            child: Text(
          usuario.nombre.substring(0, 2),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        )),
      ),
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      trailing: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: (usuario.online) ? Colors.green[300] : Colors.red[600]),
      ),
    );
  }
}
