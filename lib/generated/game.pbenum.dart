//
//  Generated code. Do not modify.
//  source: game.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class KniffelField extends $pb.ProtobufEnum {
  static const KniffelField none = KniffelField._(0, _omitEnumNames ? '' : 'none');
  static const KniffelField ones = KniffelField._(1, _omitEnumNames ? '' : 'ones');
  static const KniffelField twos = KniffelField._(2, _omitEnumNames ? '' : 'twos');
  static const KniffelField threes = KniffelField._(3, _omitEnumNames ? '' : 'threes');
  static const KniffelField fours = KniffelField._(4, _omitEnumNames ? '' : 'fours');
  static const KniffelField fives = KniffelField._(5, _omitEnumNames ? '' : 'fives');
  static const KniffelField sixes = KniffelField._(6, _omitEnumNames ? '' : 'sixes');
  static const KniffelField threeOfAKind = KniffelField._(7, _omitEnumNames ? '' : 'threeOfAKind');
  static const KniffelField fourOfAKind = KniffelField._(8, _omitEnumNames ? '' : 'fourOfAKind');
  static const KniffelField fullHouse = KniffelField._(9, _omitEnumNames ? '' : 'fullHouse');
  static const KniffelField smallStraight = KniffelField._(10, _omitEnumNames ? '' : 'smallStraight');
  static const KniffelField largeStraight = KniffelField._(11, _omitEnumNames ? '' : 'largeStraight');
  static const KniffelField kniffel = KniffelField._(12, _omitEnumNames ? '' : 'kniffel');
  static const KniffelField chance = KniffelField._(13, _omitEnumNames ? '' : 'chance');

  static const $core.List<KniffelField> values = <KniffelField> [
    none,
    ones,
    twos,
    threes,
    fours,
    fives,
    sixes,
    threeOfAKind,
    fourOfAKind,
    fullHouse,
    smallStraight,
    largeStraight,
    kniffel,
    chance,
  ];

  static final $core.Map<$core.int, KniffelField> _byValue = $pb.ProtobufEnum.initByValue(values);
  static KniffelField? valueOf($core.int value) => _byValue[value];

  const KniffelField._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
