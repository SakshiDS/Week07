# Week07
##                                                                            Week 7 In Class Assignment
===============================================================================================================================================================================
### 1. Grocery Store ER Diagram
![Grocery Store ER Diagram](https://lucid.app/publicSegments/view/408c7a66-548a-4942-98bb-60f7ca02de3f/image.png)


### 2. With your group, create a list of at least 5 and no more than 10 ways data can be “dirty”. Perhaps think back to some data sets we have used that have had weird stuff in them. Discuss how you would resolve each of these and briefly explain.

      1. meaningful column or table names
          Proper headers help in easy accessibility to data. The column or table or any entity needs to be proper labeled while following standard conventions.
          the jeopardy data had proper column names but had a space in front of them, resulting in error when called on them. Such errors need to be eliminated. 
          
      2. Missing/duplicate values
          Many times data has duplicate values or missing values. As per the need these can be handled. 
          Duplicate values can be sorted and removed to keep only unique ones.
          For missing values, they can be subsituted by neared value or could just be filled as Na for proper handling
          
      3. Whitespaces / weird chracter in data
          The data entries at times have spelling errors oe weird character and spaces. These need to be filtered and the data needs to be sanitixed before any processing
          
      4. data formatting
          The data format mismatch. In jeopary data the date column had values in string. This made it difficult to process date. hence in such case the date column data type        needs to be chnage from string to datetime format. 
          
      5. obsolete data
          The data provided might be out dated. In such case we need to update the data with current one through joins and filter.
      
      6. data inconsistency
          When the column does not have the data expected. Like when th birthdate column has the name string. Such inconsistencies need to be identified and fixed
          At times one column has multiple information seperated by a delimiter like a comma or semicolon. Such data can be parsed with the help of the delimiter identified.
          
### 3. Look at the requirements for the exploratory data analysis project. List at least 2 APIs that have data interesting to you. Please pick at least one API that’s not listed in the project instructions.

Choice of APIs

      1. FBI Crime Data API - https://crime-data-explorer.fr.cloud.gov/api
      2. Global Wine Score API https://www.globalwinescore.com/api/
      
##                                                                            Week 7 HomeWork
========================================================================================================================================================================
### explain what autoincrementing is. Also explain the difference between creating a join and a subquery. This section should be less than 300 words

Autoincrementing is a great tool while creating or altering a table to have a unique id. 
With the help of a counter a unique digit will be added to the table for each new entry made. 
This can be specially useful when the data columns in the table might have duplicate values.
Using autoincrement can help us create a primary key for the table.

Join are used to combine rows of data from two or more tables on common column to process data.
While subquery is a standalone query initself which return a result which can be a single value or rowd of data. This is nested within the main query for processing data.
Join always returns rows of data.
In essence both combine data for processing. Depending on the what we want both of them can be useful tool for different purposes.
