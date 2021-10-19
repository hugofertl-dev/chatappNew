class Usuario {
  Usuario({
    this.online = false,
    this.nombre = '',
    this.email = '',
    this.uid = '',
  });

  bool online;
  String nombre;
  String email;
  String uid;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"] ?? false,
        nombre: json["nombre"] ?? '',
        email: json["email"] ?? '',
        uid: json["uid"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "uid": uid,
      };
}
