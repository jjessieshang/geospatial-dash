import dash
import json
from dash import html, dcc, dash_table, callback, Input, Output
import pandas as pd
import plotly.express as px  # (version 4.7.0 or higher)

dash.register_page(__name__)

# ------------------------------------------------------------------------------
empty_table_data = {
        'Column 1': ['', ''],
        'Column 2': ['', '']
    }
empty_table = pd.DataFrame(empty_table_data)

# Read the geojson data from the file location
with open('data/Geospatial Data/chsa_2022_wgs.geojson') as f:
    jdata = json.load(f)

df_distances = pd.read_csv("data/Geospatial Data/CHSA-to-Hosp-distances.csv", delimiter=",", encoding="utf-8", header=0)
ha_mean_distances = pd.read_csv("data/Geospatial Data/HealthAuthority_Distances.csv", delimiter=",", encoding="utf-8", header=0)
ha_mean_durations = pd.read_csv("data/Geospatial Data/HealthAuthority_Durations.csv", delimiter=",", encoding="utf-8", header=0)

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
                           zoom=4,  # Set the initial zoom level
                           height=600,
                           color_continuous_scale='blues',
                           )

fig7.update_layout(
    margin=dict(t=0, b=50, l=50, r=30),
)

# ------------------------------------------------------------------------------
layout = html.Div(className="map", children=[
    html.Div(className="column1", children=[
        html.H3(className="section-title", 
                children=["Geospatial Cost Derivations"]),
        html.P(className="section-description", 
            children=["Explore our novel geospatial method to determine travel distance from each Community Health Service Area in BC to the nearest in-person clinical location."]),
        html.P(className="section-description", 
            children=["The values seen are used to calculate direct out-of-pocket travel costs, the total time commitment per visit, productivity changes and informal caregiving costs in the single visitation cost analysis."]),
            html.Br(),
            html.Label(className="select-label", children="Select Measurement"),
        dcc.Dropdown(className="in", id="multi_slct-ha1",
        options=[
            {"label": "Distance", "value": "distance"},
            {"label": "Duration", "value": "duration"}],
                multi=False,
        ),
        html.Br(),
        html.Label(className="select-label", children="Aggregated Values for Health Authorities"),

        #aggregated ha table
        html.Br(),
        dash_table.DataTable(
            id="ha_table",
            data=ha_mean_distances.to_dict('records'),
            columns=[
                {"name": col, "id": col} for col in ha_mean_distances.columns
            ],
            style_table={'height': '550px', 'overflowY': 'auto', 'font-size': '.9rem'},
            style_cell={'textAlign': 'left'},
            cell_selectable=False,
            style_data={
                'color': 'black',
                'backgroundColor': 'white'
            },
            style_data_conditional=[
                {
                    'if': {'row_index': 'odd'},
                    'backgroundColor': 'rgb(230, 230, 230)',
                }
            ],
            style_header={
                'backgroundColor': 'rgb(230, 230, 230)',
                'color': 'black',
                'fontWeight': 'bold'
            }
        ),
        html.P(className="section-title", id="text"),
    ]),
    html.Div(className="column2", children=[
        # choropleth map
        html.Div(className="plot", children=[
            html.H3(className="component-title", id="plot-title", children="CHSA map of british columbia"),
            html.Hr(),
            dcc.Graph(figure=fig7),
        ]),
    ]),
])

#-----------------------

# costs table entries
# @callback(
#     [Output("text", "children")],
#     [Input("multi_slct-ha1", "value")]
# )
# def graph_update_text(selected_value):
#     if selected_value is not None:
#         return [f"Selected value: {selected_value}"]
#     else:
#         return ["Select a value from the dropdown"]
