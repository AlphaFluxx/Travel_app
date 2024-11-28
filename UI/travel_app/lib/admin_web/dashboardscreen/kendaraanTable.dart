import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class KendaraanTable extends StatefulWidget {
  @override
  State<KendaraanTable> createState() => KendaraanTableState();
}

class KendaraanTableState extends State<KendaraanTable> {
  static Map<String, dynamic>? selectedRowKendaraan;

  static final List<Map<String, dynamic>> kendaraanData = [
    {
      'id_kendaraan': 1,
      'jenis_kendaraan': 'Hiace',
      'kapasitas' : 12
    },
    {
      'id_kendaraan': 2,
      'jenis_kendaraan': 'Bus',
      'kapasitas' : 24
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StyledDataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Jenis Kendaraan')),
        DataColumn(label: Text('Kapasitas')),
              ],
      rows: kendaraanData.map((kendaraan) {
        return DataRow(
          selected: KendaraanTableState.selectedRowKendaraan?['id_kendaraan'] == kendaraan['id_kendaraan'],
          color: WidgetStateProperty.resolveWith<Color?>((states) {
            if (KendaraanTableState.selectedRowKendaraan?['id_kendaraan'] == kendaraan['id_kendaraan']) {
              return Colors.blue.withOpacity(0.2);
            }
            return null;
          }),
          onSelectChanged: (isSelected) {
            setState(() {
              if (isSelected != null && isSelected) {
                KendaraanTableState.selectedRowKendaraan = kendaraan;
              } else {
                KendaraanTableState.selectedRowKendaraan = null;
              }
            });
          },
          cells: [
            DataCell(Text(kendaraan['id_kendaraan'].toString())),
            DataCell(Text(kendaraan['jenis_kendaraan'].toString())),
            DataCell(Text(kendaraan['kapasitas'].toString())),
          ],
        );
      }).toList(),
    );
  }
}
