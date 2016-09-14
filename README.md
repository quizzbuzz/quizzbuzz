# QuizzBuzz
Let's get quizzical

###Overview

Makers Academy final project, a multiplayer quiz game for all ages.

###User Stories

```
Roles:
User - a player who wants to test their general knowledge
```

####MVP

```
As a User
So that I can test my general knowledge
I can answer 10 general knowledge questions
```
```
As a User
So that I can choose an answer quickly
There is a choice of 4 possible answers for each question
```
```
As a User
So that I can see the outcome of the game
I am told how many questions I answered correctly on completion
```
```
As a User
So that I can change my mind about playing
I can abandon an in progress game
```
```
As a User
So that I can have lots of fun
I can choose to play again
```

####Version 2

```
As a User
So that my highest score is saved
I can create an account
```
```
As a User
So that my score is my own
I can sign in and sign out
```
```
As a User
So that I can compare my skills against others
I can see the leaderboard of all scores
```


####Version 3

```
As a User
So that the games are quick
There is a limit of 10 seconds to answer each question
```
```
As a User
So that I can test my skills against others
I can play against a randomly selected player
```
```
As a User
So that I can interact with other players
I can chat to players before and during games
```

####Version 4

```
As a User
So that I can test my skills against others
I can play against groups of other players
```



####Optional Extras

These features could be added in future versions:

```
As a User
So that I can track my scores
I can view my scores from previous games
```
```
As a User
So that I can play my friends
I can challenge another user to a game
```
```
As a User
So that I can test my specialist knowledge
I can select different categories of questions
```
```
As an Administrator
So that the games are interesting
I can add new questions together with the answer choices
```


###Instructions
fork the repo
clone the code

setup
```
mix deps.get
```
```
npm install
```
```
mix ecto.create
```
```
mix ecto.migrate
```
```
mix run priv/repo/seeds.exs
```

run the code

```
mix phoenix.server
```

got to localhost4000 in your browser and have all the fun!

###Authors
[Aga Kowalczuk](https://github.com/agakow), [Becca Pearce](https://github.com/beccapearce), [Jack Oddy](https://github.com/JackOddy), [Sophie Gill](https://github.com/soph-g)
