# Mosquitto

[Mosquitto](https://mosquitto.org/) is the message broker. 
Services such as the stack modules can publish messages to topics managed by 
the broker. They can also subscribe to topics.

All messages are exchanged with the MQTT protocol, which is similar to TCP 
but more lightweight. 

**The MQTT broker is the backbone of all communications within the stack**

As we saw above, the broker container is running: 

```shell
docker compose ps | grep mosquitto
```

```shell
stack-mosquitto-1     "/docker-entrypoint.…"   mosquitto           running             0.0.0.0:1884->1883/tcp
```

The mosquitto port in the container, 1883, is mapped to port 1884 on the host
machine. 

The mosquitto container runs the mosquitto server, and features a command line
mosquitto client, `mosquitto_sub`

We'll run this client from within the container to connect to all topics: 

```
docker exec stack-mosquitto-1 mosquitto_sub -v -t /#
```

You should see the messages that are being sent by the dummy modules: 

```
/lv/status [{"number": 0, "on": 0, "vreq": 0.0}]
/hv/status [{"number": 0, "on": 0, "vreq": 0.0}]
/sensor_1/status {"meas1": -0.9931889975255942, "meas2": 0.9931889975255942}
```

You can also submit messages with `mosquitto_pub`. For help, do: 

```shell
docker exec stack-mosquitto-1 mosquitto_pub --help 
```