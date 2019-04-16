# Garmin Device Connect IQ IoT App
**produced by Dave Lusty**

## Introduction
This guide details how to configure the IoT watch app with Azure Services

## Prerequisites

Before getting started with this app you'll need to have a few things. Firstly you'll need a compatible (Garmin device)[https://developer.garmin.com/connect-iq/compatible-devices/]. Different devices have different capabilities so not all of them will be able to send all metrics.

Next, you'll need the Connect IQ SDK, the Eclipse IDE and the Java JRE installed. Instructions for setting these up can be found in the (Garmin getting started guide)[https://developer.garmin.com/connect-iq/programmers-guide/getting-started/].

# Environment 1

![environment 1 image](images/environment1.png)

Of the two methods shown here, environment 1 is the simplest. This architecture uses a Logic App with HTTP endpoint to ingest data and push this to the Power BI streaming data service. This is simple to configure but not as scalable as the Event Hub version below.

## Logic App

## Power BI

# Environment 2

![environment 2 image](images/environment2.png)

This environment uses an Azure Event Hub to ingest messages. As such this would be much more scalable and allows for copying data to a data lake for later analytics. Stream Analytics then takes these events and pushed them on to Power BI for the demo environment.

## Storage Account

## Event Hubs

## Stream Analytics

## Power BI