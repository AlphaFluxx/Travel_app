import 'package:flutter/material.dart';
import 'package:travel_app/admin_web/utils/api/jadwalHarian.service.dart';
import 'package:travel_app/admin_web/utils/api/kursi.service.dart';
import 'package:travel_app/admin_web/utils/api/transaksi.service.dart';
import '../utils/api/pelanggan.service.dart'; // Pastikan mengimport PelangganService
import '../dashboardscreen/dashboardScreen.dart';
import '../utils/api/kendaraan.service.dart';

class InputDialog extends StatefulWidget {
  final Map<String, String> fields;
  final Map<String, dynamic>? initialData;
  final String activeTable;
  final Map<String, dynamic>? indikator;

  const InputDialog({
    Key? key,
    required this.fields,
    this.initialData,
    required this.activeTable,
    this.indikator,
  }) : super(key: key);

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late Map<String, TextEditingController> controllers;
  late Map<String, String?> errors;

  List<Map<String, dynamic>> availableKendaraan =
      []; // Daftar kendaraan untuk dropdown
  String? selectedKendaraanId; // Kendaraan yang dipilih

  @override
  void initState() {
    super.initState();
    print("Initializing InputDialog...");

    controllers = widget.fields.map((key, _) {
      String initialValue =
          widget.initialData != null && widget.initialData!.containsKey(key)
              ? widget.initialData![key]?.toString() ?? ''
              : '';
      return MapEntry(key, TextEditingController(text: initialValue));
    });

    errors = widget.fields.map((key, _) => MapEntry(key, null));

    // Fetch kendaraan data jika field "ID Kendaraan" ada
    if (widget.fields.containsKey('ID Kendaraan')) {
      print("Fetching kendaraan data...");
      KendaraannService.getAllKendaraan().then((kendaraanData) {
        setState(() {
          availableKendaraan = kendaraanData;
          print("Kendaraan data fetched: $availableKendaraan");
        });
      }).catchError((error) {
        print("Error fetching kendaraan data: $error");
      });
    }
  }

  // Validasi hanya untuk field yang kosong
  bool validateFields() {
    bool isValid = true;
    final newErrors = <String, String?>{};

    controllers.forEach((key, controller) {
      print("Validating field: $key, Value: ${controller.text}");
      // Abaikan validasi untuk field yang tidak wajib diisi
      if (controller.text.isEmpty &&
          !(widget.fields[key]!.contains("optional") ?? false)) {
        isValid = false;
        newErrors[key] = "$key tidak boleh kosong";
      }
    });

    setState(() {
      errors = newErrors;
    });

    print("Validation errors: $errors");
    return isValid;
  }

  Future<void> saveData() async {
    print("Starting save data...");
    if (validateFields()) {
      final result = {
        ...controllers.map((key, controller) => MapEntry(key, controller.text)),
      };

      print("Data to save: $result");

      try {
        if (widget.indikator!.isEmpty) {
          if (widget.activeTable == "pelanggan") {
            await PelangganService.createPelanggan(result);
          } else if (widget.activeTable == "kendaraan") {
            await KendaraannService.createKendaraan(result);
          } else if (widget.activeTable == "kursi") {
            await KursinService.createKursi(result);
          } else if (widget.activeTable == "jadwalharian") {
            await JadwalharianService.createJadwalHarian(result);
          } else if (widget.activeTable == "transaksi") {
            await TransaksiService.createTransaksi(result);
          }
        } else {
          if (widget.activeTable == "pelanggan") {
            await PelangganService.updatePelanggan(
                widget.indikator!['ID'], result);
          } else if (widget.activeTable == "kendaraan") {
            await KendaraannService.updateKendaraan(
                widget.indikator!['id_kendaraan'], result);
          } else if (widget.activeTable == "kursi") {
            await KursinService.updateKursi(
                widget.indikator!['id_kursi'], result);
          } else if (widget.activeTable == "jadwalHarian") {
            await JadwalharianService.updateJadwalHarian(
                widget.indikator!['id_jadwal'], result);
          } else if (widget.activeTable == "transaksi") {
            await TransaksiService.updateTransaksi(
                widget.indikator!['id_transaksi'], result);
          }
        }

        print("Data saved successfully, returning result.");
        Navigator.of(context).pop(result);
      } catch (e) {
        print("Error saving data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan data: $e")),
        );
      }
    } else {
      print("Validation failed. Data not saved.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Input Data"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.fields.entries.map((entry) {
            final fieldName = entry.key;
            final fieldType = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: controllers[fieldName],
                keyboardType: fieldType == 'number'
                    ? TextInputType.number
                    : TextInputType.text,
                decoration: InputDecoration(
                  labelText: fieldName,
                  border: const OutlineInputBorder(),
                  errorText: errors[fieldName],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: saveData,
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
