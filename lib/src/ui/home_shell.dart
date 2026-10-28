import 'package:flutter/material.dart';

import 'caesar_screen.dart';
import 'missions_screen.dart';
import 'theme.dart';
import 'widgets.dart';

/// Üstte başlık, altta LAB / GÖREVLER sekmeleri olan ana çerçeve.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '> ENCRYPTION_LAB',
              style: TextStyle(
                color: Hacker.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.5,
              ),
            ),
            BlinkingCursor(),
          ],
        ),
      ),
      body: SafeArea(
        // IndexedStack: sekme değişince diğer ekran silinmez, yazdıkların kalır.
        child: IndexedStack(
          index: _tab,
          children: const [CaesarScreen(), MissionsScreen()],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            key: Key('tab-lab'),
            icon: Icon(Icons.terminal),
            label: 'LAB',
          ),
          NavigationDestination(
            key: Key('tab-missions'),
            icon: Icon(Icons.flag_outlined),
            selectedIcon: Icon(Icons.flag),
            label: 'GÖREVLER',
          ),
        ],
      ),
    );
  }
}
