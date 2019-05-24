# Heart Rate data anomoly detection Part 2
**produced by Dave Lusty**

# Introduction
This guide details how to use the machine learning model we trained in the last part to test new readings coming from the watch. In this demo we'll set up the web service in Stream Analytics

You can find videos of this demo and the rest in the series on Youtube at the following locations:
[Part 1 - Intro](https://youtu.be/_39eKRNK3UU)
[Part 2 - Initial Platform Build](https://youtu.be/9llyGjfKiLo)

The architecture for this demo is shown below.
![MLArchitecture.png](images/MLArchitecture.png)

## Prerequisites
You'll need to have completed the previous demo so you can generate some useful data to train the model with. You can find this at [Watch demo infrastructure](https://github.com/davedoesdemos/ConnectIQ-Watch-IoT/blob/master/IoTWatchInstructions.md) but if you don't have a device you can skip over to YouTube and see the demo videos instead.


## Stream Analytics

```SQL
WITH bob AS (  
SELECT EventProcessedUtcTime, EventEnqueuedUtcTime, heartRate, yAccel, xAccel, altitude, cadence, heading, xMag, yMag, zMag, power, pressure, speed, temp, latitude, longitude, test(heartRate, yAccel, xAccel, altitude, cadence, heading, xMag, yMag, zMag, power, pressure, speed, temp, latitude, longitude) as result 
FROM connectIQ
)  

SELECT EventProcessedUtcTime, EventEnqueuedUtcTime, heartRate, yAccel, xAccel, altitude, cadence, heading, xMag, yMag, zMag, power, pressure, speed, temp, latitude, longitude, cast(result.[Scored Labels] as int) AS scoredLabels
INTO connectIQOut2
FROM bob 
```