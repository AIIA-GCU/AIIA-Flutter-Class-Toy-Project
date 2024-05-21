import 'package:aiia_drive/config/assets.dart';
import 'package:aiia_drive/config/color.dart';
import 'package:aiia_drive/config/font.dart';
import 'package:aiia_drive/dto/file_info.dart';
import 'package:aiia_drive/firebase/db.dart';
import 'package:aiia_drive/firebase/storage.dart';
import 'package:aiia_drive/pages/image_viewer.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.refresh=false});

  final bool refresh;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textController = TextEditingController();

  final db = DB();
  final storage = Storage();

  bool needToLoad = true;
  String query = '';
  List<bool> checkboxValues = [];
  List<FileInfo> loadedFiles = [];
  List<FileInfo> selectedFiles = [];

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    needToLoad = widget.refresh;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(color: Palette.base1),
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: "검색",
                        hintStyle: Fonts.parag4.copyWith(color: Palette.base3),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 18)
                    ),
                  ),
                ),

                iconButton(
                    Icons.search,
                    size: 36,
                    color: Palette.base1,
                    () {
                      setState(() {
                        needToLoad = true;
                        query = textController.text;
                      });
                    }
                )
              ],
            ),
          ),

          const Divider(
            height: 30,
            color: Palette.base2,
            thickness: 1,
            indent: 12,
            endIndent: 12,
          ),

          IgnorePointer(
            ignoring: selectedFiles.isEmpty,
            child: Opacity(
              opacity: selectedFiles.isEmpty ? 0 : 1,
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${selectedFiles.length}개 선택됨",
                        style: Fonts.parag3.copyWith(color: Palette.primaryDarkColor),
                      ),

                      const Spacer(),

                      iconButton(
                          Icons.delete,
                          size: 24,
                          color: Palette.primaryDarkColor,
                          deleteData
                      )
                    ],
                  )
              ),
            ),
          ),

          Expanded(child: FutureBuilder<List<FileInfo>>(
            future: needToLoad ? getData(str: query) : null,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.none:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Expanded(child: Center(child: Text('Error: ${snapshot.error}')));
                  }

                  if (needToLoad) {
                    loadedFiles.addAll(snapshot.data ?? []);
                    checkboxValues = List.generate(loadedFiles.length, (index) => false);
                    needToLoad = false;
                  }

                  return ListView.builder(
                      itemCount: loadedFiles.length,
                      itemBuilder: (context, index) => itemBuilder(index, loadedFiles[index])
                  );
              }
            },
          ))
        ],
      ),
    );
  }

  Future<void> deleteData() async {
    OverlayEntry? entry = OverlayEntry(builder: (context) => progressCircle());
    Overlay.of(context).insert(entry);

    for (var fileInfo in selectedFiles) {
      await db.deleteData(fileInfo.path);
      await storage.deleteData(fileInfo.name);
    }

    entry.remove();
    setState(() {
      loadedFiles.removeWhere((e) => selectedFiles.contains(e));
      checkboxValues = List.generate(loadedFiles.length, (index) => false);
      selectedFiles.clear();
      needToLoad = true;
    });
  }

  Future<List<FileInfo>> getData({String? str}) async {
    final List<FileInfo> result = [];
    final fileInfoList = await DB().getData(str);
    for (var info in fileInfoList) {
      info['data'] = await storage.getFile(info['name']);
      result.add(FileInfo.fromJson(info));
    }
    return result;
  }

  Widget progressCircle() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.25),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget itemBuilder(int index, FileInfo fileInfo) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageViewer(fileInfo: fileInfo)
              )
          ),
          child: Ink(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (fileInfo.data == null)
                    const Icon(Icons.image, size: 60, color: Palette.base3)
                  else
                    Image.memory(
                      fileInfo.data!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),

                  const SizedBox(width: 32),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(fileInfo.name, style: Fonts.parag4),
                      const SizedBox(height: 4),
                      // Todo : 날짜 추가
                      Text("날짜 추가할 것", style: Fonts.label),
                    ],
                  ),

                  const Spacer(),

                  Checkbox(
                      value: checkboxValues[index],
                      activeColor: Palette.secondaryDarkColor,
                      onChanged: (val) => setState(() {
                        checkboxValues[index] = val!;
                        if (val) {
                          selectedFiles.add(fileInfo);
                        } else {
                          selectedFiles.removeWhere((e) => fileInfo.path == e.path);
                        }
                      })
                  ),
                ],
              )
          ),
        )
    );
  }

  Widget iconButton(IconData icon, void Function()? onTap, {double size=24, Color? color}) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(),
      icon: Icon(icon, size: size, color: color),
    );
  }
}
