# StartTheZoom

StartTheZoom is an app for macOS (10.13 High Sierra or later) that opens http and https URLs in the Zoom app and then quits.

The Zoom app does not declare that it can open http and https URLs. Thus, sandboxed Mac App Store apps such as [Link Unshortener](https://underpassapp.com/LinkUnshortener/) and [StopTheMadness](https://underpassapp.com/StopTheMadness/) cannot open these URLs in Zoom. StartTheZoom can, because it is not sandboxed.

See [StopTheMadness Web Rules](https://underpassapp.com/StopTheMadness/support-rules.html#web) for instructions on how to use StartTheZoom.

## Installing

1. Download the [latest release](https://github.com/lapcat/StartTheZoom/releases/latest).
2. Unzip the downloaded `.zip` file.
3. Move `StartTheZoom.app` to your Applications folder.
4. Open `StartTheZoom.app`.
5. Quit `StartTheZoom.app`.

## Uninstalling

1. Move `StartTheZoom.app` to the Trash.

## Building

Building StartTheZoom from source requires Xcode 13 or later.

Before building, you need to create a file named `DEVELOPMENT_TEAM.xcconfig` in the project folder (the same folder as `Shared.xcconfig`). This file is excluded from version control by the project's `.gitignore` file, and it's not referenced in the Xcode project either. The file specifies the build setting for your Development Team, which is needed by Xcode to code sign the app. The entire contents of the file should be of the following format:
```
DEVELOPMENT_TEAM = [Your TeamID]
```

## Author

[Jeff Johnson](https://lapcatsoftware.com/)

To support the author, you can [PayPal.Me](https://www.paypal.me/JeffJohnsonWI) or buy [my App Store apps](https://underpassapp.com/).

## Copyright

StartTheZoom is Copyright © 2022 Jeff Johnson. All rights reserved.

Zoom is Copyright © 2012 Zoom Video Communications, Inc. All rights reserved.

Neither StartTheZoom nor Jeff Johnson is associated in any way with Zoom Video Communications, Inc.

## License

See the [LICENSE.txt](LICENSE.txt) file for details.
