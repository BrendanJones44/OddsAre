Feature: Friend Request
As a developer
I want users to be able to friend request each other
So that they can only perform actions with their friends

Scenario: User friend requests a user they are not friends with
Given Two users exist
And The two users are not friends
When The first user requests the second user
Then The second user has a 
