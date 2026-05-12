import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_logic.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;

    return Scaffold(
      backgroundColor: dark ? const Color(0xff0F0F0F) : const Color(0xffF8F9FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false, // Left-aligned consistent with your other screens
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        title: Text(
          "Developer Team",
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
          const SizedBox(height: 20),

          /// SECTION LABEL
          _sectionTitle("OUR TEAM MEMBERS", dark),

          /// TEAM LIST GROUPED CONTAINER
          _buildGroupedContainer(
            dark,
            children: [
              _buildMemberTile("Sith Rachna", dark),
              _buildDivider(dark),
              _buildMemberTile("Nimol Linda", dark),
              _buildDivider(dark),
              _buildMemberTile("Phoung Phalla", dark),
              _buildDivider(dark),
              _buildMemberTile("Phork Monineath", dark),
            ],
          ),

          const SizedBox(height: 40),
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

  /// COMPONENT: MEMBER TILE
  Widget _buildMemberTile(String name, bool dark) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
        child: Text(
          name.substring(0, 1),
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "Flutter Developer",
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: Icon(
        Icons
            .chevron_right_rounded, // Use chevron for a cleaner "Settings" look
        color: dark ? Colors.white24 : Colors.grey.shade300,
      ),
    );
  }

  /// COMPONENT: DIVIDER
  Widget _buildDivider(bool dark) {
    return Divider(
      height: 1,
      indent: 70, // Aligns with the text, not the avatar
      endIndent: 16,
      color: dark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
    );
  }
}
