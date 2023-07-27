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

z_values = [1] * len(jdata['features'])

# Create a DataFrame with 'id' and 'value' columns
data = {'id': [feature['properties']['CHSA_Name'] for feature in jdata['features']],
        'value': z_values}
gdf = pd.DataFrame(data)

# Plot the choropleth map
fig7 = px.choropleth_mapbox(gdf, geojson=jdata,
                           featureidkey='properties.CHSA_Name',
                           locations='id',
                           color='value',
                           mapbox_style='carto-positron',
                           center={"lat": 53.7267, "lon": -127.6476},  # Set the center of the map
                           zoom=4,  # Set the initial zoom level
                           height=800
                           )

fig7.update_layout(title_text='Choropleth Map with z=1 for All Features',
                  title_x=0.5,
                  coloraxis_reversescale=True,
                  )
# ------------------------------------------------------------------------------
layout = html.Div(children=[
    dcc.Graph(figure=fig7),
    html.Div(
        children=[
            html.H2("INSERT AGGREGATED HA DISTANCES TABLE")
        ]
    )
])
