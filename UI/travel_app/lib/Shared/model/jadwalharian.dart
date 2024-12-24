class JadwalHarian {
  final int id;
  final String asal;
  final String tujuan;
  final String waktuBerangkat;
  final String waktuKedatangan;
  final int harga;
  final String jenisKendaraan;

  JadwalHarian({
    required this.id,
    required this.asal,
    required this.tujuan,
    required this.waktuBerangkat,
    required this.waktuKedatangan,
    required this.harga,
    required this.jenisKendaraan,
  });

  factory JadwalHarian.fromJson(Map<String, dynamic> json) {
    return JadwalHarian(
      id: json['id_jadwal'],
      asal: json['asal'],
      tujuan: json['tujuan'],
      waktuBerangkat: json['waktu_berangkat'],
      waktuKedatangan: json['waktu_kedatangan'],
      harga: json['harga'],
      jenisKendaraan:
          json['jenis_kendaraan'] ?? 'Unknown', // Pastikan jenis kendaraan ada
    );
  }
}
