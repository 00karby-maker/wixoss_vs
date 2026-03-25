import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/match_record.dart';
import 'edit_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  String keyword = "";
  String sortType = "date";
  String formatFilter = "すべて";

  List<String> usedFilters = [];
  List<String> opponentFilters = [];

  final usedCtrl = TextEditingController();
  final opponentCtrl = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  /// 🎨 色固定
  final Map<String, Color> colorMap = {};
  Color getColor(String key) {
    if (colorMap.containsKey(key)) return colorMap[key]!;

    final colors = [
      Colors.indigo,
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    final c = colors[colorMap.length % colors.length];
    colorMap[key] = c;
    return c;
  }

  /// サジェスト生成
  List<String> getSuggestions(Box<MatchRecord> box, bool used) {
    final set = <String>{};
    for (var r in box.values) {
      final v = used ? r.usedLrig : r.opponentLrig;
      if (v.isNotEmpty) set.add(v);
    }
    return set.toList();
  }

  String formatDate(DateTime? d) {
    if (d == null) return "未選択";
    return "${d.year}/${d.month}/${d.day}";
  }

  @override
  Widget build(BuildContext context) {

    final box = Hive.box<MatchRecord>('records');
if (box.isEmpty) {
  return const Center(child: Text("記録がありません"));
}

    final usedSuggestions = getSuggestions(box, true);
    final oppSuggestions = getSuggestions(box, false);

    return Column(
      children: [

        /// 🔍 検索
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "検索（大会名・ルリグ）",
              border: OutlineInputBorder(),
            ),
            onChanged: (v)=>setState(()=>keyword=v),
          ),
        ),

        /// 🎯 フィルタエリア
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// フォーマット
              Wrap(
                spacing: 6,
                children: ["すべて", "A", "K", "D"].map((e){
                  return ChoiceChip(
                    label: Text(e),
                    selected: formatFilter == e,
                    onSelected: (_)=>setState(()=>formatFilter = e),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              /// 📅 日付
              Row(
                children: [

                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(()=>startDate = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("開始: ${formatDate(startDate)}"),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(()=>endDate = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("終了: ${formatDate(endDate)}"),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 10),

              /// 🔷 使用ルリグ入力
              TextField(
                controller: usedCtrl,
                decoration: const InputDecoration(
                  labelText: "使用ルリグ追加",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (v){
                  if(v.isEmpty) return;
                  setState(() {
                    usedFilters.add(v);
                    usedCtrl.clear();
                  });
                },
              ),

              /// サジェスト
              Wrap(
                spacing: 6,
                children: usedSuggestions.map((e){
                  return ActionChip(
                    label: Text(e),
                    onPressed: (){
                      if(!usedFilters.contains(e)){
                        setState(()=>usedFilters.add(e));
                      }
                    },
                  );
                }).toList(),
              ),

              /// 選択チップ
              Wrap(
                spacing: 6,
                children: usedFilters.map((e){
                  return Chip(
                    label: Text(e),
                    backgroundColor: getColor(e).withOpacity(0.2),
                    onDeleted: ()=>setState(()=>usedFilters.remove(e)),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              /// 🔶 対戦ルリグ入力
              TextField(
                controller: opponentCtrl,
                decoration: const InputDecoration(
                  labelText: "対戦ルリグ追加",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (v){
                  if(v.isEmpty) return;
                  setState(() {
                    opponentFilters.add(v);
                    opponentCtrl.clear();
                  });
                },
              ),

              Wrap(
                spacing: 6,
                children: oppSuggestions.map((e){
                  return ActionChip(
                    label: Text(e),
                    onPressed: (){
                      if(!opponentFilters.contains(e)){
                        setState(()=>opponentFilters.add(e));
                      }
                    },
                  );
                }).toList(),
              ),

              Wrap(
                spacing: 6,
                children: opponentFilters.map((e){
                  return Chip(
                    label: Text(e),
                    backgroundColor: getColor(e).withOpacity(0.2),
                    onDeleted: ()=>setState(()=>opponentFilters.remove(e)),
                  );
                }).toList(),
              ),

              /// リセット
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      keyword = "";
                      formatFilter = "すべて";
                      usedFilters.clear();
                      opponentFilters.clear();
                      startDate = null;
                      endDate = null;
                    });
                  },
                  child: const Text("リセット"),
                ),
              ),
            ],
          ),
        ),

        /// ソート
        DropdownButton(
          value: sortType,
          items: const [
            DropdownMenuItem(value: "date", child: Text("日付順")),
            DropdownMenuItem(value: "event", child: Text("大会名順")),
          ],
          onChanged: (v)=>setState(()=>sortType=v!),
        ),

        /// 📋 リスト
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (_, Box<MatchRecord> box, __) {

              List<MatchRecord> list = box.values.toList();

              list = list.where((e){

                final matchKeyword =
                    e.eventName.contains(keyword) ||
                    e.usedLrig.contains(keyword) ||
                    e.opponentLrig.contains(keyword);

                final matchFormat =
                    formatFilter == "すべて" || e.format == formatFilter;

                final matchUsed =
                    usedFilters.isEmpty ||
                    usedFilters.any((f)=>e.usedLrig.contains(f));

                final matchOpponent =
                    opponentFilters.isEmpty ||
                    opponentFilters.any((f)=>e.opponentLrig.contains(f));

                final matchDate =
                    (startDate == null || !e.date.isBefore(startDate!)) &&
                    (endDate == null || !e.date.isAfter(endDate!));

                return matchKeyword &&
                       matchFormat &&
                       matchUsed &&
                       matchOpponent &&
                       matchDate;

              }).toList();

              if(sortType=="date"){
                list.sort((a,b)=>b.date.compareTo(a.date));
              }else{
                list.sort((a,b)=>a.eventName.compareTo(b.eventName));
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i){
                  final r = list[i];

                  return Card(
                    child: ListTile(
                      title: Text("${r.usedLrig} vs ${r.opponentLrig}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${r.eventName} / ${r.round}回戦"),
                          Text(
                            "${r.date.year}/${r.date.month}/${r.date.day} ・ ${r.format} ・ ${r.result}",
                            style: TextStyle(
                              fontSize: 12,
                              color: r.result == "勝"
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          /// 📸 画像
                          IconButton(
                            icon: const Icon(Icons.image),
                            onPressed: (){
                              if (r.imagePath == null) return;

                              showDialog(
                                context: context,
                                builder:(_)=>Dialog(
                                  child: InteractiveViewer(
                                    child: Image.file(File(r.imagePath!)),
                                  ),
                                ),
                              );
                            },
                          ),

                          /// ✏ 編集
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder:(_)=>EditPage(record:r)));
                            },
                          ),

                          /// ❌ 削除
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder:(_)=>AlertDialog(
                                  title: const Text("削除確認"),
                                  content: const Text("削除しますか？"),
                                  actions: [
                                    TextButton(onPressed:()=>Navigator.pop(context), child: const Text("キャンセル")),
                                    TextButton(
                                      onPressed:(){
                                        r.delete();
                                        Navigator.pop(context);
                                      },
                                      child: const Text("削除"),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}