import 'package:chat_app/models/message.dart';
import 'package:get/get.dart';

class ChatScreenController extends GetxController {
  List<Message> _list = [];
  bool _showEmoji = false;
  bool _isUploading = false;

  List<Message> get list => _list;
  bool get showEmoji => _showEmoji;
  bool get isUploading => _isUploading;

  void toggleEmoji() {
    _showEmoji = !_showEmoji;
    update();
  }

  void startUploading() {
    _isUploading = true;
    update();
  }

  void stopUploading() {
    _isUploading = false;
    update();
  }
}
