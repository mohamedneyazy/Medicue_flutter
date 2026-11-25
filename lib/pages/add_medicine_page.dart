
import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dosageController = TextEditingController();

  String medicineType = 'Tablet';
  String frequency = 'Once daily';
  String instructions = 'After food';

  TimeOfDay reminderTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    super.dispose();
  }

  String get formattedTime {
    final hour = reminderTime.hourOfPeriod == 0
        ? 12
        : reminderTime.hourOfPeriod;

    final minute = reminderTime.minute.toString().padLeft(2, '0');
    final period = reminderTime.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  Future<void> selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );

    if (selectedTime != null) {
      setState(() {
        reminderTime = selectedTime;
      });
    }
  }

  void saveMedicine() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final newMedicine = <String, dynamic>{
      'name': nameController.text.trim(),
      'details': '${dosageController.text.trim()} • $medicineType',
      'time': formattedTime,
      'status': 'Pending',
      'icon': medicineType == 'Syrup'
          ? Icons.local_drink_outlined
          : medicineType == 'Drops'
          ? Icons.water_drop_outlined
          : medicineType == 'Injection'
          ? Icons.vaccines_outlined
          : Icons.medication_outlined,
      'frequency': frequency,
      'instructions': instructions,
    };

    Navigator.pop(context, newMedicine);
  }

  InputDecoration fieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.dark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.dark,
          ),
        ),
        title: const Text(
          'Add Medicine',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add a New Medicine',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Enter your medication details and set a reminder.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 28),

                sectionLabel('Medicine Name'),

                TextFormField(
                  controller: nameController,
                  decoration: fieldDecoration(
                    'e.g. Vitamin D',
                    Icons.medication_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the medicine name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                sectionLabel('Dosage'),

                TextFormField(
                  controller: dosageController,
                  decoration: fieldDecoration(
                    'e.g. 500 mg or 1 tablet',
                    Icons.scale_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the dosage';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                sectionLabel('Medicine Type'),

                DropdownButtonFormField<String>(
                  value: medicineType,
                  isExpanded: true,
                  decoration: fieldDecoration(
                    'Select medicine type',
                    Icons.category_outlined,
                  ),
                  items: [
                    'Tablet',
                    'Capsule',
                    'Syrup',
                    'Drops',
                    'Injection',
                    'Other',
                  ].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        medicineType = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                sectionLabel('Frequency'),

                DropdownButtonFormField<String>(
                  value: frequency,
                  isExpanded: true,
                  decoration: fieldDecoration(
                    'Select frequency',
                    Icons.repeat,
                  ),
                  items: [
                    'Once daily',
                    'Twice daily',
                    'Three times daily',
                    'Every week',
                    'As needed',
                  ].map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        frequency = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                sectionLabel('Reminder Time'),

                InkWell(
                  onTap: selectTime,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.dark,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textGrey,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                sectionLabel('Instructions'),

                DropdownButtonFormField<String>(
                  value: instructions,
                  isExpanded: true,
                  decoration: fieldDecoration(
                    'Select instructions',
                    Icons.restaurant_outlined,
                  ),
                  items: [
                    'Before food',
                    'After food',
                    'With food',
                    'No specific instructions',
                  ].map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        instructions = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveMedicine,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Save Medicine',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
