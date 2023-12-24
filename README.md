# SyncWaveNexus 🧠

## Overview 🌐

In today's tech landscape, neural networks are making waves in various fields by mimicking the brain's functions. Spike Neural Networks (SNN) are particularly interesting for their close resemblance to the brain's workings, using discrete spike events.

This project dives into Functional Connectivity (FC) in neuroscience, examining connections between different brain regions. Unlike traditional connections, these don't have a physical link. Our goal is to explore how combining SNN with FC data can help classify different brain states, offering new insights into brain-computer interfaces and disease detection.

## Project Goals 🎯

1. **Explore SNN with FC:** Investigate how SNN, paired with Functional Connectivity data, can classify distinct brain states.

2. **Contribute to Applications:** Develop models that could enhance brain-computer interface control and improve brain disease detection.

## Approach 🛠📌

1. **Review Existing Research:** Look into studies on SNN, FC, and their applications in brain state classification.

2. **Data Collection:** Gather relevant brain signal data, focusing on Functional Connectivity, for model training and testing.

3. **Tools and Libraries:**
   - **Matlab:** Used in the initial phase for processing and obtaining brain signals. Utilized the FastFC library for efficient computation of connectivity indices and complex network measures.
   - **Pytorch/SNNTorch:** Pytorch, an open-source deep learning tool, facilitated the construction and training of SNN models. SNNTorch, a Python package for gradient-based learning with Spiking Neural Networks, integrated seamlessly with PyTorch.

4. **Model Creation:** Design and implement SNN models integrated with Functional Connectivity data.

5. **Evaluation:** Thoroughly test and assess the models to understand their effectiveness in classifying different brain states.

6. **Applications Exploration:** Investigate potential uses, such as improving control models for brain-computer interfaces and aiding in brain disease diagnosis.

## Content 📦

### Synch Directory

#### Description
The `Synch` folder contains a series of MATLAB scripts crucial for data handling and manipulation. This directory is key to the initial stages of the data processing pipeline.

#### Key Components
- `Dataset.m`: The core script containing essential functions for data manipulation.
- `EEGDataset.m`: Dedicated to storing and managing EEG data.
- `FastPLVGraphDataset.m`: Manages data in a graph structure, optimized for specific analyses.

#### 🛠 Installation and Execution
1. **Adding External Libraries**:
   - Add `Biosig` ([Biosig for MATLAB](https://es.mathworks.com/matlabcentral/fileexchange/79427-biosig-a-toolbox-for-biomedical-signal-processing)) and `FastFC` ([FastFC GitHub](https://github.com/juangpc/FastFC)) to the `toolboxes` folder in the project.
2. **Running the Setup**:
   - Execute `install.m` to integrate these libraries into MATLAB.
3. **Data Generation**:
   - Run the main script (notably `mainFastPLV`) to commence data generation.

### NN Directory

#### Description
The `NN` folder is composed of several Jupyter Notebooks, each tailored for specific neural network training and data analysis tasks. These notebooks are developed in the Jupyter Notebook runtime environment, ensuring a user-friendly interface for in-depth data analysis.

#### Key Components
- `Linear.ipynb`: For training a linear neural network.
- `CNN.ipynb`: Dedicated to Convolutional Neural Network training.
- `SCNN.ipynb`: Focuses on Spiking Convolutional Neural Network.
- `Analysis.ipynb`: Conducts final experiments, including assessments of accuracy, training time, and emissions.

#### Usage
These Jupyter Notebooks are designed to directly load and utilize data processed by the MATLAB scripts from the `Synch` directory. Users can execute these notebooks sequentially to perform a comprehensive analysis and training of neural networks.

---

## Additional Information

For any queries or further assistance regarding the installation, configuration, or usage of the software, please refer to the GitHub repository's `Issues` section or directly contact the repository maintainers.
