# ConnectIQ-Watch-IoT
This is a Connect IQ app for Garmin devices. It will send data in realtime to Azure via the Connect Mobile app.

# IoTWatch
This version uses a callback on the HR sensor and submits data whenever it changes. Only submits HR.

# IoTWatch2
This version uses a timer and submits all sensor data as a JSON each time the timer triggers.

# Instructions
Set up a Logic App with HTTP Response trigger as a POST method. Save the Logic App and copy the URL into the code before building and running. You may need to look at [developer.garmin.com](https://developer.garmin.com) to see how to build Connect IQ apps, as well as how to set up the required tooling such as Eclipse and the SDK.