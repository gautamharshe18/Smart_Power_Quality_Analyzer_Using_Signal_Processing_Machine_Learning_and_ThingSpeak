# Smart_Power_Quality_Analyzer_Using_Signal_Processing_Machine_Learning_and_ThingSpeak
A cloud-enabled Smart Power Quality Analyzer developed in MATLAB that combines Digital Signal Processing (DSP), feature extraction, FFT and THD analysis, and comparative evaluation of Random Forest, SVM, and KNN classifiers for automatic power quality disturbance classification. ThingSpeak is integrated for cloud-based data monitoring.
# Smart Power Quality Analyzer Using DSP, Machine Learning, and Cloud Integration

Power quality plays a crucial role in the reliability and efficiency of modern electrical systems. Disturbances such as voltage sag, voltage swell, interruptions, harmonic distortion, transients, and frequency variations can negatively affect electrical equipment and industrial processes. This project presents a Smart Power Quality Analyzer developed using Digital Signal Processing (DSP), Machine Learning, and Cloud Integration techniques to analyze, classify, and monitor power quality disturbances intelligently.

The project is implemented in MATLAB and focuses on the generation, analysis, and classification of different power quality events. Various disturbance signals are simulated, including normal voltage conditions, voltage sag, voltage swell, interruption, harmonic distortion, transient disturbances, and frequency variations. These signals are processed using DSP techniques such as time-domain analysis, Fast Fourier Transform (FFT), and Total Harmonic Distortion (THD) calculation to extract important characteristics of the electrical waveform.

Feature extraction is performed by obtaining significant parameters from the analyzed signals, including RMS voltage, peak voltage, average voltage, crest factor, frequency components, and harmonic information. These extracted features are then used as inputs for machine learning models to automatically identify and classify different power quality disturbances.

To evaluate the effectiveness of machine learning approaches, three classification algorithms are implemented and compared: K-Nearest Neighbors (KNN), Support Vector Machine (SVM), and Random Forest. The models are evaluated based on performance metrics such as accuracy, precision, recall, F1-score, and execution time. The comparison demonstrates that the Random Forest classifier provides the best performance with an accuracy of 99.29%, outperforming KNN and SVM for power quality disturbance classification.

The project also incorporates ThingSpeak cloud integration for data visualization and monitoring, providing a pathway toward IoT-based power quality analysis systems. The cloud platform enables remote visualization of analyzed parameters and supports future expansion toward real-time monitoring using embedded hardware platforms.

This project combines the concepts of electrical power systems, digital signal processing, machine learning, and cloud computing to develop an intelligent power quality monitoring framework. The proposed system can serve as a foundation for future real-time implementations using ESP32-based data acquisition, voltage and current sensors, and IoT-enabled smart grid monitoring applications.

## Technologies Used

MATLAB, Digital Signal Processing (DSP), Fast Fourier Transform (FFT), Total Harmonic Distortion (THD) Analysis, Feature Extraction, Machine Learning, K-Nearest Neighbors (KNN), Support Vector Machine (SVM), Random Forest, and ThingSpeak Cloud Platform.

## Machine Learning Models Compared

- K-Nearest Neighbors (KNN) – Accuracy: 96.79%
- Support Vector Machine (SVM) – Accuracy: 91.79%
- Random Forest – Accuracy: 99.29%

The Random Forest model achieved the highest classification accuracy and was selected as the most suitable model for automatic power quality disturbance detection.
