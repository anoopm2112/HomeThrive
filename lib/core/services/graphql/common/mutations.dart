import 'package:graphql/client.dart';

class Mutations {
  static final sendInvitation = gql(r'''
  mutation SendInvitation($input: InvitationInput!) {
    sendInvitation(input: $input) {
      success
    }
  }
  ''');
}
