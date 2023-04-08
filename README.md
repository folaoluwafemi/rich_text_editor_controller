A new Flutter package that let's you edit text in flutter text fields very easily, by
simply just providing it a ```RichTextEditorController``` and ```RichTextField``` (
just ```TextField``` that supports changing alignment).
note that you can use the controller on a normal ```TextField``` but you will not be able to change
the alignment of the text.

## Features

- change text alignment
- change text color
- change text size (TBD)
- change font style
- change font family (TBD)
- change font weight
- change font features (TBD currenly supports changing 1)
- change text decoration

## Getting started

add this to your ```pubspec.yaml``` file

```yaml
dependencies:
  flutter:
    sdk: flutter
  rich_text_editor_flutter: 0.0.1
```

or
using pub

```bash
pub add rich_text_editor_flutter
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter/rich_text_editor_controller/rich_text_editor_controller.dart';

...

class _HomePageState extends State<HomePage> {

  final RichTextEditorController controller = RichTextEditorController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            RichTextField(
              controller: controller,
              maxLines: 10, //use or apply style like in normal text fields
              minLines: 1,
            ),
          ],
        ),
      ),
    );
  }

}

```

Or use like normal controller

```dart
 ...
//or use normal TextField but without alignment support
TextField(
controller: controller,
maxLines: 10,
minLines:
1
,
)
,

...
```

Don't forget to dispose your controller

```dart
  @override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

## Additional information

To create issues, prs or otherwise contribute in anyway, please visit
the [github repo](https://github.com/folaoluwafemi/rich_text_editor_controller)