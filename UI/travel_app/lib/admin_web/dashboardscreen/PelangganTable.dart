// File ini mengatur tabel pelanggan, yang digunakan untuk menampilkan
// dan mengelola data pelanggan seperti ID, nama, email, dan password.
// File ini juga menangani pemilihan baris data untuk aksi Update atau Delete.

// pelanggan_table.dart
// File ini digunakan untuk menampilkan tabel data pelanggan dan logika seleksi baris.

import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class PelangganTable extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> pelangganFuture;

  // Constructor untuk menerima pelangganFuture dari luar
  const PelangganTable({Key? key, required this.pelangganFuture})
      : super(key: key);

  @override
  State<PelangganTable> createState() => PelangganTableState();
}

class PelangganTableState extends State<PelangganTable> {
  static Map<String, dynamic>? selectedRowPelanggan;
  late Future<List<Map<String, dynamic>>> pelangganFuture;
  final ScrollController _scrollController = ScrollController();
  String _maskPassword(String password, [int limit = 6]) {
  final maskedLength = password.length > limit ? limit : password.length;
  return List.generate(maskedLength, (_) => '●').join();
}



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.pelangganFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final pelangganData = snapshot.data!;

        return Column(
          children: [
            Flexible(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    child: StyledDataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Password')),
                      ],
                      rows: pelangganData.map((pelanggan) {
                        return DataRow(
                          selected: PelangganTableState
                                  .selectedRowPelanggan?['id_pelanggan'] ==
                              pelanggan['id_pelanggan'],
                          onSelectChanged: (isSelected) {
                            setState(() {
                              if (isSelected != null && isSelected) {
                                PelangganTableState.selectedRowPelanggan =
                                    pelanggan;
                              } else {
                                PelangganTableState.selectedRowPelanggan = null;
                              }
                            });
                          },
                          cells: [
                            DataCell(
                                Text(pelanggan['id_pelanggan'].toString())),
                            DataCell(Text(pelanggan['Nama'])),
                            DataCell(Text(pelanggan['Email'])),
                            DataCell(Text(_maskPassword(pelanggan['Password'])))
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
