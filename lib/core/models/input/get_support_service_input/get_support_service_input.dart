import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_support_service_input.g.dart';

@JsonSerializable(createFactory: false)
class GetSupportServiceInput {
  final String id;

  const GetSupportServiceInput({this.id});

  void toJson() => _$GetSupportServiceInputToJson(this);
}
