import 'dart:typed_data';

import '../../models/config_model.dart';
import '../../models/desired_state_model.dart';

enum SaveRecallState {
  none(0),
  recall(1),
  save(2);

  const SaveRecallState(this.value);

  final int value;
}

double remap(
  double value,
  double low1,
  double high1,
  double low2,
  double high2,
) {
  return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
}

class CommandMessage {
  final BytesBuilder _builder = BytesBuilder();

  bool enabled = false;
  bool advanced = false;
  int auxiliary = 0;
  double angleP = 0;
  double angleI = 0;
  double angleD = 0;
  double speedP = 0;
  double speedI = 0;
  double speedD = 0;
  int saveRecallState = SaveRecallState.recall.value;

  int speed = 0;
  int turn = 0;

  List<int> getBytes() {
    _builder.addByte(enabled ? 1 : 0);
    _builder.addByte(speed);
    _builder.addByte(turn);
    _builder.addByte(auxiliary);
    _builder.addByte(advanced ? 1 : 0);

    if (advanced) {
      // Convert float data to a 4-byte array
      var data = ByteData(4);

      data.setFloat32(0, angleP, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, angleI, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, angleD, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, speedP, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, speedI, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, speedD, Endian.little);
      _builder.add(data.buffer.asUint8List(0));
    }

    _builder.addByte(saveRecallState);

    return _builder.takeBytes();
  }

  static CommandMessage from(Object object, {ConfigModel? config}) {
    var commandMessage = CommandMessage();

    if (object is CommandMessage) {
      commandMessage.enabled = object.enabled;
      commandMessage.speed = object.speed;
      commandMessage.turn = object.turn;
      commandMessage.auxiliary = object.auxiliary;
      commandMessage.advanced = object.advanced;
      commandMessage.angleP = object.angleP;
      commandMessage.angleI = object.angleI;
      commandMessage.angleD = object.angleD;
      commandMessage.speedP = object.speedP;
      commandMessage.speedI = object.speedI;
      commandMessage.speedD = object.speedD;
      commandMessage.saveRecallState = object.saveRecallState;
    } else if (object is DesiredStateModel) {
      commandMessage.enabled = object.enabled;
      commandMessage.speed =
          remap(object.speed * (config?.speedScalar ?? 1), -1, 1, 0, 200)
              .round();
      commandMessage.turn =
          remap(object.turn * (config?.turnScalar ?? 1), -1, 1, 0, 200).round();
      commandMessage.auxiliary = object.auxiliary;
      commandMessage.advanced = object.advanced;
      commandMessage.angleP = object.angleP;
      commandMessage.angleI = object.angleI;
      commandMessage.angleD = object.angleD;
      commandMessage.speedP = object.speedP;
      commandMessage.speedI = object.speedI;
      commandMessage.speedD = object.speedD;
      commandMessage.saveRecallState = object.saveRecallState;
    } else {
      throw Exception('Object must be CommandMessage or DesiredStateModel');
    }

    return commandMessage;
  }

  @override
  String toString() {
    return 'CommandMessage{enabled: $enabled, speed: $speed, turn: $turn, auxiliary: $auxiliary, advanced: $advanced, angleP: $angleP, angleI: $angleI, angleD: $angleD, speedP: $speedP, speedI: $speedI, speedD: $speedD, saveRecallState: $saveRecallState}';
  }

  @override
  bool operator ==(Object other) {
    return other is CommandMessage &&
        enabled == other.enabled &&
        speed == other.speed &&
        turn == other.turn &&
        auxiliary == other.auxiliary &&
        advanced == other.advanced &&
        angleP == other.angleP &&
        angleI == other.angleI &&
        angleD == other.angleD &&
        speedP == other.speedP &&
        speedI == other.speedI &&
        speedD == other.speedD &&
        saveRecallState == other.saveRecallState;
  }

  @override
  int get hashCode => Object.hash(
        enabled,
        speed,
        turn,
        auxiliary,
        advanced,
        angleP,
        angleI,
        angleD,
        speedP,
        speedI,
        speedD,
        saveRecallState,
      );
}
