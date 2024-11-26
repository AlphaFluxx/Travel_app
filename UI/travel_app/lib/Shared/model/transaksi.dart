class Transaksi {
  final int idTransaksi;
  final int idPelanggan;
  final int idJadwal;
  final String metodePembayaran;
  final DateTime tanggal;


  Transaksi({
    required this.idTransaksi,
    required this.idPelanggan,
    required this.idJadwal,
    required this.metodePembayaran,
    required this.tanggal,
  });

  // Fungsi untuk membuat objek Transaksi dari JSON
  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      idTransaksi: json['id_transaksi'],
      idPelanggan: json['id_pelanggan'],
      idJadwal: json['id_jadwal'],
      metodePembayaran: json['metodePembayaran'],
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  // Fungsi untuk mengubah objek Transaksi menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_transaksi': idTransaksi,
      'id_pelanggan': idPelanggan,
      'id_jadwal': idJadwal,
      'metodePembayaran': metodePembayaran,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}