import 'package:cashsyncapp/commons/widgets/auth_button.dart';
import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/pages/profile/profile_screen.dart';
import 'package:cashsyncapp/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),
            ConfigConstant.sizedBoxH6,
            _buildNavigationMenu(),
            const Spacer(),
            AuthButton(
              title: "Logout",
              icon: Icons.logout,
              onPressed: () {
                authViewModel.logout();
                Navigator.pop(context);
              },
            ),
            ConfigConstant.sizedBoxH6,
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfigConstant.sizedBoxH3,
        const CircleAvatar(radius: 38, child: Icon(Icons.person, size: 38)),
        ConfigConstant.sizedBoxH3,
        Text(
          "William Smith",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        ConfigConstant.sizedBoxH1,
        Text(
          "willsmith@gmail.com",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Color(0xFFB0B0B0)),
        ),
      ],
    );
  }

  Widget _buildNavigationMenu() {
    return Column(
      children: [
        _buildNavItem(
          icon: Icons.home,
          title: "Home",
          onTap: () {
            Navigator.pop(context);
            // Navigate to Home
          },
        ),
        SizedBox(height: 8), // Add spacing between items
        _buildNavItem(
          icon: Icons.account_balance_wallet,
          title: "My Wallet",
          onTap: () {
            Navigator.pop(context);
            // Navigate to Wallet
          },
        ),
        SizedBox(height: 8),
        _buildNavItem(
          icon: Icons.person_2,
          title: "Profile",
          onTap: () {
            Navigator.pop(context);
            // Navigate to Profile
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        SizedBox(height: 8),
        _buildNavItem(
          icon: Icons.settings,
          title: "Settings",
          onTap: () {
            Navigator.pop(context);
            // Navigate to Settings
          },
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ConfigConstant.radius3),
        splashColor: const Color(0xFF8EDFEB).withOpacity(0.2),
        highlightColor: const Color(0xFF8EDFEB).withOpacity(0.1),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ConfigConstant.radius3),
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(
                icon,
                color: const Color(0xFF8EDFEB),
                size: ConfigConstant.iconSize2,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: ConfigConstant.textSizeTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
