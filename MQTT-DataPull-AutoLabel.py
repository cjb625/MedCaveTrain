import paho.mqtt.client as mqtt
import time
import sys
import msvcrt
import csv
fName = input('File Name:')
f = open("data",'w')
c = open("dataTimeStamp",'w')
csv = csv.writer(c)
csv.writerow(['TIME','DERAIL'])
derail = 0
def keepData(strData):
    global derail
    global csv
    global f
    global c
    if(msvcrt.kbhit()):
        k = ord(msvcrt.getch())
        if(k == 32):
            derail = 1
        if(k == 13):
            import os
            import csv
            import json
            f.close()
            c.close()
            global fName

            os.chdir('C:\\Users\\cjb62_000\\Desktop')
            f = open('data','r')
            d = open('dataTimeStamp','r')
            timedata = list(csv.reader(d))
            data = f.readlines()
            data2 = data[0].split(",b")
            print(len(data2))
            print(len(timedata))
            q = 2
            r = open('JSONpre','w')
            r.write('[')
            for i in range(1,len(data2)):
                print(i)
                if not i == len(data2) - 1:
                    r.write(data2[i][data2[i].index('{'):data2[i].rfind(',')]+',"TimeStamp":"'+timedata[q][0]+'","DERAIL":"'+timedata[q][1]+'"},')
                else:
                    r.write(data2[i][data2[i].index('{'):data2[i].rfind(',')]+',"TimeStamp":"'+timedata[q][0]+'","DERAIL":"'+timedata[q][1]+'"}')
                q += 2
            r.write(']')
            r.close()
            f.close()
            d.close()
            os.remove('data')
            os.remove('dataTimeStamp')
            r = open('JSONpre','r')
            p = open('JSON','w')
            data4 = r.readline()
            data5 = data4.replace("\\n","")
            p.write(data5)
            p.close()
            r.close()
            x = open('JSON','r')
            data6 = json.load(x)
            outputFile = open('TrainData/'+fName+'.csv', 'w')
            outputWriter = csv.writer(outputFile)
            outputWriter.writerow(["ambientTemp","objectTemp","humidity","accelX","accelY","accelZ","gyroX","gyroY","gyroZ","magX","magY","magZ","TimeStamp","DERAIL"])
            for i in range(1,len(data6)):
                print(i)
                outputWriter.writerow([data6[i]["ambientTemp"],data6[i]["objectTemp"],data6[i]["humidity"],data6[i]["accelX"],data6[i]["accelY"],data6[i]["accelZ"],data6[i]["gyroX"],data6[i]["gyroY"],data6[i]["gyroZ"],data6[i]["magX"],data6[i]["magY"],data6[i]["magZ"],data6[i]["TimeStamp"],data6[i]["DERAIL"]])
            outputFile.close()
            x.close()
            os.remove('JSON')
            os.remove('JSONpre')

            sys.exit(0)
    f.write(','+strData)
    csv.writerow([str(time.time()),derail])
    print("1")
    


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    keepData(str(msg.payload))
    
    
client = mqtt.Client(protocol=mqtt.MQTTv31)

client.on_connect = on_connect
client.on_message = on_message

client.connect("54.165.202.20", 1883, 60)

client.subscribe("To Topic")

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
