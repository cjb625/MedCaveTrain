// Initializing Global Variables

const int BellPin = 9;
const int TalkPin = 10;
const int WhistlePin = 11;
String T = "T";               
String W = "W";
String B = "B";
String R = "R";
String S = "S";
String F = "F";
int SpeedIntFix;
String Button = "";
String Speed = "";
int SpeedInt = 0;
int hold = 0;

// Adding libraries

#include <SPI.h>
#include <Adafruit_WINC1500.h>

// Defining library reserved variables as Pins on FeatherBoard M0 WiFi

#define WINC_CS   8
#define WINC_IRQ  7
#define WINC_RST  4
#define WINC_EN   2
const int slaveSelectPin = 13;

// Initializing WiFi Module on FeatherBoard

Adafruit_WINC1500 WiFi(WINC_CS, WINC_IRQ, WINC_RST);

// Connecting to the Access Point

char ssid[] = "SSID";      //  your network SSID (name)
char pass[] = "password";   // your network password

int status = WL_IDLE_STATUS;
Adafruit_WINC1500Server server(80);

void setup() {
  #ifdef WINC_EN
    pinMode(WINC_EN, OUTPUT);
    digitalWrite(WINC_EN, HIGH);
  #endif

  // initialize serial communication
    Serial.begin(9600); 
    pinMode(WhistlePin,OUTPUT);
    digitalWrite(WhistlePin, HIGH);
    pinMode(BellPin,OUTPUT);
    digitalWrite(BellPin, HIGH);
    pinMode(TalkPin,OUTPUT);
    digitalWrite(TalkPin, HIGH);
    
    // check for the presence of the shield:
    if (WiFi.status() == WL_NO_SHIELD) {
      Serial.println("WiFi shield not present");
      while (true);       // don't continue
    }
  
    // attempt to connect to Wifi network:
    while ( status != WL_CONNECTED) {
      Serial.print("Attempting to connect to Network named: ");
      Serial.println(ssid);                   // print the network name (SSID);
  
      // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
      status = WiFi.begin(ssid, pass);
      // wait 10 seconds for connection:
      delay(10000);
    }
    server.begin();                           // start the web server on port 80
    printWifiStatus();                        // you're connected now, so print out the status

    // set the slaveSelectPin as an output:
    pinMode (slaveSelectPin, OUTPUT);
    // initialize SPI:
    SPI.begin();
}
void loop() {
  Adafruit_WINC1500Client client = server.available();   // listen for incoming clients

  if (client) {                             // if you get a client,
    Serial.println("new client");           // print a message out the serial port
    String currentLine = "";                // make a String to hold incoming data from the client
    while (client.connected()) {            // loop while the client's connected
      if (client.available()) {             // if there's bytes to read from the client,
        char c = client.read();
        
        Serial.write(c);                    // print it out the serial monitor
        if (c == '\n') {                    // if the byte is a newline character

          // if the current line is blank, you got two newline characters in a row.
          // that's the end of the client HTTP request, so send a response:
          if (currentLine.length() == 0) {
            // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
            // and a content-type so the client knows what's coming, then a blank line:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();

            // the content of the HTTP response follows the header:
            client.print("Click <a href=\"/F\">here</a> Move Forward<br>");
            client.print("Click <a href=\"/S\">here</a> Stop<br>");
            client.print("Click <a href=\"/R\">here</a> Move Backwards<br>");

            // The HTTP response ends with another blank line:
            client.println();
            // break out of the while loop:
            break;
          }
          else {      // if you got a newline, then clear currentLine:
            currentLine = "";
          }
        }
        else if (c != '\r') {    // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }
        // Check to see if the client request was moving forward backward or stop:
        if(currentLine.endsWith("END")){
          Button = currentLine.substring(6,7);
          Speed = currentLine.substring(8,11);
          SpeedInt = Speed.toInt();
          
        }
      }
      if(Button==W){
        digitalWrite(WhistlePin, LOW);
        delay(1);
        digitalWrite(WhistlePin, HIGH);
      }
      else if(Button==B){
        digitalWrite(BellPin, LOW);
        delay(50);
        digitalWrite(BellPin, HIGH);
        delay(3000);
        digitalWrite(BellPin, LOW);
        delay(50);
        digitalWrite(BellPin, HIGH);
      }
      else if(Button==T){
        digitalWrite(TalkPin, LOW);
        delay(50);
        digitalWrite(TalkPin, HIGH);
      }
      else if(Button==F){
        
        SpeedIntFix = 64 - (64*SpeedInt)/100;
        digitalPotWrite(0,SpeedIntFix);
      }
      else if(Button==R){
        SpeedIntFix = (64*SpeedInt)/100 + 64;
        digitalPotWrite(0,SpeedIntFix);
      }
      else if(Button==S){
        digitalPotWrite(0,64);
      }
    }
    // close the connection:
    client.stop();
    Serial.println("client disconnected");
    Serial.println(SpeedIntFix);
    Serial.println(Button);
  }
}
void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
  // print where to go in a browser:
  Serial.print("To see this page in action, open a browser to http://");
  Serial.println(ip);
}

void digitalPotWrite(int address, int value) {
  // take the SS pin low to select the chip:
  digitalWrite(slaveSelectPin, LOW);
  //  send in the address and value via SPI:
  SPI.transfer(address);
  SPI.transfer(value);
  // take the SS pin high to de-select the chip:
  digitalWrite(slaveSelectPin, HIGH);
}
