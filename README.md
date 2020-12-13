# SuperHeroSquadMaker

This is the ultimate superhero squad app using the Marvel API for data.
Its purpose is to demonstrate my approach to building an application and some general good practices I follow.

![superherosquadmaker](https://user-images.githubusercontent.com/33260372/102020685-c1af7680-3d72-11eb-902a-b6ab24a2faab.gif)

## Requirements

iOS Deployment Target | Xcode Version | Swift Language Version
------------ | ------------- | -------------
14.0 | 12.2 | Swift 5.3


## Getting started

To run the app, use the `SuperheroSquadMaker.xcodeproj`, select the `SuperheroSquadMaker` scheme and hit `⌘ + R`.

#### Configuration

In this simple use-case, the application target is using default `Config-Default.plist` file and a run script phase to generate `Config.swift` struct at compile time. For setup with different environments (like staging or production), it may use a different `.plist` file resolved using environment variables. In real life, none of these files should be committed to the repository.

## Architecture

In essence, every application is just a set of behaviors that can be modeled as a state machine. That means it can be defined in a definite number of states and events that trigger transitions between states. Events can be used to model user actions as well as be sent out by the state machine itself to perform side effects i.e. fetching image data.

This approach results in a unidirectional data flow, that comes with several benefits:

* clear separation of concerns (state, events, reducers are separated from each other, each one of them deals with a specific concern)
* UI as a pure function of application state (views can be created in a declarative manner, they're always a representation of a given immutable state)
* predictability (current state and new event are reduced into a new state)
* maintainability (state, events, and reducers are simple structs, easy to maintain and test)
* scalability (any new team member can easily understand how things work)

Any component should be created in a way that it be easily reused across the application, or even in other applications. Large features should be built with smaller components that can be extracted to their own, isolated modules and be easily glued back together to form the feature.

I decided to use MVVM architecture and with unidirectional data flow inside ViewModel layer. I think it fits SwiftUI declarative approach quite well.
 
## Dependencies
I decided to keep the generic code in the Utilities framework that is imported by the SuperheroSquadMaker target. For the more complex app, I would prefer it more modular, each feature ideally living in its own module.

### 1st party dependencies

* **[Utils]** is a framework that contains basic tools that are utilized in the rest of the project. It contains the base `ViewModel` class, cache, networking layer, and several `SwiftUI.View` utils and extensions.


### 3rd party dependencies
This project uses the Swift Package Manager to import third-party dependencies.
Given the simple nature of the task, I wanted to avoid using 3rd party libraries. I decided to make just a few exceptions and I explain my reasoning below.

* **[Disk]**

    I decided to use a simple disk cache to persist squad. I believe this approach fits the use case quite well, I did not feel the need to use more complex frameworks like CoreData or Realm.
    I did not want to reinvent the wheel, so I decided to use [Disk](https://github.com/saoudrizwan/Disk). 
    Nonetheless, it's all abstracted in the generic cache so it may be implemented using any other library.
    
    Since I already had a generic cache, I decided this app would benefit from caching hero images as well 🙂

* **[combine-schedulers]**

    A few schedulers that make working with Combine easier and what is most important makes it way more testable.

* **[SnapshotTesting]**
  
    This is [PointFree](https://github.com/pointfreeco/swift-snapshot-testing)'s snapshot testing library.


## Tests
  
Hit `⌘` + `U` to run all tests. 

All components that don't have corresponding tests should be easy to test as it follows the dependency injection principle.
Each view model has its own set of unit tests, that asserts it's state changes.
Snapshots are generated using an iPhone 12 14.2 simulator.

## TODOs
Some things I wish I did but didn't have enough time for it:

- present errors to the user in a meaningful way for the user
- adding more unit tests, especially for some Utils framework

