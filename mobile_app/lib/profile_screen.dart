import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF9),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFD4AF37),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Vander Noormahomed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "vander@stonetrading.co.mz",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _ProfileTile(
                  icon: Icons.description,
                  label: "Minhas Cotações",
                  onTap: () {},
                ),
                _ProfileTile(
                  icon: Icons.location_on,
                  label: "Endereços de Obra",
                  onTap: () {},
                ),
                _ProfileTile(
                  icon: Icons.settings,
                  label: "Configurações",
                  onTap: () {},
                ),
                const Divider(),
                _ProfileTile(
                  icon: Icons.exit_to_app,
                  label: "Sair",
                  color: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _ProfileTile({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
