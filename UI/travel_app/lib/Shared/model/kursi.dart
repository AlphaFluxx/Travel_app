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

  factory Kursi.fromJson(Map<String, dynamic> json) {
    return Kursi(
      idKursi: json['id_kursi'],
      nomorKursi: json['nomor_kursi'],
      idKendaraan: json['id_kendaraan'],
      statusKetersediaan: json['statusKetersediaan'] ==
          1, // Mengkonversi 1 menjadi true dan 0 menjadi false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kursi': idKursi,
      'nomor_kursi': nomorKursi,
      'id_kendaraan': idKendaraan,
      'statusKetersediaan': statusKetersediaan
          ? 1
          : 0, // Mengkonversi true menjadi 1 dan false menjadi 0
    };
  }
}
