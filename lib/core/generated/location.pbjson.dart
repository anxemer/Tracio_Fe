//
//  Generated code. Do not modify.
//  source: location.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use locationDescriptor instead')
const Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'altitude', '3': 3, '4': 1, '5': 1, '9': 0, '10': 'altitude', '17': true},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'speed', '3': 5, '4': 1, '5': 1, '9': 1, '10': 'speed', '17': true},
    {'1': 'distance', '3': 6, '4': 1, '5': 1, '9': 2, '10': 'distance', '17': true},
  ],
  '8': [
    {'1': '_altitude'},
    {'1': '_speed'},
    {'1': '_distance'},
  ],
};

/// Descriptor for `Location`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationDescriptor = $convert.base64Decode(
    'CghMb2NhdGlvbhIaCghsYXRpdHVkZRgBIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgAS'
    'gBUglsb25naXR1ZGUSHwoIYWx0aXR1ZGUYAyABKAFIAFIIYWx0aXR1ZGWIAQESHAoJdGltZXN0'
    'YW1wGAQgASgDUgl0aW1lc3RhbXASGQoFc3BlZWQYBSABKAFIAVIFc3BlZWSIAQESHwoIZGlzdG'
    'FuY2UYBiABKAFIAlIIZGlzdGFuY2WIAQFCCwoJX2FsdGl0dWRlQggKBl9zcGVlZEILCglfZGlz'
    'dGFuY2U=');

@$core.Deprecated('Use locationRequestDescriptor instead')
const LocationRequest$json = {
  '1': 'LocationRequest',
  '2': [
    {'1': 'routeId', '3': 1, '4': 1, '5': 5, '10': 'routeId'},
    {'1': 'locations', '3': 2, '4': 3, '5': 11, '6': '.Location', '10': 'locations'},
  ],
};

/// Descriptor for `LocationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationRequestDescriptor = $convert.base64Decode(
    'Cg9Mb2NhdGlvblJlcXVlc3QSGAoHcm91dGVJZBgBIAEoBVIHcm91dGVJZBInCglsb2NhdGlvbn'
    'MYAiADKAsyCS5Mb2NhdGlvblIJbG9jYXRpb25z');

@$core.Deprecated('Use locationResponseDescriptor instead')
const LocationResponse$json = {
  '1': 'LocationResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LocationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationResponseDescriptor = $convert.base64Decode(
    'ChBMb2NhdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2FnZR'
    'gCIAEoCVIHbWVzc2FnZQ==');

