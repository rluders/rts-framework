# RTS Framework - Addon Structure

## Introduction

This document explains the structure of the RTS Framework addon, detailing how features, assets, and scripts are organized to maintain modularity, reusability, and scalability.

## Directory Structure

```
addons/rts_framework/
│── core/                 # Core systems and utilities
│   ├── rts_controller.gd
│   ├── raycaster.gd
│   ├── signals.gd
│   ├── config.gd
│
│── features/             # Organized by feature (Selection, Commands, Camera, etc.)
│   ├── selection/
│   │   ├── selection_manager.gd
│   │   ├── selectable_component.gd
│   │   ├── ui_selection_box.tscn
│   │   ├── assets/      # Selection-specific assets
│   │   │   ├── selection_shader.tres
│   │   │   ├── selection_circle.png
│   │   ├── tests/       # Unit tests related to selection
│
│   ├── commands/
│   │   ├── command_manager.gd
│   │   ├── commandable_component.gd
│   │   ├── assets/
│   │   │   ├── command_icons.png
│   │   ├── tests/
│
│   ├── camera/
│   │   ├── camera_controller.gd
│   │   ├── camera_gimbal.tscn
│   │   ├── assets/
│   │   │   ├── camera_icon.png
│   │   ├── tests/
│
│── entities/             # Base entities and their logic
│   ├── base_entity.gd
│   ├── unit_entity.gd
│   ├── building_entity.gd
│   ├── resource_entity.gd
│   ├── assets/           # Assets shared among entities
│   │   ├── entity_icons/
│   │   │   ├── unit_icon.png
│   │   │   ├── building_icon.png
│   │   │   ├── resource_icon.png
│   │   ├── shaders/
│   │   │   ├── entity_highlight.tres
│   │   │   ├── damage_effect.tres
│   ├── tests/
│
│── ui/                   # UI components and assets
│   ├── hud.tscn
│   ├── hud.gd
│   ├── command_panel.tscn
│   ├── assets/
│   │   ├── ui_font.tres
│   │   ├── ui_background.png
│   │   ├── cursor_icons/
│   │   │   ├── move_cursor.png
│   │   │   ├── attack_cursor.png
│   ├── tests/
│
│── assets/               # Global assets (shaders, fonts, icons)
│   ├── icons/
│   │   ├── rts_framework_icon.png
│   │   ├── selection_manager_icon.png
│   │   ├── command_manager_icon.png
│   ├── shaders/
│   │   ├── outline_shader.tres
│   │   ├── water_shader.tres
│   ├── fonts/
│   │   ├── sci_fi_font.tres
│   │   ├── medieval_font.tres
│
│── debug/                # Debugging tools and overlays
│   ├── debug_overlay.gd
│   ├── debug_ui.tscn
│   ├── assets/
│   │   ├── debug_icons.png
│   ├── tests/
│
│── README.md
│── plugin.cfg
│── rts_framework_plugin.gd
```

## Explanation

### Core Systems (`core/`)

Contains essential global systems like:

- **RTSController**: The main orchestrator handling communication between components.
- **Raycaster**: A global singleton to detect objects under the cursor.
- **Signals**: A global singleton managing event-based communication.

### Features (`features/`)

Each feature has its own folder with:

- **Scripts** (`.gd` files) handling the feature logic.
- **Assets** (`assets/` subfolder) containing feature-specific resources (textures, shaders, etc.).
- **Tests** (`tests/` subfolder) containing unit tests for the feature.

### Entities (`entities/`)

Contains base entities such as:

- **UnitEntity**: Units like soldiers or tanks.
- **BuildingEntity**: Structures like barracks or factories.
- **ResourceEntity**: Collectable resources.

> Shared assets like entity icons and shaders are included in an `assets/` subfolder.

### UI (`ui/`)

- UI components like the HUD, Command Panel, and cursor icons.
- UI-specific assets (e.g., UI textures and fonts).

### Global Assets (`assets/`)

Resources shared across the entire framework:

- Icons for custom nodes in the editor.
- Shaders for visual effects (e.g., outlines, water effects).
- Fonts for UI and in-game text.

### Debugging (`debug/`)

- Debugging tools, overlays, and development utilities.
- Includes visual debugging assets.

### Plugin Configuration (`plugin.cfg` and `plugin.gd`)

Defines the addon for Godot’s plugin system.