import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../model/match_record.dart';

class EditPage extends StatefulWidget {
  final MatchRecord record;
  const EditPage({super.key, required this.record});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  late TextEditingController eventCtrl;
  late TextEditingController usedCtrl;
  late TextEditingController opponentCtrl;
  late TextEditingController memoCtrl;

  late String result;
  late String firstSecond;
  late int selfLb;
  late int oppLb;
  late String format;
  late int round;
  late DateTime date;

  /// ★追加
  String? imagePath;

  @override
  void initState() {
    super.initState();

    eventCtrl = TextEditingController(text: widget.record.eventName);
    usedCtrl = TextEditingController(text: widget.record.usedLrig);
    opponentCtrl = TextEditingController(text: widget.record.opponentLrig);
    memoCtrl = TextEditingController(text: widget.record.memo);

    result = widget.record.result;
    firstSecond = widget.record.firstSecond;
    selfLb = widget.record.selfLb;
    oppLb = widget.record.opponentLb;
    format = widget.record.format;
    round = widget.record.round;
    date = widget.record.date;

    imagePath = widget.record.imagePath;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final name = DateTime.now().millisecondsSinceEpoch.toString();

    final saved = await File(file.path).copy('${dir.path}/$name.jpg');

    setState(() {
      imagePath = saved.path;
    });
  }

  Widget label(String t)=>Padding(
    padding: const EdgeInsets.only(top:10),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  void save(){
    widget.record
      ..eventName = eventCtrl.text
      ..usedLrig = usedCtrl.text
      ..opponentLrig = opponentCtrl.text
      ..memo = memoCtrl.text
      ..result = result
      ..firstSecond = firstSecond
      ..selfLb = selfLb
      ..opponentLb = oppLb
      ..format = format
      ..date = date
      ..round = round
      ..imagePath = imagePath; // ★追加

    widget.record.save();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("編集")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(children:[

          label("大会名"),
          TextField(controller:eventCtrl),

          label("日付"),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => date = picked);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text("${date.year}/${date.month}/${date.day}"),
            ),
          ),

          label("使用ルリグ"),
          TextField(controller:usedCtrl),

          label("フォーマット"),
          DropdownButton(
            value: format,
            isExpanded:true,
            items:['A','K','D'].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),
            onChanged:(v)=>setState(()=>format=v!),
          ),

          label("●回戦"),
          DropdownButton(
            value: round,
            isExpanded:true,
            items: List.generate(10,(i)=>DropdownMenuItem(value:i+1, child:Text("${i+1}回戦"))),
            onChanged:(v)=>setState(()=>round=v!),
          ),

          label("対面ルリグ"),
          TextField(controller:opponentCtrl),

          label("先後・勝敗・LB数"),
          Row(children: [

            Expanded(
              child: DropdownButton(
                value:firstSecond,
                isExpanded:true,
                items:["先手","後手"].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),
                onChanged:(v)=>setState(()=>firstSecond=v!),
              ),
            ),

            Expanded(
              child: DropdownButton(
                value:result,
                isExpanded:true,
                items:["勝","負"].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),
                onChanged:(v)=>setState(()=>result=v!),
              ),
            ),

            Expanded(
              child: Row(children:[
                Expanded(
                  child: DropdownButton(
                    value:selfLb,
                    isExpanded:true,
                    items:List.generate(10,(i)=>DropdownMenuItem(value:i,child:Text("$i"))),
                    onChanged:(v)=>setState(()=>selfLb=v!),
                  ),
                ),
                const Text("-"),
                Expanded(
                  child: DropdownButton(
                    value:oppLb,
                    isExpanded:true,
                    items:List.generate(10,(i)=>DropdownMenuItem(value:i,child:Text("$i"))),
                    onChanged:(v)=>setState(()=>oppLb=v!),
                  ),
                ),
              ]),
            ),
          ]),

          label("メモ"),
          TextField(controller:memoCtrl, maxLines:null),

          const SizedBox(height: 10),

          /// ★画像
          ElevatedButton(
            onPressed: pickImage,
            child: const Text("デッキレシピ"),
          ),

          if (imagePath != null)
            Image.file(File(imagePath!), height: 120),

          const SizedBox(height: 20),

          ElevatedButton(onPressed:save, child:const Text("保存"))

        ]),
      ),
    );
  }
}