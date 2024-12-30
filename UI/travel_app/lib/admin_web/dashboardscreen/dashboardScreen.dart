// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:travel_app/admin_web/dashboardscreen/jadwalHarianTable.dart';
import 'package:travel_app/admin_web/dashboardscreen/kendaraanTable.dart';
import 'package:travel_app/admin_web/dashboardscreen/transaksiTable.dart';
import 'sideMenu.dart';
import 'pelangganTable.dart';
import 'kursiTable.dart';
import 'inputDialog.dart';
import '../auth/loginAdminScreen.dart';
import '../utils/api/pelanggan.service.dart';
import '../utils/api/kursi.service.dart';
import '../utils/api/kendaraan.service.dart';
import '../utils/api/transaksi.service.dart';
import '../utils/api/jadwalHarian.service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String activeTable = 'pelanggan';

  late Future<List<Map<String, dynamic>>> pelangganFuture;
  late Future<List<Map<String, dynamic>>> kursiFuture;
  late Future<List<Map<String, dynamic>>> kendaraanFuture;
  late Future<List<Map<String, dynamic>>> transaksiFuture;
  late Future<List<Map<String, dynamic>>> jadwalHarianFuture;

  @override
  void initState() {
    super.initState();
    refreshTable();
  }

  void refreshTable() {
    print("Refreshing table data for activeTable: $activeTable");
    setState(() {
      pelangganFuture = PelangganService.getAllPelanggan();
      kursiFuture = KursinService.getAllKursi();
      kendaraanFuture = KendaraannService.getAllKendaraan();
      transaksiFuture = TransaksiService.getAllTransaksi();
      jadwalHarianFuture = JadwalharianService.getAllJadwalHarian();
    });
  }

  Future<void> _showInputDialog({
    required String title,
    required Map<String, String> fields,
    Map<String, dynamic>? initialData,
    required String activeTable,
    Map<String, dynamic>? indikator,
  }) async {
    print("Opening input dialog for table: $activeTable");
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => InputDialog(
        fields: fields,
        initialData: initialData,
        activeTable: activeTable,
        indikator: indikator,
        refreshTable: refreshTable,
      ),
    );

    if (result != null) {
      print("Data saved/updated, refreshing table...");
      refreshTable();
    } else {
      print("No data returned from input dialog.");
    }
  }

  void _showAlert(BuildContext context, String message,
      {bool isLogout = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isLogout ? 'Konfirmasi Logout' : 'Peringatan'),
          content: Text(message),
          actions: [
            if (isLogout) ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Ya'),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ],
        );
      },
    );
  }

  void _deleteData(String id, String activeTable) async {
    try {
      int parsedId = int.parse(id);

      if (activeTable == 'pelanggan') {
        await PelangganService.deletePelanggan(parsedId);
        _showAlert(context, 'Data pelanggan berhasil dihapus.');
      } else if (activeTable == 'kendaraan') {
        await KendaraannService.deleteKendaraan(parsedId);
        _showAlert(context, 'Data kendaraan berhasil dihapus.');
      } else if (activeTable == 'kursi') {
        await KursinService.deleteKursi(parsedId);
        _showAlert(context, 'Data kursi berhasil dihapus.');
      } else if (activeTable == 'jadwalharian') {
        await JadwalharianService.deleteJadwalHarian(parsedId);
        _showAlert(context, 'Data jadwal harian berhasil dihapus.');
      } else if (activeTable == 'transaksi') {
        await TransaksiService.deleteTransaksi(parsedId);
        _showAlert(context, 'Data transaksi berhasil dihapus.');
      } else {
        _showAlert(context, 'Tabel tidak dikenali.');
        return;
      }

      refreshTable();
    } catch (e) {
      _showAlert(context, 'Gagal menghapus data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            'assets/icon/back.png', // Path gambar Anda
            width: 24,
            height: 24,
          ),
          onPressed: () {
            print("Logout requested.");
            _showAlert(
              context,
              'Apakah Anda yakin ingin logout?',
              isLogout: true, // Tampilkan opsi logout
            );
          },
        ),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(children: [
        SideMenu(
          onTableSelected: (table) {
            print("Table selected: $table");
            setState(() {
              activeTable = table;
            });
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Table: $activeTable',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print("Creating new data for table: $activeTable");
                            if (activeTable == 'pelanggan') {
                              _showInputDialog(
                                  title: 'Tambah Pelanggan',
                                  fields: {
                                    'Nama': 'text',
                                    'Email': 'text',
                                    'Password': 'text',
                                  },
                                  initialData: {},
                                  activeTable: activeTable,
                                  indikator: {});
                            } else if (activeTable == 'kursi') {
                              _showInputDialog(
                                  title: 'Tambah Kursi',
                                  fields: {
                                    'Nomor Kursi': 'number',
                                    'id_kendaraan': 'number',
                                    'StatusKetersediaan': 'number',
                                  },
                                  initialData: {},
                                  activeTable: activeTable,
                                  indikator: {});
                            } else if (activeTable == 'kendaraan') {
                              _showInputDialog(
                                  title: 'Tambah kendaraan',
                                  fields: {
                                    'jenis_kendaraan': 'text',
                                    'kapasitas': 'number'
                                  },
                                  initialData: {},
                                  activeTable: activeTable,
                                  indikator: {});
                            } else if (activeTable == 'jadwalharian') {
                              _showInputDialog(
                                  title: 'Tambah jadwal',
                                  fields: {
                                    'id_kendaraan': 'number',
                                    'asal': 'text',
                                    'tujuan': 'text',
                                    'waktu_berangkat': 'text',
                                    'waktu_kedatangan': 'text',
                                    'harga': 'number',
                                    'tanggal_keberangkatan': 'date'
                                  },
                                  activeTable: activeTable,
                                  initialData: {},
                                  indikator: {});
                            } else if (activeTable == 'transaksi') {
                              _showInputDialog(
                                  title: 'Tambah transaksi',
                                  fields: {
                                    'id_pelanggan': 'number',
                                    'id_jadwal': 'number',
                                    'id_kursi': 'number',
                                    'status_transaksi': 'text',
                                    'tanggal_reservasi': 'date'
                                  },
                                  initialData: {},
                                  activeTable: activeTable,
                                  indikator: {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Create'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            print("Update requested for table: $activeTable");
                            if (activeTable == 'pelanggan') {
                              if (PelangganTableState.selectedRowPelanggan !=
                                  null) {
                                _showInputDialog(
                                    title: 'Edit Pelanggan',
                                    fields: {
                                      "ID": 'int',
                                      'Nama': 'text',
                                      'Email': 'text',
                                      'Password': 'text',
                                    },
                                    initialData: {
                                      'ID': PelangganTableState
                                              .selectedRowPelanggan![
                                          'id_pelanggan'],
                                      'Nama': PelangganTableState
                                          .selectedRowPelanggan!['Nama']
                                          .toString(),
                                      'Email': PelangganTableState
                                          .selectedRowPelanggan!['Email']
                                          .toString(),
                                    },
                                    indikator: {
                                      'id_pelanggan': PelangganTableState
                                              .selectedRowPelanggan![
                                          'id_pelanggan'],
                                    },
                                    activeTable: activeTable);
                              } else {
                                _showAlert(context,
                                    'Silakan pilih data pelanggan terlebih dahulu.');
                              }
                            } else if (activeTable == 'kursi') {
                              if (KursiTableState.selectedRowKursi != null) {
                                _showInputDialog(
                                  title: 'Edit Kursi',
                                  fields: {
                                    'Nomor Kursi': 'text',
                                    'ID Kursi': 'text',
                                    'StatusKetersediaan': 'number',
                                  },
                                  initialData: {
                                    'Nomor Kursi': KursiTableState
                                        .selectedRowKursi!['nomor_kursi'],
                                    'ID Kursi': KursiTableState
                                        .selectedRowKursi!['id_kursi'],
                                    'StatusKetersediaan': KursiTableState
                                        .selectedRowKursi!['statusKetersediaan']
                                  },
                                  activeTable: activeTable,
                                  indikator: {
                                    'id_kursi': KursiTableState
                                        .selectedRowKursi!['id_kursi']
                                        .toString(),
                                  },
                                );
                              } else {
                                _showAlert(context,
                                    'Silakan pilih data kursi terlebih dahulu.');
                              }
                            } else if (activeTable == 'kendaraan') {
                              if (KendaraanTableState.selectedRowKendaraan !=
                                  null) {
                                _showInputDialog(
                                  title: 'Edit kendaraan',
                                  fields: {
                                    'ID Kendaraan': 'text',
                                    'jenis_kendaraan': 'text',
                                    'kapasitas': 'number',
                                  },
                                  initialData: {
                                    'ID Kendaraan': KendaraanTableState
                                        .selectedRowKendaraan!["id_kendaraan"],
                                    'jenis_kendaraan': KendaraanTableState
                                        .selectedRowKendaraan![
                                            'jenis_kendaraan']
                                        .toString(),
                                    'kapasitas': KendaraanTableState
                                        .selectedRowKendaraan!['kapasitas']
                                  },
                                  activeTable: activeTable,
                                  indikator: {
                                    'id_kendaraan': KendaraanTableState
                                        .selectedRowKendaraan!["id_kendaraan"],
                                  },
                                );
                              } else {
                                _showAlert(context,
                                    'Silakan pilih data Kendaraan terlebih dahulu.');
                              }
                            } else if (activeTable == 'jadwalharian') {
                              if (JadwalhariantableState.selectedRowjadwal !=
                                  null) {
                                _showInputDialog(
                                  title: 'Edit jadwal',
                                  fields: {
                                    'id_kendaraan': 'number',
                                    'asal': 'text',
                                    'tujuan': 'text',
                                    'waktu_berangkat': 'text',
                                    'waktu_kedatangan': 'text',
                                    'harga': 'number',
                                    'tanggal_keberangkatan': 'date'
                                  },
                                  initialData: {
                                    'id_kendaraan': JadwalhariantableState
                                        .selectedRowjadwal!['id_kendaraan'],
                                    'asal': JadwalhariantableState
                                        .selectedRowjadwal!['asal']
                                        .toString(),
                                    'tujuan': JadwalhariantableState
                                        .selectedRowjadwal!['tujuan']
                                        .toString(),
                                    'waktu_berangkat': JadwalhariantableState
                                        .selectedRowjadwal!['waktu_berangkat']
                                        .toString(),
                                    'waktu_kedatangan': JadwalhariantableState
                                        .selectedRowjadwal!['waktu_kedatangan']
                                        .toString(),
                                    'harga': JadwalhariantableState
                                        .selectedRowjadwal!['harga'],
                                    'tanggal_keberangkatan':
                                        JadwalhariantableState
                                                .selectedRowjadwal![
                                            'tanggal_keberangkatan']
                                  },
                                  activeTable: activeTable,
                                  indikator: {
                                    'id_jadwal': JadwalhariantableState
                                        .selectedRowjadwal!['id_jadwal']
                                  },
                                );
                              } else {
                                _showAlert(context,
                                    'Silakan pilih data Jadwal terlebih dahulu.');
                              }
                            } else if (activeTable == 'transaksi') {
                              if (TransaksiTableState.selectedRowTransaksi !=
                                  null) {
                                _showInputDialog(
                                  title: 'Edit transaksi',
                                  fields: {
                                    'id_transaksi': 'number',
                                    'id_pelanggan': 'number',
                                    'id_jadwal': 'number',
                                    'id_kursi': 'number',
                                    'status_transaksi': 'text',
                                    'tanggal_reservasi': 'date'
                                  },
                                  initialData: {
                                    'id_transaksi': TransaksiTableState
                                        .selectedRowTransaksi!['id_transaksi'],
                                    'id_pelanggan': TransaksiTableState
                                        .selectedRowTransaksi!['id_pelanggan'],
                                    'id_jadwal': TransaksiTableState
                                        .selectedRowTransaksi!['id_jadwal'],
                                    'id_kursi': TransaksiTableState
                                        .selectedRowTransaksi!['id_kursi'],
                                    'tanggal': TransaksiTableState
                                        .selectedRowTransaksi!['tanggal']
                                        .toString(),
                                    'status_transaksi': TransaksiTableState
                                        .selectedRowTransaksi![
                                            'status_transaksi']
                                        .toString(),
                                    'tanggal_reservasi': TransaksiTableState
                                            .selectedRowTransaksi![
                                        'tanggal_reservasi'],
                                  },
                                  activeTable: activeTable,
                                  indikator: {
                                    'id_transaksi': TransaksiTableState
                                        .selectedRowTransaksi!['id_transaksi'],
                                  },
                                );
                              } else {
                                _showAlert(context,
                                    'Silakan pilih data Jadwal terlebih dahulu.');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('Update'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            print("Delete requested for table: $activeTable");

                            if (activeTable == 'pelanggan' &&
                                PelangganTableState.selectedRowPelanggan !=
                                    null) {
                              String id = PelangganTableState
                                  .selectedRowPelanggan!['id_pelanggan']
                                  .toString();
                              _deleteData(id, activeTable);
                            } else if (activeTable == 'kendaraan' &&
                                KendaraanTableState.selectedRowKendaraan !=
                                    null) {
                              String id = KendaraanTableState
                                  .selectedRowKendaraan!['id_kendaraan']
                                  .toString();
                              print(
                                  "ID Kendaraan yang akan dihapus: $id"); // Tambahkan log untuk memastikan ID kendaraan
                              _deleteData(id, activeTable);
                            } else if (activeTable == 'kursi' &&
                                KursiTableState.selectedRowKursi != null) {
                              String id = KursiTableState
                                  .selectedRowKursi!['id_kursi']
                                  .toString();
                              _deleteData(id, activeTable);
                            } else if (activeTable == 'jadwalharian' &&
                                JadwalhariantableState.selectedRowjadwal !=
                                    null) {
                              String id = JadwalhariantableState
                                  .selectedRowjadwal!['id_jadwal']
                                  .toString();
                              _deleteData(id, activeTable);
                            } else if (activeTable == 'transaksi' &&
                                TransaksiTableState.selectedRowTransaksi !=
                                    null) {
                              String id = TransaksiTableState
                                  .selectedRowTransaksi!['id_transaksi']
                                  .toString();
                              _deleteData(id, activeTable);
                            } else {
                              _showAlert(context,
                                  'Silakan pilih data dari tabel $activeTable terlebih dahulu.');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: activeTable == 'pelanggan'
                      ? PelangganTable(pelangganFuture: pelangganFuture)
                      : activeTable == 'kursi'
                          ? KursiTable(kursiFuture: kursiFuture)
                          : activeTable == 'kendaraan'
                              ? KendaraanTable(kendaraanFuture: kendaraanFuture)
                              : activeTable == 'jadwalharian'
                                  ? Jadwalhariantable(
                                      jadwalFuture: jadwalHarianFuture)
                                  : TransaksiTable(
                                      transaksiFuture: transaksiFuture),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
