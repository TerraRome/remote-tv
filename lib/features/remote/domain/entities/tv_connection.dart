import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/enums/connection_state.dart';

part 'tv_connection.freezed.dart';
part 'tv_connection.g.dart';

@freezed
class TvConnection with _$TvConnection {
  const factory TvConnection({
    required String deviceId,
    required String driverId,
    required TvConnectionState state,
    required String sessionToken,
    required DateTime connectedAt,
    DateTime? lastActivityAt,
    @Default({}) Map<String, String> capabilities,
  }) = _TvConnection;

  factory TvConnection.fromJson(Map<String, dynamic> json) =>
      _$TvConnectionFromJson(json);
}
