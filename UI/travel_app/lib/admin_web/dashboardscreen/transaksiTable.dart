import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class TransaksiTable extends StatefulWidget {
  @override
  State<TransaksiTable> createState() => TransaksiTableState();
}

class TransaksiTableState extends State<TransaksiTable> {
  static Map<String, dynamic>? selectedRowtransaksi;

  static final List<Map<String, dynamic>> transaksiData = [
    {
      'id_transaksi': 1,
      'id_pelanggan': 1,
      'id_jadwal': 12,
      'id_kursi': 1,
      'tanggal': '12-12-2004',
      'status_transaksi': 'Belum Selesai Dibayar'
    },
    {
      'id_transaksi': 2,
      'id_pelanggan': 2,
      'id_jadwal': 12,
      'id_kursi': 3,
      'tanggal': '12-15-2004',
      'status_transaksi': 'Sudah Selesai Dibayar'
    },
    {
      'id_transaksi': 3,
      'id_pelanggan': 3,
      'id_jadwal': 14,
      'id_kursi': 4,
      'tanggal': '12-16-2004',
      'status_transaksi': 'Belum Selesai Dibayar'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StyledDataTable(
          columns: const [
            DataColumn(label: Text('ID Transaksi')),
            DataColumn(label: Text('ID Pelanggan')),
            DataColumn(label: Text('ID Jadwal')),
            DataColumn(label: Text('ID Kursi')),
            DataColumn(label: Text('Tanggal')),
            DataColumn(label: Text('Status Transaksi')),
          ],
          rows: transaksiData.map((transaksi) {
            return DataRow(
              selected:
                  TransaksiTableState.selectedRowtransaksi?['id_transaksi'] ==
                      transaksi['id_transaksi'],
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                if (TransaksiTableState.selectedRowtransaksi?['id_transaksi'] ==
                    transaksi['id_transaksi']) {
                  return Colors.blue.withOpacity(0.2);
                }
                return null;
              }),
              onSelectChanged: (isSelected) {
                setState(() {
                  if (isSelected != null && isSelected) {
                    TransaksiTableState.selectedRowtransaksi = transaksi;
                  } else {
                    TransaksiTableState.selectedRowtransaksi = null;
                  }
                });
              },
              cells: [
                DataCell(Text(transaksi['id_transaksi'].toString())),
                DataCell(Text(transaksi['id_pelanggan'].toString())),
                DataCell(Text(transaksi['id_jadwal'].toString())),
                DataCell(Text(transaksi['id_kursi'].toString())),
                DataCell(Text(transaksi['tanggal'].toString())),
                DataCell(Text(transaksi['status_transaksi'].toString())),
              ],
            );
          }).toList(),
        ),
      ),
    ));
  }
}
