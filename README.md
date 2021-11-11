# flutter_camera_overlay

This package provides a simple camera overlay to aid capture of documents such 
as national ID cards, passports and driving licenses.

## Default ISO Card formats
https://www.iso.org/standard/70483.html

cardID1 - Most banking cards and ID cards

cardID2 - French and other ID cards. Visas.

cardID3 - United States government ID cards

simID000 - SIM cards

<img src="https://raw.githubusercontent.com/matwright/flutter_camera_overlay/main/example/flutter_camera_overlay.webp" width="300">

## Getting Started

Import the file.

```
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
```

### Use with default style:

```
CameraOverlay(
    snapshot.data!.first,
    CardOverlay.byFormat(format),
    (XFile file) => print(file.path),
    info: 'Position your ID card within the rectangle and ensure the image is perfectly readable.',
    label: 'Scanning ID Card');
```

### TODO

* add data capture (card numbers, etc)
* automatic edge detection & capture