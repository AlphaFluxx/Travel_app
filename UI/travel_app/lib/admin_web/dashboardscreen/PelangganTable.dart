// File ini mengatur tabel pelanggan, yang digunakan untuk menampilkan 
// dan mengelola data pelanggan seperti ID, nama, email, dan password.
// File ini juga menangani pemilihan baris data untuk aksi Update atau Delete.

// pelanggan_table.dart
// File ini digunakan untuk menampilkan tabel data pelanggan dan logika seleksi baris.

import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class PelangganTable extends StatefulWidget {
  @override
  State<PelangganTable> createState() => PelangganTableState();
}

class PelangganTableState extends State<PelangganTable> {
  static Map<String, dynamic>? selectedRowPelanggan;

  static final List<Map<String, dynamic>> pelangganData = [
    {
      'id_pelanggan': 1,
      'Nama': 'John Doe',
      'Email': 'john@example.com',
      'Password': '******',
    },
    {
      'id_pelanggan': 2,
      'Nama': 'Jane Doe',
      'Email': 'jane@example.com',
      'Password': '******',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StyledDataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Nama')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Password'))
      ],
      rows: pelangganData.map((pelanggan) {
        return DataRow(
          selected: PelangganTableState.selectedRowPelanggan?['id_pelanggan'] ==
              pelanggan['id_pelanggan'],
          color: WidgetStateProperty.resolveWith<Color?>((states) {
            if (PelangganTableState.selectedRowPelanggan?['id_pelanggan'] ==
                pelanggan['id_pelanggan']) {
              return Colors.blue.withOpacity(0.2);
            }
            return null;
          }),
          onSelectChanged: (isSelected) {
            setState(() {
              if (isSelected != null && isSelected) {
                PelangganTableState.selectedRowPelanggan = pelanggan;
              } else {
                PelangganTableState.selectedRowPelanggan = null;
              }
            });
          },
          cells: [
            DataCell(Text(pelanggan['id_pelanggan'].toString())),
            DataCell(Text(pelanggan['Nama'])),
            DataCell(Text(pelanggan['Email'])),
            DataCell(Text(pelanggan['Password'])),
          ],
        );
      }).toList(),
    );
  }
}
