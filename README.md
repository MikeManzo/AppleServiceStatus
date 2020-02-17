# AppleServiceStatus

[![Status](https://travis-ci.org/MikeManzo/Ansi.svg?branch=master)](https://travis-ci.org/MikeManzo/AppleServiceStatus)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/mikemanzo/AppleServiceStatus.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/MikeManzo/AppleServiceStatus.svg)
![GitHub All Releases](https://img.shields.io/github/downloads/MikeManzo/AppleServiceStatus/total.svg)
![Swift](https://img.shields.io/badge/%20in-swift%205.1-orange.svg)

Retrieve Apple Service Status notifications in a simple and compact form.  For exmple:

- [English - Developer Services](https://www.apple.com/support/systemstatus/data/developer/system_status_en_US.js)
- [English - System Services](https://www.apple.com/support/systemstatus/data/system_status_en_US.js)

Allows you to programitcally interrogate the Apple Services Websites and find out:
  - Which services are up
  - Which services are down (and why)
  - Affected User-Base
  - Time of outage and estimated closure date

## Usage

Dirt-simple usage:

```
 let service = AppleServiceStatus()
 test.getStatus(type: .developer, { status, error in
    guard let goodStatus = status else {
        print("Error! \(error?.localizedDescription ?? "")")
        return
    }
    print(goodStatus)
})
```

## Features

### Available Data Model

- serviceName: TestFlight,
    - redirectUrl: https://developer.apple.com/testflight/,
        - event 1: 
            - startDate: 02/10/2020 11:45 PST
            - endDate: 02/12/2020 03:00 PST
            - affectedServices: 
            - eventStatus: resolved
            - usersAffected: Some users were affected
            - epochStartDate: 1581363900000
            - epochEndDate: 1581505200000
            - messageId: 1003214
            - statusType: Issue
            - datePosted: 02/15/2020 01:00 PST
            - message: Users experienced a problem with this service
        - event N:
            - startDate: ...
            - endDate: ...
            - affectedServices: ... 
            - eventStatus: ...
            - usersAffected: ...
            - epochStartDate: ...
            - epochEndDate: ...
            - messageId: ...
            - statusType: ...
            - datePosted: ...
            - message: ...

## Installation

#### Swift Package Manager

For [Swift Package Manager](https://swift.org/package-manager/) add the following package to your Package.swift file. Swift 3, 4 & 5 are supported, macOS 10.12 and later:

``` Swift
.package(url: "https://github.com/MikeManzo/AppleServiceStatus", .branch("master")),
```

## ToDo

- [ ] Add support for localizaion
- [ ] Add support for past events and only pushing updates to those

#### Credits
I have always wanted an easy way to programatcally determine the status of Apple's services.  While, I admit - clicking a webpage is dirt simple - offering the [swift](https://swift.org) community a way to do it programitcally seemed like a fun little project.  To help, I took inspiration from [macadmins](https://github.com/macadmins) and their python module [apple-status-api](https://github.com/macadmins/apple-status-api).