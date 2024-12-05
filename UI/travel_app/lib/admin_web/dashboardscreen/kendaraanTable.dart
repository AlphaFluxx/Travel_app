import 'package:flutter/material.dart';
import 'styledDataTable.dart';

class KendaraanTable extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> kendaraanFuture;

  const KendaraanTable({Key? key, required this.kendaraanFuture})
      : super(key: key);

  @override
  State<KendaraanTable> createState() => KendaraanTableState();
}

class KendaraanTableState extends State<KendaraanTable> {
  static Map<String, dynamic>? selectedRowKendaraan;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.kendaraanFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final kendaraanData = snapshot.data!;

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
                        DataColumn(label: Text('Jenis Kendaraan')),
                        DataColumn(label: Text('Kapasitas')),
                      ],
                      rows: kendaraanData.map((kendaraan) {
                        return DataRow(
                          selected: KendaraanTableState
                                  .selectedRowKendaraan?['id_kendaraan'] ==
                              kendaraan['id_kendaraan'],
                          onSelectChanged: (isSelected) {
                            setState(() {
                              if (isSelected != null && isSelected) {
                                KendaraanTableState.selectedRowKendaraan =
                                    kendaraan;
                              } else {
                                KendaraanTableState.selectedRowKendaraan = null;
                              }
                            });
                          },
                          cells: [
                            DataCell(
                                Text(kendaraan['id_kendaraan'].toString())),
                            DataCell(
                                Text(kendaraan['jenis_kendaraan'].toString())),
                            DataCell(Text(kendaraan['kapasitas'].toString())),
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
