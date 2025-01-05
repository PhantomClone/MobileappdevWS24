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

import 'game.pbenum.dart';

export 'game.pbenum.dart';

class Player extends $pb.GeneratedMessage {
  factory Player({
    $core.String? playerName,
  }) {
    final $result = create();
    if (playerName != null) {
      $result.playerName = playerName;
    }
    return $result;
  }
  Player._() : super();
  factory Player.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Player.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Player', package: const $pb.PackageName(_omitMessageNames ? '' : 'edu.hm.mobileappdev.proto'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playerName', protoName: 'playerName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Player clone() => Player()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Player copyWith(void Function(Player) updates) => super.copyWith((message) => updates(message as Player)) as Player;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Player create() => Player._();
  Player createEmptyInstance() => create();
  static $pb.PbList<Player> createRepeated() => $pb.PbList<Player>();
  @$core.pragma('dart2js:noInline')
  static Player getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Player>(create);
  static Player? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playerName => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayerName() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerName() => clearField(1);
}

class PlayerMove extends $pb.GeneratedMessage {
  factory PlayerMove({
    Player? player,
    $core.String? gameId,
    $core.Iterable<$core.int>? dice,
    $core.int? rerollsLeft,
    KniffelField? done,
  }) {
    final $result = create();
    if (player != null) {
      $result.player = player;
    }
    if (gameId != null) {
      $result.gameId = gameId;
    }
    if (dice != null) {
      $result.dice.addAll(dice);
    }
    if (rerollsLeft != null) {
      $result.rerollsLeft = rerollsLeft;
    }
    if (done != null) {
      $result.done = done;
    }
    return $result;
  }
  PlayerMove._() : super();
  factory PlayerMove.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerMove.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlayerMove', package: const $pb.PackageName(_omitMessageNames ? '' : 'edu.hm.mobileappdev.proto'), createEmptyInstance: create)
    ..aOM<Player>(1, _omitFieldNames ? '' : 'player', subBuilder: Player.create)
    ..aOS(2, _omitFieldNames ? '' : 'gameId', protoName: 'gameId')
    ..p<$core.int>(3, _omitFieldNames ? '' : 'dice', $pb.PbFieldType.K3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'rerollsLeft', $pb.PbFieldType.O3, protoName: 'rerollsLeft')
    ..e<KniffelField>(5, _omitFieldNames ? '' : 'done', $pb.PbFieldType.OE, defaultOrMaker: KniffelField.none, valueOf: KniffelField.valueOf, enumValues: KniffelField.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerMove clone() => PlayerMove()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerMove copyWith(void Function(PlayerMove) updates) => super.copyWith((message) => updates(message as PlayerMove)) as PlayerMove;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerMove create() => PlayerMove._();
  PlayerMove createEmptyInstance() => create();
  static $pb.PbList<PlayerMove> createRepeated() => $pb.PbList<PlayerMove>();
  @$core.pragma('dart2js:noInline')
  static PlayerMove getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerMove>(create);
  static PlayerMove? _defaultInstance;

  @$pb.TagNumber(1)
  Player get player => $_getN(0);
  @$pb.TagNumber(1)
  set player(Player v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayer() => clearField(1);
  @$pb.TagNumber(1)
  Player ensurePlayer() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get gameId => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGameId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get dice => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get rerollsLeft => $_getIZ(3);
  @$pb.TagNumber(4)
  set rerollsLeft($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRerollsLeft() => $_has(3);
  @$pb.TagNumber(4)
  void clearRerollsLeft() => clearField(4);

  @$pb.TagNumber(5)
  KniffelField get done => $_getN(4);
  @$pb.TagNumber(5)
  set done(KniffelField v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDone() => $_has(4);
  @$pb.TagNumber(5)
  void clearDone() => clearField(5);
}

class GameId extends $pb.GeneratedMessage {
  factory GameId({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GameId._() : super();
  factory GameId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameId', package: const $pb.PackageName(_omitMessageNames ? '' : 'edu.hm.mobileappdev.proto'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameId clone() => GameId()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameId copyWith(void Function(GameId) updates) => super.copyWith((message) => updates(message as GameId)) as GameId;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameId create() => GameId._();
  GameId createEmptyInstance() => create();
  static $pb.PbList<GameId> createRepeated() => $pb.PbList<GameId>();
  @$core.pragma('dart2js:noInline')
  static GameId getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameId>(create);
  static GameId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class JoinRequest extends $pb.GeneratedMessage {
  factory JoinRequest({
    Player? player,
    $core.String? gameId,
  }) {
    final $result = create();
    if (player != null) {
      $result.player = player;
    }
    if (gameId != null) {
      $result.gameId = gameId;
    }
    return $result;
  }
  JoinRequest._() : super();
  factory JoinRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'edu.hm.mobileappdev.proto'), createEmptyInstance: create)
    ..aOM<Player>(1, _omitFieldNames ? '' : 'player', subBuilder: Player.create)
    ..aOS(2, _omitFieldNames ? '' : 'gameId', protoName: 'gameId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinRequest clone() => JoinRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinRequest copyWith(void Function(JoinRequest) updates) => super.copyWith((message) => updates(message as JoinRequest)) as JoinRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRequest create() => JoinRequest._();
  JoinRequest createEmptyInstance() => create();
  static $pb.PbList<JoinRequest> createRepeated() => $pb.PbList<JoinRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRequest>(create);
  static JoinRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Player get player => $_getN(0);
  @$pb.TagNumber(1)
  set player(Player v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayer() => clearField(1);
  @$pb.TagNumber(1)
  Player ensurePlayer() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get gameId => $_getSZ(1);
  @$pb.TagNumber(2)
  set gameId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGameId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGameId() => clearField(2);
}

class Ack extends $pb.GeneratedMessage {
  factory Ack({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  Ack._() : super();
  factory Ack.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Ack.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Ack', package: const $pb.PackageName(_omitMessageNames ? '' : 'edu.hm.mobileappdev.proto'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Ack clone() => Ack()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Ack copyWith(void Function(Ack) updates) => super.copyWith((message) => updates(message as Ack)) as Ack;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ack create() => Ack._();
  Ack createEmptyInstance() => create();
  static $pb.PbList<Ack> createRepeated() => $pb.PbList<Ack>();
  @$core.pragma('dart2js:noInline')
  static Ack getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ack>(create);
  static Ack? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

class GameState extends $pb.GeneratedMessage {
  factory GameState({
    $core.String? gameId,
    $core.Iterable<Player>? players,
    Player? currentPlayer,
    $core.Iterable<PlayerMove>? moves,
    $core.bool? gameStarted,
  }) {
    final $result = create();
    if (gameId != null) {
      $result.gameId = gameId;
    }
    if (players != null) {
      $result.players.addAll(players);
    }
    if (currentPlayer != null) {
      $result.currentPlayer = currentPlayer;
    }
    if (moves != null) {
      $result.moves.addAll(moves);
    }
    if (gameStarted != null) {
      $result.gameStarted = gameStarted;
    }
    return $result;
  }
  GameState._() : super();
  factory GameState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameState', package: const $pb.PackageName(_omitMessageNames ? '' : 'edu.hm.mobileappdev.proto'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gameId', protoName: 'gameId')
    ..pc<Player>(2, _omitFieldNames ? '' : 'players', $pb.PbFieldType.PM, subBuilder: Player.create)
    ..aOM<Player>(3, _omitFieldNames ? '' : 'currentPlayer', protoName: 'currentPlayer', subBuilder: Player.create)
    ..pc<PlayerMove>(4, _omitFieldNames ? '' : 'moves', $pb.PbFieldType.PM, subBuilder: PlayerMove.create)
    ..aOB(5, _omitFieldNames ? '' : 'gameStarted', protoName: 'gameStarted')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameState clone() => GameState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameState copyWith(void Function(GameState) updates) => super.copyWith((message) => updates(message as GameState)) as GameState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameState create() => GameState._();
  GameState createEmptyInstance() => create();
  static $pb.PbList<GameState> createRepeated() => $pb.PbList<GameState>();
  @$core.pragma('dart2js:noInline')
  static GameState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameState>(create);
  static GameState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gameId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Player> get players => $_getList(1);

  @$pb.TagNumber(3)
  Player get currentPlayer => $_getN(2);
  @$pb.TagNumber(3)
  set currentPlayer(Player v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCurrentPlayer() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentPlayer() => clearField(3);
  @$pb.TagNumber(3)
  Player ensureCurrentPlayer() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<PlayerMove> get moves => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get gameStarted => $_getBF(4);
  @$pb.TagNumber(5)
  set gameStarted($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGameStarted() => $_has(4);
  @$pb.TagNumber(5)
  void clearGameStarted() => clearField(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
