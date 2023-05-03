# Introduction

**Grande Mastro** is Fantasy-themed Godot-based Game of the Goose project that serves as a board game base, featuring both client and server components for multiplayer gameplay.

![Some Gameplay](resources\intro.gif)

# How to use
To start the game, you need to initially run the server within the 'executables' folder, and then you can start the client from the same folder. If you wish to make the project public, you need to open the router ports or rely on a VPS, in which case the port used in the project is 3234.

![Server States](resources\lobby.gif)


# Implementation Details
Information is given below regarding the implementation of the game

## Server
The server was creating a state machine using dictionaries to communicate with the client. Within the server is stored both information about the boxes and the cards used in the game, which are represented by scripts since they are context-dependent (e.g., player position, box feature, or other players' positions). The state machine is defined below.

![Server States](resources\server-states.png)

## Client
The client is responsible for taking the information sent at the end of each state from the server and processing it. The server is able to communicate information about the state it is in so that it can best handle mechanics, camera changes, and visual information. 

![Client States](resources\client.png)

# Features
Below you can find some features implemented in the game:

- Multiplayer
- Automatic or Manual Camera
- Easy Card and Squares Customization
- Complex Card behaviour implementable
- Easy Pawn Customization

![End Game](resources\endgame.gif)