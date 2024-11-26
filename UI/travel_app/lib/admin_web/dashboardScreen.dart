import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String currentTable = 'pelanggan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        children: [
          SideMenu(
            onTableSelected: (table) {
              setState(() {
                currentTable = table;
              });
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Table: $currentTable',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: currentTable == 'pelanggan'
                        ? PelangganTable()
                        : KursiTable(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showInputDialog('Create',
                              null); // Memanggil dialog kosong untuk Create
                        },
                        child: const Text('Create'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (PelangganTableState.selectedRowPelanggan !=
                              null) {
                            // Logika untuk tabel pelanggan
                            showInputDialog('Update',
                                PelangganTableState.selectedRowPelanggan);
                          } else if (KursiTableState.selectedRow != null) {
                            // Logika untuk tabel kursi
                            showInputDialog(
                                'Update', KursiTableState.selectedRow);
                          } else {
                            // Menampilkan Snackbar jika belum ada data yang dipilih
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Silakan pilih data terlebih dahulu!'),
                              ),
                            );
                          }
                        },
                        child: const Text('Update'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (PelangganTableState.selectedRowPelanggan !=
                              null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Confirmation'),
                                  content: const Text(
                                      'Are you sure you want to delete this item?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Logika untuk Delete di sini
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Menampilkan Snackbar jika belum ada data yang dipilih
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Silakan pilih data terlebih dahulu!')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showInputDialog(String action, Map<String, dynamic>? selectedData) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController idkendaraanController = TextEditingController();
    String? statusKetersediaan;

    if (selectedData != null) {
      nameController.text =
          selectedData['Nama'] ?? selectedData['Nomor Kursi'] ?? '';
      emailController.text = selectedData['Email'] ?? '';
      passwordController.text = selectedData['Password'] ?? '';
      idkendaraanController.text = selectedData['Id kendaraan'] ?? '';
      if (currentTable == 'kursi') {
        statusKetersediaan = selectedData['StatusKetersediaan'] == 1
            ? 'Available'
            : 'Unavailable';
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$action Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentTable == 'pelanggan') ...[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
              ] else if (currentTable == 'kursi') ...[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nomor Kursi'),
                ),
                TextField(
                  controller: idkendaraanController,
                  decoration: const InputDecoration(labelText: 'Id kendaraan'),
                ),
                DropdownButtonFormField<String>(
                  value: statusKetersediaan,
                  decoration:
                      const InputDecoration(labelText: 'Status Ketersediaan'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Available', child: Text('Available')),
                    DropdownMenuItem(
                        value: 'Unavailable', child: Text('Unavailable')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      statusKetersediaan = value;
                    });
                  },
                ),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (currentTable == 'pelanggan') {
                  final newData = {
                    'Nama': nameController.text,
                    'Email': emailController.text,
                    'Password': passwordController.text,
                  };
                  // Tambahkan logika simpan data pelanggan
                } else if (currentTable == 'kursi') {
                  final newData = {
                    'Nomor Kursi': nameController.text,
                    'Id kendaraan': idkendaraanController.text,
                    'StatusKetersediaan':
                        statusKetersediaan == 'Available' ? 1 : 0,
                  };
                  // Tambahkan logika simpan data kursi
                }
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class SideMenu extends StatelessWidget {
  final Function(String) onTableSelected;

  const SideMenu({Key? key, required this.onTableSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          ListTile(
            leading: const Icon(Icons.people, color: Colors.black),
            title: const Text('Pelanggan'),
            onTap: () => onTableSelected('pelanggan'),
          ),
          ListTile(
            leading: const Icon(Icons.chair, color: Colors.black),
            title: const Text('Kursi'),
            onTap: () => onTableSelected('kursi'),
          ),
        ],
      ),
    );
  }
}

class StyledDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const StyledDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Pengguliran horizontal
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context)
                  .size
                  .width), // Lebar minimal sama dengan layar
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: WidgetStateProperty.resolveWith(
              (states) => Colors.blue.shade300,
            ),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            dataRowColor: WidgetStateProperty.resolveWith(
              (states) => Colors.white,
            ),
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );
  }
}

class PelangganTable extends StatefulWidget {
  @override
  State<PelangganTable> createState() => PelangganTableState();
}

class PelangganTableState extends State<PelangganTable> {
  static Map<String, dynamic>? selectedRowPelanggan;

  final List<Map<String, dynamic>> pelangganData = [
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
              return Colors.blue
                  .withOpacity(0.2); // Highlight warna untuk baris terpilih
            }
            return null; // Warna default
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

class KursiTable extends StatefulWidget {
  @override
  State<KursiTable> createState() => KursiTableState();
}

class KursiTableState extends State<KursiTable> {
  static Map<String, dynamic>? selectedRow;

  final List<Map<String, dynamic>> kursiData = [
    {
      'id_kursi': 1,
      'nomor_kursi': 101,
      'id_kendaraan': 10,
      'statusKetersediaan': 1,
    },
    {
      'id_kursi': 2,
      'nomor_kursi': 102,
      'id_kendaraan': 11,
      'statusKetersediaan': 0,
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
          selected:
              KursiTableState.selectedRow?['id_kursi'] == kursi['id_kursi'],
          color: WidgetStateProperty.resolveWith<Color?>((states) {
            if (KursiTableState.selectedRow?['id_kursi'] == kursi['id_kursi']) {
              return Colors.blue
                  .withOpacity(0.2); // Highlight warna untuk baris terpilih
            }
            return null; // Warna default
          }),
          onSelectChanged: (isSelected) {
            setState(() {
              if (isSelected != null && isSelected) {
                KursiTableState.selectedRow = kursi;
              } else {
                KursiTableState.selectedRow = null;
              }
            });
          },
          cells: [
            DataCell(Text(kursi['id_kursi'].toString())),
            DataCell(Text(kursi['nomor_kursi'].toString())),
            DataCell(Text(kursi['id_kendaraan'].toString())),
            DataCell(Text(kursi['statusKetersediaan'] == 1
                ? 'Available'
                : 'Unavailable')),
          ],
        );
      }).toList(),
    );
  }
}
