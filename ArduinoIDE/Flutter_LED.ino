#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
//Include this in the Library folder


char ssid[] = "Majdi fiber 4g"; // add your wi-fi name
char password[] = "0505306426"; // add your wi-fi password

boolean ledState = false;
ESP8266WebServer server(80);
void handleRoot() {
    // try typing your ip adress in your browser to check your connection
  server.send(200, "text/html", "<h1>Device is Connected</h1>");
}
void setup() {
  // put your setup code here, to run once:
  pinMode(14, OUTPUT);// GPIO14 
  Serial.begin(9600);
  //Wi-fi connection
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
   delay(1000);
    Serial.println("connecting");
  }

  // change it your ip adress
  
  IPAddress ip(192, 168, 1, 40);
   // if your are using mac OS: use this command in your terminal to get the ip adress: ipconfig getifaddr en0
  // if ypur are using windows OS: use this command in your cmd to get the ip adress: ipconfig

  IPAddress gateway(192, 168, 1, 1);
  IPAddress subnet(255, 255, 255, 0);
  WiFi.config(ip, gateway, subnet);
 


  server.on("/", handleRoot); // if you type your IP adress in your browser the handleRoot function will be called, and the connection massage will be displayed in your browser
  server.on("/led/off", turnOffLed);
  server.on("/led/on", turnOnLed);
  server.begin();
  Serial.println("Http has Started");

}




void turnOnLed() {
  ledState = true;
  digitalWrite(14, ledState);
  server.send(200, "text/plain", "off");
  
}

void turnOffLed() {
  ledState = false;
  digitalWrite(14, ledState);
  server.send(200, "text/plain", "on");
 
}
//
void loop() {
  // put your main code here, to run repeatedly:
  server.handleClient();
  // let the server handle data coming from the client 
}
