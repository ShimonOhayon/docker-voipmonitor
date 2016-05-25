# docker-voipmonitor

## Startup

```
docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.6
docker run --name voipmonitor -d --link mysql:mysql -p 80:80 -p 5029:5029 voipmonitor:0.1.0
```

After that open the voipmonitor GUI in your browser and follow the instructions

## Sniffer
### Install
see https://www.voipmonitor.org/doc/Sniffer_installation
### Configure
#### modify /etc/voipmonitor.conf
- Enable and set "id_sensor" unique
- Set correct "interface"
- Set "managerip" so that the voipmonitor server can reach the sniffer
- Set database details "mysqlhost", "mysqlport" etc. so that the sniffer can inject data into the database 
#### configure the voipmonitor server via GUI
- Settings -> Sensors
  - New record
  - "Sensor id" is the id of your sniffer
  - Choose a speaking name (hostname?)
  - "Managerip" => sniffer ip
- Settings -> Systemconfiguration
  - update "default sensor hostname" => choose the ip of your sniffer
#### Additional informations
see https://www.voipmonitor.org/doc/Settings
