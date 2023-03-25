# RecycleRight
## Inspiration
According to CBC, 25% of our home city of Toronto's recycling is contaminated with other types of waste making it harder to effectively recycle.

## Problem statement
RecycleRight is an IoT application to reduce the number of incorrectly thrown waste by detecting the type of material that is in front of the garbage bin. It denies garbage that does not belong in the container and send analytics data to the system's supporting App. Our solution targets UN sustainable goal 11 - sustainable cities and communities and goal 12 - responsible consumption and production becauase reducing contaminated recycling is essential for create more sustainable cities with responsible consumption practices. The target audience of RecycleRight are city residents as most of the incorrect recycling occur is big cities like Toronto as mentioned above.

## Implementation
Our project has two components, a hardware component with the Raspberry Pi and TensorFlow Lite Model, and a software GUI component with Flutter. 

For the hardware component, we used an empty cardboard box as the prototype for a garbage bin, and attached a Raspberry Pi to the back of it. The Pi itself is connected to a camera mounted at a angle and is able to detect the footage in front of the garbage bin, wires coming out from its GPIO pins go to LEDs to which light up to indicate different signals (Green means correct recycling, red means incorrect recycling/waiting, and blue means communication with Flutter). Moreover, a servo motor can be controlled by the Pi to open/close the lid to allow/prevent the entry of garbage. The machine learning model is trained with datasets collected from [Kaggle](https://www.kaggle.com/datasets/dataclusterlabs/domestic-trash-garbage-dataset) and around the Mcmaster University Campus using [TeachableMachine](https://teachablemachine.withgoogle.com/). The output file is a TensorFlow Lite Model which was then implemented into the Raspberry Pi using tflite runtime library. Combining the model with OpenCV for processing the image, we were able to achieve real time object detection.

The Raspberry Pi was chosen because it is a lightweight solution for something that can be attached to the garbage bin and simultaneously run computationally heavy tasks (eg. running a model against a video). Alternatively, certain microcontrollers can be used, but due to weighing the resources we had and ease of development, we ultimately decided to use a Raspberry Pi. The decision to choose TensorFlow Lite model is that it offers a major size advantage for running on embedded systems and micro-computers like Raspberry Pi, it speeds up performance and offers a lightweight solution to real time object detection.

For the software component, 


## Feedback/Testing/Iteration
- Originally, we tried to use neural network models from the web that were trained to recognize trash in the wild such as [TACO](https://www.kaggle.com/datasets/bouweceunen/trained-models-taco-trash-annotations-in-context). But upon performing tests with different people holding trash in different locations, we soon realized that those data don't fit well to the environment/trash around us, thus we decided to train our own model using [TeachableMachine](https://teachablemachine.withgoogle.com/).

## Success/Completion

## Next Steps
- Include more modes for the garbage bin, such as organic waste, trash etc.
- Replace the Raspberry Pi with a smaller, cheaper microcontroller for better cost and portableness.
- For expansion into a larger audience, we have tailored the use of the supporting app to governments. Therefore, the government would use the app and their resources to help this project expand to a larger audience.
