import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/med_log_entry/med_log_entry.dart';
import 'package:fostershare/core/models/data/med_log_note/med_log_note.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/core/models/input/med_log/create_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/create_med_log_note_input.dart';
import 'package:fostershare/core/models/input/med_log/generate_signing_request_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_logs_input.dart';
import 'package:fostershare/core/models/input/med_log/get_medication_input.dart';
import 'package:fostershare/core/models/input/med_log/update_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/update_signing_status_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/create_med_log_entry_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/create_med_log_entry_note_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/get_med_log_entries_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/get_med_log_entry_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/update_med_log_entry_input.dart';
import 'package:fostershare/core/models/input/medlog_medication_details/create_medication_details_input.dart';
import 'package:fostershare/core/models/response/get_med_log_entries_response/get_med_log_entries_response.dart';
import 'package:fostershare/core/models/response/med_log/get_med_logs_response.dart';
import 'package:fostershare/core/services/graphql/auth/auth_graphql_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:graphql/client.dart';

class MedLogService {
  final _authGraphQLService = locator<AuthGraphQLService>();
  final _loggerService = locator<LoggerService>();

  Future<GetMedLogsResponse> medLogs(
    GetMedLogsInput input, {
    bool extendedDetails = false,
  }) async {
    _loggerService.info("MedLogService - medLogs()");

    final QueryResult result = await _authGraphQLService.medLogs(input,
        extendedDetails: extendedDetails);

    return GetMedLogsResponse.fromJson(result.data["medLogs"]);
  }

  Future<MedLog> createMedLog(CreateMedLogInput input) async {
    _loggerService.info("MedLogService - createMedLog()");

    final QueryResult result = await _authGraphQLService.createMedLog(
      input,
    );

    return MedLog.fromJson(result.data["createMedLog"]);
  }

  Future<GetMedLogEntriesResponse> medLogEntries(
      GetMedLogEntriesInput input) async {
    _loggerService.info("MedLogService - medLogEntries()");

    final QueryResult result = await _authGraphQLService.medLogEntries(
      input,
    );

    return GetMedLogEntriesResponse.fromJson(result.data["medLogEntries"]);
  }

  Future<MedLog> medLog(GetMedLogInput input, {bool isExtended = false}) async {
    _loggerService.info("MedLogService - medLog()");

    final QueryResult result =
        await _authGraphQLService.medLog(input, isExtended: isExtended);

    return MedLog.fromJson(result.data["medLog"]);
  }

  Future<List<MedLogMedicationDetail>> addNewMedications(
      String medLogId, List<CreateMedicationDetailsInput> medications) async {
    _loggerService.info("MedLogService - addNewMedications()");

    var input = UpdateMedLogInput(medLogId, medications: medications);
    final QueryResult result = await _authGraphQLService.updateMedLogMedication(
      input,
    );
    var parsedResult = MedLog.fromJson(result.data["updateMedLog"]);
    return parsedResult.medications;
  }

  Future<MedLogMedicationDetail> medLogMedication(
      GetMedicationInput input) async {
    _loggerService.info("MedLogService - medLogMedication()");

    final QueryResult result = await _authGraphQLService.medLogMedication(
      input,
    );
    return MedLogMedicationDetail.fromJson(result.data["medication"]);
  }

  Future<List<MedLogNote>> addNewNotesForMedication(
      String medLogId, List<CreateMedLogNoteInput> inputs) async {
    _loggerService.info("MedLogService - addNewNotesForMedication()");

    var input = UpdateMedLogInput(medLogId, notes: inputs);
    final QueryResult result = await _authGraphQLService.updateMedLogNotes(
      input,
    );
    var parsedResult = MedLog.fromJson(result.data["updateMedLog"]);
    return parsedResult.notes;
  }

  Future<MedLogEntry> createNewEntry(CreateMedLogEntryInput input) async {
    _loggerService.info("MedLogService - createNewEntry()");

    final QueryResult result = await _authGraphQLService.createMedLogEntry(
      input,
    );
    var parsedResult = MedLogEntry.fromJson(result.data["createMedLogEntry"]);
    return parsedResult;
  }

  Future<MedLogEntry> medLogEntry(GetMedLogEntryInput input) async {
    _loggerService.info("MedLogService - medLogEntry()");

    final QueryResult result = await _authGraphQLService.medLogEntry(
      input,
    );
    var parsedResult = MedLogEntry.fromJson(result.data["medLogEntry"]);
    return parsedResult;
  }

  Future<List<MedLogNote>> addNewNotesForEntry(String medLogId, String entryId,
      List<CreateMedLogEntryNoteInput> inputs) async {
    _loggerService.info("MedLogService - addNewNotesForEntry()");

    var input = UpdateMedLogEntryInput(entryId, inputs);
    final QueryResult result = await _authGraphQLService.updateMedLogEntryNotes(
      input,
    );
    var parsedResult = MedLog.fromJson(result.data["updateMedLogEntry"]);
    return parsedResult.notes;
  }

  Future<void> deleteMedLogEntry(String entryId) async {
    _loggerService.info("MedLogService - deleteMedLogEntry()");

    var input = GetMedLogEntryInput(entryId);
    await _authGraphQLService.deleteMedLogEntry(
      input,
    );
  }

  Future<void> submitAndGenerateSigningRequest(
    GenerateSigningRequestInput input,
  ) async {
    _loggerService.info("MedLogService - submitAndGenerateSigningRequest()");

    await _authGraphQLService.submitAndGenerateSigningRequest(
      input,
    );
  }

  Future<String> signingUrl(
    GenerateSigningRequestInput input,
  ) async {
    _loggerService.info("MedLogService - signingUrl()");

    var result = await _authGraphQLService.generateSigningUrl(
      input,
    );
    return result.data["generateSigningUrl"];
  }

  Future<String> documentUrl(GetMedLogInput input) async {
    _loggerService.info("MedLogService - medLog()");

    final QueryResult result =
        await _authGraphQLService.medLogDocumentUrl(input);

    var parsedResponse = MedLog.fromJson(result.data["medLog"]);
    return parsedResponse.documentUrl;
  }

  Future<MedLog> updateSigningStatus(UpdateSigningStatusInput input) async {
    _loggerService.info("MedLogService - updateSigningStatus()");

    final QueryResult result = await _authGraphQLService.updateSigningStatus(
      input,
    );

    return result.data[0];
  }
}
