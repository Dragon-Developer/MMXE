## Notice
We decided to restart after a few years of hiatus. This is to take advantage of changes made to gamemaker, the tool used to make MMXE run.

We intend to use as little code as possible from the old version going forward. Because of the extreme difference between the old and new version of MMXE, porting the old enemies / armors / bosses is not possible. 

# Mega Man X Engine Version 2
Mega Man X Engine is a framework being developed using GameMaker that implements common Mega Man X game features so you don't have to start from scratch, plus a few extra features to make better games. 

This new version makes the process of adding new content much easier and less confusing when compared to version 1. It also allows for things such as texture packs. 

This is NOT a proper game. We will NOT add content if you ask us. We CANNOT take money from people. 

## Social Media
- YouTube: https://www.youtube.com/@MMXEngine
- Discord: https://discord.gg/dXygbY9

The majority of updates come from discord. If you need help, go ask there!

# How to use
Get Gamemaker. For the best compatibility and the least amount of issues, use 2024.4.1.152 as this is the version used to develop MMXE.

You can find the version here: https://releases.gamemaker.io/release-notes/2024/4

If the above link does not work, complain to AxlForte (That's me!).

After that, go click on the code button here in the github page and click on the download option in the dropdown menu. This will download a copy of the project files onto your computer. This is a copy, which means changing your downloaded version does not apply the changes to this repository.

Once you have your own local copy of the engine, you are capable of making your own changes! Read the wiki for help, and if the wiki does not contain what you need go to the discord and ask help there!

# Wiki
This Github features a wiki!

https://github.com/Dragon-Developer/MMXE/wiki

If you want to learn the ins and outs of the engine, start there. It includes pages on:

- A description of the animation system
- Doccumentation on adding new characters, armors, etc
- How to add new enemies (Currently unfinished)
- Some programming syntax
- How to add new levels
- tips and tricks for creating good levels.

While the engine is currently about 99% feature complete, there is very little example content showing how these features work. 
# Features

This engine is meant to be as close as possible to the SNES megaman x games. While we stick to the SNES games as much as possible, we do add features beyond the snes games or beyond the main 8 games. 

Content is a seperate thing from features. Something like the armor system is a feature (it's a system you use to make the game) while something like the light armor is content (you use it in the game directly). 

Currently notable features include:
- Basic Movement (walking, jumping, walljumping, dashing)
- Enemies (Though there many to use yet)
- Dialouge (While complete, text effects arent added yet)
- Scene rotation/flipping (No content uses the world flipping, but the functions exist)
- Armors
- Seperate Characters
- Projectile based special weapons
- state based special weapons
- weapon get screen
- armor select

In progress features:
- Ladders (Animation is unfinished and the shoot animation has yet to be handled)
- Bosses (Death state is unclean. )
- stage select (Needs boss tease, fortress stages, transitions in/out, boss preview)
- Pause menu (sub tanks dont work, settings dont work, settings section doesnt show which icon is selected)
- melee special weapons (Projectile to enemy collision needs a few extra things to be consistent. small projectiles still work as expected.)
- aimed special weapons (Code assumes you're axl. does not support moving while jumping, EG metal blade from mm2)

Features not added:
- Armor Capsules

Feel free to suggest new features in the discord. If your suggestion is for content and not for a feature (Distinction can be found above), you will be told to make it yourself. 

# Contributors
### Programming:
- Dark Shadow (Dragon-Developer): main programmer. (Animation system, Component system, Base player)
- ApselTheBlue: creates test stages and helps with programming in v1 of the engine.
- AxlForte: tried his best (Special weapon code, enemy and boss handler code, player armor and )
- Gacel: general programming, X game data, SNES palette shader

### Music:
- K-Lips-O
- Mentlegen

### Spriting:
- Kaegrin: Axl sprites, 4th armor, Vile, general spriting
- Orion: X Armor Spriter, general spriting
- SuperKuperX: Effect Spriter, general spriting
- Vent: Secret Content
- HombreRandom: Magma Dragoon sprites
- Luminers: Stage tile designer, background artist
- Burai: Axl sprites
- Bwogglyswog: General spriting, Menus
- Fncilpeeps: General spriting
- DocrobotZX: Rock, Protoman, Bass
- Thomas Light (AKA: MaverickBlue on DeviantArt): Zero, Iris, Ultimate Armor X
- yesilovenachos: Secret content, X sprites
- Victor from Maverick Wars: General spriting.
- Fen: Glide armor
- AxlForte: General spriting
- Mikael(?)

### Helpers:
- TheUltDark: ripping resources
- Patwick: spriting/programming tips
- Justin3009: programming tips
- Kammesennin: Tester, armor separation, SNES game data
- ColeFam: emotional support
