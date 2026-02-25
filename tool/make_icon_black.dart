// Генерирует assets/icon_launcher_black.png из assets/logo.png:
// все непрозрачные пиксели становятся чёрными (для иконки приложения).
import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final root = Directory.current.path;
  final srcPath = Platform.isWindows ? '$root\\assets\\logo.png' : '$root/assets/logo.png';
  final dstPath = Platform.isWindows ? '$root\\assets\\icon_launcher_black.png' : '$root/assets/icon_launcher_black.png';
  final srcFile = File(srcPath);
  if (!srcFile.existsSync()) {
    print('Source not found: $srcPath');
    exit(1);
  }
  final bytes = srcFile.readAsBytesSync();
  final image = img.decodePng(bytes);
  if (image == null) {
    print('Failed to decode PNG: $srcPath');
    exit(1);
  }
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final p = image.getPixel(x, y);
      final a = p.a.toInt();
      if (a > 10) {
        image.setPixel(x, y, img.ColorRgba8(0, 0, 0, a));
      }
    }
  }
  File(dstPath).writeAsBytesSync(img.encodePng(image));
  print('Written: $dstPath');
}
