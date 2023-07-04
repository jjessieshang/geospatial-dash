import pandas as pd
import plotly.express as px  # (version 4.7.0 or higher)
import plotly.graph_objects as go
from dash import Dash, dcc, html, Input, Output, dash_table  # pip install dash (version 2.0.0 or higher) 
from collections import OrderedDict
from plotly.subplots import make_subplots

app = Dash(__name__)

# ------------------------------------------------------------------------------
# import, clean, and process data
df = pd.read_csv("dummy.csv")
df = df.groupby(['State', 'ANSI', 'Affected by', 'Year', 'state_code'])[['Pct of Colonies Impacted']].mean()
df.reset_index(inplace=True)
# print(df[:5]),

# costs dataframe preprocessing
df2 = pd.read_csv("data/P&F Costs Data/P&F-Costs-Simplfied.csv", delimiter=",", encoding="utf-8", header=0)
df2.reset_index(inplace=True)
df2 = df2.rename(columns={'lost_productivity': 'Lost Productivity', 'informal_caregiver': 'Informal Caregiver', 'out_of_pocket': 'Out of Pocket', 
                          'cost_value': 'Total'})
print(df2.head()),

#sample table data
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
    title_text="Global Emissions 1990-2011",
    # Add annotations in the center of the donut pies.
    annotations=[dict(text='GHG', x=0.18, y=0.5, font_size=20, showarrow=False),
                 dict(text='CO2', x=0.82, y=0.5, font_size=20, showarrow=False)])

# ------------------------------------------------------------------------------
# app layout: contains dash components and html
app.layout = html.Div(className="main-content", children=[
    html.H1(className="dash-title", children=["Healthcare Costing Across British Columbia"]),

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
            html.Label(className="select-label", children="Select an Age Group"),
            dcc.Dropdown(className="slct_age", id="slct_age",
            options=[
                {"label": "0-14 years", "value": "0-14"},
                {"label": "15-64 years", "value": "15-64"},
                {"label": "65+ years", "value": "65+"}],
            multi=False,
            value="0-14"
            ),

            # cost of care summary
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
                dash_table.DataTable(
                    id="datatable",
                    style_table={'height': '550px', 'overflowY': 'auto'},
                ),

                html.Div(className="my_rose", children=[]),
            ])
        ]),

        html.Div(className="column2", children=[

                html.Div(id='output_container', children=[]),
                html.Br(),

                dcc.Graph(id='my_bee_map', figure={}),


                dcc.Graph(id='my_polar1', figure=fig),
        ]),
    ]),

])

# ------------------------------------------------------------------------------
# Connect the Plotly graphs with Dash Components
# each callback has inputs and outputs, along with a function with arguments that realte to each input

@app.callback(
    [Output(component_id='output_container', component_property='children'),
     Output(component_id='my_bee_map', component_property='figure')],
    [Input(component_id='slct_year', component_property='value')]
)
def update_graph(option_slctd):
    print(option_slctd)
    print(type(option_slctd))

    container = "The year chosen by user was: {}".format(option_slctd)

    dff = df.copy() #always make a copy of df
    dff = dff[dff["Year"] == option_slctd]
    dff = dff[dff["Affected by"] == "Varroa_mites"]

    # Plotly Express
    fig = px.choropleth(
        data_frame=dff,
        locationmode='USA-states',
        locations='state_code',
        scope="usa",
        color='Pct of Colonies Impacted',
        hover_data=['State', 'Pct of Colonies Impacted'],
        color_continuous_scale=px.colors.sequential.YlOrRd,
        labels={'Pct of Colonies Impacted': '% of Bee Colonies'},
        # template='plotly_dark'
    )
    return container, fig


# costs table entries
@app.callback(
    Output("datatable", "data"), 
    [Input(component_id='slct-service-type', component_property='value'),
     Input(component_id='slct_ha', component_property='value'),
     Input(component_id='slct_age', component_property='value')
     ]
)
def update_table(service_slctd, ha_slctd, age_slctd):

    dff = df2.copy() #always make a copy of df
    dff =dff[["service_type", "health_authority", "ctas_admit", "age", "Total", "Lost Productivity", "Informal Caregiver","Out of Pocket"]]

    # filter by service type drop down
    dff = dff[dff["service_type"] == service_slctd]

    # filter by health authority dropdown, non specific for virtual care
    if (service_slctd != "virtual") :
        dff = dff[dff["health_authority"] == ha_slctd]

    # filter by age category dropdown
    dff = dff[dff["age"] == age_slctd]

    dff2 = dff[["Total", "Lost Productivity", "Informal Caregiver","Out of Pocket"]]
    dff2 = dff2.transpose()

    # new df
    values = ["Total", "Lost Productivity", "Informal Caregiver","Out of Pocket"]
    df3 = pd.DataFrame({'Cost Category': values, "Amount": dff2.iloc[:,0].values})

    # # move sum to end of df
    first_row = df3.head(1)
    df3 = df3.iloc[1:]
    df3 = pd.concat([df3, first_row], ignore_index=True)


    return df3.to_dict('records')


# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=True)