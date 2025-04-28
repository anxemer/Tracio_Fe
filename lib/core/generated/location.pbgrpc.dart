//
//  Generated code. Do not modify.
//  source: location.proto
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

import 'location.pb.dart' as $0;

export 'location.pb.dart';

@$pb.GrpcServiceName('LocationService')
class LocationServiceClient extends $grpc.Client {
  static final _$sendLocations = $grpc.ClientMethod<$0.LocationRequest, $0.LocationResponse>(
      '/LocationService/SendLocations',
      ($0.LocationRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LocationResponse.fromBuffer(value));

  LocationServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.LocationResponse> sendLocations($0.LocationRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendLocations, request, options: options);
  }
}

@$pb.GrpcServiceName('LocationService')
abstract class LocationServiceBase extends $grpc.Service {
  $core.String get $name => 'LocationService';

  LocationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LocationRequest, $0.LocationResponse>(
        'SendLocations',
        sendLocations_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LocationRequest.fromBuffer(value),
        ($0.LocationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LocationResponse> sendLocations_Pre($grpc.ServiceCall call, $async.Future<$0.LocationRequest> request) async {
    return sendLocations(call, await request);
  }

  $async.Future<$0.LocationResponse> sendLocations($grpc.ServiceCall call, $0.LocationRequest request);
}
