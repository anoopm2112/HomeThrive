import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:meta/meta.dart';

class CurrentUser {
  String get firstName => _getUserAttribute<String>("given_name");
  String get lastName => _getUserAttribute<String>("family_name");
  int get role => _getUserAttribute<int>("custom:roles");
  String get fullName => this.firstName != null && lastName != null
      ? "${this.firstName} ${this.lastName}"
      : null;
  String get email => _getUserAttribute<String>("email");
  final List<AuthUserAttribute> attributes;

  const CurrentUser({
    @required this.attributes,
  });

  T _getUserAttribute<T>(String usserAttributeKey) {
    return this
        .attributes
        .firstWhere(
          (attribute) => attribute.userAttributeKey == usserAttributeKey,
          orElse: null,
        )
        .value as T;
  }
}
