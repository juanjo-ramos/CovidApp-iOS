# CovidApp-iOS
Proof of concept showing how mobile technologies in general and bluetooth in particular could help with the COVID-19 situation.

This is a very simple (iOS only for now) POC that shows how we could leverage bluetooth technology in every mobile phone to help develop better isolation policies.

## Idea
Complete isolation cannot last until a vaccine is ready. Removing existing isolation measures blindly would create a new wave of COVID-19 infections. **Controlled isolation** could be a solution.

When someone tests positives for the virus, it is critical to put them and *those that have been in contact with them* on isolation. Locating those that have in close contact with someone is not always easy. Co-workers, flatmates and closed family is easy to identify. But what about that person that sat next to you on a tube ride for 30m?

Using the Bluetooth on your phone, we could determine what people have been in contact with you and for how long. On top of that, **this can be done in an anonymised** way.
* Medical authorities do not to know where you were. Just that you were in contact with another person.
* The application does not need to share or even store your personal information. Just a random userId that identify yourself as a user.

## How does the POC work
Every time the application "sees" another device running the app within its bluetooth range, it stores that userId and timestamp.

A demo running the app can be found [here](https://www.youtube.com/watch?v=faFobUoJQak).

## Future work
* Proper registration and login system.
* Calculating for how long 2 people have been in contact, not just the timestamp.
* Persisting the information.
* Push notification integration. That would be to simulate the medical authorities' role where upon someone testing positive for the virus, they could send a notification to all phones so that anyone in contact with that user would asked to quarantine themselves.
