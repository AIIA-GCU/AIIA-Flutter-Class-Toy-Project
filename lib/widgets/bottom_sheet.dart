
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config/color.dart';
import '../config/font.dart';
import '../firebase/db.dart';
import '../firebase/storage.dart';

class UploadBottomSheet extends StatefulWidget {
  const UploadBottomSheet({super.key, required this.onUpload});

  final void Function(bool) onUpload;

  @override
  State<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {

  bool enableToPick = true;
  List<bool> checkboxValues = [];
  List<XFile> loadedImages = [];
  List<XFile> selectedImages = [];

  final Storage storage = Storage();
  final DB db = DB();

  Future<List<XFile>> pickingImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.6,
          child: FutureBuilder<List<XFile>>(
            future: enableToPick ? pickingImages() : null,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
              // case ConnectionState.none:
              //   return GestureDetector(
              //       onTap: () => setState(() => print("hello")),
              //       behavior: HitTestBehavior.translucent,
              //       child: const Center(child: Text('hello'))
              //   );

                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.none:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return GestureDetector(
                        onTap: () => setState(() {}),
                        behavior: HitTestBehavior.translucent,
                        child: Expanded(child: Center(child: Text('Error: ${snapshot.error}')))
                    );
                  }

                  if (enableToPick) {
                    loadedImages.addAll(snapshot.data ?? []);
                    checkboxValues = List.generate(loadedImages.length, (index) => false);
                    enableToPick = false;
                  }

                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(children: [
                              Text("${loadedImages.length}개의 파일 찾음"
                                  "${selectedImages.isEmpty ? "" : "(${selectedImages.length})"}",
                                  style: Fonts.parag2
                              ),

                              const Spacer(),

                              iconButton(Icons.add, size: 24, () => setState(() {
                                enableToPick = true;
                              })),

                              iconButton(Icons.delete, size: 24, selectedImages.isEmpty ? null : () {
                                setState(() {
                                  loadedImages.removeWhere((e) => selectedImages.contains(e));
                                  checkboxValues = List.generate(loadedImages.length, (index) => false);
                                  selectedImages.clear();
                                });
                              })
                            ]),
                          ),

                          const SizedBox(height: 20),

                          // const Spacer(),
                          Expanded(
                            child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                itemCount: loadedImages.length,
                                itemBuilder: (context, index) => itemBuilder(index, loadedImages[index])
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                bottomButton(
                                    '취소',
                                    Palette.primaryLightColor,
                                        () => Navigator.pop(context)),
                                bottomButton(
                                    '업로드${selectedImages.isEmpty ? "" : "(${selectedImages.length})"}',
                                    selectedImages.isNotEmpty ? Palette.primaryColor : Palette.base4,
                                    selectedImages.isNotEmpty ? upload : null
                                ),
                              ]
                          )
                        ],
                      )
                  );
              }
            },
          )
      ),
    );
  }

  Future<void> upload() async {
    try {
      OverlayEntry? entry = OverlayEntry(builder: (context) => progressCircle());
      Overlay.of(context).insert(entry);

      // await Future.delayed(Duration(seconds: 2));
      for (final image in selectedImages) {
        if (await db.addData(image) == 400) {
          throw Exception('Failed to upload');
        }
        if (await storage.addData(image) == 400) {
          throw Exception('Failed to upload');
        }
      }

      widget.onUpload(true);
      entry.remove();
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
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

  Widget itemBuilder(int index, XFile file) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() {
            checkboxValues[index] = !checkboxValues[index];
            if (checkboxValues[index]) {
              selectedImages.add(file);
            } else {
              selectedImages.removeWhere((e) => file.path == e.path);
            }
          }),
          child: Ink(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Checkbox(
                      value: checkboxValues[index],
                      activeColor: Palette.secondaryDarkColor,
                      onChanged: (val) => setState(() {
                        checkboxValues[index] = val!;
                        if (val) {
                          selectedImages.add(file);
                        } else {
                          selectedImages.removeWhere((e) => file.path == e.path);
                        }
                      })
                  ),

                  const SizedBox(width: 20),
                  const Icon(Icons.image, size: 24),
                  const SizedBox(width: 4),
                  Text(file.name, style: Fonts.parag4),

                  const Spacer(),

                  GestureDetector(
                    onTap: () => setState(() {
                      loadedImages.removeAt(index);
                      checkboxValues.removeAt(index);
                      selectedImages.removeWhere((e) => file.path == e.path);
                    }),
                    child: const Icon(Icons.close, size: 16),
                  )
                ],
              )
          ),
        )
    );
  }

  Widget iconButton(IconData icon, void Function()? onTap, {double size=24}) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(fixedSize: Size(size, size)),
      icon: Icon(icon, size: size,
          color: onTap == null ? Palette.base4 : Palette.primaryColor),
    );
  }

  Widget bottomButton(String title, Color background, void Function()? onTap) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(title,
                style: Fonts.parag2.copyWith(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
