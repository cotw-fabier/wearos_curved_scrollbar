# CurvedScrollbar

CurvedScrollbar is a custom Flutter widget designed to replicate the scroll bar used on Android Wear devices. It provides a curved scrollbar that wraps around scrollable content, making it an ideal solution for small circular screens like those found on smartwatches. This widget is meant to be a drop-in replacement for the standard `Scrollbar` widget, offering a unique and visually appealing way to indicate scroll position.

## Why I Built It

I built CurvedScrollbar to address the need for a curved scrollbar specifically designed for use with Android Wear devices. The default scrollbar in Flutter does not cater to the circular nature of certain smartwatch displays, and I wanted to provide a simple yet effective solution for developers targeting this platform.

I hope you enjoy it. This is my first attempt at releasing a plugin to the world.

## Features

- **Curved Scrollbar**: A visually appealing curved scrollbar that mimics the one used in Android Wear.
- **Customizable**: Easily change the color, thickness, and track width to match your app's theme.
- **Auto-Hide**: Optionally hide the scrollbar when not scrolling, with smooth fade-in and fade-out animations.
- **Drop-In Replacement**: Simple to integrate and use as a replacement for the standard `Scrollbar` widget.

## Installation

Add the following line to your `pubspec.yaml` file under `dependencies`:

```yaml
dependencies:
  curved_scrollbar: ^0.0.1
```

Then, run `flutter pub get` to install the package.

## Usage

To use CurvedScrollbar, simply wrap your scrollable widget with `CurvedScrollbar`:

```dart
import 'package:curved_scrollbar/curved_scrollbar.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Curved Scrollbar Example'),
        ),
        body: CurvedScrollbar(
          controller: _scrollController,
          color: Colors.blue,
          blockThickness: 6.0,
          trackWidth: 10.0,
          isCurved: true,
          hideOnNoScroll: true,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 30,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
```

## Widget Options

The `CurvedScrollbar` widget offers several customization options:

- **`child`**: The scrollable widget to be wrapped by the scrollbar. (required)
- **`controller`**: The `ScrollController` used to read the scroll position of the child widget. This also plays nice with [Wear Roary](https://pub.dev/packages/wearable_rotary). Simply use the `RotaryScrollController()` in place of a standard `ScrollController()` (required)
- **`color`**: The color of the scrollbar. Default is `Colors.grey`.
- **`blockThickness`**: The thickness of the scrollbar block. Default is `4.0`.
- **`trackWidth`**: The width of the scrollbar track. Default is `8.0`.
- **`isCurved`**: Whether the scrollbar should be curved. Default is `true`. This is here so you can use a Wear plugin to detect the screen shape and auto-snap back to a standard square orientation scrollbar on square devices. Simple bool.
- **`hideOnNoScroll`**: Whether the scrollbar should hide when not scrolling. Default is `true`.

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request on the [GitHub repository](https://github.com/yourusername/curved_scrollbar).

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/cotw-fabier/wearos_curved_scrollbar?tab=Apache-2.0-1-ov-file) file for details.

---

Feel free to reach out if you have any questions or need further assistance. Enjoy using CurvedScrollbar!