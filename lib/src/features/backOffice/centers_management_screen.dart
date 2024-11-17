import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/backOffice/help_center_validators.dart';
import 'package:alamo/src/features/map/domain/help_center.dart';
import 'package:alamo/src/features/map/presentation/map_controller.dart';
import 'package:alamo/src/widgets/dropdown_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alamo/src/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class HelpCenterCreationScreen extends ConsumerStatefulWidget {
  const HelpCenterCreationScreen({super.key});

  @override
  createState() => _HelpCenterCreationScreenState();
}

class _HelpCenterCreationScreenState extends ConsumerState<HelpCenterCreationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name, address, contactNumber, category;
  late Map<String, Map<String, String>> openingHours;

  // Create an instance of the controller and validators
  final validators = HelpCenterValidators();

  List<String> categories = ['alimentacion', 'refugio', 'salud', 'vestimenta'];
  List<String> daysOfWeek = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final adressController = TextEditingController();
  final streetNumberController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    openingHours = {};
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Centro de Ayuda')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width / 3),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              _buildTextFormField(
                label: 'Nombre del Centro',
                controller: nameController,
                validator: (value) => validators.nameErrorText(value ?? ''),
              ),
              gapH16,
              // Category Picker (dropdown)
              _buildDropdownField(
                label: 'Categoría',
                controller: categoryController,
                items: categories,
                validator: (value) => validators.categoryErrorText(value!),
              ),
              gapH16,
              // Address fields
              _buildTextFormField(
                label: 'Calle',
                controller: adressController,
                validator: (value) => validators.nameErrorText(value ?? ''),
              ),
              gapH16,
              _buildTextFormField(
                label: 'Número de puerta',
                controller: streetNumberController,
                validator: (value) => validators.nameErrorText(value ?? ''),
              ),
              gapH16,
              // Contact number field (Uruguayan phone format)
              _buildTextFormField(
                label: 'Número de contacto',
                controller: phoneNumberController,
                validator: (value) => validators.phoneNumberErrorText(value ?? ''),
                keyboardType: TextInputType.phone,
              ),
              gapH16,
              // Opening hours picker for each day
              const Text('Selecciona las horas de apertura para cada día:'),
              gapH8,
              for (var day in daysOfWeek) _buildDayPicker(day),
              gapH16,
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Crear Centro de Ayuda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        gapH4,
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: Colors.black)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: Colors.red)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: Colors.green)),
          ),
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required List<String> items,
    required FormFieldValidator<String> validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      validator: validator,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item.toUpperCase()),
        );
      }).toList(),
      onChanged: (value) => controller.text = value ?? '',
    );
  }

// Helper function to build the time picker for each day with the "Closed" option
  Widget _buildDayPicker(String day) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Day label
        SizedBox(
          width: 100,
          child: Text(day, style: const TextStyle(fontSize: 16)),
        ),
        // Text for "Desde" (Opening Time)
        if (openingHours[day]?.containsKey('closed') != true) const Text("Desde"),
        // Opening Time Picker (only active if the day is not closed)
        if (openingHours[day]?.containsKey('closed') != true)
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _getTimeForDay(day, isOpening: true),
              );
              if (time != null) {
                setState(() {
                  openingHours[day] = {
                    'open': _formatTime(time),
                  };
                });
              }
            },
          ),
        // Display selected opening time or placeholder
        openingHours[day]?.containsKey('open') == true
            ? Text(openingHours[day]!['open'] ?? 'Seleccionar hora', style: const TextStyle(fontSize: 16))
            : const Text(''),
        const SizedBox(width: 16),
        if (openingHours[day]?.containsKey('closed') != true) const Text("Hasta"),
        // Closing Time Picker (only active if the day is not closed)
        if (openingHours[day]?.containsKey('closed') != true)
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _getTimeForDay(day, isOpening: false),
              );
              if (time != null) {
                setState(() {
                  openingHours[day] = {
                    'open': openingHours[day]?['open'] ?? '08:00',
                    'close': _formatTime(time),
                  };
                });
              }
            },
          ),
        // Display selected closing time or placeholder
        openingHours[day]?.containsKey('close') == true
            ? Text(openingHours[day]!['close'] ?? 'Seleccionar hora', style: const TextStyle(fontSize: 16))
            : const Text(''),
        gapW20,
        if (openingHours[day]?.containsKey('closed') != true) const Text("Cerrado"),
        Checkbox(
          activeColor: Colors.white,
          semanticLabel: "Cerrado",
          value: openingHours[day]?.containsKey('closed') ?? false,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                // Mark the day as closed
                openingHours[day] = {'closed': 'true'};
              } else {
                // Reset the opening and closing times
                openingHours[day]?.remove('closed');
              }
            });
          },
        ),
        if (openingHours[day]?.containsKey('closed') == true) const Text('Cerrado', style: TextStyle(fontSize: 16, color: Colors.red)),
      ],
    );
  }

// Helper function to get the opening or closing time for a specific day
  TimeOfDay _getTimeForDay(String day, {required bool isOpening}) {
    if (openingHours[day] != null) {
      final timeString = isOpening ? openingHours[day]!['open'] : openingHours[day]!['close'];
      final parts = timeString?.split(':');
      if (parts != null && parts.length == 2) {
        final hour = int.tryParse(parts[0]) ?? 8;
        final minute = int.tryParse(parts[1]) ?? 0;
        return TimeOfDay(hour: hour, minute: minute);
      }
    }
    return isOpening ? const TimeOfDay(hour: 8, minute: 0) : const TimeOfDay(hour: 18, minute: 0);
  }

// Helper function to format TimeOfDay to hh:mm string
  String _formatTime(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  // Submit Form and handle creation
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final helpCenterJson = {
        'name': nameController.text.trim(),
        'category': categoryController.text.trim(),
        'contact_number': phoneNumberController.text.trim(),
        'address': "${adressController.text.trim()}, ${streetNumberController.text.trim()}",
        'opening_hours': openingHours,
      };

      // Call the controller method to create the help center
      await ref.read(mapControllerProvider.notifier).createHelpCenter(helpCenterJson);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Centro de ayuda creado con éxito!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
    }
  }
}
