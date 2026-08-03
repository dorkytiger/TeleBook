import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_provider.freezed.dart';
part 'main_provider.g.dart';

@freezed
abstract class MainState with _$MainState {
  const factory MainState({
    @Default(0) int currentIndex,
  }) = _MainState;
}

@riverpod
class Main extends _$Main {
  @override
  MainState build() {
    return const MainState();
  }

  void updateCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}