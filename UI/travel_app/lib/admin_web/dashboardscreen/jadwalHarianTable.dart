import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class Jadwalhariantable extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> jadwalFuture;

  const Jadwalhariantable({Key? key, required this.jadwalFuture})
      : super(key: key);

  @override
  State<Jadwalhariantable> createState() => JadwalhariantableState();
}

class JadwalhariantableState extends State<Jadwalhariantable> {
  static Map<String, dynamic>? selectedRowjadwal;
  final ScrollController _vertikalscrollController = ScrollController();
  final ScrollController _horizontallscrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.jadwalFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final jadwalData = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _horizontallscrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _vertikalscrollController,
            child: StyledDataTable(
              columns: const [
                DataColumn(label: Text('ID Jadwal')),
                DataColumn(label: Text('ID Kendaraan')),
                DataColumn(label: Text('Asal')),
                DataColumn(label: Text('Tujuan')),
                DataColumn(label: Text('Waktu Berangkat')),
                DataColumn(label: Text('Waktu Kedatangan')),
                DataColumn(label: Text('Tanggal Keberangkatan')),
                DataColumn(label: Text('Harga')),
              ],
              rows: jadwalData.map((jadwal) {
                return DataRow(
                  selected:
                      JadwalhariantableState.selectedRowjadwal?['id_jadwal'] ==
                          jadwal['id_jadwal'],
                  color: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (JadwalhariantableState
                            .selectedRowjadwal?['id_jadwal'] ==
                        jadwal['id_jadwal']) {
                      return Colors.blue.withOpacity(0.2);
                    }
                    return null;
                  }),
                  onSelectChanged: (isSelected) {
                    setState(() {
                      if (isSelected != null && isSelected) {
                        JadwalhariantableState.selectedRowjadwal = jadwal;
                      } else {
                        JadwalhariantableState.selectedRowjadwal = null;
                      }
                    });
                  },
                  cells: [
                    DataCell(Text(jadwal['id_jadwal'].toString())),
                    DataCell(Text(jadwal['id_kendaraan'].toString())),
                    DataCell(Text(jadwal['asal'].toString())),
                    DataCell(Text(jadwal['tujuan'].toString())),
                    DataCell(Text(jadwal['waktu_berangkat'].toString())),
                    DataCell(Text(jadwal['waktu_kedatangan'].toString())),
                    DataCell(Text(jadwal['tanggal_keberangkatan']
                        .toString())), // Kolom baru
                    DataCell(Text(jadwal['harga'].toString())),
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
