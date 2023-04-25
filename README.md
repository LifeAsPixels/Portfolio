# Code Samples -- PowerShell, SQL, Python

## SQL
Written for t-SQL on SQLServer

### ID_Search_HR.sql
A common task is to identify users in correspondense to take action on requests. This is a search file. Correspondences often require a task to be completed for some certain list of users and the lists are often missing information necessary to complete the task. This query takes in a parameter and searches for the value in columns related to a persons contact information.

### Experiential_Learning_Course.sql
There is no particular attribute as of yet in the course creation process on paper nor in the database to identify which courses qualify as experiental learning credits. This has made the process of finding EL courses for students difficult and has made them underrepresented during course registration due to the difficulty in finding them all. Courses that qualify as experiental learning have varied criteria. Qualifying courses are determined by a combination of each college's criteria and the university's criteria. This query makes a single list of all courses qualifying for EL credit historically, and moving forward at a University.

## PowerShell
The Settings.ps1 and Functions.ps1 files are included in the Procedure.ps1 file and the 3 are designed to work together. Configure settings to organize and create all the static, custom user-variables, make the tier-1 functions that can be re-used in procedures and recursed. Then create a 'procedure' shell file for each procedure as necessary -- currently only one.

### Settings.ps1
Variables -- hashes, arrays, variables, dictionaries which are static, typed by the user, like a configuration file with all settings in one place used to programattically generate variables elsewhere.

### Functions.ps1
Functions made by the user to be used in procedures.

### Procedure.ps1
Procedures made of combinations of CMDlets, user-functions, and user-variables to complete some tasks such as configuring a machine for remote sessions and starting one

### DynamicPowerShell.ps1
Example of writing then calling a dynamically written powershell script

## Python

### Avocado
The folder contains a README describing a 3-step installation for a python server presenting a one-page dashboard with analysis of Avocado sales using Dash in Python 3.
