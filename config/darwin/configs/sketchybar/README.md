# Utility Bar - Rosé Pine Moon

This is a config I made which aggregate functionnality and aesthetics.

See https://github.com/FelixKratz/SketchyBar/discussions/47?sort=new#discussioncomment-14058252

> [!WARNING] 
> Some of the functionnalities of the bar are not working currently in MacOS Tahoe.

## Install :

Install sketchybar

```sh
brew tap FelixKratz/formulae
brew install sketchybar
brew services start sketchybar
```

Install this config with it's dependencies

```sh
brew install media-control macmon image-magick
brew install --cask SF-Pro sketchybar-app-font
# brew install yabai # Recommended only if you already have a config
# brew tap Waydabber/betterdisplay-cli # Recommended if using better display Configure [here](<plugins/display/script.sh>)

mkdir -p ~/.config
cd ~/.config/
git clone https://www.github.com/Kcraft059/sketchybar

sketchybar --reload
```

## A little demonstration of the functionalities :

<img width="2940" height="1912" alt="Screenshot 2025-08-09 at 18 49 42" src="https://github.com/user-attachments/assets/23066c77-1b31-4372-a737-8bf450af1d80" />
<img width="2940" height="1912" alt="Screenshot 2025-08-09 at 18 55 12" src="https://github.com/user-attachments/assets/0406413d-4468-4ba7-b55d-1c59e7e52cfb" />


https://github.com/user-attachments/assets/c9db52a4-d7fe-4daa-a904-cd201476556c