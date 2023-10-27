import 'package:fostershare/core/models/input/get_app_update_availability_input/get_app_update_availability_input.dart';
import 'package:fostershare/core/models/input/invitiation_input/invitiation_input.dart';
import 'package:fostershare/core/services/graphql/common/mutations.dart';
import 'package:fostershare/core/services/graphql/guest/guest_queries.dart';
import 'package:fostershare/core/services/graphql/common/utils.dart';
import 'package:fostershare/env/env.dart';
import 'package:graphql/client.dart';

class GuestGraphQLService {
  static final _httpLink = HttpLink(
    Env.baseGuestApiUrl.toString(),
  );

  final GraphQLClient _client = GraphQLClient(
    link: _httpLink,
    cache: GraphQLCache(),
  );

  /// Gets the current available resources
  /// TODO
  /// OnSuccess: Returns resource feed
  /// OnFailure: throws an OperationException
  Future<QueryResult> appAvailability(
    GetAppUpdateAvailabilityInput input,
  ) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: Queries.appAvailability,
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, GetAppUpdateAvailabilityInput>{
          "input": input,
        },
      ),
    );
  }

  /// Gets resource category with [id]
  ///
  /// OnSuccess: Returns resource category [id]
  /// OnFailure: throws an OperationException
  Future<QueryResult> resourceCategory(String id) async {
    return await graphQLQuery(
      client: _client,
      options: QueryOptions(
        document: Queries.resourceCategory,
        variables: {"id": id},
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
        document: Queries.resourceFeed,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  /// Gets all details pertaining to the medication
  /// associated with [productId] TODO
  ///
  /// OnSuccess: Returns the response on successes
  /// OnFailure: throws a ClientException or GraphQLException
  Future<QueryResult> sendInvitation(InvitiationInput invitiationInput) async {
    assert(invitiationInput != null);

    return graphQLMutation(
      client: _client,
      options: MutationOptions(
        document: Mutations.sendInvitation,
        variables: {
          "input": invitiationInput,
        },
      ),
    );
  }
}
