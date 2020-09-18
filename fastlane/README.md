fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios screenshots
```
fastlane ios screenshots
```
Generates screenshots and uploads them to the App Store
### ios prepare_release_ci
```
fastlane ios prepare_release_ci
```
Prepare the GitHub Actions environment for a release build
### ios test
```
fastlane ios test
```
Runs tests
### ios release
```
fastlane ios release
```
Push a new release build to the App Store
### ios update_certs
```
fastlane ios update_certs
```
Updates the certificates and provisioning profiles in the match repo

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
