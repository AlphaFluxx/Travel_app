class JadwalHarian {
  final int idJadwal;
  final int idKendaraan;
  final String asal;
  final String tujuan;
  final String waktuBerangkat;
  final String waktuKedatangan;
  final String harga;

  JadwalHarian({
    required this.idJadwal,
    required this.idKendaraan,
    required this.asal,
    required this.tujuan,
    required this.waktuBerangkat,
    required this.waktuKedatangan,
    required this.harga,
  });

  // Fungsi untuk membuat objek JadwalHarian dari JSON
  factory JadwalHarian.fromJson(Map<String, dynamic> json) {
    return JadwalHarian(
      idJadwal: json['id_jadwal'],
      idKendaraan: json['id_kendaraan'],
      asal: json['asal'],
      tujuan: json['tujuan'],
      waktuBerangkat: json['waktu_berangkat'],
      waktuKedatangan: json['waktu_kedatangan'],
      harga: json['harga'],
    );
  }

  // Fungsi untuk mengubah objek JadwalHarian menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_jadwal': idJadwal,
      'id_kendaraan': idKendaraan,
      'asal': asal,
      'tujuan': tujuan,
      'waktu_berangkat': waktuBerangkat,
      'waktu_kedatangan': waktuKedatangan,
      'harga': harga,
    };
  }
}