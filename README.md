# RecycleRight

## How to run project
Materials required
- A computer
- Raspberry Pi
- Raspberry Pi Camera Module
- Servo motor
- LEDs
- 3 100 ohms Resistors
- Breadboard & Jumper wires 

Instruction for running the app
1. Clone the repo using `git clone repo_name`
2. Connect to a IOS/Andriod device or emulator
3. Run `pip install cffi`
4. Download any other dependencies if exceptions occur
5. Run the command `flutter run` at the project base directory

Instruction for running the hardware device
1. Connect the GPIO pins to their respective external devices (LEDs, servo motor), ports are listed in the code
2. Attach the camera module to the Raspberry Pi
3. Install TensorFlow Lite, TFLite runtime, and all other necessary dependencies listed in the code.
4. run `python main.py`


## Project Setup
RecycleRight is an IoT-based solution designed to reduce waste contamination in recycling by accurately detecting the type of material being disposed of and ensuring that it is placed in the correct recycling bin. The application aims to decrease the amount of landfill waste generated due to contaminated recycling (incorrect disposal of waste materials) and save significant costs for cities. By targeting UN Sustainable Development Goals 11 (Sustainable Cities and Communities) and 12 (Responsible Consumption and Production), RecycleRight aims to create more sustainable cities with responsible waste management practices.

The RecycleRight solution targets two United Nations' Sustainable Development Goals: Goal 11 - Sustainable Cities and Communities, and Goal 12 - Responsible Consumption and Production. The RecycleRight solution addresses Goal 11 by improving waste management practices in cities, reducing the amount of contaminated recycling, and ultimately decreasing the landfill waste generated. RecycleRight contributes to Goal 12 by ensuring that waste materials are correctly disposed of and recycled, which in turn reduces the environmental impact of waste disposal.

The inspiration for selecting these specific goals and targets comes from touring different places, from cities like Hamilton and Toronto to the McMaster campus, where a large amount of recycling is contaminated with other types of waste. By addressing this problem, RecycleRight aims to improve recycling efficiency, reduce waste in landfills, and save costs for cities. This aligns with both Goal 11 and Goal 12, making these goals the most suitable for the solution.

## Implementation
The RecycleRight solution has a two-component architecture: a hardware component responsible for real-time object detection and mechanical waste disposal control, and a software component responsible for user interaction and data management. 

For the hardware component, a Raspberry Pi 4 was used to process the images captured by the camera and run the Tensorflow Lite model for object detection. The Raspberry Pi also controls the servo motor to open and close the garbage bin’s lid and manages the LEDs for visual feedback. The python program operates on the OpenCV library, where images are processed by the TensorFlow Lite model to recognize various waste materials and determine whether they are appropriate for the selected recycling mode. Signals between the Raspberry Pi and flutter app are exchanged through Wifi using TCP sockets.

For the software component, the UI for the RecycleRight  solution used Flutter which is coded in the Dart programming language. This interface allows users to interact with the system, change waste disposal modes, and view their waste disposal history. The user data is stored locally in txt files, enabling the app to display the correct information to users.

The Raspberry Pi was chosen for its small size, affordability, and computational capabilities. It is powerful enough to handle the computationally intensive tasks like running a TensorFlow Lite Model for real-time object detection while maintaining a light-weight, low cost profile suitable for attaching to a garbage bin.

Tensorflow Lite was chosen for its advantages in size, speed, and performance when running on embedded systems and micro-computers like the Raspberry Pi. It provides a lightweight solution for real-time object detection, which is crucial for the efficient functioning of the RecycleRight system.

OpenCV was used for image processing in conjunction with the TensorFlow Lite Model. It was chosen for its extensive functionality, compatibility with the Raspberry Pi, and the wide range of computer vision algorithms it provides.

Flutter was selected over other SDKs for the front-end development of the RecycleRight application due to its scalability, cross-platform compatibility, and ability to support rapid development. Using Flutter allowed the team to create a single codebase that works on both Android and IOS platforms, saving time and effort while ensuring a consistent user experience.

TeachableMachine is Google’s web-based tool that uses TensorFlow to simplify the creation of machine learning models. It was used to train the custom object detection model for waste materials. It was chosen for its ease of use, allowing the team to quickly create and tune a model tailored to the specific environment and waste materials in the project context.

## Feedback/Testing/Iteration
The first step we took to test the solution with real users came from simply asking our housemates for ideas on improving. Many of our housemates are not in engineering and came from diverse backgrounds, and it is extremely valuable to pursue different opinions and thoughts in order to push development forward. When I came to my housemates with the initial tests on separating waste from recycling, they told me that the proposed preliminary solution would not be that useful, as Hamilton further separates recycling into paper/cardboard and plastic/metal. This was an invaluable feedback point based on grounded evidence, and it led to the further development of the mobile app and the TensorFlow model such as the decision to use TeachableMachine for fast machine learning model creation.

The second step was to test the solution in a foreign environment. While most of our testing was done at our respective houses, we decided to test it at different locations around school with a few classmates to ensure things were running smoothly. This led us to receive the feedback that our model could still be more accurate, as the change in location meant a change in common recyclables and disposables. Therefore, this led to the decision of including a more diverse range of training dataset to account for the variation in the environment and waste materials.

Finally, the third feedback point came from friends and strangers on social media whom we showcased the projects to, who discussed that for RecycleRight to be a truly global app it would need to also recognize additional waste categories such as compostables. This feedback highlighted the importance of addressing various waste categories to make the solution more comprehensive and globally applicable, which helps guide the future steps of our application.

Based on the first feedback, we were able to separate our recycling mode into paper/cardboard and plastic/metal. This helped us realize that the initial waste classification system was insufficient, prompting the development of the mobile app and improvements to the TensorFlow model to accommodate these additional changes.

Based on the second feedback, we tested the solution in foreign environments and discovered that the model needed to be more accurate in recognizing different types of recyclables and disposables across various locations. This feedback led to refining the model to account for variations in waste materials, resulting in the inclusion of a more diverse training data set that is more adaptable and effective in distinguishing waste materials and background variations.

Based on the third feedback, the users pointed out the importance of recognizing compostables to make RecycleRight a truly global app. This feedback encouraged us to consider additional waste categories, leading to plans for incorporating compostable waste recognition into the solution, ultimately making it more comprehensive and applicable to a wider range of users.

## Challenge
One challenge faced during the development of the code was finding a suitable pre-trained neural network model that could accurately recognize trash in diverse environments. Initially, we attempted to use models available online, such as TACO (Trash Annotations in Context), which were trained to recognize trash in the wild. However, after testing the model with different people holding trash in various locations, it became apparent that the model did not perform well in recognizing the specific types of waste materials and environments relevant to our project.

To address this issue, we decided to train our own machine learning model using TeachableMachine, a web-based tool to streamline the machine learning model creation process. We collected datasets from Kaggle and real life images around the McMaster University campus, ensuring that the data reflected the actual waste materials and environments we wanted the model to recognize. This custom model was then implemented on the Raspberry Pi using the TensorFlow Lite runtime library, which provided a lightweight and efficient solution for real-time object detection.

The decision to create a custom model allowed the team to overcome the limitations of pre-trained models, resulting in improved accuracy and performance in diverse environments. This approach also provided valuable experience in training and fine-tuning machine learning models, which could be leveraged for further improvements and iterations in the future.

## Success and Completion of Solution
The RecycleRight solution aims to reduce the number of incorrectly thrown waste items by detecting the type of material in front of a garbage bin, preventing incorrect disposal and sending analytics data to a supporting app. By addressing the issue of waste contamination in recycling through smart garbage detection and waste disposal control, the solution contributes to more sustainable cities and communities and encourages responsible consumption practices.

The impact of the RecycleRight solution is evidenced by its ability to prevent improper disposal of waste materials, which in turn reduces contamination rates in recycling systems. This reduction helps achieve the project’s goals in a cause-and-effect relationship, as decreased contamination leads to a decrease in landfill waste and cost savings for municipalities. In Toronto, for instance, every percentage point decrease in recycling contamination could save the city between $600,000 and $1,000,000 per year.

To assess the success of the solution, we collected quantifiable data on the number of times the self-trained AI could correctly recognize waste materials. Our model, trained with data from Kaggle and the McMaster University campus, was tested in diverse environments to ensure accuracy in real-world scenarios. Overall, the RecycleRight system is able to achieve ~80% accuracy in recognizing waste materials and correctly classifying them. 

The analytics data generated by the support provided valuable insights into the solution's performance, and we used these insights to refine and optimize the model for improved accuracy.

In summary, the RecycleRight solution directly addresses the problem of waste contamination by preventing incorrect waste disposal and providing valuable analytics data to support informed decision-making. The project's impact is evident in its potential to reduce recycling contamination, leading to environmental benefits and cost savings for cities adopting the solution.


## Scalability / Next Steps
To make the solution globally applicable and accommodate diverse waste management systems, additional modes for organic waste, trash, and other specific waste categories can be added. This will ensure the solution caters to the needs of various cities and countries with different waste disposal requirements.

We aim to replace the Raspberry Pi with a smaller, cost-effective microcontroller to improve portability and affordability, making it easier for municipalities and organizations to adopt the technology.

We want to also continuously improve the accuracy and efficiency of the Tensorflow Lite model by training it on a broader range of waste materials and items commonly found in different regions. This will ensure the solution remains relevant and effective in various geographical contexts. 

Additional features can also be developed on the mobile app, such as a Google Map to show the users all the garbage bins for different types of waste in their area. This would provide greater scalability as we plan on adding more garbage detection systems in the future.

Lastly, we plan to collaborate with stakeholders and secure partnerships by engaging with local governments, waste management companies, and community organizations to raise awareness and encourage adoption. We'll seek funding opportunities and form partnerships with organizations committed to sustainability, helping scale up the solution and reach a larger audience.

The light nature of the TensorFlow Lite model allows it to run efficiently on low-powered devices like the Raspberry Pi or even smaller microcontrollers, enabling the implementation of our solution on a larger number of waste bins without significantly increasing hardware costs.

As we replace the Raspberry Pi with a more cost-effective microcontroller, it will become easier to deploy our solution on a large scale. The microcontroller’s low power consumption and small form factor make it suitable for integration into various types of waste receptacles, allowing for a flexible and scalable solution.

The cross-platform nature of Flutter allows for the development of a single codebase that works on both IOS and Android devices. This simplifies the process of maintaining and updating the app while reaching a larger audience. Moreover, the app can be easily updated with new features and waste categories to accommodate the diverse requirements of different cities and countries.

Lastly, with the current data storage medium being txt files, integrating cloud-based services for data storage, processing, and analysis would be a good idea as it enables us to efficiently manage the data generated by the system as it scales. It allows for seamless communication between the hardware components and the mobile app while providing a centralized platform for monitoring, maintenance, and updates.

