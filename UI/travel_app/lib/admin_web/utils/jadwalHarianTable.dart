// import 'package:flutter/material.dart';
// import 'styledDataTable.dart';

// class Jadwalhariantable extends StatefulWidget {
//   @override
//   State<Jadwalhariantable> createState() => JadwalhariantableState();
// }

// class JadwalhariantableState extends State<Jadwalhariantable> {
//   static Map<String, dynamic>? selectedRowjadwal;

//   static final List<Map<String, dynamic>> jadwalData = [
//     {
//       'id_jadwal': 1,
//       'id_kendaraan': 1,
//       'asal': 12,
//       'tujuan': 1,
//       'waktu_berangkat': '12-12-2004',
//       'waktu_kedatangan': 'Belum Selesai Dibayar',
//       'harga': '2000'
//     },
//     {
//       'id_jadwal': 3,
//       'id_kendaraan': 1,
//       'asal': 12,
//       'tujuan': 1,
//       'waktu_berangkat': '12-12-2004',
//       'waktu_kedatangan': 'Belum Selesai Dibayar',
//       'harga': '2000'
//     },
//     {
//       'id_jadwal': 2,
//       'id_kendaraan': 1,
//       'asal': 12,
//       'tujuan': 1,
//       'waktu_berangkat': '12-12-2004',
//       'waktu_kedatangan': 'Belum Selesai Dibayar',
//       'harga': '2000'
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal, // Scroll horizontal untuk tabel
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical, // Scroll vertikal untuk baris tabel
//         child: StyledDataTable(
//           columns: const [
//             DataColumn(label: Text('ID jadwal')),
//             DataColumn(label: Text('ID Kendaraan')),
//             DataColumn(label: Text('Asal')),
//             DataColumn(label: Text('Tujuan')),
//             DataColumn(label: Text('Waktu Berangkat')),
//             DataColumn(label: Text('Waktu Kedatangan')),
//             DataColumn(label: Text('Harga')),
//           ],
//           rows: jadwalData.map((jadwal) {
//             return DataRow(
//               selected:
//                   JadwalhariantableState.selectedRowjadwal?['id_jadwal'] ==
//                       jadwal['id_jadwal'],
//               color: WidgetStateProperty.resolveWith<Color?>((states) {
//                 if (JadwalhariantableState.selectedRowjadwal?['id_jadwal'] ==
//                     jadwal['id_jadwal']) {
//                   return Colors.blue.withOpacity(0.2);
//                 }
//                 return null;
//               }),
//               onSelectChanged: (isSelected) {
//                 setState(() {
//                   if (isSelected != null && isSelected) {
//                     JadwalhariantableState.selectedRowjadwal = jadwal;
//                   } else {
//                     JadwalhariantableState.selectedRowjadwal = null;
//                   }
//                 });
//               },
//               cells: [
//                 DataCell(Text(jadwal['id_jadwal'].toString())),
//                 DataCell(Text(jadwal['id_kendaraan'].toString())),
//                 DataCell(Text(jadwal['asal'].toString())),
//                 DataCell(Text(jadwal['tujuan'].toString())),
//                 DataCell(Text(jadwal['waktu_berangkat'].toString())),
//                 DataCell(Text(jadwal['waktu_kedatangan'].toString())),
//                 DataCell(Text(jadwal['harga'].toString())),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
