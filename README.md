# NPCGenerator-App
The iOS app component of the NPC Generator

This app features a home page upon which users can generate NPCs for their fantasy Table Top Role Playing game.
The home page is written with SwiftUI and Combine, it features custom animations and web calls to the NPCGenerator-Server App to create NPCs and present them here. ( For more information on the server, see the companion project NPCGenerator-Server)

The second piece to the app is a page that contains all the previously generated NPCs. This page is created with UIKit, RxSwift, and RxDataSources and makes calls to the Server to get a paginated list of all NPCs previously generated and displays them on a UITableView.

Other notable pieces of this app are:

Network Service
- Contains Alamofire API requests

Network Manager
- Interfaces and handles responses from the methods in the service

Dependency Container
- Uses Swinject to create a container that contains the Network Manager and the View Model for the all characters page
- Don't want to be creating a new instance of Network Manager or the Viewmodel everytime we instantiate the VC
