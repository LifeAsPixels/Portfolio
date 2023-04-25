cd "$PSScriptRoot" # set current working directory to the script path for reltive commands

python -m venv venv # create a virtual environment (venv) folder here named 'venv'
venv\Scripts\activate # activate the venv in this console
python -m pip install dash==2.8.1 pandas==1.5.3 # install necessary package versions in venv for app to run
Start-Process .\app.py # run the file to start the app
Start-Process .\OpenAvocadoServer.py