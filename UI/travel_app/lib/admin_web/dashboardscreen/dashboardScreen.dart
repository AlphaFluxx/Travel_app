// File ini merupakan layar utama Dashboard untuk aplikasi admin.
// Berfungsi sebagai tempat pengelolaan tampilan utama dashboard,
// termasuk menu samping, tabel data, dan tombol aksi (Create, Update, Delete).

// dashboard_screen.dart
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String activeTable = 'pelanggan';
  List<Map<String, dynamic>> pelangganData = [];

  late Future<List<Map<String, dynamic>>> pelangganFuture;

  @override
  void initState() {
    super.initState();
    pelangganFuture = PelangganService.getAllPelanggan();
  }

  void refreshTable() {
    setState(() {
      pelangganFuture = PelangganService.getAllPelanggan();
    });
  }

  _showInputDialog(
    context, {
    required String title,
    required Map<String, String> fields,
    required Map<String, dynamic> initialData,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return InputDialog(
          title: title,
          fields: fields,
          initialData: initialData,
          onSubmit: (updatedData) async {
            try {
              // Logika saat data di-submit
              if (activeTable == 'pelanggan') {
                Map<String, dynamic> pelangganData = {
                  'Nama': updatedData['Nama'],
                  'Email': updatedData['Email'],
                  'Password': updatedData['Password'],
                };
                await PelangganService.createPelanggan(pelangganData);
                _showAlert(context, 'Pelanggan berhasil ditambahkan');
                refreshTable();
              }
            } catch (e) {
              _showAlert(context, 'Gagal menambahkan data: $e');
            }
          },
          refreshTable: refreshTable,
        );
      },
    );
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
                  // Logika untuk logout
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginPage(), // Navigasi ke halaman login
                    ),
                  );
                },
                child: const Text('Ya'),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: const Text('OK'),
              ),
            ],
          ],
        );
      },
    );
  }

  void _deleteData(String id) async {
    try {
      int parsedId = int.parse(id);
      await PelangganService.deletePelanggan(parsedId);
      _showAlert(context, 'Data pelanggan berhasil dihapus.');
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
      body: Row(
        children: [
          SideMenu(
            onTableSelected: (table) {
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
                              // Tambah data
                              if (activeTable == 'pelanggan') {
                                _showInputDialog(
                                  context,
                                  title: 'Tambah Pelanggan',
                                  fields: {
                                    'Nama': 'text',
                                    'Email': 'text',
                                    'Password': 'text',
                                  },
                                  initialData: {},
                                );
                              } else if (activeTable == 'kursi') {
                                _showInputDialog(
                                  context,
                                  title: 'Tambah Kursi',
                                  fields: {
                                    'Nomor Kursi': 'number',
                                    'ID Kendaraan': 'number',
                                    'StatusKetersediaan': 'number',
                                  },
                                  initialData: {},
                                );
                              } else if (activeTable == 'kendaraan') {
                                _showInputDialog(
                                  context,
                                  title: 'Tambah kendaraan',
                                  initialData: {},
                                  fields: {
                                    'Jenis Kendaraan': 'text',
                                    'Kapasitas': 'text'
                                  },
                                  // Menambahkan refreshTable
                                );
                              } else if (activeTable == 'jadwalharian') {
                                _showInputDialog(
                                  context,
                                  title: 'Tambah jadwal',
                                  initialData: {},
                                  fields: {
                                    'id_kendaraan': 'number',
                                    'asal': 'text',
                                    'tujuan': 'text',
                                    'Waktu berangkat': 'text',
                                    'Waktu kedatangan': 'text',
                                    'harga': 'text'
                                  },
                                );
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
                              if (activeTable == 'pelanggan') {
                                if (PelangganTableState.selectedRowPelanggan !=
                                    null) {
                                  _showInputDialog(context,
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
                                      });
                                } else {
                                  _showAlert(context,
                                      'Silakan pilih data pelanggan terlebih dahulu.');
                                }
                              } else if (activeTable == 'kursi') {
                                if (KursiTableState.selectedRowKursi != null) {
                                  _showInputDialog(
                                    context,
                                    title: 'Edit Kursi',
                                    fields: {
                                      'Nomor Kursi': 'text',
                                      'ID Kendaraan': 'text',
                                      'StatusKetersediaan': 'number',
                                    },
                                    initialData: {
                                      'Nomor Kursi': KursiTableState
                                          .selectedRowKursi!['nomor_kursi']
                                          .toString(),
                                      'ID Kendaraan': KursiTableState
                                          .selectedRowKursi!['id_kendaraan']
                                          .toString(),
                                      'StatusKetersediaan':
                                          KursiTableState.selectedRowKursi![
                                              'statusKetersediaan']
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
                                    context,
                                    title: 'Edit kendaraan',
                                    fields: {
                                      'Jenis Kendaraan': 'text',
                                      'Kapasitas': 'number',
                                    },
                                    initialData: {
                                      'Jenis Kendaraan': KendaraanTableState
                                          .selectedRowKendaraan![
                                              'jenis_kendaraan']
                                          .toString(),
                                      'Kapasitas': KendaraanTableState
                                          .selectedRowKendaraan!['kapasitas']
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
                                    context,
                                    title: 'Edit jadwal',
                                    fields: {
                                      'id_kendaraan': 'number',
                                      'asal': 'text',
                                      'tujuan': 'text',
                                      'Waktu berangkat': 'text',
                                      'Waktu kedatangan': 'text',
                                      'harga': 'number'
                                    },
                                    initialData: {
                                      'Id Kendaraan': JadwalhariantableState
                                          .selectedRowjadwal!['id_kendaraan']
                                          .toString(),
                                      'asal': JadwalhariantableState
                                          .selectedRowjadwal!['asal']
                                          .toString(),
                                      'tujuan': JadwalhariantableState
                                          .selectedRowjadwal!['tujuan']
                                          .toString(),
                                      'Waktu berangkat': JadwalhariantableState
                                          .selectedRowjadwal!['waktu_berangkat']
                                          .toString(),
                                      'Waktu kedatangan': JadwalhariantableState
                                          .selectedRowjadwal![
                                              'waktu_kedatangan']
                                          .toString(),
                                      'harga': JadwalhariantableState
                                          .selectedRowjadwal!['harga']
                                          .toString()
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
                              if (activeTable == 'pelanggan') {
                                if (PelangganTableState.selectedRowPelanggan !=
                                    null) {
                                  String id = PelangganTableState
                                      .selectedRowPelanggan!['id_pelanggan']
                                      .toString();
                                  _deleteData(
                                      id); // Kirim sebagai String ke _deleteData
                                } else {
                                  _showAlert(context,
                                      'Silakan pilih data pelanggan terlebih dahulu.');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
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
                            ? KursiTable()
                            : activeTable == 'kendaraan'
                                ? KendaraanTable()
                                : activeTable == 'jadwalharian'
                                    ? Jadwalhariantable()
                                    : TransaksiTable(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
