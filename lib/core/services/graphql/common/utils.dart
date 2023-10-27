import 'package:graphql/client.dart';
import 'package:meta/meta.dart';

Future<QueryResult> graphQLQuery({
  @required GraphQLClient client,
  @required QueryOptions options,
}) async {
  assert(client != null);

  final QueryResult result = await client.query(options);

  _checkAndHandleExceptions(result);

  return result;
}

Future<QueryResult> graphQLMutation({
  @required GraphQLClient client,
  @required MutationOptions options,
}) async {
  assert(client != null);

  final QueryResult result = await client.mutate(options);

  _checkAndHandleExceptions(result);

  return result;
}

void _checkAndHandleExceptions(QueryResult result) {
  if (result.hasException) {
    throw result.exception;
  }
}
