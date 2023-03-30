 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/google-iris-login)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fgoogle-iris-login&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fgoogle-iris-login)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fgoogle-iris-login&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fgoogle-iris-login)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)
# Google IRIS Login
This is an app to add social login using Google.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/yurimarx/google-iris-login.git
```

Go to the .env file and input your CLIENT_ID generated in your Google Cloud Console (to generate a CLIENT_ID see the article https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid)

Open the terminal in this directory and call the command to build InterSystems IRIS in container:  

```
$ docker-compose build
```

To run the InterSystems IRIS in container:  

```
$ docker-compose up -d
```

## What does it do
Allows to the user login using google social login.

1. Open the Management Portal in your browser (http://localhost:52773/csp/sys/%2525CSP.Portal.Home.zen):
2. Click the button Sign In with (Google logo)

## Credits
1. Passwordless app - https://openexchange.intersystems.com/package/passwordless
2. Support from Alexander Koblov - https://community.intersystems.com/user/alexander-koblov
3. https://developers.google.com/identity/gsi/web/guides/overview
