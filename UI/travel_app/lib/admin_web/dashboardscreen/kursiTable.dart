import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class KursiTable extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> kursiFuture;

  const KursiTable({Key? key, required this.kursiFuture}) : super(key: key);

  @override
  State<KursiTable> createState() => KursiTableState();
}

class KursiTableState extends State<KursiTable> {
  static Map<String, dynamic>? selectedRowKursi;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.kursiFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final kursiData = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            child: StyledDataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nomor Kursi')),
                DataColumn(label: Text('ID Kendaraan')),
                DataColumn(label: Text('Status Ketersediaan')),
              ],
              rows: kursiData.map((kursi) {
                return DataRow(
                  selected: KursiTableState.selectedRowKursi?['id_kursi'] ==
                      kursi['id_kursi'],
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
                    DataCell(Text(kursi['statusKetersediaan'].toString())),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
