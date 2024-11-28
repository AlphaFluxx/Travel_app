import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class KursiTable extends StatefulWidget {
  @override
  State<KursiTable> createState() => KursiTableState();
}

class KursiTableState extends State<KursiTable> {
  static Map<String, dynamic>? selectedRowKursi;

  static final List<Map<String, dynamic>> kursiData = [
    {
      'id_kursi': 1,
      'nomor_kursi': 101,
      'id_kendaraan': 10,
      'statusKetersediaan': 1, // Available
    },
    {
      'id_kursi': 2,
      'nomor_kursi': 102,
      'id_kendaraan': 11,
      'statusKetersediaan': 0, // Unavailable
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StyledDataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Nomor Kursi')),
        DataColumn(label: Text('ID Kendaraan')),
        DataColumn(label: Text('StatusKetersediaan')),
      ],
      rows: kursiData.map((kursi) {
        return DataRow(
          selected: KursiTableState.selectedRowKursi?['id_kursi'] == kursi['id_kursi'],
          color: WidgetStateProperty.resolveWith<Color?>((states) {
            if (KursiTableState.selectedRowKursi?['id_kursi'] == kursi['id_kursi']) {
              return Colors.blue.withOpacity(0.2);
            }
            return null;
          }),
          onSelectChanged: (isSelected) {
            setState(() {
              if (isSelected != null && isSelected) {
                KursiTableState.selectedRowKursi = kursi;
              } else {
                KursiTableState.selectedRowKursi = null;
              }
            });
          },
          cells: [
            DataCell(Text(kursi['id_kursi'].toString())),
            DataCell(Text(kursi['nomor_kursi'].toString())),
            DataCell(Text(kursi['id_kendaraan'].toString())),
            DataCell(
              DropdownButton<int>(
                value: kursi['statusKetersediaan'],
                onChanged: (int? newValue) {
                  setState(() {
                    kursi['statusKetersediaan'] = newValue;
                  });
                },
                items: [
                  const DropdownMenuItem(
                    value: 1,
                    child: Text('Available'),
                  ),
                  const DropdownMenuItem(
                    value: 0,
                    child: Text('Unavailable'),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
