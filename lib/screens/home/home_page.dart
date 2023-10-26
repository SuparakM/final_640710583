import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../models/weatherapi_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int selectedUnit = 0; // 0 คือ °C, 1 คือ °F
  String cityName = "bangkok"; // เริ่มต้นด้วยการแสดงสภาพอากาศในกรุงเทพฯ
  WeatherData? weatherData;

  Future<void> fetchWeatherData() async {
    try {
      final response = await Dio().get(
          'https://cpsu-test-api.herokuapp.com/api/1_2566/weather/current?city=$cityName');

      setState(() {
        weatherData = WeatherData.fromJson(response.data);
      });
    } catch (e) {
      print("เกิดข้อผิดพลาดในการดึงข้อมูล: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Widget buildWeatherInfo() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              '${weatherData?.city ?? ''}',
              style: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              '${weatherData?.country ?? ''}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              '${weatherData?.lastUpdated ?? ''}',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Image.network(
              'https://cdn.weatherapi.com/weather/128x128/night/116.png',
              width: 100.0, // กำหนดขนาดของรูปภาพตามที่คุณต้องการ
              height: 100.0,
            ),
            Text(
              'Partly cloudy',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              '${selectedUnit == 0 ? weatherData?.tempC ?? 0 : weatherData?.tempF ?? 0}',
              style: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${selectedUnit == 0 ? 'Feels Like ' : 'Feels Like '}: ${selectedUnit == 0 ? weatherData?.feelsLikeC ?? 0 : weatherData?.feelsLikeF ?? 0}',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedUnit = 0;
                    });
                  },
                  child: Text(
                    '°C',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: selectedUnit == 0
                          ? Colors.black
                          : Colors.grey, // เปลี่ยนสีตามเงื่อนไข
                    ),
                  ),
                ),
                Container(
                  width: 2.0,
                  height: 16.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedUnit = 1;
                    });
                  },
                  child: Text(
                    '°F',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: selectedUnit == 1
                          ? Colors.black
                          : Colors.grey, // เปลี่ยนสีตามเงื่อนไข
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0), // สร้างระยะห่างด้านบน
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.opacity,
                      size: 40,
                      color: Colors.grey,
                    ),
                    // ใช้ไอคอนหยดน้ำ
                    Text(
                      'HUMIDITY',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${weatherData?.humidity ?? 0}%',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 2.0,
                  height: 40.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.air,
                      size: 40,
                      color: Colors.grey,
                    ), // ใช้ไอคอนลม (wind) ขนาด 40
                    Text(
                      'WIND',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${selectedUnit == 0 ? '${weatherData?.windKph ?? 0} km/h' : '${weatherData?.windMph ?? 0} mph'}',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 2.0,
                  height: 40.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.wb_sunny,
                      size: 40,
                      color: Colors.grey,
                    ), // ใช้ไอคอนอากาศและแสดง UV
                    Text(
                      'UV',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${weatherData?.uv ?? 0}',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(
                      child: Text(
                        'Bongkok',
                        style: TextStyle(fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(
                      child: Text(
                        'Singapore',
                        style: TextStyle(fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (weatherData != null) // ตรวจสอบว่ามีข้อมูลอากาศ
              buildWeatherInfo(),
          ],
        ),
      ),
    );
  }
}
