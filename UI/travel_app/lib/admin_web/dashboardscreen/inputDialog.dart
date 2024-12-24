import 'package:flutter/material.dart';
import 'package:travel_app/admin_web/utils/api/jadwalHarian.service.dart';
import 'package:travel_app/admin_web/utils/api/kursi.service.dart';
import 'package:travel_app/admin_web/utils/api/transaksi.service.dart';
import '../utils/api/pelanggan.service.dart';
import '../utils/api/kendaraan.service.dart';

class InputDialog extends StatefulWidget {
  final Map<String, String> fields;
  final Map<String, dynamic>? initialData;
  final String activeTable;
  final Map<String, dynamic>? indikator;
  final Function refreshTable;

  const InputDialog({
    Key? key,
    required this.fields,
    this.initialData,
    required this.activeTable,
    this.indikator,
    required this.refreshTable,
  }) : super(key: key);

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late Map<String, TextEditingController> controllers;
  late Map<String, String?> errors;

  List<Map<String, dynamic>> availableKendaraan = [];
  List<Map<String, dynamic>> availableJadwal = [];
  List<Map<String, dynamic>> availableKursi = [];
  List<Map<String, dynamic>> availablePelanggan = [];
  String? selectedKendaraanId;
  String? selectedJadwalId;
  String? selectedKursiId;
  String? selectedPelangganId;

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

    // Fetch data untuk dropdown sesuai tabel aktif
    if (widget.activeTable == 'kursi') {
      KendaraannService.getAllKendaraan().then((kendaraanData) {
        setState(() {
          availableKendaraan = kendaraanData;
          print("Kendaraan data fetched: $availableKendaraan");
        });
      }).catchError((error) {
        print("Error fetching kendaraan data: $error");
      });
    } else if (widget.activeTable == 'jadwalharian') {
      KendaraannService.getAllKendaraan().then((kendaraanData) {
        setState(() {
          availableKendaraan = kendaraanData;
          print("Kendaraan data fetched: $availableKendaraan");
        });
      }).catchError((error) {
        print("Error fetching kendaraan data: $error");
      });
    } else if (widget.activeTable == 'transaksi') {
      PelangganService.getAllPelanggan().then((pelangganData) {
        setState(() {
          availablePelanggan = pelangganData;
          print("Pelanggan data fetched: $availablePelanggan");
        });
      }).catchError((error) {
        print("Error fetching pelanggan data: $error");
      });

      JadwalharianService.getAllJadwalHarian().then((jadwalData) {
        setState(() {
          availableJadwal = jadwalData;
          print("Jadwal data fetched: $availableJadwal");
        });
      }).catchError((error) {
        print("Error fetching jadwal data: $error");
      });

      KursinService.getAllKursi().then((kursiData) {
        setState(() {
          availableKursi = kursiData;
          print("Kursi data fetched: $availableKursi");
        });
      }).catchError((error) {
        print("Error fetching kursi data: $error");
      });
    }
  }

  bool validateFields() {
    bool isValid = true;
    final newErrors = <String, String?>{};

    controllers.forEach((key, controller) {
      if (controller.text.isEmpty &&
          !(widget.fields[key]!.contains("optional") ?? false)) {
        isValid = false;
        newErrors[key] = "$key tidak boleh kosong";
      }
    });

    setState(() {
      errors = newErrors;
    });

    return isValid;
  }

  Future<void> saveData() async {
    if (validateFields()) {
      final result = {
        ...controllers.map((key, controller) => MapEntry(key, controller.text)),
      };

      try {
        if (widget.indikator!.isEmpty) {
          if (widget.activeTable == "kursi") {
            await KursinService.createKursi(result);
          } else if (widget.activeTable == "jadwalharian") {
            await JadwalharianService.createJadwalHarian(result);
          } else if (widget.activeTable == "transaksi") {
            await TransaksiService.createTransaksi(result);
          } else if (widget.activeTable == "pelanggan") {
            await PelangganService.createPelanggan(result);
          } else if (widget.activeTable == "kendaraan") {
            await KendaraannService.createKendaraan(result);
          }
        } else {
          if (widget.activeTable == "kursi") {
            await KursinService.updateKursi(
                widget.indikator!['id_kursi'], result);
          } else if (widget.activeTable == "jadwalharian") {
            await JadwalharianService.updateJadwalHarian(
                widget.indikator!['id_jadwal'], result);
          } else if (widget.activeTable == "transaksi") {
            await TransaksiService.updateTransaksi(
                widget.indikator!['id_transaksi'], result);
          } else if (widget.activeTable == "pelanggan") {
            await PelangganService.updatePelanggan(
                widget.indikator!['id_pelanggan'], result);
          } else if (widget.activeTable == "kendaraan") {
            await KendaraannService.updateKendaraan(
                widget.indikator!['id_kendaraan'], result);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan data: $e")),
        );
      }
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

            // Dropdown untuk Kursi
            if (fieldName == 'id_kendaraan' && widget.activeTable == 'kursi') {
              return buildDropdown(
                fieldName,
                selectedKendaraanId,
                availableKendaraan,
                'Pilih Kendaraan',
                (newValue) {
                  setState(() {
                    selectedKendaraanId = newValue;
                    controllers[fieldName]?.text = newValue ?? '';
                  });
                },
              );
            }

            // Dropdown untuk Jadwalharian
            if (fieldName == 'id_kendaraan' &&
                widget.activeTable == 'jadwalharian') {
              return buildDropdown(
                fieldName,
                selectedKendaraanId,
                availableKendaraan,
                'Pilih Kendaraan',
                (newValue) {
                  setState(() {
                    selectedKendaraanId = newValue;
                    controllers[fieldName]?.text = newValue ?? '';
                  });
                },
              );
            }

            // Dropdown untuk Transaksi
            if (widget.activeTable == 'transaksi') {
              if (fieldName == 'id_pelanggan') {
                return buildDropdown(
                  fieldName,
                  selectedPelangganId,
                  availablePelanggan,
                  'Pilih Pelanggan',
                  (newValue) {
                    setState(() {
                      selectedPelangganId = newValue;
                      controllers[fieldName]?.text = newValue ?? '';
                    });
                  },
                );
              } else if (fieldName == 'id_jadwal') {
                return buildDropdown(
                  fieldName,
                  selectedJadwalId,
                  availableJadwal,
                  'Pilih Jadwal',
                  (newValue) {
                    setState(() {
                      selectedJadwalId = newValue;
                      controllers[fieldName]?.text = newValue ?? '';
                    });
                  },
                );
              } else if (fieldName == 'id_kursi') {
                return buildDropdown(
                  fieldName,
                  selectedKursiId,
                  availableKursi,
                  'Pilih Kursi',
                  (newValue) {
                    setState(() {
                      selectedKursiId = newValue;
                      controllers[fieldName]?.text = newValue ?? '';
                    });
                  },
                );
              }
            }

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
          onPressed: () async {
            await saveData();
            widget.refreshTable();
            Navigator.of(context).pop();
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }

  Widget buildDropdown(
    String fieldName,
    String? selectedValue,
    List<Map<String, dynamic>> availableData,
    String labelText,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: availableData.map((data) {
          return DropdownMenuItem<String>(
            value: data['id_${fieldName.split('_')[1]}'].toString(),
            child: Text(data['id_${fieldName.split('_')[1]}'].toString()),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          errorText: errors[fieldName],
        ),
      ),
    );
  }
}
