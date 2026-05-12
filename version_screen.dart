import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_logic.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;

    return Scaffold(
      backgroundColor: dark ? const Color(0xff0F0F0F) : const Color(0xffF8F9FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false, // Left-aligned consistent with Discover/Settings
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        title: Text(
          "Version",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800, // Matches your main headers
            color: dark ? Colors.white : Colors.black,
            fontFamily: 'Inter', // Ensuring consistency
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),

          /// SECTION LABEL
          _sectionTitle("APPLICATION INFO", dark),

          /// VERSION DATA CONTAINER
          _buildGroupedContainer(
            dark,
            children: [
              _buildVersionTile(
                title: "App Version",
                value: "1.0.0",
                icon: Icons.info_outline_rounded,
                dark: dark,
              ),
              _buildDivider(dark),
              _buildVersionTile(
                title: "Build Status",
                value: "Stable Release",
                icon: Icons.verified_user_outlined,
                dark: dark,
              ),
            ],
          ),

          const SizedBox(height: 32),

          /// LOGO OR DESCRIPTION AREA
          Center(
            child: Column(
              children: [
                Text(
                  "First release of News Reader App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: dark ? Colors.white38 : Colors.grey.shade600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "© 2026 Developer Team",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: dark ? Colors.white12 : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// COMPONENT: SECTION TITLE (Consistent uppercase style)
  Widget _sectionTitle(String title, bool dark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: dark ? Colors.white38 : Colors.grey.shade600,
          letterSpacing: 1.5,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  /// COMPONENT: GROUPED CONTAINER (Matches About/Settings)
  Widget _buildGroupedContainer(bool dark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xff1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Colors.white12 : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Column(children: children),
    );
  }

  /// COMPONENT: VERSION TILE
  Widget _buildVersionTile({
    required String title,
    required String value,
    required IconData icon,
    required bool dark,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          color: dark ? Colors.white70 : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// COMPONENT: DIVIDER
  Widget _buildDivider(bool dark) {
    return Divider(
      height: 1,
      indent: 50,
      endIndent: 16,
      color: dark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
    );
  }
}
