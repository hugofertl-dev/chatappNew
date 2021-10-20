import 'package:chat_app/bloc/autservice/authservice_bloc.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/model/usuarios_response.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/model/usuario.dart';

class ObtieneUsuarios {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final token = await AuthserviceBloc.obtenerToken();
      final url = Uri.parse('${Environment.apiUrl}/usuarios');
      final response = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token});
      if (response.statusCode == 200) {
        final usuarioResponse = usuariosResponseFromJson(response.body);
        return usuarioResponse.usuarios;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
