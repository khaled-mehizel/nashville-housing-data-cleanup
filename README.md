# Nashville Housing Data Cleanup
 A comprehensive cleanup of a very dirty dataset, purely in SQL.

# Overview
The data consitutes homes and homeowners in Nashville, TN, USA.

Definitely not the most interesting dataset but it serves the purpose to show my SQL skills, hopefully.

# Tools & Resources Used
 - Dataset kindly provided by [Alex the Analyst](https://www.youtube.com/@AlexTheAnalyst)
 - Microsoft Excel for eyeballing the data, and exporting it as a .csv file.
 - Notepad++ and CSV Lint to convert the .csv file into a .sql script for quick import into MySQL Workbench, as well as setting the primary key of the main table. Even though I adore the workbench, its import wizard is unacceptably slow.
 - MySQL Workbench for cleaning the dataset, as well as exporting it into a nice and clean DB ready to be queried for analysis.

# Preliminary look at the dataset and CSV export
- Little look at the data using Excel to see what we're working with and what kind of data we have.
- Export into CSV through the built-in function.

# Conversion of CSV file into SQL script and import
 - Used Notepad++ and CSV Lint to verify the data types, and convert the file into a .sql script for quick import.
 - Set the Unique ID of the property as the primary key of the main table. There was no need to assign another since the unique ID was already there.

 # The actual cleaning
 Using MySQL Workbench, I've done the following:
 - Standardized the date format using the str-to-date() function.
 - Populated empty address records:
    - Looking at the Parcel_ID, we notice that each parcel_id has an equivalent address, but appears multiple times with its own unique ID. So, to find the missing addresses, it's a matter of finding the addresses that are equivalent to their (missing addresses) parcel_IDs
      - This can be done using a **self-join**. We join the table to itself through the parcel_ID, and we make sure the Unique_IDs are not equal. This enables us to have all the parcel_IDs and their equivalent addresses, bunched up coveniently next to the missing addresses.
      - So, all the missing addresses will be facing the their parcel_ID's equivalent address, which is what should populate them.
      - As for the population itself, we can simply use an **IFNULL()** function that fills the missing address with its parcel_ID's address.

- Broke the Address column into three: Address, City, State
