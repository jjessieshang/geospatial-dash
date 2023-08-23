
import json
from dash import html, dcc, dash_table, callback, Input, Output
import pandas as pd
import plotly.express as px  # (version 4.7.0 or higher)
import dash

dash.register_page(__name__)

# ------------------------------------------------------------------------------

# Read the geojson data from the file location
with open('data/Geospatial Data/chsa_2022_wgs.geojson') as f:
    jdata = json.load(f)

df_distances = pd.read_csv("data/Geospatial Data/CHSA-to-Hosp-distances.csv", delimiter=",", encoding="utf-8", header=0)

# Read aggregated ha csv data
ha_mean_distances = pd.read_csv("data/Geospatial Data/HealthAuthority_Distances.csv", delimiter=",", encoding="utf-8", header=0)
ha_mean_durations = pd.read_csv("data/Geospatial Data/HealthAuthority_Durations.csv", delimiter=",", encoding="utf-8", header=0)

ha_mean_distances.rename(columns={'HA Name': 'Health Authority','Street Distance': 'Street Distance (km)'}, inplace=True)
ha_mean_durations.rename(columns={'HA Name': 'Health Authority','Street Duration - W mean': 'Street Duration (min)'}, inplace=True)

# Create a DataFrame with 'id' and 'value' columns
data = {'CHSA_Name': [feature['properties']['CHSA_Name'] for feature in jdata['features']]}
gdf = pd.DataFrame(data)




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
        dcc.Dropdown(className="options", id="multi_slct-ha1",
        options=[
            {"label": "Distance", "value": "distance"},
            {"label": "Duration", "value": "duration"}],
                value="distance",
                multi=False,
        ),
        html.P(className="ha-table-title", id="value-description"),
        html.Br(),

        html.Label(className="select-label", children="Mean Values Across Health Authorities"),

        #aggregated ha table
        html.Br(),
        dash_table.DataTable(
            id="ha_table",
            row_selectable='single',  # Allow selecting only one row
            selected_rows=[],  # Initialize selected_rows as an empty list
            style_table={ 'overflowY': 'auto', 'font-size': '.8rem', 'padding-top':'1rem'},
            style_cell={'textAlign': 'left', 'padding': '6px'},
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

        #reset map button
        html.Button("Reset Map", id="clear_selection_button", className="reset"),
    ]),
    html.Div(className="column2", children=[
        # choropleth map
        html.Div(className="plot", children=[
            html.H3(className="component-title", id="plot-title", children="Community Heath Service Area to Nearest ED"),
            html.Hr(),
            dcc.Graph(id='choropleth'),
        ]),
    ]),
])

#-----------------------
#CALLBACK FUNCTIONS

# parameter for map and ha table
@callback(
    [Output("choropleth", "figure"),
     Output("ha_table", "data"),
     Output("ha_table", "columns"),
     Output("value-description", "children"),], 
    [Input("multi_slct-ha1", "value"),
     Input("ha_table", "selected_rows")]
    
)
def update_geospatial(measure, row):
        dff_distances  = df_distances
        # Filter merged_df to include only CHSAs with 'Health Authority' name 'Fraser'
        if (len(row) > 0) :
             dff_distances = df_distances[df_distances['HA'] == ha_mean_distances.iloc[row[0]]['Health Authority']]

        merged_df = pd.merge(dff_distances[['CHSA_Name', 'Street distance (km)']], gdf[['CHSA_Name']], on='CHSA_Name', how='right')
        measure_name = 'Street distance (km)'
        table_data = ha_mean_distances.to_dict('records')
        columns=[
                {"name": col, "id": col} for col in ha_mean_distances.columns
            ]
        description = "*Mean street distance in km to travel to nearest ED"

        if (measure == "duration"):
            merged_df = pd.merge(dff_distances[['CHSA_Name', 'Street duration']], gdf[['CHSA_Name']], on='CHSA_Name', how='right')
            measure_name = 'Street duration'
            table_data = ha_mean_durations.to_dict('records')
            columns=[
                {"name": col, "id": col} for col in ha_mean_durations.columns
            ]
            description = "*Mean duration in minutes to travel to nearest ED, accounting for traffic data"

        # Generate the choropleth map
        fig = px.choropleth_mapbox(merged_df, geojson=jdata,
                                featureidkey='properties.CHSA_Name',
                                locations='CHSA_Name',
                                color=measure_name,
                                mapbox_style="carto-positron",
                                center={"lat": 55, "lon": -127.6476},  # Set the center of the map
                                zoom=3.5,  # Set the initial zoom level
                                height=600,
                                color_continuous_scale='blues',
                                )

        fig.update_layout(
            margin=dict(t=0, b=50, l=50, r=30),
        )
        return fig, table_data, columns, description

@callback(
    Output("ha_table", "selected_rows"),
    Input("clear_selection_button", "n_clicks"),
)
def clear_table_selection(n_clicks):
    if n_clicks is None:
        # No button click, return the current selected rows
        return dash.callback_context.states["ha_table.selected_rows"]

    # Button was clicked, reset the selected rows to an empty list
    return []






