import 'package:flutter/material.dart';
import 'package:skibiditoiltetv2/screens/controller.dart';

// --- Data Model Simulasi (Simulated Data Model) ---

/// Kelas untuk menyimpan informasi polutan.
class PollutantData {
  final String name;
  final String label;
  final double value;
  final String unit;

  PollutantData(
      {required this.name,
      required this.label,
      required this.value,
      required this.unit});
}

/// Struktur data utama IKU.
class AirQualityData {
  final int aqi;
  final String status;
  final String recommendation;
  final Color color;
  final List<PollutantData> pollutants;

  AirQualityData(
      this.aqi, this.status, this.recommendation, this.color, this.pollutants);

  // Metode untuk menentukan data berdasarkan nilai IKU simulasi
  static AirQualityData getMockData(int aqi) {
    if (aqi <= 50) {
      return AirQualityData(
        aqi,
        "Baik",
        "Kualitas udara memuaskan, minim risiko.",
        Colors.green.shade600,
        [
          PollutantData(
              name: "PM2.5",
              label: "Partikulat Halus",
              value: 12.1,
              unit: "µg/m³"),
          PollutantData(
              name: "PM10",
              label: "Partikulat Kasar",
              value: 25.4,
              unit: "µg/m³"),
          PollutantData(name: "O3", label: "Ozon", value: 0.05, unit: "ppm"),
          PollutantData(
              name: "NO2",
              label: "Nitrogen Dioksida",
              value: 0.015,
              unit: "ppm"),
        ],
      );
    } else if (aqi <= 100) {
      return AirQualityData(
        aqi,
        "Sedang",
        "Kualitas udara dapat diterima; namun, ada risiko ringan bagi sebagian kecil orang yang sensitif.",
        Colors.yellow.shade800,
        [
          PollutantData(
              name: "PM2.5",
              label: "Partikulat Halus",
              value: 35.5,
              unit: "µg/m³"),
          PollutantData(
              name: "PM10",
              label: "Partikulat Kasar",
              value: 65.0,
              unit: "µg/m³"),
          PollutantData(
              name: "CO", label: "Karbon Monoksida", value: 5.2, unit: "ppm"),
          PollutantData(
              name: "SO2", label: "Sulfur Dioksida", value: 0.03, unit: "ppm"),
        ],
      );
    } else if (aqi <= 150) {
      return AirQualityData(
        aqi,
        "Tidak Sehat",
        "Setiap orang mungkin mulai merasakan dampak kesehatan; kelompok sensitif harus menghindari aktivitas luar ruangan.",
        Colors.orange.shade700,
        [
          PollutantData(
              name: "PM2.5",
              label: "Partikulat Halus",
              value: 70.0,
              unit: "µg/m³"),
          PollutantData(
              name: "PM10",
              label: "Partikulat Kasar",
              value: 150.0,
              unit: "µg/m³"),
          PollutantData(
              name: "NO2", label: "Nitrogen Dioksida", value: 0.1, unit: "ppm"),
          PollutantData(name: "O3", label: "Ozon", value: 0.09, unit: "ppm"),
        ],
      );
    } else {
      return AirQualityData(
        aqi,
        "Sangat Tidak Sehat",
        "Peringatan Kesehatan: Semua orang harus menghindari aktivitas luar ruangan.",
        Colors.red.shade700,
        [
          PollutantData(
              name: "PM2.5",
              label: "Partikulat Halus",
              value: 180.5,
              unit: "µg/m³"),
          PollutantData(
              name: "PM10",
              label: "Partikulat Kasar",
              value: 300.2,
              unit: "µg/m³"),
          PollutantData(
              name: "CO", label: "Karbon Monoksida", value: 12.0, unit: "ppm"),
          PollutantData(
              name: "SO2", label: "Sulfur Dioksida", value: 0.1, unit: "ppm"),
        ],
      );
    }
  }
}

class AirQualityApp extends StatelessWidget {
  const AirQualityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pemantauan Kualitas Udara',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const AirQualityScreen(),
    );
  }
}

// --- HomeScreen / Main Screen ---

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  // Simulasi nilai IKU yang bisa diubah-ubah
  int simulatedAqi = 75;
  late AirQualityData data;

  @override
  void initState() {
    super.initState();
    data = AirQualityData.getMockData(simulatedAqi);
  }

  // Widget untuk tombol mengubah IKU (hanya untuk simulasi)
  Widget _buildAqiControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Simulasi IKU: ${simulatedAqi}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          Slider(
            value: simulatedAqi.toDouble(),
            min: 0,
            max: 200,
            divisions: 200,
            label: simulatedAqi.round().toString(),
            activeColor: data.color,
            inactiveColor: Colors.grey.shade300,
            onChanged: (double value) {
              setState(() {
                simulatedAqi = value.round();
                data = AirQualityData.getMockData(simulatedAqi);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemantauan Kualitas Udara',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.location_on_outlined, color: Colors.blue.shade700),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildAqiControl(), // Tombol kontrol simulasi
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildPollutantsGrid(),
            const SizedBox(height: 20),
            _buildHealthAdviceCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Widget: Header Card (Main AQI Display) ---
  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: data.color.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Lokasi Saat Ini',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Jakarta Pusat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildAqiGauge(),
          const SizedBox(height: 20),
          Text(
            data.status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Indeks Kualitas Udara (IKU)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget: AQI Gauge (Circular Indicator) ---
  Widget _buildAqiGauge() {
    // Penggunaan CustomPaint atau library pihak ketiga bisa memberikan efek gauge yang lebih baik.
    // Untuk kesederhanaan, kita gunakan Stack untuk efek melingkar sederhana.
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Circle
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 8),
          ),
        ),
        // AQI Value
        Text(
          '${data.aqi}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 64,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  // --- Widget: Pollutant Details Grid ---
  Widget _buildPollutantsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Polutan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A), // Dark Blue
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.pollutants.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return _buildPollutantCard(data.pollutants[index]);
            },
          ),
        ],
      ),
    );
  }

  // --- Widget: Single Pollutant Card ---
  Widget _buildPollutantCard(PollutantData pollutant) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pollutant.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            pollutant.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${pollutant.value}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                pollutant.unit,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Widget: Health Advice Card ---
  Widget _buildHealthAdviceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MQTTControllerPage(), // layar tujuan
                ),
              );
            },
            child: const Text("kontrol"),
          )
        ],
      ),
    );
  }
}
