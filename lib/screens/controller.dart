import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MQTTControllerPage(),
    );
  }
}

class MQTTControllerPage extends StatefulWidget {
  const MQTTControllerPage({Key? key}) : super(key: key);

  @override
  State<MQTTControllerPage> createState() => _MQTTControllerPageState();
}

class _MQTTControllerPageState extends State<MQTTControllerPage> {
  MqttServerClient? client;
  bool isConnected = false;
  String statusMessage = 'Disconnected';

  // MQTT Configuration
  final TextEditingController brokerController =
      TextEditingController(text: 'broker.hivemq.com');
  final TextEditingController portController =
      TextEditingController(text: '1883');
  final TextEditingController topicController =
      TextEditingController(text: 'robot/control');
  final TextEditingController clientIdController =
      TextEditingController(text: 'flutter_client');

  @override
  void dispose() {
    client?.disconnect();
    brokerController.dispose();
    portController.dispose();
    topicController.dispose();
    clientIdController.dispose();
    super.dispose();
  }

  Future<void> connectMQTT() async {
    try {
      final broker = brokerController.text;
      final port = int.parse(portController.text);
      final clientId = clientIdController.text;

      client = MqttServerClient(broker, clientId);
      client!.port = port;
      client!.keepAlivePeriod = 20;
      client!.logging(on: false);

      final connMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      client!.connectionMessage = connMessage;

      setState(() {
        statusMessage = 'Connecting...';
      });

      await client!.connect();

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        setState(() {
          isConnected = true;
          statusMessage = 'Connected to $broker';
        });
      }
    } catch (e) {
      setState(() {
        isConnected = false;
        statusMessage = 'Connection failed: $e';
      });
      client?.disconnect();
    }
  }

  void disconnectMQTT() {
    client?.disconnect();
    setState(() {
      isConnected = false;
      statusMessage = 'Disconnected';
    });
  }

  void publishMessage(String message) {
    if (!isConnected || client == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not connected to MQTT broker')),
      );
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client!.publishMessage(
      topicController.text,
      MqttQos.atLeastOnce,
      builder.payload!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Published: $message'),
          duration: const Duration(milliseconds: 500)),
    );
  }

  Widget buildControlButton(String label, IconData icon, {Color? color}) {
    return ElevatedButton(
      onPressed: isConnected ? () => publishMessage(label) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Controller'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: brokerController,
                      decoration: const InputDecoration(
                        labelText: 'MQTT Broker',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !isConnected,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: portController,
                      decoration: const InputDecoration(
                        labelText: 'Port',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !isConnected,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: topicController,
                      decoration: const InputDecoration(
                        labelText: 'Topic',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !isConnected,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: clientIdController,
                      decoration: const InputDecoration(
                        labelText: 'Client ID',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !isConnected,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isConnected ? null : connectMQTT,
                            icon: const Icon(Icons.link),
                            label: const Text('Connect'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isConnected ? disconnectMQTT : null,
                            icon: const Icon(Icons.link_off),
                            label: const Text('Disconnect'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      statusMessage,
                      style: TextStyle(
                        color: isConnected ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Control Panel
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Control Panel',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Directional Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildControlButton('UP_LEFT', Icons.north_west),
                        const SizedBox(width: 12),
                        buildControlButton('UP', Icons.arrow_upward),
                        const SizedBox(width: 12),
                        buildControlButton('UP_RIGHT', Icons.north_east),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildControlButton('LEFT', Icons.arrow_back),
                        const SizedBox(width: 12),
                        buildControlButton('STOP', Icons.stop,
                            color: Colors.red),
                        const SizedBox(width: 12),
                        buildControlButton('RIGHT', Icons.arrow_forward),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildControlButton('DOWN_LEFT', Icons.south_west),
                        const SizedBox(width: 12),
                        buildControlButton('DOWN', Icons.arrow_downward),
                        const SizedBox(width: 12),
                        buildControlButton('DOWN_RIGHT', Icons.south_east),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Turn Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildControlButton('TURN_LEFT', Icons.rotate_left,
                            color: Colors.orange),
                        const SizedBox(width: 12),
                        buildControlButton('TURN_RIGHT', Icons.rotate_right,
                            color: Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
