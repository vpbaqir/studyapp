import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const StudyApp());

class AppColors {
  static const lavender = Color(0xFFB69AF5);
  static const lavenderSoft = Color(0xFFEDE7FF);
  static const blue = Color(0xFFAED8F5);
  static const mint = Color(0xFFBEE8D1);
  static const yellow = Color(0xFFFFD77A);
  static const pink = Color(0xFFF6B8D8);
  static const ink = Color(0xFF17171C);
  static const warm = Color(0xFFF9F8FC);
  static const dark = Color(0xFF101014);
}

class StudyApp extends StatefulWidget {
  const StudyApp({super.key});
  @override State<StudyApp> createState() => _StudyAppState();
}

class _StudyAppState extends State<StudyApp> {
  ThemeMode mode = ThemeMode.light;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Study',
    debugShowCheckedModeBanner: false,
    themeMode: mode,
    theme: ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.warm,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lavender),
      useMaterial3: true,
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.lavenderSoft,
      ),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.lavender,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
    home: MainShell(
      onToggleTheme: () => setState(() {
        mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      }),
    ),
  );
}

class MainShell extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const MainShell({super.key, required this.onToggleTheme});
  @override State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      Dashboard(onOpenTimer: () => setState(() => index = 2)),
      const SubjectsScreen(),
      const FocusTimerScreen(),
      const ProgressScreen(),
      ProfileScreen(onToggleTheme: widget.onToggleTheme),
    ];
    return Scaffold(
      body: SafeArea(child: screens[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Subjects'),
          NavigationDestination(icon: Icon(Icons.timer_outlined), selectedIcon: Icon(Icons.timer), label: 'Timer'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  final VoidCallback onOpenTimer;
  const Dashboard({super.key, required this.onOpenTimer});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
    children: [
      Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Hello, Student 👋', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Let’s make today productive.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ])),
        const CircleAvatar(radius: 24, backgroundColor: AppColors.lavenderSoft, child: Icon(Icons.school_rounded, color: AppColors.ink)),
      ]),
      const SizedBox(height: 22),
      SoftHeroCard(onTap: onOpenTimer),
      const SizedBox(height: 18),
      Row(children: const [
        QuickAction(icon: Icons.sticky_note_2_outlined, label: 'Notes', color: AppColors.yellow),
        QuickAction(icon: Icons.style_outlined, label: 'Flashcards', color: AppColors.lavenderSoft),
        QuickAction(icon: Icons.quiz_outlined, label: 'Q&A', color: AppColors.mint),
        QuickAction(icon: Icons.more_horiz, label: 'More', color: AppColors.blue),
      ]),
      const SizedBox(height: 24),
      const SectionTitle(title: "Today's Plan", action: 'See all'),
      const SizedBox(height: 10),
      const PlanTile(title: 'Islamic History', time: '8:00 – 9:00 AM', icon: Icons.account_balance_outlined, color: AppColors.lavenderSoft),
      const PlanTile(title: 'Arabic Language', time: '10:00 – 11:00 AM', icon: Icons.translate, color: AppColors.mint),
      const PlanTile(title: 'Revision', time: '4:00 – 5:00 PM', icon: Icons.auto_stories_outlined, color: AppColors.pink),
      const SizedBox(height: 18),
      const StreakCard(),
    ],
  );
}

class SoftHeroCard extends StatelessWidget {
  final VoidCallback onTap;
  const SoftHeroCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFC8B4FF), Color(0xFFE3D9FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Small\nSteps, Big Results', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, height: .98)),
        const SizedBox(height: 10),
        const Text('Focus for a little while today and build a better tomorrow.'),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(backgroundColor: AppColors.ink, foregroundColor: Colors.white),
          child: const Text('Start focus'),
        ),
      ])),
      const SizedBox(width: 8),
      const SizedBox(width: 100, height: 100, child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.auto_stories_rounded, size: 78, color: Color(0xFF7B61D6)),
          Positioned(right: 2, top: 8, child: Icon(Icons.star_rounded, size: 24, color: Colors.white)),
          Positioned(left: 5, bottom: 5, child: Icon(Icons.star_rounded, size: 16, color: Colors.white)),
        ],
      )),
    ]),
  );
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const QuickAction({super.key, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 58,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
        child: Icon(icon, color: AppColors.ink),
      ),
      const SizedBox(height: 7),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
    ]),
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  const SectionTitle({super.key, required this.title, this.action});
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
    if (action != null) Text(action!, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
  ]);
}

class PlanTile extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color color;
  const PlanTile({super.key, required this.title, required this.time, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18)),
    child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)), child: Icon(icon, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text(time, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ])),
      Icon(Icons.play_circle_fill_rounded, color: Theme.of(context).colorScheme.primary),
    ]),
  );
}

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: AppColors.yellow.withValues(alpha: .42), borderRadius: BorderRadius.circular(22)),
    child: const Row(children: [
      Icon(Icons.local_fire_department_rounded, size: 34),
      SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('7 day streak', style: TextStyle(fontWeight: FontWeight.w800)),
        SizedBox(height: 3),
        Text('Keep your momentum going today.'),
      ])),
      Text('🔥', style: TextStyle(fontSize: 25)),
    ]),
  );
}

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final subjects = [
      ('Quran Studies', '12 lessons', .60, AppColors.mint, Icons.menu_book_rounded),
      ('Arabic', '20 lessons', .35, AppColors.lavenderSoft, Icons.translate),
      ('Islamic History', '18 lessons', .80, AppColors.yellow, Icons.account_balance_rounded),
      ('English', '24 lessons', .40, AppColors.blue, Icons.text_fields_rounded),
      ('Logic & Thinking', '16 lessons', .25, AppColors.pink, Icons.psychology_outlined),
      ('General Knowledge', '30 lessons', .50, AppColors.mint, Icons.public_rounded),
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const ScreenHeader(title: 'Subjects', icon: Icons.search),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: subjects.map((s) => SubjectCard(title: s.$1, lessons: s.$2, progress: s.$3, color: s.$4, icon: s.$5)).toList(),
        ),
      ],
    );
  }
}

class SubjectCard extends StatelessWidget {
  final String title, lessons;
  final double progress;
  final Color color;
  final IconData icon;
  const SubjectCard({super.key, required this.title, required this.lessons, required this.progress, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final width = ((MediaQuery.sizeOf(context).width - 52) / 2).clamp(145.0, 230.0);
    return SizedBox(width: width, child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(23)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .75), shape: BoxShape.circle), child: Icon(icon, size: 20)),
        const SizedBox(height: 18),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(lessons, style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: progress, minHeight: 5, backgroundColor: Colors.white54)),
        const SizedBox(height: 6),
        Text('${(progress * 100).round()}% complete', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
      ]),
    ));
  }
}

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});
  @override State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  Timer? timer;
  int seconds = 25 * 60;
  bool running = false;

  void toggle() {
    if (running) {
      timer?.cancel();
      setState(() => running = false);
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds <= 0) {
        timer?.cancel();
        setState(() => running = false);
      } else {
        setState(() => seconds--);
      }
    });
    setState(() => running = true);
  }

  void reset() {
    timer?.cancel();
    setState(() {
      seconds = 25 * 60;
      running = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const ScreenHeader(title: 'Focus Timer', icon: Icons.settings_outlined),
        const SizedBox(height: 18),
        Row(children: const [
          ChoicePill(label: 'Pomodoro', selected: true),
          ChoicePill(label: 'Short Break'),
          ChoicePill(label: 'Long Break'),
        ]),
        const SizedBox(height: 36),
        Center(child: SizedBox(width: 260, height: 260, child: Stack(alignment: Alignment.center, children: [
          SizedBox(width: 250, height: 250, child: CircularProgressIndicator(
            value: seconds / (25 * 60), strokeWidth: 13, backgroundColor: AppColors.lavenderSoft, color: AppColors.lavender,
          )),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('$mins:$secs', style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w900)),
            Text('Focus time', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ]),
        ]))),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(22)),
          child: const Row(children: [
            Icon(Icons.menu_book_rounded),
            SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Current session', style: TextStyle(fontSize: 11)),
              SizedBox(height: 3),
              Text('Islamic History · Chapter 3', style: TextStyle(fontWeight: FontWeight.w700)),
            ])),
            Icon(Icons.chevron_right),
          ]),
        ),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton.filledTonal(onPressed: reset, icon: const Icon(Icons.refresh_rounded)),
          const SizedBox(width: 24),
          FloatingActionButton.large(onPressed: toggle, backgroundColor: AppColors.ink, foregroundColor: Colors.white, child: Icon(running ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 34)),
          const SizedBox(width: 24),
          IconButton.filledTonal(onPressed: reset, icon: const Icon(Icons.skip_next_rounded)),
        ]),
      ],
    );
  }
}

class ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  const ChoicePill({super.key, required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    margin: const EdgeInsets.only(right: 6),
    padding: const EdgeInsets.symmetric(vertical: 11),
    decoration: BoxDecoration(color: selected ? AppColors.ink : Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(18)),
    child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: selected ? Colors.white : null, fontSize: 11, fontWeight: FontWeight.w700)),
  ));
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const ScreenHeader(title: 'My Progress', icon: Icons.calendar_today_outlined),
      const SizedBox(height: 18),
      Row(children: const [
        ChoicePill(label: 'Overview', selected: true),
        ChoicePill(label: 'Subjects'),
        ChoicePill(label: 'Stats'),
        ChoicePill(label: 'Goals'),
      ]),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.lavenderSoft, borderRadius: BorderRadius.circular(25)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Study time', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('This week', style: TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 18),
          SizedBox(height: 150, child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final h = [45.0, 80, 60, 120, 55, 92, 110][i];
              return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(width: 22, height: h, decoration: BoxDecoration(color: i == 3 ? AppColors.lavender : Colors.white70, borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 7),
                Text(['M','T','W','T','F','S','S'][i], style: const TextStyle(fontSize: 10)),
              ]);
            }),
          )),
        ]),
      ),
      const SizedBox(height: 14),
      Row(children: const [
        StatCard(value: '32h', label: 'Total study time', color: AppColors.lavenderSoft),
        StatCard(value: '85', label: 'Day streak', color: AppColors.yellow),
      ]),
      Row(children: const [
        StatCard(value: '12', label: 'Completed lessons', color: AppColors.mint),
        StatCard(value: '6', label: 'Tests taken', color: AppColors.blue),
      ]),
    ],
  );
}

class StatCard extends StatelessWidget {
  final String value, label;
  final Color color;
  const StatCard({super.key, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    margin: const EdgeInsets.only(right: 8, bottom: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      const SizedBox(height: 3),
      Text(label, style: const TextStyle(fontSize: 10)),
    ]),
  ));
}

class ProfileScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const ProfileScreen({super.key, required this.onToggleTheme});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const ScreenHeader(title: 'Profile', icon: Icons.settings_outlined),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(24)),
        child: const Row(children: [
          CircleAvatar(radius: 30, backgroundColor: AppColors.lavenderSoft, child: Icon(Icons.school, size: 28)),
          SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Student', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            SizedBox(height: 3),
            Text('Keep learning ✨'),
          ]),
          Spacer(),
          Icon(Icons.chevron_right),
        ]),
      ),
      const SizedBox(height: 14),
      Row(children: const [
        StatCard(value: '12', label: 'Subjects', color: AppColors.lavenderSoft),
        StatCard(value: '85', label: 'Day streak', color: AppColors.yellow),
        StatCard(value: '240', label: 'Hours', color: AppColors.mint),
      ]),
      const SizedBox(height: 12),
      ...[
        ('My Notes', Icons.note_alt_outlined),
        ('Bookmarks', Icons.bookmark_border),
        ('Study Plan', Icons.calendar_month_outlined),
        ('Achievements', Icons.emoji_events_outlined),
        ('Settings', Icons.settings_outlined),
        ('Help & Support', Icons.help_outline),
      ].map((item) => Container(
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: .35)))),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(item.$2, size: 21),
          title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right),
        ),
      )),
      const SizedBox(height: 8),
      OutlinedButton.icon(onPressed: onToggleTheme, icon: const Icon(Icons.dark_mode_outlined), label: const Text('Toggle light / dark mode')),
    ],
  );
}

class ScreenHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const ScreenHeader({super.key, required this.title, required this.icon});
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900))),
    IconButton.filledTonal(onPressed: () {}, icon: Icon(icon)),
  ]);
}
