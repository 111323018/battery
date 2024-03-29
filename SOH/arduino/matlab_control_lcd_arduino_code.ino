#include <Arduino.h>
#include <U8g2lib.h>

#ifdef U8X8_HAVE_HW_SPI
#include <SPI.h>
#endif

#ifdef U8X8_HAVE_HW_I2C
#include <Wire.h>
#endif

U8G2_SSD1306_128X64_NONAME_F_4W_SW_SPI u8g2(U8G2_R0, /* clock=*/ 13, /* data=*/ 11, /*cs*/3, /* dc=*/ 9, /* reset=*/ 8);   // Adafruit Feather M0 Basic Proto + FeatherWing OLED

void setup(void) {
  u8g2.begin();
  Serial.begin(9600);
}

void loop(void) {

  if (Serial.available() > 0) {
    String receivedString = Serial.readStringUntil('\n');
    if (receivedString.startsWith("Temperature:")) {
      u8g2.clearBuffer();              // clear the internal memory
      u8g2.setFont(u8g2_font_ncenB08_tr);  // choose a suitable font
      u8g2.drawStr(0, 10, receivedString.c_str()); // Display the received string
      u8g2.sendBuffer();             // transfer internal memory to the display
      delay(1000);
    }
  }
}