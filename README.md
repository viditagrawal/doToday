# doToday 
## [Watch the video](https://youtu.be/ERDeLzjI-PQ)
An application to help users manage their time efficiently while productively collaborating with peers. 

### Inspiration
Even before this year, one of the most crucial skills we began and still continue to work on is our time management. Although we started to get the hang of it as we progressed through high school, moving school online brought back and further exacerbated any procrastination tendencies that had been slowly fleeting. One extension of the Pomodoro technique we had found useful in the past was something called Timeboxing. This is when you allocate a fixed time period for a set planned activity. Additionally, the COVID-19 pandemic has made it harder than ever to be able to meet new people and engage in group activities which led to the creation of our collaboration feature.

### What it does
Our application provides the user with an easy access way to quickly add tasks and receive a plan in which those tasks can be completed. This helps the user stay on track and complete as many things as they can rather than waste large amounts of time pondering what they should work on next only to get distracted by anything else. The point of our application isn't to have the user follow it to a tea 100% of the time because we understand life gets in the way. We save all of the user's data and simply allow them to try their best and make the most of their day and continuing the following day if they are unable to complete all their tasks.  When a user clicks on a certain task, we take them to a task-manager page where they will see information about their task. This page enables users to connect with other people who may have similar tasks. Using Apple's built-in NLP (Natural Language Processing) library we filter similar tasks, allowing users to meet new people and engage in more productive learning as people tend to learn better in groups. This feature is not only limited to academics, as you can find a gym buddy or someone to go hiking with, and having a whole community a few button-taps away allows users to meet new people, ultimately improving one's mental health.

### How we built it
We built this iOS application using Swift 5 and the Xcode IDE. We used built-in frameworks such as UIKit for the animations and design; NLP for the event filtering; as well as external libraries like Firebase to store the user's data, enable easy access to their plan, and allow them to meet new people through our collaboration feature.

### Challenges we ran into
One of the main challenges we ran into was the implementation of the UI. Our app priorities convenience so we spent much time debating on how to best present information to the user in a way that was aesthetically pleasing but also very understandable. In addition, we had to navigate Firebase and store users' data in a fast yet secure manner without overcrowding the database. While we didn't have enough time to completely finish it, we struggled with expanding our iOS application to other operating systems such as macOS. Lastly, we ran into a challenge when discussing how best to sort the users' events since we knew that different people work in different ways.

## Accomplishments that we're proud of
One of the accomplishments we are most proud of is the algorithm that we developed to order a user's events. Using array manipulation, we allow the user to get a healthy mix of difficult and easy tasks while also understanding people's energy diminishes as the day goes on. Another accomplishment we are proud of is our database integration which we do believe accomplishes our goal of safely securing their data while allowing for optimal performance. Lastly, we are proud of our application being able to detect similarity levels between two given events using NLP which enables the users to contact each other to collaborate.

### What we learned
We definitely learned a lot about user design and UIKit, struggling but eventually overcoming problems such as using the CollectionView to aesthetically display the events. We learned a lot about debugging code and how libraries (like Firebase) can often make it difficult due to complex methods but Xcode features such as stepping into functions really helps aid that. We gained a better understanding of how important algorithmic design is for an application as we had to devise a program to order the events. Lastly, we learned a lot more about Machine Learning and NLP Text Processing in particular.

### What's next for doToday
First and foremost, we will implement a framework to be able to port the app to multiple different operating systems after we gain a better understanding of Universal Swift. Then we shall expand and allow tutors to sign up and mentor individuals and provide in-app blockchain or Stripe technology to easily handle payments. Finally, we intend to increase customizability by allowing users to create custom categories giving them more freedom as to how they would like to schedule their day.

### How viable is doToday in the market
We believe that doToday would thrive in today's environment as many people are still in quarantine and often feel demotivated if they are unable to complete everything they aimed to achieve during the day. Our application has motivational quotes to remind them of their goals and aims to show users that by properly structuring their day, they are able to achieve significantly more than by tackling goals in a seemingly random pattern. Finally, with the collaboration feature, we believe that people will be able to foster more meaningful relationships as users will be able to learn from each other, and depend on each other. 


