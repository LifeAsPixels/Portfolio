# [LifeAsPixels GitHub Site](https://lifeaspixels.github.io/)

# Code Samples

## Python

### [bs4-PageScrape.py](/Python/bs4-PageScrape.py)
Scrape data from a page and save locally as csv

### [Avocado](/Python/Avacado)
Python app using Dash and Pandas. Main file is [app.py](/Python/Avocado/app.py). Folder contains a [README](/Python/Avocado/README.md) with 3-step instructions to run this python server locally. Presents a one-page dashboard with analysis of Avocado sales. [Link to live site.](http://lifeaspixels.pythonanywhere.com/). More live examples can be found on my [LifeAsPixels GitHub Site](https://lifeaspixels.github.io/)

## [SQL](/SQL)
Written for t-SQL on SQLServer

### [ID_Search_HR.sql](SQL/ID_Search_HR.sql)
Returns contact information from matches in an ID search.
#### Why
A common task is to verify the identify of users in correspondense to take action on requests for data access. Correspondences often require a task to be completed for some certain list of users and the lists are often missing information necessary to complete the task.

### [Experiential_Learning_Course.sql](SQL/Experiential_Learning_Course.sql)
Cross DB query for attributes and conditions to identify EL courses historically, and moving forward at a University.
#### Why
There is no particular attribute as of yet in the course creation process 'on paper' nor in the database to identify which courses qualify as experiental learning credits. This has made the process of finding EL courses for students difficult and underrepresented during course registration. Courses that qualify as experiental learning have varied criteria. Qualifying courses are determined by a combination of each college's criteria and the university's criteria. 

## [PowerShell](/Powershell)
Shell scripts I use to configure a new installation of Windows to my specifications.

Use Settings.ps1 to create the user-variables and parameters. Use Functions.ps1 to make the low-level functions for use and recursion in procedures. Then use one procedure file for each procedure as necessary so they can be defined and run selectively as a file -- currently only one here. Imagine: one user, multiple machines, different configurations for each, but similar ie: this is effectively a way to create a template for a custom user config on VMs, or, rather define the template after some software cofig.

### [Settings.ps1](/PowerShell/Settings.ps1)
Static-value variables of all kinds typed by the user.
#### In-Particular
Paths, Network and PC configurations, regex.
#### Why
All settings in one place used to programattically generate variables here and elsewhere, and passed as parameters in functions and procedures.

### [Functions.ps1](/PowerShell/Functions.ps1)
Low-level code relative to the language made by the user.
#### Why
Use as the building blocks in procedures. Every time a code block needs to be re-written, make the code-block a function instead, then replace the code-block with a function call.

### [Procedure.ps1](/PowerShell/Procedure.ps1)
Wrap code-blocks that complete a high-level task in a user-function labelled 'procedure-'. Call the procedure.
#### In-Particular
Imports fonts, enables RDP, remote PowerShell sessions, file-sharing on a workgroup, share folders to network, map network drives, add workgroup members, import previously configured app profile files.
#### Why
A procedure can be read in-place to comprehend the entirety of some action at a high-level and can be run as a file to complete a task statically or dynamically based on settings.ps1 and environment variables.

### [DynamicPowerShell.ps1](/PowerShell/DynamicPowerShell.ps1)
Example of writing then calling a dynamically written powershell script.
