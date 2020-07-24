import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:identitic/providers/events_provider.dart';
import 'package:identitic/pages/home/widgets/event_list_tile.dart';

class EventsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsProvider>(
      builder: (_, EventsProvider eventsProvider, __) {
        if (eventsProvider.events != null) {
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: /* eventsProvider.events?.length ?? */ 4,
            itemBuilder: (_, int i) {
              final EventListTile eventListTile =
                  EventListTile(eventsProvider.events[i]);

              if (i == 0) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Próximos eventos',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                    ),
                    eventListTile,
                  ],
                );
              }

              return eventListTile;
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}