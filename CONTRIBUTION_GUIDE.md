
# Guide to contribution

## General
### Issues
- Give a short title to your issue in the title section
- Add a tag at the beginning of your comment with the format: "[ {Tag} ] ...{comment continuation}". below are the possible tag:
  - `feature request`, `error`, `bug`
- Make your comment as descriptive as possible.

### Pull Request
- PRs should follow the similar guide to issues
- Add a tag at the beginning of your comment with the format: "[ {Tag} ] ...{comment continuation}". below are the possible tag:
    - `feature request`, `error`, `bug`
- If your PR was made to fix an issue, reference the issue in your pr title like so: "{your pr title} | Issue {issue number}"

### Roadmap
If you wish to contribute to the roadmap, fork this [repo](https://github.com/folaoluwafemi/rich_text_editor_controller) at branch ```{ROADMAP-TAG}``` if the branch does not exist, feel free to create one in your fork.

## Code conventions
- All variables MUST be strongly typed except for local variables
  - Do `final RichTextEditorController controller = RichTextEditorController();`
  - Do `final controller = RichTextEditorController();` for local variable.
- All code MUST pass static analysis.
- DO NOT `ignore` any lint rule.