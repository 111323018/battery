#include <Arduino.h>
#include <U8g2lib.h>
#include <OneWire.h> 
#include <DallasTemperature.h> 

#define DQ_Pin 2  

OneWire oneWire(DQ_Pin);
DallasTemperature sensors(&oneWire);

#ifdef U8X8_HAVE_HW_SPI
#include <SPI.h>
#endif
#ifdef U8X8_HAVE_HW_I2C
#include <Wire.h>
#endif

U8G2_SSD1306_128X64_NONAME_F_4W_SW_SPI u8g2(U8G2_R0, /* clock=*/ 13, /* data=*/ 11, /*cs*/4, /* dc=*/ 9, /* reset=*/ 8);   // Adafruit Feather M0 Basic Proto + FeatherWing OLED

void setup(void) {
  u8g2.begin();
  Serial.begin(9600);
  sensors.begin();
}

void loop(void) {
  float temp; 

  u8g2.clearBuffer();                   
  u8g2.setFont(u8g2_font_ncenB08_tr);  
 
  Serial.print("Temperatures --> ");
  sensors.requestTemperatures(); 
  temp = sensors.getTempCByIndex(1); 

  char tempStr[10];
  dtostrf(temp, 6, 2, tempStr);  

  char displayStr[20];
  sprintf(displayStr, "Temperature:%s C", tempStr); 
  u8g2.drawStr(0, 10, displayStr);   

  u8g2.sendBuffer();                 
  delay(1000); 
}

