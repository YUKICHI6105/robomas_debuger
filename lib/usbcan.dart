// this is mock class
// I should delete this file when I commit to git.
class UsbCan {
  Future<bool> sendUint8List(sendData) async {
    print(sendData);
    return true;
  }

  Future<bool> connectUSB(int productId) async {
    print(productId);
    return true;
  }
}
