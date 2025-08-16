# Roadtrip Sidekick

Roadtrip Sidekick is a Flutter application designed for tablets to assist with planning and managing road trips.

## Getting Started

```bash
flutter pub get
flutter run
```

## Offline tiles

1. Copy your `.mbtiles` file to the device or any accessible storage.
2. In the app go to **Map** → **Pick MBTiles** and select the file.
3. The app copies the file into its private `Documents/tiles/` folder and
   remembers that path for future launches.

Very large MBTiles archives (multiple gigabytes) can take a while to copy – keep
the app in the foreground until the operation completes.

## Branch Policy
- `main` is protected; all changes go through pull requests.
- Create feature branches off `main` for work.

## Conventional Commits
This project uses [Conventional Commits](https://www.conventionalcommits.org/) for commit messages, e.g.:

```
feat: add bottom navigation scaffold
fix: correct theme colors
```
