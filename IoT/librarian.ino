
/*******************************************************************************************
 *
 * Library includes.
 *
 ******************************************************************************************/

// M5 Stack system.
#include <M5Stack.h>


// M5 Stack Wifi connection.
#include <WiFi.h>
#include <esp_wifi.h>
WiFiClient wifi_client;

// PubSubClient external library.
#include <PubSubClient.h>
PubSubClient ps_client( wifi_client );


/*******************************************************************************************
 *
 * Global Variables
 *
 ******************************************************************************************/

uint8_t guestMacAddress[6] = {0xA4, 0x02, 0xB9, 0xDF, 0x58, 0x04};

// Wifi settings
const char* ssid = "UoB Guest";             
const char* password = "";                     


// MQTT Settings
const char* MQTT_clientname = "SEGP_GROUP7";
const char* MQTT_sub_topic = "response_to_M5";
const char* MQTT_pub_topic = "M5_query";

// Please leave this alone - to connect to HiveMQ
const char* server = "broker.mqttdashboard.com";
const int port = 1883;


int M5_query_flag = 1;





/*******************************************************************************************
 *
 * Setup() and Loop()
 *
 ******************************************************************************************/

// Standard, one time setup function.
void setup()
{
    M5.begin();
    M5.Power.begin();

    // title page
    titlePage();
    

    // logo
    drawLogo();

    // connecting page
    M5.Lcd.clear(BLACK);   
    M5.Lcd.setTextSize(2);
    M5.Lcd.setCursor( 10, 10 );
    M5.Lcd.setTextColor( WHITE );
    M5.Lcd.println("Reset, connecting ...");

    // Setup a serial port
    Serial.begin(115200);
    delay(10);
    Serial.println("*** RESET ***\n");


    setupWifi();
    

    setupMQTT();


    // scan book
    scanBook();
}


// Standard, iterative loop function (main)
void loop()
{
  if (!ps_client.connected())
  {
    reconnect();
  }

  if(M5_query_flag)
  {
    ps_client.publish( MQTT_pub_topic, "{\"book_id\": \"Q02\"}" );
    M5_query_flag = 0;
  }
  
  ps_client.loop();

  if( M5.Lcd.getCursorY() > M5.Lcd.height() )
  {
    M5.Lcd.fillScreen( BLACK );
    M5.Lcd.setCursor( 0, 10 );
  }
}





/*******************************************************************************************
 *
 * Helper functions after this...
 *
 ******************************************************************************************/

void publishMessage( String message )
{

  if( ps_client.connected() ) {

    // Make sure the message isn't blank.
    if( message.length() > 0 ) {

      // Convert to char array
      char msg[ message.length() ];
      message.toCharArray( msg, message.length() );

      M5.Lcd.println("send >>");
      M5.Lcd.println( message );
      delay(2000);

      // Send
      ps_client.publish( MQTT_pub_topic, msg );
    }

  } else {
    Serial.println("Can't publish message: Not connected to MQTT :( ");

  }


}


void callback(char* topic, byte* payload, unsigned int length)
{

  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");

  String in_str = "";
  char input[length+1];

  for (int i=0;i<length;i++)
  {
    in_str += (char)payload[i];
    input[i] = (char)payload[i];
    Serial.print((char)payload[i]);
  }
  in_str += '\0';
  input[length] = '\0';
  Serial.println();

  splitAndPrintBookInfo(input);

}

void splitAndPrintBookInfo(char input[])
{
  char* bookId;
  char* booked;
  char* positions;
  char delimiter[] = ",";
  char* ptr = strtok(input, delimiter);

  while(ptr != NULL)
  {
    String temp = String(ptr);
    if(temp.indexOf("book_id") >= 0)
    {
      bookId = ptr;
    }
    else if(temp.indexOf("booked") >= 0)
    {
      booked = ptr;
    }
    else if(temp.indexOf("position") >= 0)
    {
      positions = ptr;
    }
    ptr = strtok(NULL, delimiter);
  }

  printBookInfo(bookId, booked, positions);
}

void printBookInfo(char* bookId, char* booked, char* positions)
{
    M5.Lcd.clear(BLACK);
    
    M5.Lcd.fillRect(0, 0, 320, 60, RED);
    M5.Lcd.fillRect(10, 10, 300, 40, BLACK);
    M5.Lcd.fillRect(0, 60, 320, 60, DARKGREY);
    M5.Lcd.fillRect(10, 70, 300, 40, BLACK);
    M5.Lcd.fillRect(0, 120, 320, 60, DARKGREEN);
    M5.Lcd.fillRect(10, 130, 300, 40, BLACK);

    M5.Lcd.setTextSize(2);
    M5.Lcd.setTextColor(WHITE);
    M5.Lcd.setCursor(45, 220);
    M5.Lcd.println("send");
    M5.Lcd.setCursor(135, 220);
    M5.Lcd.println("scan");
    M5.Lcd.setCursor(230, 220);
    M5.Lcd.println("cancel");

    M5.Lcd.setTextColor(YELLOW);
    M5.Lcd.setCursor(22, 20);
    M5.Lcd.println(bookId);

    M5.Lcd.setCursor(10, 80);
    M5.Lcd.println(booked);

    M5.Lcd.setCursor(10, 140);
    M5.Lcd.println(positions);

    ps_client.publish( booked, "your book is in library now." );
}

void scanBook()
{
    M5.Lcd.clear(BLACK);
    M5.Lcd.setTextSize(3);
    M5.Lcd.setTextColor(YELLOW);
    M5.Lcd.setCursor(120, 20);
    M5.Lcd.println("Scan");
    M5.Lcd.drawRect(100, 70, 120, 120, BLUE);
    M5.Lcd.setTextSize(2);
    M5.Lcd.setTextColor(WHITE);
    M5.Lcd.setCursor(45, 220);
    M5.Lcd.println("send");
    M5.Lcd.setCursor(135, 220);
    M5.Lcd.println("scan");
    M5.Lcd.setCursor(230, 220);
    M5.Lcd.println("cancel");

    while(true)
    {
      delay(10);
      if(M5.BtnB.wasReleased())
      {
        M5.Lcd.setTextColor(YELLOW);
        M5.Lcd.setCursor(135, 220);
        M5.Lcd.println("scan");
        M5.Lcd.fillRect(100, 70, 120, 120, BLUE);
      }
      else if(M5.BtnA.wasReleased())
      {   
        //publishMessage( "\"book_id\": \"002\"" );        
        M5.Lcd.clear(BLACK);   
        M5.Lcd.setTextSize(2);
        M5.Lcd.setCursor( 10, 10 );
        M5.Lcd.setTextColor( WHITE );
        M5.Lcd.println("Waiting ...");
        break;
      }
      else if(M5.BtnC.wasReleased())
      {
        M5.Lcd.clear(BLACK);
        M5.Lcd.setTextSize(3);
        M5.Lcd.setTextColor(YELLOW);
        M5.Lcd.setCursor(120, 20);
        M5.Lcd.println("Scan");
        M5.Lcd.drawRect(100, 70, 120, 120, BLUE);
        M5.Lcd.setTextSize(2);
        M5.Lcd.setTextColor(WHITE);
        M5.Lcd.setCursor(45, 220);
        M5.Lcd.println("send");
        M5.Lcd.setCursor(135, 220);
        M5.Lcd.println("scan");
        M5.Lcd.setCursor(230, 220);
        M5.Lcd.println("cancel");
      }
      M5.update();
    }
}

void titlePage()
{
    M5.Lcd.fillScreen(BLACK);
    M5.Lcd.setTextColor(YELLOW);
    M5.Lcd.setTextSize(3);
    M5.Lcd.setCursor(60, 60);
    M5.Lcd.println("Library");
    M5.Lcd.setCursor(60, 90);
    M5.Lcd.println("Management");
    M5.Lcd.setCursor(60, 120);
    M5.Lcd.println("System");
    delay(500);
    M5.Lcd.setTextSize(2);
    M5.Lcd.setTextColor(WHITE);
    M5.Lcd.setCursor(200, 160);
    M5.Lcd.println("Group 7");
    delay(2500);
}

void drawLogo()
{
    M5.Lcd.clear(BLACK);
    M5.Lcd.setTextSize(3);
    M5.Lcd.setTextColor(YELLOW);
    M5.Lcd.setCursor(120, 30);
    M5.Lcd.println("Librarian");
    delay(500);
    M5.Lcd.drawLine(40, 155, 100, 80, TFT_WHITE);
    delay(500);
    M5.Lcd.drawCircle(80, 160, 40, WHITE);
    delay(500);
    M5.Lcd.drawLine(120, 160, 160, 160, TFT_WHITE);
    delay(500);
    M5.Lcd.drawCircle(200, 160, 40, WHITE);
    delay(500);
    M5.Lcd.drawLine(240, 160, 280, 90, TFT_WHITE);
    delay(500);
    M5.Lcd.fillCircle(80, 160, 40, WHITE);
    M5.Lcd.fillCircle(200, 160, 40, WHITE);
    delay(1500);
}



/*******************************************************************************************
 *
 *
 * You shouldn't need to change any code below this point!
 *
 *
 *
 ******************************************************************************************/


void setupMQTT() {
    ps_client.setServer(server, port);
    ps_client.setCallback(callback);
}

void setupWifi() {

    byte mac[6];
    Serial.println("Original MAC address: " + String(WiFi.macAddress()));
    esp_base_mac_addr_set(guestMacAddress);
    Serial.println("Borrowed MAC address: " + String(WiFi.macAddress()));

    Serial.println("Connecting to network: " + String(ssid));
    WiFi.begin(ssid );
    while (WiFi.status() != WL_CONNECTED) delay(500);
    Serial.println("IP address allocated: " + String(WiFi.localIP()));
}

void setupWifiWithPassword( ) {

    byte mac[6];
    Serial.println("Original MAC address: " + String(WiFi.macAddress()));
    esp_base_mac_addr_set(guestMacAddress);
    Serial.println("Borrowed MAC address: " + String(WiFi.macAddress()));

    Serial.println("Connecting to network: " + String(ssid));
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) delay(500);
    Serial.println("IP address allocated: " + String(WiFi.localIP()));

}



void reconnect() {

  // Loop until we're reconnected
  while (!ps_client.connected()) {

    Serial.print("Attempting MQTT connection...");

    // Attempt to connect
    // Sometimes a connection with HiveMQ is refused
    // because an old Client ID is not erased.  So to
    // get around this, we just generate new ID's
    // every time we need to reconnect.
    String new_id = generateID();

    Serial.print("connecting with ID ");
    Serial.println( new_id );

    char id_array[ (int)new_id.length() ];
    new_id.toCharArray(id_array, sizeof( id_array ) );

    if (ps_client.connect( id_array ) ) {
      Serial.println("connected");

      // Once connected, publish an announcement...
      ps_client.publish( MQTT_pub_topic, "reconnected");
      // ... and resubscribe
      ps_client.subscribe( MQTT_sub_topic );
    } else {
      if( M5.Lcd.getCursorY() > M5.Lcd.height() )
      {
        M5.Lcd.fillScreen( BLACK );
        M5.Lcd.setCursor( 0, 10 );
      }
      M5.Lcd.println(" - Coudn't connect to HiveMQ :(");
      M5.Lcd.println("   Trying again.");
      Serial.print("failed, rc=");
      Serial.print(ps_client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
  M5.Lcd.println(" - Success!  Connected to HiveMQ\n\n");
  delay(500);
}

String generateID() {

  String id_str = MQTT_clientname;
  id_str += random(0,9999);

  return id_str;
}
