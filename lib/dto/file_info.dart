///
/// class FileInfo
///
/// @param name: String
/// @param path: String
/// @param url: String
/// @param type: String
/// @param size: int
///
/// FileInfo.fromJson(Map<String, dynamic> json)
///
class FileInfo {
  final String name;
  final String path;
  final String? url;
  final String type;
  final int size;

  FileInfo(this.name, this.path, this.url, this.type, this.size);

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      json['name'],
      json['path'],
      json['url'],
      json['type'],
      json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'url': url ?? "(none)",
      'type': type,
      'size': size,
    };
  }
}