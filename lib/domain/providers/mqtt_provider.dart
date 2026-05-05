import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttProvider extends ChangeNotifier {
  MqttServerClient? _client;

  final Map<String, String> _temperatures = {};
  Map<String, String> get temperatures => _temperatures;

  Future<void> connect() async {
    if (_client != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      return;
    }

    final clientId = 'workshop_app_${DateTime.now().millisecondsSinceEpoch}';
    _client = MqttServerClient('broker.hivemq.com', clientId)
      ..port = 1883
      ..keepAlivePeriod = 20
      ..logging(on: false)
      ..autoReconnect = true
      ..onDisconnected = _onDisconnected;

    final connMsg =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atMostOnce);

    _client!.connectionMessage = connMsg;

    try {
      await _client!.connect();
    } on NoConnectionException catch (e) {
      debugPrint('MQTT Помилка: Немає з\'єднання ($e)');
      _client!.disconnect();
      return;
    } on SocketException catch (e) {
      debugPrint('MQTT Помилка: Втрачено сокет ($e)');
      _client!.disconnect();
      return;
    } catch (e) {
      debugPrint('MQTT Помилка: Невідома ($e)');
      _client!.disconnect();
      return;
    }

    if (_client!.connectionStatus?.state == MqttConnectionState.connected) {
      _client!.subscribe('workshop/machine/+/temp', MqttQos.atMostOnce);
      _client!.updates?.listen(_onMessage);
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    final msg = messages[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(
      msg.payload.message,
    );
    final topic = messages[0].topic;

    final parts = topic.split('/');
    if (parts.length >= 4) {
      final machineId = parts[2];
      _temperatures[machineId] = payload;
      notifyListeners();
    }
  }

  void _onDisconnected() {
    debugPrint('MQTT відключено від брокера');
  }

  void disconnect() {
    _client?.disconnect();
  }
}
