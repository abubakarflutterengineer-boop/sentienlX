import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
class PhotoService {
  final ImagePicker _picker = ImagePicker();
  Future<Directory> _folder() async { final root=await getApplicationDocumentsDirectory(); final dir=Directory('${root.path}/sentinelx_evidence'); if(!await dir.exists()) await dir.create(recursive:true); return dir; }
  Future<File?> capture() async { final x=await _picker.pickImage(source: ImageSource.camera,imageQuality:85,maxWidth:1600); if(x==null)return null; final dir=await _folder(); final file=File('${dir.path}/evidence_${DateTime.now().millisecondsSinceEpoch}.jpg'); return File(x.path).copy(file.path); }
  Future<void> delete(File file) async { if(await file.exists()) await file.delete(); }
}
