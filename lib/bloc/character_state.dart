part of 'character_bloc.dart';


@freezed
class CharacterState with _$CharacterState {
  factory CharacterState.loading() = CharacterStateLoading;
  factory CharacterState.loaded({required Character characterLoaded}) = CharacterStateLoaded;
  factory CharacterState.error() = CharacterStateError;


  factory CharacterState.fromJson(Map<String, dynamic> json) => _$CharacterStateFromJson(json);
}