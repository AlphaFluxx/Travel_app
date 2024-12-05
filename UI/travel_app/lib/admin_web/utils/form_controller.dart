import 'package:flutter/material.dart';

class FormController {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, String?> errors = {};
  final Map<String, dynamic> fields;

  FormController({required this.fields, Map<String, dynamic>? initialData}) {
    // Inisialisasi controller untuk setiap field
    fields.forEach((key, value) {
      String initialValue = initialData?[key]?.toString() ?? '';
      controllers[key] = TextEditingController(text: initialValue);
      errors[key] = null;
    });
  }

  TextEditingController getController(String key) {
    return controllers[key]!;
  }

  // Menambahkan method getControllers
  Map<String, TextEditingController> getControllers() {
    return controllers;
  }

  String? getError(String key) {
    return errors[key];
  }

  // Menambahkan method setError untuk menetapkan error
  void setError(String key, String errorMessage) {
    errors[key] = errorMessage;
  }

  bool validateFields() {
    bool isValid = true;
    final newErrors = <String, String?>{};

    controllers.forEach((key, controller) {
      if (controller.text.isEmpty) {
        isValid = false;
        newErrors[key] = "$key tidak boleh kosong";
      } else {
        newErrors[key] = null;
      }
    });

    errors.clear();
    errors.addAll(newErrors);
    return isValid;
  }

  Map<String, dynamic> getFormData() {
    return controllers.map((key, controller) {
      return MapEntry(key, controller.text);
    });
  }

  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
  }
}