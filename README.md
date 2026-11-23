
# Hybrid Cluster-Based Energy Efficient Protocol (HC-EEP)

A MATLAB-based simulation of an energy-efficient routing protocol for Wireless Sensor Networks (WSNs). HC-EEP combines K-Means clustering, residual-energy-based Cluster Head (CH) selection, fuzzy logic-based node activity decisions, and multi-hop routing to reduce communication energy consumption and improve network performance.

---

## Table of Contents

- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Objectives](#objectives)
- [Key Features](#key-features)
- [How HC-EEP Works](#how-hc-eep-works)
- [Technology Stack](#technology-stack)
- [System Requirements](#system-requirements)
- [Getting Started](#getting-started)
- [Simulation Outputs](#simulation-outputs)
- [Performance Evaluation](#performance-evaluation)
- [Future Scope](#future-scope)
- [Project Team](#project-team)
- [Academic Details](#academic-details)
- [References](#references)

---

## Overview

Wireless Sensor Networks consist of distributed, battery-powered sensor nodes that collect and transmit information to a base station (sink). Since sensor nodes often operate in locations where battery replacement is difficult, minimizing energy consumption is essential to maintaining network connectivity and extending network lifetime.

Traditional clustering protocols such as LEACH can suffer from uneven energy consumption, random Cluster Head selection, and high communication costs when nodes or Cluster Heads communicate over long distances.

The **Hybrid Cluster-Based Energy Efficient Protocol (HC-EEP)** addresses these challenges through a combination of clustering, intelligent node activity management, and multi-hop communication. The project is implemented and evaluated in MATLAB.

## Problem Statement

Energy-constrained Wireless Sensor Networks face several challenges:

- Sensor nodes have limited battery capacity and may fail prematurely.
- Random Cluster Head selection can cause uneven energy consumption.
- Direct, long-distance communication with the base station can consume significant energy.
- Unnecessary transmissions increase communication overhead.
- Early node failures can reduce network lifetime and overall delivery performance.

HC-EEP aims to improve energy usage, load distribution, and routing efficiency through adaptive clustering and communication decisions.

## Objectives

- Develop a hybrid energy-efficient routing protocol for WSNs.
- Organize sensor nodes using K-Means clustering.
- Select Cluster Heads using residual-energy information.
- Use fuzzy logic to determine whether nodes should remain active or enter sleep mode.
- Reduce communication distance through multi-hop routing between Cluster Heads.
- Evaluate network lifetime, residual energy, throughput, and Packet Delivery Ratio (PDR).
- Compare the proposed protocol with the LEACH protocol.

## Key Features

| Feature | Description |
|---|---|
| K-Means clustering | Groups sensor nodes based on their spatial positions. |
| Energy-based CH selection | Uses residual energy when selecting Cluster Heads to support balanced energy consumption. |
| Fuzzy logic decision system | Evaluates node energy and distance from the sink to guide active/sleep decisions. |
| Active/sleep node management | Reduces unnecessary node activity and transmissions. |
| Multi-hop routing | Allows Cluster Heads to forward data through intermediate Cluster Heads when beneficial. |
| Data aggregation | Aggregates data at Cluster Heads to reduce redundant transmissions. |
| LEACH comparison | Supports comparative evaluation against a traditional clustering protocol. |
| MATLAB visualization | Displays network and performance results through plots. |

## How HC-EEP Works

The simulation follows the general workflow below:

1. **Node deployment** — Sensor nodes are generated with random positions in the network field and assigned initial energy values.
2. **Clustering** — K-Means groups nodes according to their spatial positions.
3. **Cluster Head selection** — Cluster Heads are selected using residual-energy information.
4. **Fuzzy logic decision-making** — Node energy and distance from the sink are evaluated to determine whether a node should remain active or switch to sleep mode.
5. **Cluster formation and data aggregation** — Nodes join a suitable Cluster Head, which aggregates collected data.
6. **Routing** — Cluster Heads transmit data to the sink. Multi-hop forwarding through intermediate Cluster Heads is used when beneficial.
7. **Energy update** — Energy consumption and node status are updated during simulation rounds.
8. **Performance evaluation** — The simulation records network metrics and supports comparison with LEACH.

### Simplified workflow

```text
Start
  |
  v
Initialize network and sensor nodes
  |
  v
Deploy nodes and assign initial energy
  |
  v
Perform K-Means clustering
  |
  v
Select Cluster Heads using residual energy
  |
  v
Fuzzy logic: decide active / sleep state
  |
  v
Cluster communication and data aggregation
  |
  v
Direct or multi-hop Cluster Head routing
  |
  v
Update energy and node status
  |
  v
Record performance metrics
  |
  v
Next simulation round / Stop
```

## Technology Stack

| Technology | Purpose |
|---|---|
| MATLAB | Main development and Wireless Sensor Network simulation environment. |
| Fuzzy Logic Toolbox | Implements the fuzzy inference system for node activity decisions. |
| Statistics and Machine Learning Toolbox | Provides K-Means clustering functionality. |
| MATLAB plotting tools | Visualizes alive nodes, residual energy, throughput, and PDR. |

The project report specifically mentions MATLAB functions such as `kmeans()` and `evalfis()` for clustering and fuzzy logic evaluation.

## System Requirements

The project report specifies the following environment:

| Component | Requirement |
|---|---|
| MATLAB | R2021a or later |
| Toolboxes | Fuzzy Logic Toolbox; Statistics and Machine Learning Toolbox |
| Processor | Intel Core i3 or equivalent |
| RAM | Minimum 8 GB |
| Storage | At least 5 GB free space |
| Operating system | Windows, Linux, or macOS supported by MATLAB |

A physical sensor-node deployment is not required to run the described simulation.

## Getting Started

### 1. Install MATLAB

Install MATLAB R2021a or later from the [official MathWorks website](https://www.mathworks.com/products/matlab.html).

During installation, ensure that these toolboxes are available:

- Fuzzy Logic Toolbox
- Statistics and Machine Learning Toolbox

### 2. Get the project files

Clone this repository:

```bash
git clone <REPOSITORY_URL>
```

Or download the repository as a ZIP file and extract it.

### 3. Open the project in MATLAB

1. Start MATLAB.
2. Open the folder containing the project scripts.
3. Set that folder as the MATLAB Current Folder.
4. Confirm that the required toolboxes are installed.

### 4. Configure simulation parameters

Open the main simulation script and configure the parameters supported by the implementation, such as:

- Number of sensor nodes
- Network area
- Initial energy
- Number of simulation rounds

The exact parameter names and default values depend on the supplied MATLAB scripts.

### 5. Run the simulation

The project report identifies `main.m` as the main execution script. Run it from the MATLAB Command Window:

```matlab
run('main.m')
```

You can also open `main.m` in the MATLAB Editor and select **Run**.

### 6. Review the outputs

After execution, inspect the generated network visualizations and performance plots. Run additional simulations with different supported parameter values to study how network conditions affect performance.

> **Note:** The PDFs describe the execution procedure but do not include the MATLAB source files or a verified repository folder structure. This README therefore documents the reported run command; confirm that `main.m` and the required scripts are present in the repository before publishing.

## Simulation Outputs

The project report presents MATLAB simulation screens for the following stages:

- Home page / simulation interface
- LEACH protocol
- Routing protocol
- Multi-hop routing
- AI scheduling
- LEACH-versus-hybrid comparison

The report also identifies the following performance plots and metrics:

| Metric | What it indicates |
|---|---|
| Alive nodes vs. rounds | Number of sensor nodes that remain operational as the simulation progresses. |
| Residual energy | Remaining energy in the network over simulation rounds. |
| Throughput | Amount of successfully delivered data over time. |
| Packet Delivery Ratio (PDR) | Ratio of successfully delivered packets to packets sent. |
| Network lifetime | Duration for which the network continues to operate according to the simulation's lifetime criterion. |

### Results interpretation

The project report states that HC-EEP improves network lifetime, energy efficiency, throughput, and PDR compared with LEACH. The supplied report pages show simulation interface and comparison figures, but do not provide a complete set of readable numerical measurements in the text. For that reason, this README does not claim specific percentage improvements or benchmark values.

If you publish result charts in this repository, add the exported images under a folder such as `results/` and link them here with their actual filenames.

## Future Scope

Potential extensions identified in the project report include:

- **Advanced machine learning:** Explore reinforcement learning, neural networks, or deep learning for more adaptive routing decisions.
- **Hardware implementation:** Test the protocol on platforms such as Arduino, ESP32, or Raspberry Pi.
- **Mobile sink:** Introduce a mobile sink or dynamic base station to reduce communication distances.
- **Heterogeneous WSNs:** Extend the protocol to networks containing nodes with different energy levels and capabilities.

## Project Team

Developed as a collaborative academic project by:

| Name | Student ID |
|---|---:|
| Biswajit Majhi | 2201104021 |
| Jagadish Prasad Sahu | 2201104026 |
| Pragyan Kumbhakar | 2201104047 |
| Prajwal Purohit | 2201104048 |
| Subhankar Samal | 2201104071 |
| Suryakanta Barik | 2201104075 |

**Project Guide:** Dr. Mukesh Bathre

## Academic Details

- **Degree:** Bachelor of Technology (B.Tech.)
- **Department:** Computer Science and Engineering
- **Institution:** Government College of Engineering, Keonjhar, Odisha, India
- **University affiliation:** Biju Patnaik University of Technology, Rourkela, Odisha
- **Academic year:** 2025–2026
- **Project report date:** May 2026

## References

The following references are listed in the project report:

1. W. R. Heinzelman, A. Chandrakasan, and H. Balakrishnan, “Energy-efficient communication protocol for wireless microsensor networks,” *Proceedings of the 33rd Hawaii International Conference on System Sciences (HICSS)*, 2000, pp. 1–10.
2. W. R. Heinzelman, *Application-specific protocol architectures for wireless networks*, Ph.D. dissertation, Massachusetts Institute of Technology, 2002.
3. O. Younis and S. Fahmy, “HEED: A hybrid, energy-efficient, distributed clustering approach for ad hoc sensor networks,” *IEEE Transactions on Mobile Computing*, vol. 3, no. 4, pp. 366–379, 2004.
4. I. F. Akyildiz, W. Su, Y. Sankarasubramaniam, and E. Cayirci, “A survey on sensor networks,” *IEEE Communications Magazine*, vol. 40, no. 8, pp. 102–114, 2002.
5. S. Lindsey and C. S. Raghavendra, “PEGASIS: Power-efficient gathering in sensor information systems,” *Proceedings of the IEEE Aerospace Conference*, 2002, pp. 1125–1130.
6. A. Manjeshwar and D. P. Agrawal, “TEEN: A routing protocol for enhanced efficiency in wireless sensor networks,” *Proceedings of the International Parallel and Distributed Processing Symposium (IPDPS)*, 2001, pp. 2009–2015.
7. H. Karl and A. Willig, *Protocols and Architectures for Wireless Sensor Networks*. Wiley, 2005.
8. T. S. Rappaport, *Wireless Communications: Principles and Practice*, 2nd ed. Prentice Hall, 2001.
9. L. A. Zadeh, “Fuzzy sets,” *Information and Control*, vol. 8, no. 3, pp. 338–353, 1965.
10. T. J. Ross, *Fuzzy Logic with Engineering Applications*, 3rd ed. Wiley, 2010.
11. A. K. Jain, “Data clustering: 50 years beyond K-means,” *Pattern Recognition Letters*, vol. 31, no. 8, pp. 651–666, 2010.
12. K. Akkaya and M. Younis, “A survey on routing protocols for wireless sensor networks,” *Ad Hoc Networks*, vol. 3, no. 3, pp. 325–349, 2005.
13. J. N. Al-Karaki and A. E. Kamal, “Routing techniques in wireless sensor networks: A survey,” *IEEE Wireless Communications*, vol. 11, no. 6, pp. 6–28, 2004.
14. C. Intanagonwiwat, R. Govindan, and D. Estrin, “Directed diffusion: A scalable and robust communication paradigm for sensor networks,” *Proceedings of ACM MobiCom*, 2000, pp. 56–67.
15. *Energy Efficient Routing in Wireless Sensor Networks: A Survey*, International Journal of Computer Applications, vol. 113, no. 1, pp. 1–6, 2015.
16. S. Tilak, N. B. Abu-Ghazaleh, and W. Heinzelman, “A taxonomy of wireless micro-sensor network models,” *ACM SIGMOBILE Mobile Computing and Communications Review*, vol. 6, no. 2, pp. 28–36, 2002.
17. D. Estrin, R. Govindan, J. Heidemann, and S. Kumar, “Next century challenges: Scalable coordination in sensor networks,” *Proceedings of ACM MobiCom*, 1999, pp. 263–270.
18. MathWorks, [MATLAB Documentation](https://www.mathworks.com/help/).
19. J. Kennedy and R. Eberhart, “Particle swarm optimization,” *Proceedings of the IEEE International Conference on Neural Networks*, 1995, pp. 1942–1948.
20. M. Handy, M. Haase, and D. Timmermann, “Low energy adaptive clustering hierarchy with deterministic cluster-head selection,” *Proceedings of the IEEE International Workshop on Mobile and Wireless Communications Network*, 2002, pp. 368–372.

---

## License

No license information was specified in the supplied project documents. Add a license (for example, MIT) only after the project contributors have agreed to the terms.
