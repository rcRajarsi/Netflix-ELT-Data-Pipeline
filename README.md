# **Netflix ELT Data Pipeline Project**



###### *This project demonstrates an end-to-end ELT (Extract, Load, Transform) data pipeline using the Netflix dataset.*



## Overview

We analyze Netflix content data to extract insights on top actors, release trends, and global content distribution.



## Tools \& Technologies

\- **Jupyter Notebook** – *For extracting the dataset and loading it into Microsoft SQL Server.*

\- **Microsoft SQL Server** – *For cleaning and transforming the data.*

\- **Power BI** – *For visualization and creating interactive dashboards.*



## Project Steps

1\. Downloaded the Netflix CSV Dataset

2\. Extracted the dataset using Jupyter Notebook and loaded it into Microsoft SQL Server

3\. Cleaned and transformed the data in SQL Server

4\. Visualized the clean data in Power BI to generate meaningful insights



## Visuals and Pipeline Diagram

Below is the ELT Pipeline Diagram:
!\[Netflix ELT Pipeline](Pipeline\_Diagram/ELT\_Data\_Pipeline\_Diagram.jpg)



And here are the Power BI visuals:

!\[Power BI Dashboard](Visualization\_PowerBI/Content\_Overview\_Page.jpg)

!\[Power BI Dashboard](Visualization\_PowerBI/Creators\_Regions\_Page.jpg)



## Folder Structure

Netflix-ELT-Data-Pipeline/

├── Dataset/ *Contains the Netflix CSV dataset used for the project*

├── Python\_Notebook/ *Jupyter notebook used to extract, read and load the dataset into SQL Server*

├── SQL\_Scripts/ *SQL scripts used for data transformation and cleaning*

├── Visualization\_PowerBI/ *Power BI .pbix file with final visualizations and insights*

├── Pipeline\_Diagram/ *Visual diagram representing the complete ELT data pipeline*

├── README.md *Project documentation and overview*

