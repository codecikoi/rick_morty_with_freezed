import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_morty_find_person_freezed/data/models/character.dart';

import 'character_status.dart';

class CustomListTile extends StatelessWidget {
  final Results results;

  const CustomListTile({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: MediaQuery.of(context).size.height / 7,
        color: Color.fromRGBO(86, 86, 86, 0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: results.image,
              placeholder: (context, url) => CircularProgressIndicator(
                color: Colors.grey,
              ),
              errorWidget: (context, ur, error) => Icon(Icons.error),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.9,
                    child: Text(
                      results.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  CharacterStatus(
                    liveState: results.status == 'Alive'
                        ? LiveState.alive
                        : results.status == 'Dead'
                            ? LiveState.dead
                            : LiveState.unknown,
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Species: ${results.species}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(height: 2.0),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender: ${results.gender}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(height: 2.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
