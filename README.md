
# Sensor Data Integration and Visualization App

[![Watch the video demo](https://res.cloudinary.com/vanella/image/upload/v1705742827/2024-01-20_15-17-09_uvqqvm.gif)](https://res.cloudinary.com/vanella/video/upload/v1705739274/hlxxsshrrypp8wbdf64g.mp4)

Click on the image above to watch a video demonstration of the app's features and functionality.

## Overview

The **Sensor Data Integration and Visualization App** is a mobile application developed using Flutter. The app's primary objective is to fetch sensor data, such as temperature or pH levels, from the [sensorlevel-be](https://github.com/irvanster/sensorlevel-be) open-source API endpoint. It then visualizes this data in real-time using graphs, providing users with a user-friendly interface to view current sensor readings and historical trends.


## Download & Demo App

You can **download the APK and view the Postman documentation** [here](https://drive.google.com/drive/u/2/folders/1sXWSQkCQWXWGhQSkM_7Vs0XxrSrkRCtC).

To test the app:

1. Install the APK on your Android device.
2. Open the Postman collection from the provided link.
3. Demo URL API: `https://greenphytotest.genieedocs.com/monitors` in the `sensor add data` collection with method `POST` and Change the provided values in the body (x-www-form-urlencoded) to simulate sensor readings for locations A and B.

```plain
  location_id: 27f9d433-29d2-499c-bab7-c7ab07086d19,
  light_intensity": 200,
  water_ph": 8,
  water_tss": 5,
  water_ec": 12,
  water_tds": 14,
  soil_temperature": 20,
  soil_ec": 16,
  soil_ph": 6,
  soil_moisture": 17,
  weather_humidity": 80,
  weather_temperature": 40
```

## Stack

- **Mobile App (Flutter):**
  - Developed using the Flutter framework and Dart programming language.
  - Utilizes the **`fl_chart`** library for powerful and customizable graphing to visualize sensor data.

- **Backend (Express.js, Bun/Node.js) & Socket.IO:**
  - The backend is powered by Express.js with Bun (Node.js) and connects to the [Repository Backend API](https://github.com/irvanster/sensorlevel-be) to fetch sensor data.
  - Integrates **Socket.IO** for real-time communication with the mobile app.



## Features

- **API Integration:**
  - Fetches sensor data (temperature, pH levels, etc.) from the [sensorlevel-be](https://github.com/irvanster/sensorlevel-be) open-source API endpoint.

- **Data Visualization:**
  - Integrates the `fl_chart` library for powerful and customizable graphing to visualize sensor data.
  - The graph updates in real-time with incoming data and displays historical trends.


## Getting Started

To run the **Sensor Data Integration and Visualization App** locally, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/irvanster/greenphyto-monitoring-mobile.git greenphyto
2. Install dependencies:
	 ```bash 
	 cd greenphyto
    flutter pub get
3. Run the App:
    ```bash 
   flutter run
## Make Build Apk
1. Download & place `upload-keystore.jks` to `/Users/[yourusername]/upload-keystore.jks` 
2. Edit `thisproject/android/key.properties` configuration
    ``` bash
    storePassword=google098
    keyPassword=google098
    keyAlias=upload
    storeFile=/Users/irvanster/upload-keystore.jks #change with path your upload-keystore.jks
    ```
3. build app
   ```bash
    #for generate universal APK
    flutter build apk

    #for generate splitted APK
    flutter build apk --split-per-abi


  
