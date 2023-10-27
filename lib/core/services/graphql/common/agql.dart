import 'package:fostershare/core/services/graphql/common/visitors/add_fragments_visitor.dart';
import 'package:fostershare/core/services/graphql/common/visitors/add_nested_typename_visitor.dart';
import 'package:gql/ast.dart';
import 'package:gql/language.dart';
import 'package:meta/meta.dart';

DocumentNode agql({
  @required String document,
  List<DocumentNode> fragments,
}) {
  assert(document != null);

  return transform(
    parseString(document), // TODO fix use document and remove addnested
    [
      AddNestedTypenameVisitor(),
      if (fragments != null) AddFragmentsVisitor(fragments: fragments),
    ],
  );
}
