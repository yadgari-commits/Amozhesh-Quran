import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile".tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryGreen,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "Guest User",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildSettingTile(
              context,
              title: "language".tr(),
              subtitle: _getLanguageName(context.locale.languageCode),
              icon: Icons.language,
              onTap: () => _showLanguageDialog(context),
            ),
            _buildSettingTile(
              context,
              title: "dark_mode".tr(),
              subtitle: "System Default",
              icon: Icons.dark_mode_outlined,
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              title: "notifications".tr(),
              subtitle: "Daily Reminders",
              icon: Icons.notifications_none,
              onTap: () {},
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
                onPressed: () {},
                child: Text("logout".tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'ar': return 'العربية';
      case 'fa': return 'دری';
      case 'ps': return 'پشتو';
      default: return code;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("select_language".tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption(context, "English", const Locale('en', 'US')),
            _languageOption(context, "العربية", const Locale('ar', 'SA')),
            _languageOption(context, "دری", const Locale('fa', 'AF')),
            _languageOption(context, "پشتو", const Locale('ps', 'AF')),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'ar': return 'Arabic';
      case 'fa': return 'Dari (Persian)';
      case 'ps': return 'Pashto';
      default: return code;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption(context, "English", const Locale('en', 'US')),
            _languageOption(context, "العربية", const Locale('ar', 'SA')),
            _languageOption(context, "دری", const Locale('fa', 'AF')),
            _languageOption(context, "پشتو", const Locale('ps', 'AF')),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(BuildContext context, String name, Locale locale) {
    return ListTile(
      title: Text(name),
      onTap: () {
        context.setLocale(locale);
        Navigator.pop(context);
      },
      trailing: context.locale == locale ? const Icon(Icons.check, color: AppColors.primaryGreen) : null,
    );
  }
}
