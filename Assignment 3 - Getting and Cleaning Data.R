#loading the tidyverse package
library(tidyverse)

#1. reading and storing the dataset (in .csv format) into 'stormsdetail-1991': 
stormsdetail_1991 <-read_csv("~/Imp School Docs/Classes/Semester 2/ANA 515 Data Storage, Retrieval and Preparation/R /StormEvents_details-ftp_v1.0_d1991_c20220425.csv")

#Creating Dataframe 
Stormsdetail_1991_df <- data.frame(stormsdetail_1991)

#2. Selecting the Columns that are required, dropping the rest from the Dataframe:
StormEvents1991_df = subset(Stormsdetail_1991_df, select = c(BEGIN_DATE_TIME, END_DATE_TIME, EPISODE_ID, EVENT_ID, STATE, STATE_FIPS, CZ_NAME, CZ_FIPS, CZ_TYPE, EVENT_TYPE, SOURCE, BEGIN_LAT, BEGIN_LON, END_LAT, END_LON))

#3. Arranging the Data by the State Name: 
StormEvents1991_df <- arrange(StormEvents1991_df, (STATE))
StormEvents1991_df

#4. Changing state and county names to title case: 
StormEvents1991_df$STATE <- str_to_title(StormEvents1991_df$STATE)
StormEvents1991_df$CZ_NAME <- str_to_title(StormEvents1991_df$CZ_NAME)

#5.Limiting the events listed by county FIPS (CZ_TYPE of “C”): 
StormEvents1991_df <- StormEvents1991_df[StormEvents1991_df$CZ_TYPE == 'C',]
#And dropping the column CZ_TYPE from the DataFrame: 
StormEvents1991_df = subset(StormEvents1991_df, select = -c(CZ_TYPE))

#pad STATE_FIPS and CZ_FIPS with 0
StormEvents1991_df$STATE_FIPS <- str_pad(StormEvents1991_df$STATE_FIPS, width = 3, side = "left", pad = "0")

#7. rename all the columnto lower: 
StormEvents1991_df <- rename_all(StormEvents1991_df, tolower)
StormEvents1991_df

#8. pulling the data that comes with base R on U.S. states:
data("state")
US_State_Info<-data.frame(state=state.name, region=state.region, area=state.area)

#9. Createing a dataframe with the number of events per state (Frequency): 
table(StormEvents1991_df$state)
StormEvent_StateFreq <- data.frame(table(StormEvents1991_df$state))
StormEvent_StateFreq <- rename(StormEvent_StateFreq, c("state" = "Var1"))

#10. Merge two dataframe: 
Merged_StateData <- merge(StormEvent_StateFreq, US_State_Info, by="state")
Merged_StateData
#it can be noticed in the Merged_StateData that two Data rows for state = District of Columbia and Hawaii
#were dropped as the data was not available for the state of Hawaii and the state = District of Columbia was 
#not available in the R base state data. 

#11. Plot
library(ggplot2)
storm_plot <-
  ggplot(Merged_StateData, aes(x = area, y = Freq)) +
geom_point(aes (color = region)) +
  labs(x = "Land area (square miles)",
        y= "# of storm events in 1991")
storm_plot