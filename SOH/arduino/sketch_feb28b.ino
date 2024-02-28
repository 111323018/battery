#include <U8g2lib.h>
#include <Wire.h>

U8G2_SSD1306_128X64_NONAME_F_4W_SW_SPI u8g2(U8G2_R0, /* clock=*/ 13, /* data=*/ 11, /*cs*/3, /* dc=*/ 9, /* reset=*/ 8);   // Adafruit Feather M0 Basic Proto + FeatherWing OLED

void setup(void) {
  u8g2.begin();
  Serial.begin(9600);
}

void loop(void) {

  if (Serial.available() > 0) {
    String receivedString = Serial.readStringUntil('\n');
    
    // Assuming data format: "Temperature:XX Humidity:YY Pressure:ZZ"
    int temperature, SOH, SOC;
    if (sscanf(receivedString.c_str(), "Temperature:%d SOH:%d SOC:%d", &temperature, &SOH, &SOC) == 3) {
      u8g2.clearBuffer();              // clear the internal memory
      u8g2.setFont(u8g2_font_ncenB08_tr);  // choose a suitable font

      // Display the received values on different lines
      u8g2.drawStr(0, 10, String("Temperature: " + String(temperature) + "C").c_str());
      u8g2.drawStr(0, 20, String("SOH: " + String(SOH) + "%").c_str());
      u8g2.drawStr(0, 30, String("SOC: " + String(SOC) + "Pa").c_str());

      u8g2.sendBuffer();             // transfer internal memory to the display
      delay(1000);
    }
  }
}
