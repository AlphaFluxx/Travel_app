class Kendaraan {
  final int idKendaraan;
  final String jenisKendaraan;
  final int kapasitas;

  Kendaraan({
    required this.idKendaraan,
    required this.jenisKendaraan,
    required this.kapasitas,
  });

  // Fungsi untuk membuat objek Kendaraan dari JSON
  factory Kendaraan.fromJson(Map<String, dynamic> json) {
    return Kendaraan(
      idKendaraan: json['id_kendaraan'],
      jenisKendaraan: json['jenis_kendaraan'],
      kapasitas: json['kapasitas'],
    );
  }

  // Fungsi untuk mengubah objek Kendaraan menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_kendaraan': idKendaraan,
      'jenis_kendaraan': jenisKendaraan,
      'kapasitas': kapasitas,
    };
  }
}