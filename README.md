# Geofenced-Test
test app for slatestudios interview process

# Installation
The dependencies of the project are managed via cocoapods.

To run the project go to terminal and run `pod install` to install the dependencies. Then open `.xcworkspace`.

## Important note
This app requires access to Wifi Capabilities, and apple only allows that for a paid developer account. 
Unfortunately I don't have one. So in order to run on a device and test the app, you need to use a paid developer team and sign the app with it from xcode..

This can be done easily with automatic signing in xcode. Just login with the paid developer account under `XCode -> Preferences -> Accounts`. Then change the **Signing Team** under the project's target.

Note: For that to work seamlessly without the need to leave xcode, you might need to change the  *Bundle Identifier* to something unique. You can add `.xx` suffix or prefix to the existing bundle ID, that should help xcode generate everything without errors.

# Architecture
- Swinject for dependency injection throughout the application.
- RxSwift was used for demonstration
- Service layer was used to handle the business logic signals
- MVVM is used at the presentation layer
- While tests were not written, testability was in mind thoughout the implementation. ViewModel and service layer can be fully mocked and tested using *Quick/Nimble* or *XCTests*. ViewControllers can be tested using snapshot testing.