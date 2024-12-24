class Kursi {
  final int idKursi;
  final int nomorKursi;
  final int idKendaraan;
  final bool statusKetersediaan;

  Kursi({
    required this.idKursi,
    required this.nomorKursi,
    required this.idKendaraan,
    required this.statusKetersediaan,
  });

  /// Factory untuk membuat objek Kursi dari JSON
  factory Kursi.fromJson(Map<String, dynamic> json) {
    return Kursi(
      idKursi: json['id_kursi'],
      nomorKursi: json['nomor_kursi'],
      idKendaraan: json['id_kendaraan'],
      statusKetersediaan: (json['status_ketersediaan'] ?? 0) == 1,
    );
  }

  /// Konversi objek Kursi menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_kursi': idKursi,
      'nomor_kursi': nomorKursi,
      'id_kendaraan': idKendaraan,
      'status_ketersediaan': statusKetersediaan ? 1 : 0,
    };
  }

  /// Metode tambahan untuk deskripsi status
  String get statusKeterangan =>
      statusKetersediaan ? "Tersedia" : "Tidak Tersedia";
}
