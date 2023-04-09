A very lightweight package that allows rich text editing as well as providing a simple and intuitive
API for data serialization

A Flutter package that lets you edit text in flutter text fields very easily, by
simply just providing it a ```RichTextEditorController``` and ```RichTextField``` (
just ```TextField``` that supports changing alignment).
note that you can use the controller on a normal ```TextField``` but you will not be able to change
the alignment of the text.

## Features

- Data serialization (you can store and fetch your styled text in json format)
- change text alignment
- change text color
- change text size (TBD)
- change font style
- change font family (TBD)
- change font weight
- change font features (TBD currently supports changing 1)
- change text decoration

[video example](https://user-images.githubusercontent.com/89414401/230739943-845d77cd-60df-4d90-ba5a-1c9d14634695.mov)

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
  minLines: 1,
),

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

For more elaborate example, [see here](https://github.com/folaoluwafemi/rich_text_editor_controller_example)

## Additional information

To create issues, prs or otherwise contribute in anyway see [contribution guide](https://github.com/folaoluwafemi/rich_text_editor_controller/blob/main/CONTRIBUTION_GUIDE.md).
See our roadmap [here](https://github.com/folaoluwafemi/rich_text_editor_controller/blob/main/ROADMAP.md)