# Nashville Housing Data Cleanup
 A comprehensive cleanup of a very dirty dataset, purely in SQL.

# Overview
The data constitutes homes and homeowners in Nashville, TN, and surrounding cities.

Definitely not the most interesting dataset but it serves the purpose to show my SQL skills, hopefully.

# Tools & Resources Used
 - Dataset kindly provided by [Alex the Analyst](https://www.youtube.com/@AlexTheAnalyst).
 - Microsoft Excel for eyeballing the data, and exporting it as a .csv file.
 - Notepad++ and CSV Lint to convert the .csv file into a .sql script for quick import into MySQL Workbench, as well as setting the primary key of the main table. Even though I adore the workbench, its import wizard is unacceptably slow.
 - MySQL Workbench for cleaning the dataset, as well as exporting it into a nice and clean DB ready to be queried for analysis.

# Preliminary look at the dataset and CSV export
- We have a little look at the data using Excel to see what we're working with and what kind of data we have.
- Export into CSV through the built-in function.

# Conversion of CSV file into SQL script and import
 - Used Notepad++ and CSV Lint to verify the data types, and convert the file into a .sql script for quick import.
 - Set the Unique ID of the property as the primary key of the main table. There was no need to assign another since the unique ID was already there.

 # The actual cleaning
 Using MySQL Workbench, I've done the following:
 - Standardized the date format using the str-to-date() function.
 - Populated empty address records, we could've simply filled the rows with "no address" but I don't like cutting corners:
    - Looking at the Parcel_ID, we notice that each parcel_id has an equivalent address, but appears multiple times with its own unique ID. So, to find the missing addresses, it's a matter of finding the addresses that are equivalent to their (missing addresses) parcel_IDs
      - This can be done using a **self-join**. We join the table to itself through the parcel_ID, and we make sure the Unique_IDs are not equal. This enables us to have all the parcel_IDs and their equivalent addresses, bunched up conveniently together, including the missing ones.
      - So, all the missing addresses will be facing the their parcel_ID's equivalent address, which is what should populate them.
      
      - As for the population itself, we can simply use an **IFNULL()** function that fills the missing address with its parcel_ID's address.

- Broke the Address columns (owner and property) into three: Address, City, State:
  - **Address:** This is as easy as simply using a **SUBSTRING_INDEX()** function, we specify the column, delimiter, and the number of times we want the delimiter to be skipped.
  - **City**: We nest the previous function in another function of the same type, using it as the first parameter of the new function replacing its final parameter with a 2 (so it'll include the city name). And use a -1 as the last parameter, in the outer function. This makes the function count from right to left, extracting only the city name from the nested function.

  - **State**: The state is only mentioned in the OwnerAddress column so we'll just use our trusty **SUBSTRING_INDEX()** function to extract the state from it. The state is Tennessee so we'll just fill the missing values with "TN" while we're at it.

 - Standardized the SoldAsVacant column: 
   - Instead of having it as Yes, Y, No, N, we'll make it Yes and No (because they're more populated) through a simple **CASE** statement.

- Removing duplicate rows:
  - Using a CTE that contains a **RANK()** function which gives a row a rank based on enough columns that we're confident no two records would share. So, the only way a row would have a rank that isn't equal to 1 is a duplicate.
  - The CTE is used because RANK() is a window function, which won't work with WHERE, thus a CTE is required. We obtain a temporary table through it and apply the new condition.
  - Then we use a **DELETE** statement that targets rows whose rank is bigger than 1 (they're duplicates)
  - Unfortunately, this doesn't work in MySQL because it doesn't allow the user to delete records from CTEs :c works great in SQL Server though.
  - I tried adding a temporary column but you can't fill it with a window function. Eventually took it to Power Query and just removed the duplicates there.

- Removing unneeded rows:
  - Just used **DROP COLUMN** to delete the columns we split up previously and another one that seemed useless to me heh.

 
 
 
 # Recap
  We successfully turned a very dirty dataset into very useable data. Standardizing the date forma and whether the property was sold as vacant or not, splitting the address columns, getting rid of duplicates. These steps will massively reduce our headache when visualizing this data.

  It has been a lot of hard work, and I'm happy how it turned out!