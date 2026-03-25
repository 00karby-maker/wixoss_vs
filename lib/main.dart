import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/match_record.dart';
import 'pages/input_page.dart';
import 'pages/history_page.dart';
import 'pages/stats_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MatchRecordAdapter());
  await Hive.openBox<MatchRecord>('records');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,

        /// 🔥 修正（CardTheme）
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,

        /// 🔥 修正（CardTheme）
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      /// 🔥 const外す
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("WIXOSS対戦記録"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "入力"),
              Tab(text: "履歴"),
              Tab(text: "統計"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InputPage(),
            HistoryPage(),
            StatsPage(),
          ],
        ),
      ),
    );
  }
}