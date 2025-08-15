
# Number Match (Number Master–style) in Flutter

A clean, scalable Flutter implementation of a number-matching puzzle inspired by Number Master by KiwiFun. Match equal numbers or pairs that sum to 10 under flexible connectivity rules. Cells don’t disappear when matched—they fade and become non-interactive—preserving the board’s spatial logic. Includes 3 distinct levels, each with a 2-minute timer, partial initial grid fill, and an “Add Row” mechanic.

- Tech stack: Flutter (stable), Riverpod for state management
- Architecture: Feature-first with clear separation of UI and logic (Domain → Application → Presentation)
- Platforms: Android, iOS

***

## Features

- Match rule: tap two cells that are either equal or sum to 10
- Connectivity: match across rows, columns, diagonals, and across line breaks with empty cells in between
- No removal: matched cells remain visible, fade, and become non-interactive
- Feedback:
    - Valid match: fade + subtle scale feedback
    - Invalid match: selection clears (ready for shake/flash extensions)
- Levels:
    - 3 levels with increasing constraints
    - Each level runs on a 2-minute timer
- Grid behavior:
    - Starts with 3–4 rows filled (grid not fully filled)
    - Add Row button appends new rows in small batches until max rows
- Clean, reusable components:
    - RuleEngine, MoveFinder, GameController, GridCellWidget, HUD

***

## Demo

- Launches into a simple Level Select page → Start → Game
- No login, no tutorial screens
- Basic Material 3 theme; easy to skin

***

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)
- Android Studio/Xcode set up for device/emulator


### Setup

```bash
git clone <this-repo-url>
cd number_match
flutter pub get
flutter run
```


***

## Project Structure

```
lib/
  main.dart
  app.dart
  core/
    theme/
      app_theme.dart
  features/
    game/
      domain/
        models/
          cell.dart
          level_config.dart
        services/
          rule_engine.dart          # numeric rule: equal or sum-to-10
          move_finder.dart          # path/connectivity logic
      application/
        game_state.dart             # immutable state snapshot
        game_controller.dart        # core game orchestration
        game_providers.dart         # Riverpod providers
      presentation/
        pages/
          level_select_page.dart
          game_page.dart
        widgets/
          grid_view_widget.dart
          grid_cell_widget.dart
          hud_widget.dart
          add_row_button.dart
```


***

## How It Works

### Core Mechanics

- RuleEngine
    - Blocks already matched or same tapped cell
    - Valid when values are equal OR sum to 10
- MoveFinder
    - Validates if two cells can be connected via:
        - Same row, same column, diagonals, or a reading-order path across lines
    - Empty cells are allowed along the path; unmatched cells block the path
- GameController
    - Generates initial grid with 3–4 filled rows; rest empty up to max rows
    - Handles selection, validation, applying matches, remaining count
    - Timer from 120s; win if all matched before time; otherwise lose
    - Add Row appends a batch of rows up to maxRows


### UI

- LevelSelectPage: choose level 1/2/3 and start
- GamePage: HUD (time, remaining, status, restart), grid, Add Row button
- GridCellWidget: fades matched cells, highlights selection

***

## Configuration

Levels are defined in `game_providers.dart` as LevelConfig entries:

- initialRowsFilled: 3–4
- columns: e.g., 9
- maxRows: e.g., 10–12
- timeLimitSeconds: 120
- addRowBatchSize: 1–2
- seed: deterministic RNG for reproducible boards

Add or modify LevelConfig entries to create more levels or tune difficulty.

***

## Extensibility

- Configurable rules:
    - Add flags to LevelConfig (e.g., allowDiagonal, allowAcrossLines, allowGaps, targetSum)
    - Make RuleEngine/MoveFinder read these flags
- Row strategy:
    - Replace random row generation with a pending-pool queue to bias toward matchable pairs
- Hints:
    - Scan with RuleEngine + MoveFinder to find a valid pair and highlight
- Effects:
    - Add shake/red flash on invalid, scale/particle on valid, win/lose overlays
- Audio:
    - SfxService abstraction (tap/match/invalid/win/lose)
- Persistence:
    - Store best times, level completion, or settings via SharedPreferences/Hive

***

## Testing

- Unit tests
    - RuleEngine.isPairValid: equal/sum-to-10, matched/duplicate cell cases
    - MoveFinder.connectable: row/column/diagonal/line-break with empty and blocking cells
- Application tests
    - onCellTap transitions: select/deselect, valid/invalid matches
    - addRow respects maxRows and updates remaining correctly
    - Timer transitions to lost if time reaches 0 with unmatched cells

Seeded levels enable deterministic test scenarios.

***

## Performance

- Immutable state updates for predictability
- Grid split into rows and cells; changed cells rebuild
- Use ValueKey(cell.id) for stable identity and smoother animations

***

## Download APK

An APK download link can be added here once the release build is uploaded. Steps to produce one:

```bash
flutter build apk --release
# Output path:
# build/app/outputs/flutter-apk/app-release.apk
```

After uploading the file to a hosting location (e.g., GitHub Releases), replace the placeholder below with the actual link:

- Download latest Android APK: <ADD-LINK-TO-APK-HERE>

***

## License

MIT License. See LICENSE for details.

***

## Acknowledgments

Inspired by the Number Master/Ten Pair puzzle genre and its elegant “equal or sum-to-10” matching mechanic. This implementation follows a custom architecture and retains only the general gameplay idea and feel.

