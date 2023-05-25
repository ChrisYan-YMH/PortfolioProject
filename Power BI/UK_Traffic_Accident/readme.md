# Project Description
The dataset used in the project is the UK traffic accidents in 2021-2022. The stakeholder for this project is assumed to be UK transportation department head, transport operator and the general public.
<br/>
# Project Aim
This project aims to provide insights from the road accident. In order to achieve this objective, the following KPIs and statistics will be shown in the dashboard.
- Primary KPI: Total casualties and total accident for current year (2022) and percentage change compared to last year (2021)
- Primary KPI: Total casualties by  Accident Severity for the current year and last year
- Secondary KPI: Total casualties with respect to the vehicle type for current year
- Monthly trend showing comparison of casualties for current year and previous year
- Casualties by road type current year
- Current Year Causalties by Type of Area / Location / Light condidiotn 
- Total casualties and total accidents by location
<br/>

# Techiques used 
**Data Cleaning (Power Query)**
- Replace function
- Trim 
- lowercase
- Created custom column 

**Data Modelling**
- Connect two tables to form relational database

**Data Proecessing**
- Used DAX Calendar function to create calendar starting from 1st of Jan 2021 to 31st of Dec 2022
- DAX Time intelligence function (eg. month(),etc)
- Utiliized DAX TOTALYTD() and DAX calculate() function to create custom measure for performing calculation of total casualties and percent change 
- Use of Groups function for re-grouping the attributes (eg. Vehicle types, light condiiton, etc)

**Visualization Tool**
- Card
- Multi-row card
- Bar chart
- Line chart 
- Donut chart
- Slicer
- Edit the interaction

**Other**
- Change display unit in the chart
- Import image
