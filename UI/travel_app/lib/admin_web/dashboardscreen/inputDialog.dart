import 'package:flutter/material.dart';
import '../utils/api/pelanggan.service.dart'; // Pastikan mengimport PelangganService

class InputDialog extends StatefulWidget {
  final String title;
  final Map<String, dynamic> fields;
  final Map<String, dynamic>? initialData;
  final List<String> readOnlyFields; // Tambahkan ini

  final Function(Map<String, dynamic>) onSubmit;
  final VoidCallback refreshTable;

  const InputDialog({
    super.key,
    required this.title,
    required this.fields,
    this.initialData,
    this.readOnlyFields = const [], 
    required this.onSubmit,
    required this.refreshTable,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late Map<String, TextEditingController> controllers;
  late Map<String, String?> errors; // Menyimpan pesan error untuk setiap field

  @override
  void initState() {
    super.initState();
    controllers = widget.fields.map((key, _) {
      String initialValue =
          widget.initialData != null && widget.initialData!.containsKey(key)
              ? widget.initialData![key]?.toString() ?? ''
              : ''; // Default kosong jika tidak ada
      return MapEntry(key, TextEditingController(text: initialValue));
    });

    errors = widget.fields
        .map((key, _) => MapEntry(key, null)); // Inisialisasi errors
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  bool validateFields() {
    bool isValid = true;
    final newErrors = <String, String?>{};

    controllers.forEach((key, controller) {
      if (controller.text.isEmpty) {
        isValid = false;
        newErrors[key] = "$key tidak boleh kosong"; // Pesan error
      } else {
        newErrors[key] = null;
      }
    });

    setState(() {
      errors = newErrors;
    });

    return isValid;
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

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controllers[fieldName],
                    keyboardType: fieldType == 'number'
                        ? TextInputType.number
                        : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: fieldName,
                      border: const OutlineInputBorder(),
                      errorText: errors[fieldName], // Tampilkan pesan error
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog tanpa menyimpan
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (validateFields()) {
              final result = controllers.map((key, controller) {
                final value = controller.text;
                return MapEntry(key, value);
              });

              try {
                if (widget.initialData == null) {
                  // Jika initialData tidak ada, lakukan operasi create
                  await PelangganService.createPelanggan(result);
                } else {
                  // Jika initialData ada, lakukan operasi update
                  final id =
                      widget.initialData!['ID']; // Asumsikan ada field ID
                  await PelangganService.updatePelanggan(id, result);
                }
                widget.refreshTable();
                Navigator.of(context).pop(); // Tutup dialog
              } catch (e) {
                print("Gagal menyimpan data pelanggan: $e");
              }
            }
          },
          child: const Text('Simpan'),
        )
      ],
    );
  }
}
