int count = 0;
void setup() {
  pinMode(13,OUTPUT);
  pinMode(12,OUTPUT);
  pinMode(A0,INPUT);
  Serial.begin(9600);
  
}

void loop() {
  while(count<=20){
    Serial.println(analogRead(A0));
    if(analogRead(A0)<=50){
      count++;
      delay(3000);
    }
  }
  while(count<=22){
    digitalWrite(13,HIGH);
    count++;
    delay(1000);
  }
  tone(11,40,10000);
  while(1==1);
}
