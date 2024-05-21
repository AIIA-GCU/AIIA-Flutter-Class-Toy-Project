import 'package:flutter/material.dart';

///
/// class LogoPath
///
/// Description:
/// Class to store the path of the logo images
///
/// [logoLight] : Path to the light logo image
/// [logoDark] : Path to the dark logo image
///
class LogoPath {
  static const String logoLight = 'assets/images/logo_light.png';
  static const String logoDark = 'assets/images/logo_dark.png';
}

///
/// class IconSrc
///
/// Description:
/// Class to store the icons
///
/// [search]
/// [copyLink],
/// [download],
/// [delete],
/// [add] (to add item),
/// [back] (back to the previous screen),
/// [cancel],
/// [logout],
/// [imageIcon],
/// [videoIcon],
/// [audioIcon],
/// [textIcon]
///
class IconSrc {
  static const IconData search = Icons.search;
  static const IconData copyLink = Icons.link;
  static const IconData download = Icons.download;
  static const IconData delete = Icons.delete;
  static const IconData add = Icons.add;
  static const IconData back = Icons.arrow_back;
  static const IconData cancel = Icons.close;
  static const IconData logout = Icons.door_front_door;
  static const IconData imageIcon = Icons.image;
  static const IconData videoIcon = Icons.video_library;
  static const IconData audioIcon = Icons.audiotrack;
  static const IconData textIcon = Icons.insert_drive_file;
}