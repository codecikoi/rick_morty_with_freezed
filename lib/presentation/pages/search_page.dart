import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rick_morty_find_person_freezed/data/models/character.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rick_morty_find_person_freezed/presentation/widgets/custom_list_tile.dart';

import '../../bloc/character_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Character _currentCharacter;
  List<Results> _currentResults = [];
  int _currentPage = 1;
  String _currentSearchStr = '';

  final RefreshController refreshController = RefreshController();
  bool _isPagination = false;

  Timer? searchDebounce;

  final _storage = HydratedBloc.storage;

  @override
  void initState() {
    if (_storage.runtimeType.toString().isEmpty) {
      if (_currentResults.isEmpty) {
        context.read<CharacterBloc>().add(
              CharacterEvent.fetch(name: '', page: 1),
            );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterBloc>().state;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 15,
            bottom: 15,
            left: 16,
            right: 16,
          ),
          child: TextField(
            style: TextStyle(
              color: Colors.white70,
            ),
            cursorColor: Colors.white70,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(86, 86, 86, 0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white70,
              ),
              hintText: 'Search name',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
            onChanged: (value) {
              _currentPage = 1;
              _currentResults = [];
              _currentSearchStr = value;
              searchDebounce?.cancel();
              searchDebounce = Timer(
                  Duration(
                    milliseconds: 500,
                  ), () {
                context
                    .read<CharacterBloc>()
                    .add(CharacterEvent.fetch(name: value, page: _currentPage));
              });
            },
          ),
        ),
        Expanded(
          child: state.when(
            loading: () {
              if (!_isPagination) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(width: 10),
                      Text('Loading...'),
                    ],
                  ),
                );
              } else {
                return _customListView(_currentResults);
              }
            },
            loaded: (characterLoaded) {
              _currentCharacter = characterLoaded;
              if (_isPagination) {
                List.from(_currentResults).addAll(_currentCharacter.results);
                refreshController.loadComplete();
                _isPagination = false;
              } else {
                _currentResults = _currentCharacter.results;
              }
              return _currentResults.isNotEmpty
                  ? _customListView(_currentResults)
                  : SizedBox();
            },
            error: () => Text('nothing...'),
          ),
        ),
      ],
    );
  }

  Widget _customListView(List<Results> currentResults) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: () {
        _isPagination = true;
        _currentPage++;
        if (_currentPage <= _currentCharacter.info.pages) {
          context.read<CharacterBloc>().add(CharacterEvent.fetch(
              name: _currentSearchStr, page: _currentPage));
        } else {
          refreshController.loadNoData();
        }
      },
      child: ListView.separated(
          itemBuilder: (context, index) {
            final results = currentResults[index];
            return Padding(
              padding: EdgeInsets.only(
                right: 16,
                left: 16,
                top: 3,
                bottom: 3,
              ),
              child: CustomListTile(
                results: results,
              ),
            );
          },
          separatorBuilder: (_, index) => SizedBox(
                height: 5,
              ),
          itemCount: currentResults.length),
    );
  }
}
