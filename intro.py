import pandas as pd
import plotly.express as px  # (version 4.7.0 or higher)
import plotly.graph_objects as go
from dash import Dash, dcc, html, Input, Output, dash_table  # pip install dash (version 2.0.0 or higher) 
from collections import OrderedDict
from plotly.subplots import make_subplots

app = Dash(__name__)

# ------------------------------------------------------------------------------

# costs dataframe cleaning and preprocessing
df2 = pd.read_csv("data/P&F Costs Data/P&F-Costs-Simplfied.csv", delimiter=",", encoding="utf-8", header=0)
df2.reset_index(inplace=True)
df2 = df2.rename(columns={'lost_productivity': 'Lost Productivity', 'informal_caregiver': 'Informal Caregiver', 'out_of_pocket': 'Out of Pocket', 
                          'cost_value': 'Total'})

#DUMMY DATA FOR MAP AND PIE CHARTS
data = OrderedDict(
[
    ("Date", ["2015-01-01", "2015-10-24", "2016-05-10", "2017-01-10", "2018-05-10", "2018-08-15"]),
    ("Region", ["Montreal", "Toronto", "New York City", "Miami", "San Francisco", "London"]),
    ("Temperature", [1, -20, 3.512, 4, 10423, -441.2]),
    ("Humidity", [10, 20, 30, 40, 50, 60]),
    ("Pressure", [2, 10924, 3912, -10, 3591.2, 15]),
]
),

labels = ["US", "China", "European Union", "Russian Federation", "Brazil", "India",
          "Rest of World"]

# Create subplots: use 'domain' type for Pie subplot
fig = make_subplots(rows=1, cols=2, specs=[[{'type':'domain'}, {'type':'domain'}]])
fig.add_trace(go.Pie(labels=labels, values=[16, 15, 12, 6, 5, 4, 42], name="GHG Emissions"),
              1, 1)
fig.add_trace(go.Pie(labels=labels, values=[27, 11, 25, 8, 1, 3, 25], name="CO2 Emissions"),
              1, 2)

# Use `hole` to create a donut-like pie chart
fig.update_traces(hole=.4, hoverinfo="label+percent+name")

fig.update_layout(
    title_text="Chart Section",
    # Add annotations in the center of the donut pies.
    annotations=[dict(text='', x=0.18, y=0.5, font_size=20, showarrow=False),
                 dict(text='', x=0.82, y=0.5, font_size=20, showarrow=False)]),

df = px.data.election()
geojson = px.data.election_geojson()

fig2 = px.choropleth(df, geojson=geojson, color="Bergeron",
                    locations="district", featureidkey="properties.district",
                    projection="mercator"
                   )
fig2.update_geos(fitbounds="locations", visible=False)
fig2.update_layout(margin={"r":0,"t":0,"l":0,"b":0})


# ------------------------------------------------------------------------------
# app layout: contains dash components and html
app.layout = html.Div(className="main-content", children=[
    html.H1(className="dash-title", children=["PATIENT & FAMILY HEALTHCARE COSTS ACROSS BRITISH COLUMBIA"]),

    html.Div(className="main-row", children=[
        html.Div(className="column1", children=[
            html.H3(className="section-title", 
                    children=["Choose a health authority and age group from the list below to view costs"]),
            # dropdown menus
            html.Label(className="select-label", children="Select a Health Authority"),
            dcc.Dropdown(className="slct_ha", id="slct_ha",
            options=[
                {"label": "Northern", "value": "Northern"},
                {"label": "Interior", "value": "Interior"},
                {"label": "Vancouver Coastal", "value": "Vancouver Coastal"},
                {"label": "Fraser", "value": "Fraser"},
                {"label": "Vancouver Island", "value": "Vancouver Island"}],
            multi=False,
            value="Vancouver Island",
            ),
            html.Br(),
            html.Label(className="select-label", children="Select an Age Group"),
            dcc.Dropdown(className="slct_age", id="slct_age",
            options=[
                {"label": "0-14 years", "value": "0-14"},
                {"label": "15-64 years", "value": "15-64"},
                {"label": "65+ years", "value": "65+"}],
            multi=False,
            value="0-14"
            ),

            # cost of care table and dropdowns
            html.Div(className="cost-summary", children=[
                html.H1("Cost of Care Summary"),
                html.Label(className="select-label", children="Method of Care"),
                dcc.Dropdown(className="slct-service-type", id="slct-service-type",
                options=[
                    {"label": "Emergency Care", "value": "emergency"},
                    {"label": "Family Doctor", "value": "family medicine"},
                    {"label": "Virtual Care", "value": "virtual"},
                    {"label": "Hospitalization", "value": "hospitalization"},],
                multi=False,
                value="virtual",
                ),
                html.Br(),
                html.Label(className="select-label", children="Canadian Triage and Acuity Scale (CTAS) Level"),
                dcc.Dropdown(className="slct-ctas", id="slct-ctas", 
                multi=False,
                value="1-3",
                ),
                html.Br(),
                dash_table.DataTable(
                    id="datatable",
                    style_table={'height': '550px', 'overflowY': 'auto'},
                    style_cell_conditional=[
                        {
                            'if': {'column_id': c},
                            'textAlign': 'left'
                        } for c in ['Cost Category', 'Amount']
                    ],
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
                html.Div(className="my_rose", children=[]),
            ])
        ]),

        html.Div(className="column2", children=[
                dcc.Graph(id='my_map', figure=fig2),
                html.Br(),
                dcc.Graph(id='my_polar1', figure=fig),
        ]),
    ]),

])

# ------------------------------------------------------------------------------
# Connect the Plotly graphs with Dash Components
# each callback has inputs and outputs, along with a function with arguments that realte to each input

# cascading CTAS dropdown
@app.callback(
    Output('slct-ctas', 'options'),
    [Input('slct-service-type','value')])
def update_dropdown(selected_service):
    if (selected_service == "emergency"):
        options=[{"label": "1-3", "value": "1-3"},
                {"label": "4-5", "value": "4-5"},]
    else:
        options=[{"label": "N/A", "value": ""}]
    return options


# costs table entries
@app.callback(
    Output("datatable", "data"), 
    [Input(component_id='slct-service-type', component_property='value'),
     Input(component_id='slct_ha', component_property='value'),
     Input(component_id='slct_age', component_property='value'),
     Input(component_id='slct-ctas', component_property='value')
     ]
)
def update_table(service_slctd, ha_slctd, age_slctd, ctas_slctd):

    dff = df2.copy() #always make a copy of df
    dff =dff[["service_type", "health_authority", "ctas_admit", "age", "Total", "Lost Productivity", "Informal Caregiver","Out of Pocket"]]

    # filter by service type drop down
    dff = dff[dff["service_type"] == service_slctd]

    # filter by health authority dropdown, non specific for virtual care
    if (service_slctd != "virtual") :
        dff = dff[dff["health_authority"] == ha_slctd]

    # filter by age category dropdown
    dff = dff[dff["age"] == age_slctd]
    dff = dff[["Total", "Lost Productivity", "Informal Caregiver","Out of Pocket","ctas_admit"]]
    dff = dff.transpose()
    if (service_slctd == "emergency"):
        index = dff.loc["ctas_admit"].tolist().index(ctas_slctd)
    else:
        index = 0

    values = ["Total", "Lost Productivity", "Informal Caregiver","Out of Pocket"]
    print(dff)
    cost_summary = pd.DataFrame({'Cost Category': values, "Amount": dff.iloc[:4,index].values})

    # move total sum to end of df
    first_row = cost_summary.head(1)
    cost_summary = cost_summary.iloc[1:]
    cost_summary = pd.concat([cost_summary, first_row], ignore_index=True)

    return cost_summary.to_dict('records')


# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=True) 