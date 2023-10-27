import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/input/create_child_log_image_input/create_child_log_image_input.dart';
import 'package:fostershare/core/models/input/create_child_log_input/create_child_log_input.dart';
import 'package:fostershare/core/models/input/create_child_log_note/create_child_log_note_input.dart';
import 'package:fostershare/core/models/input/create_family_image_input/create_family_image_input.dart';
import 'package:fostershare/core/models/input/create_recreation_log_input/create_recreation_log_input.dart';
import 'package:fostershare/core/models/input/get_child_logs_input/get_child_logs_input.dart';
import 'package:fostershare/core/models/input/get_children_logs/get_children_logs_input.dart';
import 'package:fostershare/core/models/input/get_event_input/get_event_input.dart';
import 'package:fostershare/core/models/input/get_events_input/get_events_input.dart';
import 'package:fostershare/core/models/input/get_messages_input/get_messages_input.dart';
import 'package:fostershare/core/models/input/get_support_service_input/get_support_service_input.dart';
import 'package:fostershare/core/models/input/get_support_services_input/get_support_services_input.dart';
import 'package:fostershare/core/models/input/mark_messages_as_read_input/mark_messages_as_read_input.dart';
import 'package:fostershare/core/models/input/med_log/create_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/generate_signing_request_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_logs_input.dart';
import 'package:fostershare/core/models/input/med_log/get_medication_input.dart';
import 'package:fostershare/core/models/input/med_log/update_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/update_signing_status_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/create_med_log_entry_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/get_med_log_entries_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/get_med_log_entry_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/update_med_log_entry_input.dart';
import 'package:fostershare/core/models/input/register_device_input/register_device_input.dart';
import 'package:fostershare/core/models/input/update_child_input/update_child_input.dart';
import 'package:fostershare/core/models/input/update_child_nickname_input/update_child_nickname_input.dart';
import 'package:fostershare/core/models/input/update_child_log_input/update_child_log_input.dart';
import 'package:fostershare/core/models/input/update_participant_status_input/update_participant_status_input.dart';
import 'package:fostershare/core/models/input/update_profile_input/update_profile_input.dart';
import 'package:fostershare/core/models/input/get_family_images_input/get_family_images_input.dart';
import 'package:fostershare/core/models/input/get_recreation_logs_input/get_recreation_logs_input.dart';
import 'package:fostershare/core/models/input/get_recreation_log_input/get_recreation_log_input.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:fostershare/core/services/graphql/auth/auth_mutations.dart';
import 'package:fostershare/core/services/graphql/auth/auth_queries.dart';
import 'package:fostershare/core/services/graphql/common/utils.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/env/env.dart';
import 'package:graphql/client.dart';

class AuthGraphQLService {
  static final _authService = locator<AuthService>();
  final _loggerService = locator<LoggerService>();

  static final _authLink = AuthLink(
    getToken: () async => await _authService.getIdToken(),
  );

  static final _httpLink = HttpLink(
    Env.baseAuthApiUrl.toString(),
  );

  static final Link _link = _authLink.concat(_httpLink);

  final GraphQLClient _client = GraphQLClient(
    link: _link,
    cache: GraphQLCache(),
  );

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> childLog(GetChildLogInput input) async {
    _loggerService.info("AuthGraphQLSService - childLog()");

    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.childLog,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, GetChildLogInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> children() async {
    _loggerService.info("AuthGraphQLSService - children()");

    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.children,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> childrenLogs(GetChildrenLogsInput input) async {
    _loggerService.info("AuthGraphQLSService - childrenLogs()");

    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.childrenLogs,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, GetChildrenLogsInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> childrenSummary(GetChildrenLogsInput input) async {
    _loggerService.info("AuthGraphQLSService - childrenSummary()");

    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.childrenSummary,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, GetChildrenLogsInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> createChildLog(CreateChildLogInput input) async {
    _loggerService.info("AuthGraphQLSService - createChildLog()");

    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.createChildLog,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, CreateChildLogInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> updateChildLog(UpdateChildLogInput input) async {
    _loggerService.info("AuthGraphQLSService - updateChildLog()");

    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.updateChildLog,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, UpdateChildLogInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> createChildLogImage(
    CreateChildLogImageInput input,
  ) async {
    _loggerService.info("AuthGraphQLSService - createChildLogImage()");

    return graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.createChildLogImage,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, CreateChildLogImageInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> createChildLogNote(CreateChildLogNoteInput input) async {
    _loggerService.info("AuthGraphQLSService - createChildLogNote()");

    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.createChildLogNote,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, CreateChildLogNoteInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> event(GetEventInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.event,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"input": input},
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> events(GetEventsInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.events, // TODO fetch policy
        variables: {"input": input},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> updateChild(UpdateChildInput input) async {
    _loggerService.info(
      "AuthGraphQLService - updateChild()",
    );

    return graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.updateChild,
        fetchPolicy: FetchPolicy.noCache,
        variables: <String, UpdateChildInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> updateChildNickName(
      UpdateChildNickNameInput input) async {
    _loggerService.info(
      "AuthGraphQLService - updateChildNickName()",
    );

    return graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.updateChildNickName,
        fetchPolicy: FetchPolicy.noCache,
        variables: <String, UpdateChildNickNameInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> markMesssagesAsRead(MarkMessagesAsReadInput input) async {
    _loggerService.info(
      "AuthGraphQLService - markMesssagesAsRead()",
    );

    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.markMessagesAsRead,
        fetchPolicy: FetchPolicy.noCache,
        variables: {"input": input},
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> messages(GetMessagesInput input) async {
    _loggerService.info(
      "AuthGraphQLService - messages()",
    );

    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.messages,
        fetchPolicy: FetchPolicy.noCache,
        variables: {"input": input},
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> profile() async {
    _loggerService.info(
      "AuthGraphQLService - profile()",
    );

    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.profile, // TODO fetch policy
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
  }

  /// Gets the current available resources
  ///
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> registerDevice(RegisterDeviceInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthMutations.registerDevice,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  ///
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> resourceFeed() async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.resourceFeed,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> updateEventParticipantStatus(
    UpdateParticipantStatusInput input,
  ) async {
    assert(input != null);

    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document:
            AuthMutations.updateEventParticipantStatus, // TODO fetch policy
        variables: <String, UpdateParticipantStatusInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> updateProfile(UpdateProfileInput input) async {
    assert(input != null);

    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.updateProfile, // TODO fetch policy
        variables: <String, UpdateProfileInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> familyImages(GetFamilyImagesInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.familyImages,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetFamilyImagesInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> createFamilyImage(CreateFamilyImageInput input) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.createFamilyImage,
        variables: <String, CreateFamilyImageInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> supportServices(GetSupportServicesInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.supportServices,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetSupportServicesInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> supportService(GetSupportServiceInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.supportService,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetSupportServiceInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> medLogs(
    GetMedLogsInput input, {
    bool extendedDetails = false,
  }) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: extendedDetails
            ? AuthQueries.listMedLogsExtendedDetails
            : AuthQueries.listMedLogs,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetMedLogsInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> createMedLog(CreateMedLogInput input) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.createMedLog,
        variables: <String, CreateMedLogInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> medLogEntries(GetMedLogEntriesInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.listMedLogEntries,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetMedLogEntriesInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> medLog(GetMedLogInput input,
      {bool isExtended = false}) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: isExtended ? AuthQueries.medLogExtended : AuthQueries.medLog,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetMedLogInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> updateMedLogMedication(UpdateMedLogInput input) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.updateMedLogMedication,
        variables: <String, UpdateMedLogInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> medLogMedication(GetMedicationInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.medLogMedication,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetMedicationInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> updateMedLogNotes(UpdateMedLogInput input) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.updateMedLogNotes,
        variables: <String, UpdateMedLogInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> createMedLogEntry(CreateMedLogEntryInput input) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.createMedLogEntry,
        variables: <String, CreateMedLogEntryInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> recreationLogs(GetRecreationLogsInput input) async {
    _loggerService.info("AuthGraphQLSService - recreationLogs()");

    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.recreationLogs,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, GetRecreationLogsInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> medLogEntry(GetMedLogEntryInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.medLogEntry,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetMedLogEntryInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> recreationLog(GetRecreationLogInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.recreationLog,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetRecreationLogInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> updateMedLogEntryNotes(
    UpdateMedLogEntryInput input,
  ) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.updateMedLogEntryNotes,
        variables: <String, UpdateMedLogEntryInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> deleteMedLogEntry(
    GetMedLogEntryInput input,
  ) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.deleteMedLogEntry,
        variables: <String, GetMedLogEntryInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> submitAndGenerateSigningRequest(
    GenerateSigningRequestInput input,
  ) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.submitAndCreateSigningRequest,
        variables: <String, GenerateSigningRequestInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> generateSigningUrl(
    GenerateSigningRequestInput input,
  ) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.generateSigningUrl,
        variables: <String, GenerateSigningRequestInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> medLogDocumentUrl(GetMedLogInput input) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: AuthQueries.medLogDocumentUrl,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetMedLogInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> createRecreationLog(
      CreateRecreationLogInput input) async {
    _loggerService.info("AuthGraphQLSService - createRecLog()");

    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.createRecreationLog,
        fetchPolicy: FetchPolicy.networkOnly, // TODO fetch policy
        variables: <String, CreateRecreationLogInput>{
          "input": input,
        },
      ),
    );
  }

  Future<QueryResult> updateSigningStatus(
      UpdateSigningStatusInput input) async {
    return await graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: AuthMutations.updateSigningStatus,
        variables: <String, UpdateSigningStatusInput>{
          "input": input,
        },
      ),
    );
  }
}
