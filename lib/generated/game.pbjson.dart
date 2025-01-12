//
//  Generated code. Do not modify.
//  source: game.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use kniffelFieldDescriptor instead')
const KniffelField$json = {
  '1': 'KniffelField',
  '2': [
    {'1': 'none', '2': 0},
    {'1': 'ones', '2': 1},
    {'1': 'twos', '2': 2},
    {'1': 'threes', '2': 3},
    {'1': 'fours', '2': 4},
    {'1': 'fives', '2': 5},
    {'1': 'sixes', '2': 6},
    {'1': 'threeOfAKind', '2': 7},
    {'1': 'fourOfAKind', '2': 8},
    {'1': 'fullHouse', '2': 9},
    {'1': 'smallStraight', '2': 10},
    {'1': 'largeStraight', '2': 11},
    {'1': 'kniffel', '2': 12},
    {'1': 'chance', '2': 13},
  ],
};

/// Descriptor for `KniffelField`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List kniffelFieldDescriptor = $convert.base64Decode(
    'CgxLbmlmZmVsRmllbGQSCAoEbm9uZRAAEggKBG9uZXMQARIICgR0d29zEAISCgoGdGhyZWVzEA'
    'MSCQoFZm91cnMQBBIJCgVmaXZlcxAFEgkKBXNpeGVzEAYSEAoMdGhyZWVPZkFLaW5kEAcSDwoL'
    'Zm91ck9mQUtpbmQQCBINCglmdWxsSG91c2UQCRIRCg1zbWFsbFN0cmFpZ2h0EAoSEQoNbGFyZ2'
    'VTdHJhaWdodBALEgsKB2tuaWZmZWwQDBIKCgZjaGFuY2UQDQ==');

@$core.Deprecated('Use playerDescriptor instead')
const Player$json = {
  '1': 'Player',
  '2': [
    {'1': 'playerName', '3': 1, '4': 1, '5': 9, '10': 'playerName'},
  ],
};

/// Descriptor for `Player`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerDescriptor = $convert.base64Decode(
    'CgZQbGF5ZXISHgoKcGxheWVyTmFtZRgBIAEoCVIKcGxheWVyTmFtZQ==');

@$core.Deprecated('Use playerMoveDescriptor instead')
const PlayerMove$json = {
  '1': 'PlayerMove',
  '2': [
    {'1': 'player', '3': 1, '4': 1, '5': 11, '6': '.edu.hm.mobileappdev.proto.Player', '10': 'player'},
    {'1': 'gameId', '3': 2, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'dice', '3': 3, '4': 3, '5': 5, '10': 'dice'},
    {'1': 'selected_dice', '3': 4, '4': 3, '5': 5, '10': 'selectedDice'},
    {'1': 'rerollsLeft', '3': 5, '4': 1, '5': 5, '10': 'rerollsLeft'},
    {'1': 'done', '3': 6, '4': 1, '5': 14, '6': '.edu.hm.mobileappdev.proto.KniffelField', '10': 'done'},
  ],
};

/// Descriptor for `PlayerMove`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerMoveDescriptor = $convert.base64Decode(
    'CgpQbGF5ZXJNb3ZlEjkKBnBsYXllchgBIAEoCzIhLmVkdS5obS5tb2JpbGVhcHBkZXYucHJvdG'
    '8uUGxheWVyUgZwbGF5ZXISFgoGZ2FtZUlkGAIgASgJUgZnYW1lSWQSEgoEZGljZRgDIAMoBVIE'
    'ZGljZRIjCg1zZWxlY3RlZF9kaWNlGAQgAygFUgxzZWxlY3RlZERpY2USIAoLcmVyb2xsc0xlZn'
    'QYBSABKAVSC3Jlcm9sbHNMZWZ0EjsKBGRvbmUYBiABKA4yJy5lZHUuaG0ubW9iaWxlYXBwZGV2'
    'LnByb3RvLktuaWZmZWxGaWVsZFIEZG9uZQ==');

@$core.Deprecated('Use gameIdDescriptor instead')
const GameId$json = {
  '1': 'GameId',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GameId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameIdDescriptor = $convert.base64Decode(
    'CgZHYW1lSWQSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use joinRequestDescriptor instead')
const JoinRequest$json = {
  '1': 'JoinRequest',
  '2': [
    {'1': 'player', '3': 1, '4': 1, '5': 11, '6': '.edu.hm.mobileappdev.proto.Player', '10': 'player'},
    {'1': 'gameId', '3': 2, '4': 1, '5': 9, '10': 'gameId'},
  ],
};

/// Descriptor for `JoinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRequestDescriptor = $convert.base64Decode(
    'CgtKb2luUmVxdWVzdBI5CgZwbGF5ZXIYASABKAsyIS5lZHUuaG0ubW9iaWxlYXBwZGV2LnByb3'
    'RvLlBsYXllclIGcGxheWVyEhYKBmdhbWVJZBgCIAEoCVIGZ2FtZUlk');

@$core.Deprecated('Use ackDescriptor instead')
const Ack$json = {
  '1': 'Ack',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `Ack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ackDescriptor = $convert.base64Decode(
    'CgNBY2sSGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use gameStateDescriptor instead')
const GameState$json = {
  '1': 'GameState',
  '2': [
    {'1': 'gameId', '3': 1, '4': 1, '5': 9, '10': 'gameId'},
    {'1': 'players', '3': 2, '4': 3, '5': 11, '6': '.edu.hm.mobileappdev.proto.Player', '10': 'players'},
    {'1': 'currentPlayer', '3': 3, '4': 1, '5': 11, '6': '.edu.hm.mobileappdev.proto.Player', '10': 'currentPlayer'},
    {'1': 'moves', '3': 4, '4': 3, '5': 11, '6': '.edu.hm.mobileappdev.proto.PlayerMove', '10': 'moves'},
    {'1': 'gameStarted', '3': 5, '4': 1, '5': 8, '10': 'gameStarted'},
  ],
};

/// Descriptor for `GameState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameStateDescriptor = $convert.base64Decode(
    'CglHYW1lU3RhdGUSFgoGZ2FtZUlkGAEgASgJUgZnYW1lSWQSOwoHcGxheWVycxgCIAMoCzIhLm'
    'VkdS5obS5tb2JpbGVhcHBkZXYucHJvdG8uUGxheWVyUgdwbGF5ZXJzEkcKDWN1cnJlbnRQbGF5'
    'ZXIYAyABKAsyIS5lZHUuaG0ubW9iaWxlYXBwZGV2LnByb3RvLlBsYXllclINY3VycmVudFBsYX'
    'llchI7CgVtb3ZlcxgEIAMoCzIlLmVkdS5obS5tb2JpbGVhcHBkZXYucHJvdG8uUGxheWVyTW92'
    'ZVIFbW92ZXMSIAoLZ2FtZVN0YXJ0ZWQYBSABKAhSC2dhbWVTdGFydGVk');

