import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather/consts/colors.dart';
import 'package:weather/consts/images.dart';
import 'package:weather/controllers/main_controllers.dart';
import 'package:weather/models/current_weather_model.dart';
import 'package:weather/models/hourly_weather_model.dart';
import 'package:weather/our_themes.dart';
import 'package:weather/services/api_services.dart';

import 'consts/strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: CustomThemes.lightTheme,
        darkTheme: CustomThemes.darkTheme,
        themeMode: ThemeMode.light,
        //dark/light/system
        title: "Weather App",
        debugShowCheckedModeBanner: false,
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    //var dare = DateTime.now(); //'package:intl/intl.dart';
    var date = DateFormat('yMMMMd').format(DateTime.now());
    var theme = Theme.of(context); //app ka theme(custom theme banaya hai

    var controller = Get.put(MainController());//initialize

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0.0,
        title: date.text.color(theme.primaryColor).make(),
        actions: [
          Obx(
            () => //change state - getx package
                IconButton(
              onPressed: () {
                controller.changeTheme();
              },
              icon: Icon(
                  controller.isDark.value ? Icons.dark_mode : Icons.light_mode),
              color: theme.iconTheme.color,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.snackbar("Weather App", "Developed by Akash Gupta",
                  backgroundColor: Colors.black,
                colorText: Colors.white,
                  animationDuration: Duration(seconds: 2)
              );
            },
            icon: Icon(Icons.accessibility),
            color: theme.iconTheme.color,
          ),
        ],
      ),
      body: Obx(() => controller.isLoaded.value == true
          ? Container(
              child: FutureBuilder(
                // initialData: ,
                //future: getCurrentWeather(), //problem ki har bar data ayaga toh har bar UI create hogi
                future:
                controller.currentWeatherData, //har bar UI create nahi hogi
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //CurrentWeatherData data = snapshot.data as CurrentWeatherData;
                    var data = snapshot.data as CurrentWeatherData;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            data.name.text.bold
                                .fontFamily("poppins_bold")
                                .size(22)
                                .letterSpacing(3)
                                .color(theme.primaryColor)
                                .make(),
                            //10.heightBox,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/weather/${data.weather[0].icon}.png",
                                    width: 90,
                                    height: 90,
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          //har chij ko alag say design karta hai
                                          text: "${data.main.temp}$degree",
                                          style: TextStyle(
                                              color: theme.primaryColor,
                                              fontSize: 55,
                                              fontFamily: "poppins")),
                                      TextSpan(
                                          text: "${data.weather[0].main}",
                                          style: TextStyle(
                                              color: theme.primaryColor,
                                              fontSize: 25,
                                              fontFamily: "poppins"))
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.expand_less_rounded,
                                    color: theme.iconTheme.color,
                                  ),
                                  label: "${data.main.tempMax}$degree"
                                      .text
                                      .color(theme.primaryColor)
                                      .make(),
                                ),
                                TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.expand_more_rounded,
                                    color: theme.iconTheme.color,
                                  ),
                                  label: "${data.main.tempMin}$degree"
                                      .text
                                      .color(theme.primaryColor)
                                      .make(),
                                )
                              ],
                            ),
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(3, (index) {
                                var iconList = [clouds, humidity, windSpeed];
                                var values = [
                                  "${data.clouds.all}%",
                                  "${data.main.humidity}%",
                                  "${data.wind.speed} km/h"
                                ];
                                return Column(
                                  children: [
                                    Image.asset(
                                      iconList[index],
                                      width: 50,
                                      height: 50,
                                    )
                                        .box
                                        .gray200
                                        .padding(EdgeInsets.all(8))
                                        .roundedSM
                                        .make(),
                                    10.heightBox,
                                    values[index]
                                        .text
                                        .color(theme.primaryColor)
                                        .make()
                                  ],
                                );
                              }),
                            ),
                            10.heightBox,
                            Divider(
                              color: theme.dividerTheme.color,
                            ),
                            10.heightBox,

                            //per time hour weather
                            FutureBuilder(
                              // initialData: ,
                              future: controller.hourlyWeatherData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  //HourlyWeatherData hourlyData = snapshot.data as HourlyWeatherData;
                                  var hourlyData =
                                      snapshot.data as HourlyWeatherData;

                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                        itemCount: hourlyData.list.length > 8
                                            ? 8
                                            : hourlyData.list.length,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var date = DateFormat('MMMd').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      hourlyData.list[index].dt
                                                              .toInt() *
                                                          1000));
                                          var time = DateFormat.jm().format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      hourlyData.list[index].dt
                                                              .toInt() *
                                                          1000));

                                          return Container(
                                            padding: EdgeInsets.all(8.0),
                                            margin: EdgeInsets.only(right: 4),
                                            decoration: BoxDecoration(
                                                color: theme.cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                date.text
                                                    .color(theme.primaryColor)
                                                    .make(),
                                                time.text
                                                    .color(theme.primaryColor)
                                                    .make(),
                                                CircleAvatar(
                                                  backgroundColor:
                                                      theme.canvasColor,
                                                  backgroundImage: AssetImage(
                                                      "assets/weather/${hourlyData.list[index].weather[0].icon}.png"),
                                                  radius: 36,
                                                ),
                                                "${hourlyData.list[index].main.temp}$degree"
                                                    .text
                                                    .color(theme.primaryColor)
                                                    .make()
                                              ],
                                            ),
                                          );
                                        }),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            10.heightBox,
                            Divider(
                              color: theme.dividerTheme.color,
                            ),
                            10.heightBox,

                            //next 7 days weather condition
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Next 7 days"
                                    .text
                                    .semiBold
                                    .size(18)
                                    .color(theme.primaryColor)
                                    .make(),
                                TextButton(
                                  onPressed: () {},
                                  child: "View All".text.make(),
                                )
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 7,
                              itemBuilder: (BuildContext context, int index) {
                                var day = DateFormat("EEEE").format(
                                    DateTime.now()
                                        .add(Duration(days: index + 1)));
                                return Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: day.text
                                              .size(17)
                                              .semiBold
                                              .color(theme.primaryColor)
                                              .make(),
                                        ),
                                        Expanded(
                                          child: TextButton.icon(
                                            onPressed: null,
                                            icon: Image.asset(
                                              "assets/weather/weather.png",
                                              width: 60,
                                              height: 60,
                                            ),
                                            label: "26$degree"
                                                .text
                                                .color(theme.primaryColor)
                                                .make(),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "37$degree /",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: theme.primaryColor,
                                                    fontFamily: "poppins")),
                                            TextSpan(
                                                text: "26$degree",
                                                style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontSize: 16,
                                                    fontFamily: "poppins")),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            )),
    );
  }
}
