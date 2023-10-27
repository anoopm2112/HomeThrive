import 'package:add_2_calendar/add_2_calendar.dart' as add2Calendar;
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/data/event/event.dart';
import 'package:fostershare/core/models/input/get_event_input/get_event_input.dart';
import 'package:fostershare/core/models/input/update_participant_status_input/update_participant_status_input.dart';
import 'package:fostershare/core/services/events_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:stacked/stacked.dart';

enum EventDetailField {
  attendance,
}

class EventDetailViewModel extends BaseViewModel
    with FormViewModelMixin<EventDetailField> {
  final _eventsService = locator<EventsService>();
  final _loggerService = locator<LoggerService>();

  Event _event;
  Event get event => _event;

  Future<void> onModelReady(String id, Event eventDetails) async {
    setBusy(true);
    if (isAgencyEvent(eventDetails)) {
      _event = eventDetails;
    } else {
      try {
        _event = await _eventsService.event(
          GetEventInput(
            id: id,
          ),
        );

        this.addAllFormFields(
          {
            EventDetailField.attendance: FormFieldModel<EventParticipantStatus>(
              value: this._event.status,
            ),
          },
        );
      } catch (e) {
        // TODO
      }
    }
    notifyListeners();
    setBusy(false);
  }

  @override
  void updateField<T>(
    EventDetailField key, {
    T value,
    String validationMessage,
    String Function(T value) validator,
  }) async {
    this.setBusyForObject("UpdatingStatus", true);

    try {
      this._event = await _eventsService.updateEventParticipantStatus(
        UpdateParticipantStatusInput(
          eventId: this._event.id,
          status: value as EventParticipantStatus,
        ),
      );

      super.updateField<T>(
        key,
        value: value,
        validationMessage: validationMessage,
        validator: validator,
      );
    } catch (e) {
      print(e);
      // TODO
    }

    this.setBusyForObject("UpdatingStatus", false);

    notifyListeners();
  }

  void onAddToCalendar() {
    final int timeZoneOffset = DateTime.now().timeZoneOffset.inHours;
    final String timeZone = timeZoneOffset > 0
        ? '+' + timeZoneOffset.toString()
        : timeZoneOffset.toString();
    final add2Calendar.Event event = add2Calendar.Event(
      title: this._event.title,
      description: this._event.description,
      startDate: this._event.startsAt.toLocal(),
      endDate: this._event.endsAt.toLocal(),
      timeZone: "GMT$timeZone",
    );

    add2Calendar.Add2Calendar.addEvent2Cal(event);
  }

  bool isAgencyEvent(Event event) => event.eventType == "AGENCYEVENT";
}
