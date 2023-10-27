import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/event/event.dart';
import 'package:fostershare/core/models/input/get_event_input/get_event_input.dart';
import 'package:fostershare/core/models/input/get_events_input/get_events_input.dart';
import 'package:fostershare/core/models/input/update_participant_status_input/update_participant_status_input.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class EventsService {
  final _authGraphQLService = locator<AuthGraphQLService>();
  final _loggerService = locator<LoggerService>();

  Future<Event> event(GetEventInput input) async {
    _loggerService.info(
      "EventsService - event(id: ${input.id})",
    );

    final QueryResult result = await _authGraphQLService.event(input);

    return Event.fromJson(result.data["event"]);
  }

  Future<List<Event>> events(GetEventsInput input) async {
    _loggerService.info(
      "EventsService - events(fromDate: ${input.fromDate}, toDate: ${input.toDate})",
    );

    final QueryResult result = await _authGraphQLService.events(input);

    List<Event> events = <Event>[];

    final eventsJson = result.data["events"] as List<dynamic>;
    for (var eventJson in eventsJson) {
      events.add(Event.fromJson(eventJson));
    }

    return events;
  }

  Future<Event> updateEventParticipantStatus(
      UpdateParticipantStatusInput input) async {
    _loggerService.info(
      "EventsService - updateParticipantStatus()",
    );

    final QueryResult result =
        await _authGraphQLService.updateEventParticipantStatus(
      input,
    );

    return Event.fromJson(result.data["updateEventParticipantStatus"]);
  }
}
