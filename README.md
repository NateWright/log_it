# log_it 

[![test](https://github.com/NateWright/log_it/actions/workflows/tests.yml/badge.svg)](https://github.com/NateWright/log_it/actions/workflows/tests.yml)

[![build-android](https://github.com/NateWright/log_it/actions/workflows/build-android.yml/badge.svg)](https://github.com/NateWright/log_it/actions/workflows/build-android.yml)


## Setup Instructions
### Requirements
* Windows or Linux computer
* git

### Steps
1. Install android studio with these instructions. [Download](https://developer.android.com/studio) [Install](https://developer.android.com/studio/install) 
2. Create an Android Virtual Device with these [Instructions](https://developer.android.com/studio/run/managing-avds)
    * Use Android 14 and latest SDK.
3. Install Flutter [Download](https://docs.flutter.dev/get-started/install)
4. Clone repo with `git clone https://github.com/NateWright/log_it.git`
5. Get Dependencies
    * Open the repo in the terminal and run `flutter pub get`
6. Open log_it repo in Android Studio
7. Start android virtual device
8. Click green triangle to launch program

## Tests
### Run tests locally
Run all tests with `flutter test` while in the root of the repository

### View test results from CI
1. Go to [build-action](https://github.com/NateWright/log_it/actions/workflows/build-android.yml) on LogIt's GitHub page.
2. Click on latest build at the top
3. On the left, click on **Flutter Tests**
4. Save or Print with browser's print function

## Installing app on Android
### Requirements
* Latest Android device running Android 14
### Steps
**Steps may vary depending on device use these as a general guide**
* Download latest LogIt app from the releases page [HERE](https://github.com/NateWright/log_it/releases) from your Android device
* Click on downloaded apk and hit install
* Open app named log_it