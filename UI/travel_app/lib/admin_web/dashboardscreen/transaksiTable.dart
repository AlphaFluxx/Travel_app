import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class TransaksiTable extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> transaksiFuture;

  const TransaksiTable({Key? key, required this.transaksiFuture})
      : super(key: key);

  @override
  State<TransaksiTable> createState() => TransaksiTableState();
}

class TransaksiTableState extends State<TransaksiTable> {
  static Map<String, dynamic>? selectedRowTransaksi;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.transaksiFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final transaksiData = snapshot.data!;

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
                        DataColumn(label: Text('ID Transaksi')),
                        DataColumn(label: Text('ID Pelanggan')),
                        DataColumn(label: Text('ID Jadwal')),
                        DataColumn(label: Text('ID Kursi')),
                        DataColumn(label: Text('Tanggal Reservasi')),
                        DataColumn(label: Text('Status Transaksi')),
                      ],
                      rows: transaksiData.map((transaksi) {
                        return DataRow(
                          selected: TransaksiTableState
                                  .selectedRowTransaksi?['id_transaksi'] ==
                              transaksi['id_transaksi'],
                          onSelectChanged: (isSelected) {
                            setState(() {
                              if (isSelected != null && isSelected) {
                                TransaksiTableState.selectedRowTransaksi =
                                    transaksi;
                              } else {
                                TransaksiTableState.selectedRowTransaksi = null;
                              }
                            });
                          },
                          cells: [
                            DataCell(
                                Text(transaksi['id_transaksi'].toString())),
                            DataCell(
                                Text(transaksi['id_pelanggan'].toString())),
                            DataCell(Text(transaksi['id_jadwal'].toString())),
                            DataCell(Text(transaksi['id_kursi'].toString())),
                            DataCell(Text(
                                transaksi['tanggal_reservasi'].toString())),
                            DataCell(
                                Text(transaksi['status_transaksi'].toString())),
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
