
import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'add_medicine_page.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Vitamin D',
      'details': '1 tablet • 1000 IU',
      'time': '8:00 AM',
      'status': 'Taken',
      'icon': Icons.wb_sunny_outlined,
    },
    {
      'name': 'Omega 3',
      'details': '1 capsule • 1000 mg',
      'time': '2:00 PM',
      'status': 'Pending',
      'icon': Icons.water_drop_outlined,
    },
    {
      'name': 'Vitamin C',
      'details': '1 tablet • 500 mg',
      'time': '8:00 PM',
      'status': 'Pending',
      'icon': Icons.medication_outlined,
    },
    {
      'name': 'Magnesium',
      'details': '1 tablet • 250 mg',
      'time': '10:00 PM',
      'status': 'Pending',
      'icon': Icons.local_pharmacy_outlined,
    },
  ];

  int get takenCount {
    return medicines
        .where((medicine) => medicine['status'] == 'Taken')
        .length;
  }

  int get remainingCount => medicines.length - takenCount;

  void markAsTaken(int index) {
    setState(() {
      medicines[index]['status'] = 'Taken';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medication marked as taken!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Future<void> openAddMedicinePage() async {
    final newMedicine = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicinePage(),
      ),
    );

    if (!mounted) return;

    if (newMedicine != null) {
      setState(() {
        medicines.add(newMedicine);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicine added successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      buildMedicinesPage(),
      buildHistoryPage(),
      buildProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            activeIcon: Icon(Icons.medication),
            label: 'Medicines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // HOME PAGE

  Widget buildHomePage() {
    final nextIndex = medicines.indexWhere(
          (medicine) => medicine['status'] == 'Pending',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),

          const SizedBox(height: 25),

          const Text(
            'Good morning, Mohamed 👋',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Let’s keep your health on track today.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 25),

          buildProgressCard(),

          const SizedBox(height: 25),

          sectionTitle('Next Medication'),

          const SizedBox(height: 12),

          if (nextIndex == -1)
            buildAllDoneCard()
          else
            buildNextMedication(nextIndex),

          const SizedBox(height: 25),

          sectionTitle('Today’s Medicines'),

          const SizedBox(height: 12),

          ...List.generate(
            medicines.length,
                (index) => buildMedicineItem(index),
          ),

          const SizedBox(height: 25),

          sectionTitle('Quick Access'),

          const SizedBox(height: 12),

          buildQuickAccess(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // HEADER

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'MediCue',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications will appear here.'),
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.dark,
            size: 27,
          ),
        ),
      ],
    );
  }

  // DAILY PROGRESS

  Widget buildProgressCard() {
    final progress = medicines.isEmpty ? 0.0 : takenCount / medicines.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            Color(0xFF087F91),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today’s Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 85,
                      height: 85,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$takenCount of ${medicines.length} doses',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$remainingCount medications remaining',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // NEXT MEDICATION

  Widget buildNextMedication(int index) {
    final medicine = medicines[index];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              medicineIcon(medicine['icon'] as IconData),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine['name'] as String,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      medicine['details'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.access_time,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                medicine['time'] as String,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => markAsTaken(index),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Mark as Taken'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAllDoneCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.primary,
            size: 35,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Great job! You have completed all your medications for today.',
              style: TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MEDICINE ITEM

  Widget buildMedicineItem(int index) {
    final medicine = medicines[index];
    final isTaken = medicine['status'] == 'Taken';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          medicineIcon(medicine['icon'] as IconData),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine['name'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${medicine['time']} • ${medicine['details']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isTaken
                  ? const Color(0xFFE5F7EF)
                  : const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              medicine['status'] as String,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isTaken
                    ? const Color(0xFF239B68)
                    : const Color(0xFFD58B25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget medicineIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 25,
      ),
    );
  }

  // QUICK ACCESS

  Widget buildQuickAccess() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        quickAccessItem(
          Icons.calendar_month_outlined,
          'My Schedule',
              () => changePage(1),
        ),
        quickAccessItem(
          Icons.history,
          'Dose History',
              () => changePage(2),
        ),
        quickAccessItem(
          Icons.people_outline,
          'Caregivers',
              () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Caregivers page will be added soon.'),
              ),
            );
          },
        ),
        quickAccessItem(
          Icons.person_outline,
          'My Profile',
              () => changePage(3),
        ),
      ],
    );
  }

  Widget quickAccessItem(
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 21,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
    );
  }

  // MEDICINES PAGE

  Widget buildMedicinesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'My Medicines',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage and keep track of your medications.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 25),

          ...List.generate(
            medicines.length,
                (index) => buildMedicineItem(index),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: openAddMedicinePage,
              icon: const Icon(Icons.add),
              label: const Text('Add New Medicine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HISTORY PAGE

  Widget buildHistoryPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Dose History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep track of your medication activity.',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: medicines.isEmpty
                ? const Center(child: Text('No medicines yet.'))
                : ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                return buildMedicineItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // PROFILE PAGE

  Widget buildProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: const BoxDecoration(
                    color: AppColors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 55,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Mohamed Neyazy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Patient Account',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          profileOption(Icons.person_outline, 'Personal Information'),
          profileOption(Icons.people_outline, 'My Caregivers'),
          profileOption(
            Icons.notifications_outlined,
            'Notification Settings',
          ),
          profileOption(Icons.settings_outlined, 'Settings'),
          profileOption(Icons.logout, 'Log Out'),
        ],
      ),
    );
  }

  Widget profileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: AppColors.textGrey,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title page will be added soon.'),
            ),
          );
        },
      ),
    );
  }
}
