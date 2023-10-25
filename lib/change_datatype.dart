import 'dart:typed_data';

// doubleからfloatへの変換
Float32List doubleToFloat(double value) {
  final byteData = ByteData(4); // 4バイトの空間を持つByteDataを作成
  byteData.setFloat32(0, value, Endian.little); // Little-endianのフォーマットでfloatに変換
  Float32List floatData = byteData.buffer.asFloat32List(); // Float32Listに変換
  return floatData;
}

// floatからUint8Listへの変換
Uint8List floatToUint8List(Float32List value) {
  final byteData = ByteData(4); // 4バイトの空間を持つByteDataを作成
  byteData.setFloat32(0, value[0], Endian.little); // Little-endianのフォーマットでfloatに変換
  return byteData.buffer.asUint8List();
}

// doubleからfloatへの変換した後uint8Listへのメモリコピー
Uint8List doubleToFloattoUint8list (double value){
  final byteData = ByteData(4);
  byteData.setFloat32(0, value, Endian.little);
  return byteData.buffer.asUint8List();
}

// intからUint8Listへの変換
Uint8List intToUint8List(int value) {
  final byteData = ByteData(4); // 4バイトの空間を持つByteDataを作成
  byteData.setInt32(0, value, Endian.little); // Little-endianのフォーマットでintに変換
  return byteData.buffer.asUint8List();
}