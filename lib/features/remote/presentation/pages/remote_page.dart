import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../../../core/enums/remote_command.dart';
import '../bloc/remote_bloc.dart';
import '../bloc/remote_event.dart';
import '../bloc/remote_state.dart';
import '../widgets/remote_power_button.dart';
import '../widgets/remote_volume_bar.dart';
import '../widgets/remote_dpad.dart';
import '../widgets/remote_channel_buttons.dart';
import '../widgets/remote_touchpad.dart';

final class RemotePage extends StatelessWidget {
  final String deviceId;

  const RemotePage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteBloc>(
      create: (context) {
        final bloc = context.read<RemoteBloc>();
        bloc.add(RemoteDeviceChanged(deviceId));
        return bloc;
      },
      child: const _RemoteView(),
    );
  }
}

final class _KeyboardInput extends StatefulWidget {
  const _KeyboardInput();

  @override
  State<_KeyboardInput> createState() => _KeyboardInputState();
}

final class _KeyboardInputState extends State<_KeyboardInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text;
    if (text.isEmpty) return;
    context.read<RemoteBloc>().add(RemoteTextSent(text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Type text…',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            inputFormatters: [LengthLimitingTextInputFormatter(200)],
            onSubmitted: (_) => _send(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(icon: const Icon(Icons.send), onPressed: _send),
      ],
    );
  }
}

final class _RemoteView extends StatelessWidget {
  const _RemoteView();

  void _sendCommand(BuildContext context, RemoteCommand command) {
    context.read<RemoteBloc>().add(RemoteCommandIssued(command));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remote'), centerTitle: true),
      body: BlocListener<RemoteBloc, RemoteState>(
        listener: (context, state) {
          if (state case RemoteError(:final message)) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Power button
                  RemotePowerButton(
                    onPressed: () => _sendCommand(context, RemoteCommand.power),
                  ),
                  const SizedBox(height: 32),
                  // Volume controls
                  RemoteVolumeBar(
                    onVolumeUp: () =>
                        _sendCommand(context, RemoteCommand.volumeUp),
                    onVolumeDown: () =>
                        _sendCommand(context, RemoteCommand.volumeDown),
                    onMute: () => _sendCommand(context, RemoteCommand.mute),
                  ),
                  const SizedBox(height: 24),
                  // Channel controls
                  RemoteChannelButtons(
                    onChannelUp: () =>
                        _sendCommand(context, RemoteCommand.channelUp),
                    onChannelDown: () =>
                        _sendCommand(context, RemoteCommand.channelDown),
                  ),
                  const SizedBox(height: 24),
                  // D-Pad
                  RemoteDpad(
                    onUp: () => _sendCommand(context, RemoteCommand.up),
                    onDown: () => _sendCommand(context, RemoteCommand.down),
                    onLeft: () => _sendCommand(context, RemoteCommand.left),
                    onRight: () => _sendCommand(context, RemoteCommand.right),
                    onOk: () => _sendCommand(context, RemoteCommand.ok),
                    onBack: () => _sendCommand(context, RemoteCommand.back),
                    onHome: () => _sendCommand(context, RemoteCommand.home),
                    onMenu: () => _sendCommand(context, RemoteCommand.menu),
                  ),
                  const SizedBox(height: 24),
                  // Touchpad
                  const RemoteTouchpad(),
                  const SizedBox(height: 24),
                  // Keyboard input
                  const _KeyboardInput(),
                  const SizedBox(height: 24),
                  // Media controls
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        tooltip: 'Previous',
                        onPressed: () =>
                            _sendCommand(context, RemoteCommand.previous),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fast_rewind),
                        tooltip: 'Rewind',
                        onPressed: () =>
                            _sendCommand(context, RemoteCommand.fastForward),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        tooltip: 'Play',
                        onPressed: () =>
                            _sendCommand(context, RemoteCommand.play),
                      ),
                      IconButton(
                        icon: const Icon(Icons.pause),
                        tooltip: 'Pause',
                        onPressed: () =>
                            _sendCommand(context, RemoteCommand.pause),
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        tooltip: 'Stop',
                        onPressed: () =>
                            _sendCommand(context, RemoteCommand.stop),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fast_forward),
                        tooltip: 'Fast Forward',
                        onPressed: () =>
                            _sendCommand(context, RemoteCommand.fastForward),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        tooltip: 'Next',
                        onPressed: () =>
                            _sendCommand(context, RemoteCommand.next),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
