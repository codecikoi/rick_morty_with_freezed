
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rick_morty_find_person_freezed/data/repositories/character_repo.dart';
import '../data/models/character.dart';


part 'character_event.dart';
part 'character_state.dart';
part 'character_bloc.g.dart';
part 'character_bloc.freezed.dart';

class CharacterBloc extends Bloc<CharacterState, CharacterEvent> with HydratedMixin {

  final CharacterRepo characterRepo;


  CharacterBloc({required this.characterRepo}) : super (CharacterState.loading()) {
    on<CharacterEventFetch>((event, emit) async {
      emit(CharacterState.loading());
      try {
        Character characterLoaded = await characterRepo.getCharacter(event.page, event.name).timeout(Duration(seconds: 5));
        emit(CharacterState.loaded(characterLoaded: characterLoaded));
      } catch (_) {
        emit(CharacterState.error());
        rethrow;
      }
    });
  }

  @override
  CharacterState? fromJson(Map<String, dynamic> json) => CharacterState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CharacterState state) => state.toJson();
}


