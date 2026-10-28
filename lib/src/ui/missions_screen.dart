import 'package:encryption_lab/encryption_lab.dart';
import 'package:flutter/material.dart';

import 'theme.dart';
import 'widgets.dart';

/// GÖREVLER ekranı: ele geçirilen şifreli mesajları kırma oyunu.
class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int _index = 0; // kaçıncı görevdeyiz
  int _guess = 0; // oyuncunun denediği anahtar
  int _attempts = 0; // kaç kez anahtar değiştirdi
  bool _solved = false;
  bool _showHint = false;

  bool get _allDone => _index >= missions.length;
  Mission get _mission => missions[_index];

  void _tryKey(int guess) {
    setState(() {
      _guess = guess;
      _attempts++;
      _solved = _mission.isSolvedBy(guess);
    });
  }

  void _goTo(int index) {
    setState(() {
      _index = index;
      _guess = 0;
      _attempts = 0;
      _solved = false;
      _showHint = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_allDone) return _CompletedView(onRestart: () => _goTo(0));

    final mission = _mission;
    final isLast = _index == missions.length - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProgressDots(current: _index, total: missions.length),
          const SizedBox(height: 12),
          Text(
            'GÖREV ${_index + 1}/${missions.length} · '
            '${mission.title.toUpperCase()}',
            style: const TextStyle(
              color: Hacker.cyan,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          // Ele geçirilen mesaj
          NeonPanel(
            label: 'ELE GEÇİRİLEN MESAJ',
            color: Hacker.amber,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.briefing,
                  style: const TextStyle(color: Hacker.dim, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Text(
                  mission.cipherText,
                  style: const TextStyle(
                    color: Hacker.amber,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                if (_showHint)
                  Text(
                    'İPUCU: ${mission.hint}',
                    style: const TextStyle(color: Hacker.text, fontSize: 13),
                  )
                else
                  TextButton(
                    onPressed: () => setState(() => _showHint = true),
                    style: TextButton.styleFrom(
                      foregroundColor: Hacker.dim,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('> ipucu göster'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Çözme denemesi
          NeonPanel(
            label: 'ÇÖZME DENEMESİ',
            color: Hacker.cyan,
            trailing: Text(
              'DENEME: $_attempts',
              style: const TextStyle(color: Hacker.dim, fontSize: 12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KeyDial(
                  idPrefix: 'mission',
                  value: _guess,
                  enabled: !_solved,
                  onChanged: _tryKey,
                ),
                const SizedBox(height: 12),
                ScrambleText(
                  mission.decryptWith(_guess),
                  key: const Key('mission-output'),
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                    color: _solved ? Hacker.green : Hacker.dim,
                  ),
                ),
              ],
            ),
          ),

          if (_solved) ...[
            const SizedBox(height: 16),
            NeonPanel(
              label: 'SİSTEM',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lock_open, color: Hacker.green, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'ERİŞİM SAĞLANDI',
                        style: TextStyle(
                          color: Hacker.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Anahtar $_guess, $_attempts denemede bulundu.',
                    style: const TextStyle(color: Hacker.text),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    key: const Key('mission-next'),
                    onPressed: () => _goTo(_index + 1),
                    child: Text(isLast ? 'BİTİR' : 'SONRAKİ GÖREV >'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Görev ilerlemesini gösteren noktalar: ● ● ◉ ○ ○
class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++)
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < current ? Hacker.green : Colors.transparent,
              border: Border.all(
                color: i == current
                    ? Hacker.cyan
                    : (i < current ? Hacker.green : Hacker.border),
                width: 2,
              ),
            ),
          ),
      ],
    );
  }
}

/// Tüm görevler bitince çıkan ekran.
class _CompletedView extends StatelessWidget {
  const _CompletedView({required this.onRestart});

  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Icon(Icons.verified, color: Hacker.green, size: 72),
          const SizedBox(height: 16),
          const Text(
            'TÜM GÖREVLER TAMAMLANDI',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Hacker.green,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const NeonPanel(
            label: 'NE ÖĞRENDİN?',
            color: Hacker.cyan,
            child: Text(
              'Sezar şifresinde yalnızca 26 farklı anahtar var. Hepsini tek '
              'tek denemeye "brute force" (kaba kuvvet) denir ve bir '
              'bilgisayar bunu bir saniyeden kısa sürede yapar. Bu yüzden '
              'Sezar gerçek hayatta güvenli değildir.\n\n'
              'Sıradaki seviye: Vigenère. Orada anahtar bir kelimedir ve '
              'denenecek ihtimal sayısı patlar.',
              style: TextStyle(color: Hacker.text, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            key: const Key('mission-restart'),
            onPressed: onRestart,
            child: const Text('BAŞTAN OYNA'),
          ),
        ],
      ),
    );
  }
}
