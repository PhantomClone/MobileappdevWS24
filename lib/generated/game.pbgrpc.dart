//
//  Generated code. Do not modify.
//  source: game.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'game.pb.dart' as $0;

export 'game.pb.dart';

@$pb.GrpcServiceName('edu.hm.mobileappdev.proto.KniffelGame')
class KniffelGameClient extends $grpc.Client {
  static final _$createGame = $grpc.ClientMethod<$0.Player, $0.GameId>(
      '/edu.hm.mobileappdev.proto.KniffelGame/CreateGame',
      ($0.Player value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GameId.fromBuffer(value));
  static final _$joinGame = $grpc.ClientMethod<$0.JoinRequest, $0.Ack>(
      '/edu.hm.mobileappdev.proto.KniffelGame/JoinGame',
      ($0.JoinRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Ack.fromBuffer(value));
  static final _$startGame = $grpc.ClientMethod<$0.GameId, $0.Ack>(
      '/edu.hm.mobileappdev.proto.KniffelGame/StartGame',
      ($0.GameId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Ack.fromBuffer(value));
  static final _$sendMove = $grpc.ClientMethod<$0.PlayerMove, $0.GameState>(
      '/edu.hm.mobileappdev.proto.KniffelGame/SendMove',
      ($0.PlayerMove value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GameState.fromBuffer(value));
  static final _$listenForGameUpdates = $grpc.ClientMethod<$0.GameId, $0.GameState>(
      '/edu.hm.mobileappdev.proto.KniffelGame/ListenForGameUpdates',
      ($0.GameId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GameState.fromBuffer(value));

  KniffelGameClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.GameId> createGame($0.Player request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createGame, request, options: options);
  }

  $grpc.ResponseFuture<$0.Ack> joinGame($0.JoinRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$joinGame, request, options: options);
  }

  $grpc.ResponseFuture<$0.Ack> startGame($0.GameId request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$startGame, request, options: options);
  }

  $grpc.ResponseFuture<$0.GameState> sendMove($0.PlayerMove request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendMove, request, options: options);
  }

  $grpc.ResponseStream<$0.GameState> listenForGameUpdates($0.GameId request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$listenForGameUpdates, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('edu.hm.mobileappdev.proto.KniffelGame')
abstract class KniffelGameServiceBase extends $grpc.Service {
  $core.String get $name => 'edu.hm.mobileappdev.proto.KniffelGame';

  KniffelGameServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Player, $0.GameId>(
        'CreateGame',
        createGame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Player.fromBuffer(value),
        ($0.GameId value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.JoinRequest, $0.Ack>(
        'JoinGame',
        joinGame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinRequest.fromBuffer(value),
        ($0.Ack value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GameId, $0.Ack>(
        'StartGame',
        startGame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GameId.fromBuffer(value),
        ($0.Ack value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PlayerMove, $0.GameState>(
        'SendMove',
        sendMove_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PlayerMove.fromBuffer(value),
        ($0.GameState value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GameId, $0.GameState>(
        'ListenForGameUpdates',
        listenForGameUpdates_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.GameId.fromBuffer(value),
        ($0.GameState value) => value.writeToBuffer()));
  }

  $async.Future<$0.GameId> createGame_Pre($grpc.ServiceCall call, $async.Future<$0.Player> request) async {
    return createGame(call, await request);
  }

  $async.Future<$0.Ack> joinGame_Pre($grpc.ServiceCall call, $async.Future<$0.JoinRequest> request) async {
    return joinGame(call, await request);
  }

  $async.Future<$0.Ack> startGame_Pre($grpc.ServiceCall call, $async.Future<$0.GameId> request) async {
    return startGame(call, await request);
  }

  $async.Future<$0.GameState> sendMove_Pre($grpc.ServiceCall call, $async.Future<$0.PlayerMove> request) async {
    return sendMove(call, await request);
  }

  $async.Stream<$0.GameState> listenForGameUpdates_Pre($grpc.ServiceCall call, $async.Future<$0.GameId> request) async* {
    yield* listenForGameUpdates(call, await request);
  }

  $async.Future<$0.GameId> createGame($grpc.ServiceCall call, $0.Player request);
  $async.Future<$0.Ack> joinGame($grpc.ServiceCall call, $0.JoinRequest request);
  $async.Future<$0.Ack> startGame($grpc.ServiceCall call, $0.GameId request);
  $async.Future<$0.GameState> sendMove($grpc.ServiceCall call, $0.PlayerMove request);
  $async.Stream<$0.GameState> listenForGameUpdates($grpc.ServiceCall call, $0.GameId request);
}
