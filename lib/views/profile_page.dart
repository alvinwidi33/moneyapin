import 'package:flutter/material.dart';
import 'package:moneyapin/theme/app_theme.dart';
import 'package:moneyapin/theme/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child:Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Profile", style: AppTheme.buttonStyle.copyWith(color: Colors.black)),
                      Icon(Icons.edit_outlined)
                    ],
                  ),
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.primary,
                  ),
                  const SizedBox(height: 4),
                  Text("Alex M.", style: AppTheme.headingStyle),
                  const SizedBox(height: 4),
                  Text("alex.m@example.com", style: AppTheme.bodyStyle),
                  const SizedBox(height:12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ACCOUNT SETTINGS", 
                      style: AppTheme.labelStyle.copyWith(color:Colors.black)
                    )
                  ),
                  const SizedBox(height:12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: "Personal Information",
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(
                          icon: Icons.lock_outline,
                          title: "Change Password",
                          onTap: () {
                            Navigator.pushNamed(context, '/change-password');
                          },
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(
                          icon: Icons.account_balance_outlined,
                          title: "Linked Accounts",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height:26),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PREFERENCES", 
                      style: AppTheme.labelStyle.copyWith(color:Colors.black)
                    )
                  ),
                  const SizedBox(height:12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          title: "Notifications",
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(
                          icon: Icons.shield_outlined,
                          title: "Privacy & Security",
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(
                          icon: Icons.language,
                          title: "Language",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.symmetric(vertical:4),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9DDDD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 20,
                      ),
                      label: Text(
                        "Log Out",
                        style: AppTheme.bodyStyle.copyWith(color:Colors.red)
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24)
                ],
              ),
            ),
          )
        )
      ),
      bottomNavigationBar: SafeArea(
        child:NavBar(
          currentIndex: _currentIndex, 
          onTap: (index){
            if (index == _currentIndex) return;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/reports');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/wallets');
            } else if (index == 3) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
          onAddTap: () {
            Navigator.pushNamed(context, '/add');
          },
        ) ,
      ),
    );
  }
}
Widget _buildMenuItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, size: 22, color: Colors.grey[700]),
    title: Text(
      title,
      style: AppTheme.bodyStyle.copyWith(color:Colors.black)
    ),
    trailing: const Icon(
      Icons.chevron_right,
      size: 20,
      color: Colors.grey,
    ),
    onTap: onTap,
  );
}