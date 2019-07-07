# Odds Are

Build status:
[![CircleCI](https://circleci.com/gh/BrendanJones44/OddsAre.svg?style=svg)](https://circleci.com/gh/BrendanJones44/OddsAre)

Live URL:
https://www.what-are-the-odds.com/


## Table of Contents

1. [ How the game works](#how_the_game_works)
- [ Friendship](#friendship)
- [ Initial Dare ](#initial_dare)
- [ Dare's Response](#dare_response)
- [ Finalizing the Odds Are](#dare_finalize)
- [ Example of Challenger Losing](#example_losing)
- [ Example of Challenger Winning ](#example_winning)
- [ Even Number Case](#even_number_case)
2. [ Data Model ](#data_model)
- [ Diagram ](#current_diagram)
- [ Rationale ](#rationale)
- [ Old Model ](#old_model)
- [ Final Solution](#final_solution)
3. [ CI-CD ](#ci_cd)
- [ Build Instructions](#build_instructions)
- [ Deploy Instructions](#deploy_instructions)

<a name="how_the_game_works"></a>
## How the game works

OddsAre is a chance-based dare game between two users. 

<a name="friendship"></a>
### Friendship
To play the game, users much first be friends. This is accomplished on the application by sending a friend request to a user, and having that user accept the friend request.

<a name="initial_dare"></a>
### Initial Dare
Starting off, the first user, we'll refer to as `User A`, thinks of a dare to challenge `User B` to do. They then send a `Odds Are` to User B with the Dare.

<a name="dare_response"></a>
### Dare's Response
`User B` will receive a notification saying they've been sent an `Odds Are`. `User B` then "sets the odds" of the dare. If it's something they don't mind doing, they might set it low, like out of 10. Or if it's something they really wouldn't want to do, they'd set it high like out of 100.

They then select a number between 1 and what they set the odds out of.

This then sends a response to `User A`.

<a name="dare_finalize"></a>
### Finalizing the Odds Are

The number they set the odds out of is visible to the challenger, `User A` in this case. `User A` does not see the number `User B` picked though, it is up to them to guess the number.

If `User A` guesses the number correctly, they win the `OddsAre` and `User B` must do the Dare. This becomes a `Task` that doesn't go away until both `User A` and `User B` mark it as complete.

There is always risk to the challenger, `User A`, though. If the number `User A` guesses adds up with `User B`'s number to what `User B` set the odds out of, `User A` loses the `OddsAre` and the task is created for them that doesn't go away until both users mark it as complete.

<a name="example_losing"></a>
### Example of Challenger Losing
Challenger: "Odds Are you do this dare?"

Recipient:  "1 out of 10"

Recipient:  * Selects 2 *

Challenger: * Guesses 8 *

8 + 2 = 10 (what the odds were set out of)

#### Challenger lost

<a name="example_winning"></a>
### Example of Challenger Winning

Challenger: "Odds Are you do this dare?"

Recipient:  "1 out of 10"

Recipient:  * Selects 8 *

Challenger: * Guesses 8 *

#### Recipient lost

<a name="even_number_case"></a>
### Even Number Case
In the case that the odds are set out of an even number, let's say `10`, the number `5` cannot be selected. This is because if both the challenger and recipient guess `5`, it both adds up to `10` and was the correct number to guess. This would be a suicide number, and nobody would want to guess/pick it.

<a name="data_model"></a>
## Data Model

<a name="current_diagram"></a>
### Diagram
![Data Model Diagram](README_files/Odds_Are_UML.png?raw=true "OddsAreModel")

<a name="rationale"></a>
### Rationale

In this application's MVP, it was done with just two models, `User` and `OddsAre`. The issue this had was expanding and adding notifications. As the `OddsAre` was in different states, it would be editing via a `PATCH` request by the `User`. It didn't lead to good tracability with timestamps either, and led to a bloated class.

<a name="old_model"></a>
#### Old Model

![Old Data Model Diagram](README_files/Odds_Are_OLD_UML.png?raw=true "OldOddsAreModel")

Initially it made sense to have the OddsAre broken up into three stages:
- `ChallengeRequest`
- `ChallengeResponse`
- `ChallengeFinalization`

since there were three stages of the  `OddsAre`. Breaking up the model like this allowed each stage to have a notification being the notification's `notifiable` polymorphic object. This meant a notification could have an object it could link to when displayed and clicked on in the view.

The issue with breaking up the model this way was the dilemma of either data duplication throughout the process of the OddsAre, or awkward lengthy queries.
For example: If the only source of truth for the initiator of the odds are was the `ChallengeRequest` actor, then at `ChallengeFinalization`, it'd need to query:
```challenge_response.challene_request.actor```
or, like the model shows, the User models would be copied over to each object as the Odds Are progressed. This was duplicating data and led to confusing names like `ChallengeResponse.actor` was actually the recipient of the `OddsAre`.

<a name="final_solution"></a>
#### Final solution
So the raitonale for the final solution was to have one `OddsAre` class that held the source of truth for the challenge. It held the timestamps of where the `OddsAre` was in terms of progression. It abstracted away the need for `ChallengeResponse`, `ChallengeFinaliation` and `ChallengeRequest` to need a direct association for `User` since `User` is held in the `OddsAre`.

Also, the `OddsAre` object also got a `has_one` relationship with `Task` as there was a need for Users to keep track of the `OddsAre` after the whole dare-process was complete. `Task` does know about `User` since there must be a `winner` and `loser`, and this made sense for `Task` to hold the truth of. `Task` also holds timestamps of when the `winner` or `loser` marked the `Task` as complete, meaning the `loser` followed through with the Dare.

<a name="ci_cd"></a>
## CI-CD

![ CI-CD-Flow ](README_files/CI-CD-Flow.png?raw=true "CI-CD-Flow with pictures")
Currently, OddsAre uses both CircleCI and Heroku for CI/CD.

Upon commit to Master branch, using GitHub's status API, a build is kicked off in CircleCI.

<a name="build_instructions"></a>
#### Build Instructions:

All steps are documented and configured [in the circleci configuration file](.circleci/config.yml)

Basically,
 - Build with Docker, using a ruby image
 - Checkout code
 - Install Docker and Docker-Compose Client
 - Compose Docker environment see [Dockerfile](Dockerfile) and [docker-compose configuration](docker-compose.yml)
 - Unit tests are then run using `rspec`, see [rspec's configuration file](spec/spec_helper.rb)
 - Finally, upon successful completion of tests, `rubocop` runs a static code analysis. See [rubocop's configuration file](.rubocop.yml)

Upon successful build, CircleCI updates GitHub's status API, which sends a webhook to Heroku.

<a name="deploy_instructions"></a>
#### Deploy instructions

Heroku receives webhook that build has passed and creates it's own build and deploy by detecting ruby app.

Upon successful deploy, app may be found live at: https://www.what-are-the-odds.com/

#### Build information
Ruby Version: `2.4.6`
Rails Version: `5.2.0`
