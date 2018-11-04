# Chicago-Crime-Demo

This repository contains code developed for network estimation from partially observed events.  The code is explained via two demos: network_estimation_demo.m and stochastic_filtering.m.

We’re interested in network estimation in the following context: suppose we observe crimes which are each associated with a location (in this demo, we consider crimes in the city of Chicago broken down into 77 community areas).  Using the past observations, can we predict how a crime in one community area influences the likelihood of future crimes in other areas?

Full technical details on the model formulation and algorithm used can be found (here)[https://github.com/bzmark/Chicago-Crime-Demo/blob/master/Images/Details.pdf].  In short, we can reduce the problem to estimating an influence network which can be represented as a matrix of dimension 77 by 77.  The (i,j) entry of the matrix is a number which indicated how much a crime in community area j is likely to increase (or decrease if negative) the likelihood of a future crime in area i.  

This type of problem has been studied in the past under an assumption that all crimes are observed.  Our algorithm accounts for the case where one records only a subset of crimes, such as reported crimes.  

## Data

The full_data.mat file includes a matrix 'homicides_X' containing weekly homicide data in the city of Chicago for 918 weeks spanning from January 2001 to August 2018.  Specifically, 'homicides_X' is of dimension 77 by 918 and the (i,j) entry is a binary value indicating whether a homicide was recorded in community area i during week j.  The file also contains a matrix 'homicides_Z' of dimension 77 by 918 with 25% of the homicides removed from 'homicides_X' at random.

The matrix shootings_X contains records of aggravated batteries with handguns broken down by community area.  This is meant to reflect shootings, however, cross referencing these records with a [database from the Chicago Tribune](https://www.chicagotribune.com/news/data/ct-shooting-victims-map-charts-htmlstory.html) suggests that it is only around 90% accurate.  The shooting data spans March 2002 to August 2018.  Note that due to the higher frequency of shootings, 'shootings_X' is discretized into one day periods rather than one week periods, and exact counts are recorded rather than binary indicators.  The shooting data is included in case it is of interest to others, but it is not used in the demos.


