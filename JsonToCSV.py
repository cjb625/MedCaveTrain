import json
import csv
for z in range(1,11):
    fName = 'Derail(RAMP)-(Chekpoint 4):Trial-'+str(z)
    f = open('/Users/cjbenzinger/Documents/Train Derailment/RAMP-CP4/'+fName,'r')
    data = json.load(f)
    outputFile = open(fName+'Converted.csv', 'w')
    outputWriter = csv.writer(outputFile)
    outputWriter.writerow(["ambientTemp","objectTemp","humidity","accelX","accelY","accelZ","gyroX","gyroY","gyroZ","magX","magY","magZ","light","time"])
    for i in range(1,len(data)):
        print i
        outputWriter.writerow([data[i]["d"]["ambientTemp"],data[i]["d"]["objectTemp"],data[i]["d"]["humidity"],data[i]["d"]["accelX"],data[i]["d"]["accelY"],data[i]["d"]["accelZ"],data[i]["d"]["gyroX"],data[i]["d"]["gyroY"],data[i]["d"]["gyroZ"],data[i]["d"]["magX"],data[i]["d"]["magY"],data[i]["d"]["magZ"],data[i]["d"]["light"],data[i]["d"]["time"]])
    outputFile.close()


