# Code Samples -- PowerShell, SQL, Python

## SQL
Written for t-SQL on SQLServer

[ID_Search_HR.ps1](/SQL/ID_Search_HR.ps1)
[ID_Search_HR.ps1]([/SQL/ID_Search_HR.ps1](https://github.com/LifeAsPixels/Portfolio/tree/main/SQL))
[ID_Search_HR.ps1]([/SQL/ID_Search_HR.ps1](/tree/main/SQL))
[ID_Search_HR.ps1]((/tree/main/SQL))
[ID_Search_HR.ps1](https://github.com/LifeAsPixels/Portfolio/tree/main/SQL)

### ID_Search_HR.sql
Returns contact information from matches in an ID search.
#### Why
A common task is to verify the identify of users in correspondense to take action on requests for data access. Correspondences often require a task to be completed for some certain list of users and the lists are often missing information necessary to complete the task.

### Experiential_Learning_Course.sql
Cross DB query for attributes and conditions to identify EL courses historically, and moving forward at a University.
#### Why
There is no particular attribute as of yet in the course creation process 'on paper' nor in the database to identify which courses qualify as experiental learning credits. This has made the process of finding EL courses for students difficult and has made them underrepresented during course registration due to the difficulty in finding them all. Courses that qualify as experiental learning have varied criteria. Qualifying courses are determined by a combination of each college's criteria and the university's criteria. 

## PowerShell
The Settings.ps1 and Functions.ps1 files are included in the Procedure.ps1 file and the 3 are designed to work together. Configure settings to organize and create all the static, custom user-variables; make the tier-1 functions that can be re-used in procedures and recursed. Then create a 'procedure' shell file for each procedure as necessary so they can be defined and run selectively as a file -- currently only one.

### Settings.ps1
Variables -- hashes, arrays, variables, dictionaries which are static, typed by the user.
#### Why
All settings in one place used to programattically generate variables elsewhere, and passed as parameters in functions and procedures.

### Functions.ps1
Low-level code relative to the language made by the user.
#### Why
Use as the building blocks in procedures. Every time a code block needs to be re-written, make the code-block a function instead, then replace the code-block with a function call.

### Procedure.ps1
Wrap code-blocks that complete a high-level task in a user-function labelled 'procedure-'. Call the procedure.
#### In-Particular
This one in particular includes the necessary settings to set windows to be capable of importing fonts from a local folder, enable RDP, remote PowerShell sessions, file-sharing on a workgroup, share folders to network, map network drives, add workgroup members, all with basic error catching.
#### Why
A procedure can be read in-place to comprehend the entirety of some action at a high-level and can be run as a file to complete a task statically or dynamically based on settings.ps1 and environment variables.

### DynamicPowerShell.ps1
Example of writing then calling a dynamically written powershell script.

## Python

### Avocado
The folder contains a README describing a 3-step installation for a python server presenting a one-page dashboard with analysis of Avocado sales using Dash and Pandas in Python 3.
