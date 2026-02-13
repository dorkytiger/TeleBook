import 'dart:async';

import 'package:get/get.dart';
import 'package:tele_book/app/db/app_database.dart';

class EventBus extends GetxService {
  final _controller = StreamController<AppEvent>.broadcast();

  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  void fire(AppEvent event) {
    _controller.add(event);
  }
}

abstract class AppEvent {}

sealed class BookEvent extends AppEvent {}

class BookRefreshedEvent extends BookEvent {}

class BookAddedEvent extends BookEvent {
  final BookTableCompanion data;

  BookAddedEvent(this.data);
}

class BookUpdatedEvent extends BookEvent {
  final BookTableCompanion data;

  BookUpdatedEvent(this.data);
}
