# Tedd DCS stack

Stack configuration: 

* [docker-compose.yml](docker-compose.yml) : production stack with the core services: 
  * mosquitto : mqtt broker
  * web_server : for labview data ingestion
  * influxdb : time-series database
  * telegraf : ingests data from the mqtt broker into the database
  * dashboard : Grafana monitoring dashboard
  * low_voltage : Control of the Rhode and Schwartz low-voltage power supply
  * dummy modules for testing: 
    * a dummy high-voltage power supply, 
    * a dummy low-voltage power supply, 
    * a dummy environmental sensor. 

## Prerequisites

* Install [docker](https://docs.docker.com/get-docker/)

## Initial setup 

Start the InfluxDB service: 

```
docker compose up -d influxdb
```

This will create a configuration file for influxdb, `influxdb/config/influx-configs`, 
with this content (the token will be different): 

```shell
[default]
  url = "http://localhost:8086"
  token = "nGTtMTEsXZlSnz0KOAxbj22f-bAZbAcmOnTSX1q04CjYoZbHKg2Vf-fzb3IxrSgYYuf442ZrDgS8l9WcOOHMSA=="
  org = "cms-tedd"
  active = true
```

Create a file named `my.env` with this content (make sure to use your own token): 

```shell  
TRACKER_DCS_INFLUXDB_TOKEN='nGTtMTEsXZlSnz0KOAxbj22f-bAZbAcmOnTSX1q04CjYoZbHKg2Vf-fzb3IxrSgYYuf442ZrDgS8l9WcOOHMSA=='
```

**WARNING: do not commit this file to git, for security reasons.**

## Start the stack together with the dummy services 

```
docker compose up -d 
```

To check the running services:

```
docker compose ps 
```

```
NAME                  COMMAND                  SERVICE             STATUS              PORTS
stack-grafana-1       "/run.sh"                grafana             running             0.0.0.0:3001->3000/tcp
stack-hv-1            "python dummy/hv.py …"   hv                  running             
stack-influxdb-1      "/entrypoint.sh infl…"   influxdb            running             0.0.0.0:8087->8086/tcp
stack-low_voltage-1   "python3 hmp.py lw_v…"   low_voltage         exited (1)          
stack-lv-1            "python dummy/hv.py …"   lv                  running             
stack-mosquitto-1     "/docker-entrypoint.…"   mosquitto           running             0.0.0.0:1884->1883/tcp
stack-sensor_1-1      "python dummy/sensor…"   sensor_1            running             
stack-telegraf-1      "/entrypoint.sh tele…"   telegraf            running             8125/udp
stack-web_server-1    "uvicorn tracker_dcs…"   web_server          running             0.0.0.0:8001->8000/tcp
```

In the case above, I'm running the stack on my mac, which has no access to 
the low voltage power supply. As a consequence, the low voltage container 
exits with an error. This is perfectly fine. 

On the DAQ PC however, the container must be running.

## Using the services 
 
* [Mosquitto](doc/mosquitto.md): The stack message broker
* [Grafana](doc/grafana.md): The dashboard system
* [Nodered](doc/nodered.md): To be written...


