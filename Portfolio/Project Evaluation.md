# Project Evaluation   

**contents**

- [Reflective discussion](#reflective-discussion)
- [Future work](#Future-work)
- [COVID-19 and teamwork](#COVID-19-and-teamwork)





## Reflective discussion  
Thankfully, we were able to complete the project as expected. Not only did our ideas prove to be realistic, the entire system almost reached our original goal. Even though our user feedback is very limited, and COVID-19 and lockdown make it more difficult for us to test in the university library, we still overcome these difficulties and created the final system. In the process, we found that our initial structure was quite reasonable, so there was no need to change it frequently during the project. In addition, most of the experiencers indicated that they are willing to use it after the product is fully implemented, which shows that our products have the potential to be integrated into students' daily lives.

The main function of the system: our system mainly solves the problem of low student borrowing efficiency. The system provides a reservation function for students to borrow books. For example, if the book is currently available, students can borrow the book to the corresponding location in the library; if the book is currently loaned, when the book is returned to the library, the student can receive the book on the web Reminder of returning, borrowing books in the library at the first time, greatly reducing the time period for students to borrow books.

However, even if we think that our products can be put into use, there are still many restrictions. First of all, at present, we have not obtained access to the database of the university library, which forces us to use only the 10 books we filled in to test the system that retrieval has not done any optimization. In practical applications, the book information will definitely far exceed the sample data that we manually input. Therefore, in real scenes, the system's response speed may be greatly reduced. Secondly, we are not familiar with the work of administrators and librarians; we also need to further introduce the information and functions in the desktop system.For example, if a new book is purchased, the desktop end of this design cannot add the new book information to the system. Also， the information that the administrators need to possess may be much more complex than we expected，which  means our set of functions  objectives is likely not enough to satisfy the demand of the people work in library. Therefore situation like this is inevitable in practical applications. Finally, in our initial scheme, M5stack can be applied to a camera, which can scan the barcode attached to each book. After the librarian scans the book, the system will automatically send the information that the book can be borrowed to the student who has a reservation, which improves the efficiency of the student's book borrowing and will not increase the workload of the librarian. However, due to the COVID-19, it is diffifult for us to purchase a camara, and it also restricts us from evaluating which type of camara is suitable for our product.Moreover even if we can get a camara，we cannot test its performance in living environment  for the reason that we cannot go to library.Consequently we were unable to achieve this goal, and information can only be sent to students through manual simulation input.

Overall, the projects we have completed proved to be feasible, and indeed have the ability to help students improve the efficiency of finding books. However, when it comes to reality, many problems still need to be solved.
## Future work   
As mentioned above, we have a long way to go to improve our products. This is a list of our future work

-Collect more feedback after the lock is over.

UI, especially Web applications, need more user opinions to improve. More specifically, our query system is actually the most basic, and we used only 10 books to simulate this situation. In the future, you can also search for the version, year, and other related books and display their information on the web application.

Due to the influence of COVID-19, the user feedback collected in this work is very limited. Extensive user feedback is crucial to the optimization of the system, so we believe that it is necessary to conduct more extensive user research and testing to find out whether the system meets the real user scenario and whether it can really bring convenience to students to borrow books and improve their borrowing The efficiency of the book.

-Buy and fix the camera to our M5stack

In our design, M5Stack is only used to change the status of the current book. If we can install another camera, we can record the position of the book through pictures, which can be more clear and accurate. In addition, it can be used to scan the barcode of a book or take some images of damaged books.

In order to better fit the real use scenario, we think it is necessary to install a camera to scan the barcode of the book, replacing the current manual input mode, which can greatly improve the work efficiency of the librarian.

-Through market research to understand whether the product can be accepted by the public
-Interview librarians and administrators to add more features to M5stack and desktop systems

In the current design, although there is no interview with the corresponding librarian and administrator, we have been aware of the system's lack of application scenarios for the storage of new books. We think we can consider adding a page to register the new book information in the library, or directly scan the QR code through the camera of the M5 stack to register the new book information. However, due to the limited number of fields transmitted by the M5 stack, the first method may be more effective.

-Try to access library database or build database

Currently, json files are used to store data, but json is a lightweight data exchange format. From the perspective of communication, information can be transmitted very easily. From the perspective of storing data, especially for this kind of data that needs to be updated frequently, it is obviously inappropriate to use JSON. This is not suitable for some more complex queries and updates. We use json files to store book information is just an example of the system's lightweight application, not very suitable for real application scenarios. Therefore, for actual deployment, it is better to increase the database to maintain a large amount of book information.

We want to implement our system on more complex data. For example, we can add more libraries to our system. If the user searches for a book that is not provided, the interface can also display information about other libraries that own the book. In addition, the user database can be shared with the connected library. It is convenient for users not to register repeatedly.

-If we can access the library database, please extend MQTT communication

After adding the database, the desktop needs to be changed significantly. When reading and modifying data, in addition to the operation of the database rather than a simple json document, it also needs to introduce some efficient database storage and retrieval parties. This can increase the corresponding time of the system. Furthermore, the security of the database also needs to be considered.

## COVID-19 and teamwork
Despite the fact that COVID-19 caused an incursion to our group work, we collaborate very well in the distance. We have a good division of work to give the best play to everyone's superiorities. Two of our group members going back home made the 7-hours jet lag a problem when we wanted to communicate in time. To solve this problem, we decided to have a face-to-face video meeting by Wechat weekly at 2 pm Saturday. In addition to that, we set a schedule for every stage to organize our time efficiently and guarantee the project was proceeding as we planned. In each stage, everyone uploaded the files to GitHub on time, and we gave feedback and suggestions to each other after we check the updated files.

During this period, different opinions sometimes appeared; however, this also gave us opportunities to find our defects and make up for them. Though COVID-19 narrowed the area where we could find potential participants for user testing, we asked our flatmates for help, test the three systems separately and the gathered together to discuss how to improve when having a meeting.

It is a challenge that COVID-19 restrict our time and space, but we try our best to act as usual and finally succeed in completing this project.If there is no a suden raid like that, we would have meetings frequntly face to face rather than only communicate online.Besides, we would not segregate the group work so singly that it wasted us loads of time to integrate them together.Instead, we would do the whole work systemly, then we would be more unified in coding and UI style. Additionally, we should have more chance to fit a camera to our M5stack, making our product more finalized.


## Summary

In the past three months, we have proved that our project (library management system) is a viable concept, although it is still a prototype that needs optimization. Based on the feedback from the participants: if it is published in the future, they are willing to use it. They believe that our products can help them search for the books they need. Although our products are completely successful, there are many obstacles that must be overcome if they are to be promoted to the public. In order to overcome these challenges, we need to do more future work to achieve our future development. We recommend that the equipment should be updated, and the communication and storage of dates should be strengthened. In addition, we will conduct more user tests and market evaluations to improve our products. Although COVID-19 restricts our project to make it more complete in the production environment, which is untimely, we still managed to do this and learned a lot from the process of designing, coding and perfecting the product.

