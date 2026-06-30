import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import '../protocol/android_tv_message.dart';
import '../protocol/android_tv_protocol_handler.dart';
import 'certificate_manager.dart';

/// Manages the pairing lifecycle with an Android TV.
///
/// Follows the standard pairing flow:
///   1. Send pairing request
///   2. Receive pairing secret (PIN)
///   3. Send secret acknowledgment
///   4. TLS certificate exchange completes the pair
@singleton
class AndroidTvPairingManager {
  AndroidTvPairingManager({
    required AndroidTvProtocolHandler protocol,
    required CertificateManager certificateManager,
  }) : _protocol = protocol,
       _certificateManager = certificateManager;

  final AndroidTvProtocolHandler _protocol;
  final CertificateManager _certificateManager;

  Completer<String>? _pinCompleter;

  /// Stream of pairing state updates.
  final _stateController = StreamController<PairingState>.broadcast();

  Stream<PairingState> get state => _stateController.stream;

  /// Start the pairing flow.
  ///
  /// Returns the PIN code that must be displayed to the user.
  Future<String> startPairing() async {
    _stateController.add(PairingState.pairing);

    // Send pairing request
    final requestPayload = Uint8List.fromList(utf8.encode('pair') as List<int>);
    final request = AndroidTvMessage(
      type: AndroidTvMessageType.pairingRequest,
      payload: requestPayload,
    );

    // Wait for pairing secret (PIN)
    _pinCompleter = Completer<String>();
    StreamSubscription<AndroidTvMessage>? sub;

    sub = _protocol.messages.listen((msg) {
      if (msg.type == AndroidTvMessageType.pairingSecret) {
        final pin = utf8.decode(msg.payload);
        _pinCompleter?.complete(pin);
        sub?.cancel();
      }
    });

    await _protocol.sendMessage(request);

    final pin = await _pinCompleter!.future;
    _stateController.add(PairingState.waitingForPin);

    return pin;
  }

  /// Confirm the PIN displayed on the TV matches.
  ///
  /// Sends acknowledgment to complete pairing.
  Future<void> confirmPin() async {
    final ackPayload = Uint8List.fromList(utf8.encode('ok') as List<int>);
    final ack = AndroidTvMessage(
      type: AndroidTvMessageType.pairingSecretAck,
      payload: ackPayload,
    );
    await _protocol.sendMessage(ack);

    // After PIN ack, the TV sends its certificate
    // In the secure socket handshake this is handled by TLS layer
    _stateController.add(PairingState.paired);
  }

  /// Cancel the pairing flow.
  Future<void> cancelPairing() async {
    _stateController.add(PairingState.cancelled);
  }

  /// Whether a certificate is already stored (previously paired).
  Future<bool> isAlreadyPaired(String deviceId) =>
      _certificateManager.hasCertificate(deviceId);

  /// Clean up.
  Future<void> dispose() async {
    await _stateController.close();
  }
}

/// Pairing state enum.
enum PairingState {
  /// Pairing in progress.
  pairing,

  /// Waiting for user to enter PIN on TV.
  waitingForPin,

  /// Successfully paired.
  paired,

  /// Pairing cancelled.
  cancelled,

  /// Pairing failed.
  failed,
}
