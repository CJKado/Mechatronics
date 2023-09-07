#include <math.h>
#include <Servo.h>

Servo base;
Servo a;
Servo b;
Servo grip;

const int numServos = 4; // Number of servos
Servo *servos[numServos] = {&base, &a, &b, &grip}; // Array of pointers to servos

const int moveTime = 800; // Time for each move in milliseconds
const int loopTime = 60000; // Time for the entire loop in milliseconds
const int sensorPin = A0; // Analog input pin for the force sensor
const int triggerThreshold = 500; // Threshold value for triggering the sensor
int score = 0; // Keeps track of the points scored

void setup() {
  base.attach(4);
  a.attach(5);
  b.attach(6);
  grip.attach(7);
  Serial.begin(9600); // Initialize serial communication
  grip.write(20);
  base.write(120);
  a.write(90);
  b.write(135-45);
}

void loop() {
  unsigned long startTime = millis();
  unsigned long elapsed = 0;
  while (elapsed < loopTime) { // Run for 60 seconds
    ball();
    lift();
    basket();
    grip.write(20);
    
  // Check if the force sensor is triggered and update the score
  int max = 0;
  for(int i=0 ; i<1000; i++){
    int check = analogRead(sensorPin);
    if (check > max){
      max = check;
    }
  }
  if (max > triggerThreshold) {
    score++;
    Serial.print("Score: ");
    Serial.println(score);
  }

    reset1();
    reset2();
    elapsed = millis() - startTime;
    Serial.println(elapsed/1000);
  }
  
  // Move servos to the reset position and keep them there
  int positions[numServos][2] = {{4, 120}, {5, 90}, {6, 135-45}, {7, 20}}; // Target positions for each servo
  moveServos(positions);
  while (true) {
    delay(10); // Keep the program running
  }
}

void ball(){
  int positions[numServos][2] = {{4, 120}, {5,135}, {6, 135-45}, {7, 32}}; // Target positions for each servo
  moveServos(positions);
}

void lift(){
  int positions[numServos][2] = {{4, 120}, {5, 90}, {6, 135+45}, {7, 32} }; // Target positions for each servo
  moveServos(positions);
}

void basket(){
  int positions[numServos][2] = {{4, 100}, {5, 90}, {6, 135+10}, {7, 32}}; // Target positions for each servo
  moveServos(positions);
}

void reset1() {
  int positions[numServos][2] = {{4, 120}, {5, 45}, {6, 135+45}, {7, 20}}; // Target positions for each servo
  moveServos(positions);
}

void reset2() {
  int positions[numServos][2] = {{4, 120}, {5, 90}, {6, 135-45}, {7, 20}}; // Target positions for each servo
  moveServos(positions);
}

void moveServos(int positions[][2]){
  // Move servos from current position to target position simultaneously
  int startTimes[numServos];
  int startPositions[numServos];
  for(int i = 0; i < numServos; i++){
    startTimes[i] = millis();
    startPositions[i] = servos[i]->read();
  }
  while (millis() - startTimes[0] <= moveTime) {
    int elapsed = millis() - startTimes[0];
     for(int i = 0; i < numServos; i++){
      int targetPos = map(elapsed, 0, moveTime, startPositions[i], positions[i][1]);
      servos[i]->write(targetPos);
    }
    delay(10); // Delay for stability
  }
}
