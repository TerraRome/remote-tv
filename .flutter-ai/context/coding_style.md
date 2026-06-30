# Coding Style

## Dart Formatting

- All code formatted with `dart format .` before commit.
- Line length: 80 characters.
- Indentation: 2 spaces, no tabs.
- Trailing commas required for multi-line collections/parameters.

## Naming

| Element               | Convention                               | Example                            |
| --------------------- | ---------------------------------------- | ---------------------------------- |
| Files                 | snake_case                               | `user_repository.dart`             |
| Folders               | snake_case                               | `auth/`, `core/utils/`             |
| Classes               | PascalCase                               | `UserRepository`                   |
| Methods/Functions     | camelCase                                | `fetchUser()`                      |
| Variables             | camelCase                                | `userName`                         |
| Constants (top-level) | SCREAMING_SNAKE                          | `API_KEY`                          |
| Constants (local)     | camelCase                                | `const maxRetries = 3`             |
| Private members       | \_camelCase                              | `_client`, `_handleResponse()`     |
| Enums                 | PascalCase type, camelCase values        | `enum Status { active, inactive }` |
| Abstract classes      | I prefix                                 | `IAuthRepository`                  |
| Type params           | PascalCase, single letter or descriptive | `<T>`, `<UserId>`                  |

## Imports Order

1. `dart:` core library imports
2. `package:` external package imports
3. Relative imports (`../`)
4. Blank line between each group

## Comments

- Public API: `///` doc comments.
- Complex logic: `//` inline or `/* */` block.
- TODOs: `// TODO(username): message` with issue reference.
- FIXMEs: `// FIXME: message` for known bugs.

## Patterns

- Prefer expressions over statements (arrow functions, collection-if).
- Avoid `late` where possible—use nullable or lazy initialization.
- Prefer `final` over `var` for locals that don't reassign.
- Avoid `dynamic`/`Object`—prefer typed generics.
- Use `sealed class` (Dart 3) for state and result unions.

## Lint Rules (analysis_options.yaml)

```yaml
linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - prefer_final_locals
    - avoid_dynamic_calls
    - avoid_redundant_argument_values
    - sized_box_for_whitespace
    - sort_child_properties_last
    - use_key_in_widget_constructors
    - prefer_single_quotes
```
