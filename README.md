# SyncWaveNexus 🧠

## Overview 🌐

In today's tech landscape, neural networks are making waves in various fields by mimicking the brain's functions. Spike Neural Networks (SNN) are particularly interesting for their close resemblance to the brain's workings, using discrete spike events.

This project dives into Functional Connectivity (FC) in neuroscience, examining connections between different brain regions. Unlike traditional connections, these don't have a physical link. Our goal is to explore how combining SNN with FC data can help classify different brain states, offering new insights into brain-computer interfaces and disease detection.

## Project Goals 🎯

1. **Explore SNN with FC:** Investigate how SNN, paired with Functional Connectivity data, can classify distinct brain states.

2. **Contribute to Applications:** Develop models that could enhance brain-computer interface control and improve brain disease detection.

## Approach 🛠️

1. **Review Existing Research:** Look into studies on SNN, FC, and their applications in brain state classification.

2. **Data Collection:** Gather relevant brain signal data, focusing on Functional Connectivity, for model training and testing.

3. **Tools and Libraries:**
   - **Matlab:** Used in the initial phase for processing and obtaining brain signals. Utilized the FastFC library for efficient computation of connectivity indices and complex network measures.
   - **Pytorch/SNNTorch:** Pytorch, an open-source deep learning tool, facilitated the construction and training of SNN models. SNNTorch, a Python package for gradient-based learning with Spiking Neural Networks, integrated seamlessly with PyTorch.

4. **Model Creation:** Design and implement SNN models integrated with Functional Connectivity data.

5. **Evaluation:** Thoroughly test and assess the models to understand their effectiveness in classifying different brain states.

6. **Applications Exploration:** Investigate potential uses, such as improving control models for brain-computer interfaces and aiding in brain disease diagnosis.