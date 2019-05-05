# Drugstore Project (name WIP)

## 1. Project description

The aim of the project is to develop a system which would allow users to check if conflicts exist between their drugs.
The system is divided into two components - a server functioning as middleware between client devices and various online
services like Microsoft Translator, SendGrid mailing API and multiple drug databases. It is conceived with expandability to
new databases in mind. The client device is considered to be a stationary kiosk at the moment, for example at the doctor's 
and drugstores. It has been realized as an iOS application for the Apple iPad device. 


##### All instructions given in this document assume usage of Microsoft Azure as the service provider for all online services

## 2. Node.js component (middleware)

### Prerequisites:

- server running the latest node.js (eg. via Microsoft Azure)
- access token to Microsoft Translation service via Microsoft Azure
- access token to SendGrid mailing service (eg. via Microsoft Azure)

### Configuration instruction

1. Log in to Azure Portal (http://portal.azure.com/)
2. Create a resource group (or use an existing one)
3. In the selected resource group, create an App Service with Node.js as its software stack. Note its URL!
4. Configure deployment for the Web Application using the method of your choice via Deployment Center. All files from this repository
except for the drugstoreAppiOS folder and its children should reside at the root folder of the App Service 
5. In the selected resource group, create a Translator Text resource, save its API key!
6. In the selected resource group, create a SendGrid Email Delivery resource, save its API key!
7. In the App Service resource, select Application Settings, find the Application settings section and add the following keys (without brackets):
- emailSender: <email_sender> (email address to be used as the sender email for generated reports)
- emailAPI: <email_API> (SendGrid API key)
- translatorAPI: <translator_API> (Translator Text API key)
- translatorAddress: <translatorAddress> (address of Microsoft Translator service)

The complete stack should be now up and running. To confirm that the node.js server is running, enter its address into your browser and check that "Cannot GET /" is displayed.
If there are problems with node dependencies, run npm install for the App Service using Bash connection through Advanced Tools at the wwwroot directory.

### Adding new drug databases

Connecting to a new drug database requires conforming to a specific interface. The template to be used as a base for an adapter
for the given database is included in the project as databaseAdapterTemplate. Please see the documentation inside the file
for instructions on how to implement the new connection. To change the currently used adapter, change the filename on line

const adapter = require('./RxNavAdapter.js');

in routes.js to a filename of your choice.


### Using the middleware API

For documentation of the middleware API please see the documentation inside routes.js.
 

## 3. iOS component (kiosk)

- iPad device with iOS 11 or later configured in kiosk mode (see https://www.webascender.com/blog/setup-kiosk-mode-lock-ipad-just-one-app/)
- XCode 9.3 or newer
- latest CocoaPods package manager

### Configuration Instruction

0. Run pod install in the project directory. Resolve any incompatibilities that may occur.
1. Open the XCode *Workspace* from the cloned repository
2. Update the info.plist file with your server address (App Service URL)
3. Compile and run the app on a physical

While any iOS 11 or later device will work, it is strongly suggested that the application is run on iPad Air od similar in portrait mode.
iPhones and horizontal orientations are not supported.