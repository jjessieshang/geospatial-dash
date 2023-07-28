import dash
import json
from dash import html, dcc, callback, Input, Output
import pandas as pd
import plotly.express as px  # (version 4.7.0 or higher)

dash.register_page(__name__)

# ------------------------------------------------------------------------------

# Read the geojson data from the file location
with open('data/Geospatial Data/chsa_2022_wgs.geojson') as f:
    jdata = json.load(f)

df_distances = pd.read_csv("data/Geospatial Data/CHSA-to-Hosp-distances.csv", delimiter=",", encoding="utf-8", header=0)

# Create a DataFrame with 'id' and 'value' columns
data = {'CHSA_Name': [feature['properties']['CHSA_Name'] for feature in jdata['features']]}

gdf = pd.DataFrame(data)
merged_df = pd.merge(df_distances[['CHSA_Name', 'Street distance (km)']], gdf[['CHSA_Name']], on='CHSA_Name', how='right')

# Plot the choropleth map
fig7 = px.choropleth_mapbox(merged_df, geojson=jdata,
                           featureidkey='properties.CHSA_Name',
                           locations='CHSA_Name',
                           color='Street distance (km)',
                           mapbox_style='white-bg',
                           center={"lat": 55, "lon": -127.6476},  # Set the center of the map
                           zoom=5,  # Set the initial zoom level
                           height=1000,
                           color_continuous_scale='blues',
                           )

fig7.update_layout(
    margin=dict(t=0, b=50, l=50, r=30),
)

# ------------------------------------------------------------------------------
layout = html.Div(className="map", children=[
    html.Div(className="column1", children=[
        html.H3(className="section-title", 
                children=["Geospatial Costing Dashboard"]),
    ]),
    html.Div(className="column2", children=[
                    # stacked bar
        html.Div(className="plot", children=[
            html.H3(className="component-title", id="plot-title", children="CHSA map of british columbia"),
            html.Hr(),
            dcc.Graph(figure=fig7),
            html.Div(
                children=[
                    html.H2("INSERT AGGREGATED HA DISTANCES TABLE")
                ]
            )
        ]),
    ]),
])




