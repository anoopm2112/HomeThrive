import 'package:gql/ast.dart';
import 'package:meta/meta.dart';

class AddFragmentsVisitor extends TransformingVisitor {
  final List<DocumentNode> fragments;

  AddFragmentsVisitor({
    @required this.fragments,
  }) : assert(fragments != null);

  @override
  DocumentNode visitDocumentNode(
    DocumentNode node,
  ) =>
      DocumentNode(
        definitions: [
          ...node.definitions,
          ...fragments
              .expand(
                (fragment) => fragment.definitions,
              )
              .toList(),
        ],
        span: node.span,
      );
}
