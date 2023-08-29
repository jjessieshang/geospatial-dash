# DigEM-PFcosts-Geo
Geospatial content for Patient and Family costs methods project 

## About the Dashboard
This app is developed in Python, HTML, CSS, Javascript and deployed on Google Cloud Run. CD

### Backend
This dashboard processes data from a csv file using the Pandas, NumPy, and Plotly libraries in Python.

### Frontend
Pythod Dash, HTML, CSS, Javascript

### Deployment
Hosted on Google Cloud Run at https://rtvs-dash-kgo36byuna-uw.a.run.app/
CD Pipeline: changes pushed to the main branch are built and deployed via Google Cloud Build

<!-- GETTING STARTED -->
## Getting Started Locally

To get a local copy up and running follow these simple steps.

### Installing the Dependencies

1. `pip install virtualenv` (if you don't already have virtualenv installed)
2. `virtualenv venv` (to create your new environment (called 'venv' here))
3. `source venv/bin/activate` (to enter the virtual environment)
4. `pip install -r requirements.txt` (to install the requirements in the current environment)


### Starting the app

1. `python app.py` in the terminal

App will be exposed on port 8050.