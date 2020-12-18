# Delsys-Based-sEMG-Signal-Processing-and-Muscle-Performance-Evaluation

Surface EMG (sEMG) signal is the electrical activity produced by skeletal muscles, which is used to predict muscle's condition, and muscle contraction and muscle fatigue can be decided by sEMG signal. In this project, I used [Delsys Trigno Wireless System](https://www.delsys.com/), which is a high-performing device to detect sEMG signal, to collect sEMG signal to evaluate muscle performance, like muscle force and muscle fatigue during sports.

## Real Time sEMG Data Collection
Delsys provides sample code to transmit data to Matlab. I mainly solved the problem of slow transmission speed by autonomously deleting channels without data stream instead of opening 16 channels at the same time, and revised the display pattern to facilitate later research.

## Signal Processing
Raw sEMG signal is weak, unstable and random. Based on previous research, I adopted 10-500Hz bandpass ﬁlter and 50Hz notch ﬁlter. Besides, I analyzed the frequency spectrum of raw signal ﬁnding 100Hz noise interference and adopted Recursive Least Squares adaptive ﬁlter to remove 100Hz noise, which showed a better performance than Matlab toolbox designed ﬁlter.

## Feature Extraction
This is a heuristic plan to estimate muscle force and detect muscle fatigue based on the change in Root Mean Square and Mean Power Frequency of sEMG signal data.
