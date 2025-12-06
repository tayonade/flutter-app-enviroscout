import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class controlPage extends StatefulWidget {
  @override
  State<controlPage> createState() => _controlPageState();
}

class _controlPageState extends State<controlPage> {
  String esp32IpAddress = '10.110.223.166';
  String statusMessage = 'Disconnected';

  Future<void> sendCommand(String command) async {
    try {
      setState(() {
        statusMessage = 'Sending $command...';
      });

      // Match your ESP32 routes exactly (use uppercase)
      String route = command.toUpperCase();

      final response = await http
          .get(
            Uri.parse('http://$esp32IpAddress/$route'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          statusMessage = '$command sent successfully';
        });
      } else {
        setState(() {
          statusMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = 'Connection failed: $e';
      });
      /*    // Add CORS headers
    AsyncWebServerResponse *response = request->beginResponse(200, "text/plain", "OK");
    response->addHeader("Access-Control-Allow-Origin", "*");
    response->addHeader("Access-Control-Allow-Methods", "GET");
    request->send(response); }); */

    //esp32 harus memberi respon menggunakan cors header
    }
  }

  Widget controlButton({
    required String label,
    required VoidCallback onPressed,
    Color color = const Color(0xFF4CAF50),
  }) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'ESP32 IP Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.wifi),
                        ),
                        //textAlign: TextAlign.center,
                        onChanged: (value) {
                          esp32IpAddress = value;
                        },
                        controller: TextEditingController(text: esp32IpAddress),
                      )),
                  const SizedBox(height: 20),
                  // Status message
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controlButton(
                        label: 'UP_LEFT',
                        onPressed: () => sendCommand('UP_LEFT'),
                      ),
                      const SizedBox(width: 15),
                      controlButton(
                        label: 'UP',
                        onPressed: () => sendCommand('UP'),
                      ),
                      const SizedBox(width: 15),
                      controlButton(
                        label: 'RIGHT',
                        onPressed: () => sendCommand('UP_RIGHT'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controlButton(
                        label: 'LEFT',
                        onPressed: () => sendCommand('LEFT'),
                      ),
                      const SizedBox(width: 15),
                      controlButton(
                        label: 'STOP',
                        onPressed: () => sendCommand('STOP'),
                        color: const Color(0xFF555555),
                      ),
                      const SizedBox(width: 15),
                      controlButton(
                        label: 'RIGHT',
                        onPressed: () => sendCommand('RIGHT'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controlButton(
                        label: 'DOWN_LEFT',
                        onPressed: () => sendCommand('DOWN_LEFT'),
                      ),
                      const SizedBox(width: 15),
                      controlButton(
                        label: 'DOWN',
                        onPressed: () => sendCommand('DOWN'),
                      ),
                      const SizedBox(width: 15),
                      controlButton(
                        label: 'DOWN_RIGHT',
                        onPressed: () => sendCommand('DOWN_RIGHT'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              )),
        ),
      ),
    );
  }
}

