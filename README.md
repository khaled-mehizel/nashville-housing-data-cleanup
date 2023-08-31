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
 - 