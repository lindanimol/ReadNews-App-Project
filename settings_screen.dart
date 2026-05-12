import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gridstyle_logic.dart';
import 'theme_logic.dart';
import 'category_logic.dart';
import 'category_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;
    bool gridStyle = context.watch<GridstyleLogic>().gridStyle;
    String defaultCategory = context.watch<CategoryLogic>().category;

    return Scaffold(
      backgroundColor: dark ? const Color(0xff0F0F0F) : const Color(0xffF8F9FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          /// 🎨 APPEARANCE
          _sectionTitle("Appearance", dark),
          _buildSettingsGroup(
            dark,
            children: [
              _buildSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                subtitle: "Switch app theme",
                value: dark,
                // CHANGED: matched back to your toggleTheme method
                onChanged: (val) => context.read<ThemeLogic>().toggleTheme(),
              ),
              _buildDivider(dark),
              _buildSwitchTile(
                icon: Icons.grid_view_rounded,
                title: "Grid Layout",
                subtitle: gridStyle ? "Grid View Enabled" : "List View Enabled",
                value: gridStyle,
                // CHANGED: matched back to your toggleStyle method
                onChanged: (val) =>
                    context.read<GridstyleLogic>().toggleStyle(),
              ),
            ],
          ),

          /// 📱 CONTENT
          _sectionTitle("Content", dark),
          _buildSettingsGroup(
            dark,
            children: [
              _buildNavTile(
                icon: Icons.category_outlined,
                title: "Default Category",
                subtitle: defaultCategory.toUpperCase(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryScreen()),
                  );
                },
              ),
            ],
          ),

          /// 🗑 STORAGE
          _sectionTitle("Storage", dark),
          _buildSettingsGroup(
            dark,
            children: [
              _buildNavTile(
                icon: Icons.delete_outline_rounded,
                title: "Clear Cache",
                subtitle: "Remove temporary stored data",
                showArrow: false,
                onTap: () => _showClearCacheDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool dark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 0, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: dark ? Colors.white38 : Colors.grey.shade600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(bool dark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xff1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Colors.white12 : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: _buildIcon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeColor: Colors.blueAccent,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return ListTile(
      onTap: onTap,
      leading: _buildIcon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: showArrow ? const Icon(Icons.chevron_right, size: 20) : null,
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.blueAccent, size: 20),
    );
  }

  Widget _buildDivider(bool dark) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: dark ? Colors.white10 : Colors.grey.withOpacity(0.1),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Clear Cache"),
        content: const Text(
          "This will remove temporary images. Content will reload next time you browse.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cache cleared"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
