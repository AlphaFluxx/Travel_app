import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final String title; // Judul dialog (e.g., "Tambah Pelanggan")
  final Map<String, dynamic> fields; // Fields yang akan diisi pengguna
  final Map<String, dynamic>? initialData; // Data awal (untuk edit)
  final Function(Map<String, dynamic>) onSubmit; // Callback saat submit

  const InputDialog({
    super.key,
    required this.title,
    required this.fields,
    this.initialData,
    required this.onSubmit,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    // Inisialisasi TextEditingController untuk setiap field
    controllers = widget.fields.map((key, _) {
      // Periksa jika initialData tidak null, ambil nilainya
      String initialValue = widget.initialData != null && widget.initialData!.containsKey(key)
          ? widget.initialData![key]?.toString() ?? '' // Ambil dari initialData jika ada
          : ''; // Default kosong jika tidak ada di initialData

      print('Field $key, initial data: $initialValue'); // Debugging nilai initial

      return MapEntry(
        key,
        TextEditingController(text: initialValue),
      );
    });
  }

  @override
  void dispose() {
    // Bersihkan semua controller untuk menghindari kebocoran memori
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.fields.entries.map((entry) {
            final fieldName = entry.key;
            final fieldType = entry.value;

            // Menambahkan dropdown untuk StatusKetersediaan
            if (fieldName == 'StatusKetersediaan') {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<int>(
                  value: widget.initialData?['StatusKetersediaan'] ?? 1, // Default "Available"
                  onChanged: (int? newValue) {
                    setState(() {
                      controllers['StatusKetersediaan'] = TextEditingController(text: newValue.toString());
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Available'),
                    ),
                    DropdownMenuItem(
                      value: 0,
                      child: Text('Unavailable'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Status Ketersediaan',
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: controllers[fieldName],
                keyboardType: fieldType == 'number' ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  labelText: fieldName,
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog tanpa melakukan apa-apa
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            final result = controllers.map((key, controller) {
              final value = controller.text;
              final fieldType = widget.fields[key];

              // Debugging hasil konversi nilai
              print('Field $key, value: $value, type: $fieldType');

              // Menangani konversi tipe data berdasarkan fieldType
              return MapEntry(
                key,
                fieldType == 'number' 
                    ? (int.tryParse(value) ?? 0)  // Jika 'number', coba parse sebagai int
                    : value,  // Jika bukan 'number', simpan sebagai string
              );
            });

            widget.onSubmit(result); // Panggil callback dengan data yang diisi
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
