class User {
  final int idPelanggan;
  final String nama;
  final String email;
  final String password;

  User({
    required this.idPelanggan,
    required this.nama,
    required this.email,
    required this.password,
  });

  // Fungsi untuk membuat objek User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idPelanggan: json['id_pelanggan'],
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
    );
  }

  // Fungsi untuk mengubah objek User menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_pelanggan': idPelanggan,
      'nama': nama,
      'email': email,
      'password': password,
    };
  }
}