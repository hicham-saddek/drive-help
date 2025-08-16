# Roadtrip Sidekick

Roadtrip Sidekick is a Flutter application designed for tablets to assist with planning and managing road trips.

## Getting Started

```bash
flutter pub get
flutter run
```

## Offline Maps

Place your `.mbtiles` file anywhere on the device and, from the Map screen, tap **Pick MBTiles** to choose it. When no offline tiles are configured, a fallback style with a plain background is used so POI markers remain visible. Direct MBTiles rendering is a work in progress and may require additional platform support in the future.

## Branch Policy
- `main` is protected; all changes go through pull requests.
- Create feature branches off `main` for work.

## Conventional Commits
This project uses [Conventional Commits](https://www.conventionalcommits.org/) for commit messages, e.g.:

```
feat: add bottom navigation scaffold
fix: correct theme colors
```
