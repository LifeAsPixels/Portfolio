# AVOCADO ANALYTICS
Single-page Python web-server presenting a dashboard on Avocado sales. Made with Dash.

# Compatibility
Tested with python 3.11 on windows 10.
May work on UNIX-like systems. Untested bash setup file included.

## REQUIREMENTS
- Python 3 installation
- admin user account
- web-browser to view
- ability to run shell scripts

### WINDOWS INSTALL INSTRUCTIONS
	1. Copy the Avocado folder to a local directory
	2. Ensure you can run powershell scripts on your user account on this local machine by running "ExecutionPolicy-RemoteSigned.bat"
		If you can already run powershell scripts, this step is not necessary.
	3. Run "setup.ps1"
		This will...
			- install the necessary python packages in a virtual environment folder in the same directory as the script
			- run "app.py" in a python terminal generating the server
			- open the server-page in your web-browser at "http://127.0.0.1:8050/"

### WINDOWS REMOVAL INSTRUCTIONS
	1. Close the python terminal running the server-app
	2. Reset the windows execution policy to the default setting with "ExecutionPolicy-Restricted.bat"
		Only do this if you do not intend to run powershell scripts on this current user account on this machine
	3. Delete the Avacado folder in your local directory.
	
### UNIX-like INSTALL INSTRUCTIONS
Setup.sh not tested and may need altering to get the app started.
	1. Copy the Avocado folder to a local directory
	2. Ensure you can run shell scripts on your user account on this local machine
	3. Run "setup.sh"
		This will...
			- install the necessary python packages in a virtual environment folder in the same directory as the script
			- run "app.py" in a python terminal generating the server
			- open the server-page in your web-browser at "http://127.0.0.1:8050/"

### UNIX-like REMOVAL INSTRUCTIONS
	1. Close the python terminal running the server-app
	2. Delete the Avacado folder in your local directory.
