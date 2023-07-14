import pandas as pd
import plotly.express as px  # (version 4.7.0 or higher)
import plotly.graph_objects as go
from dash import Dash, dcc, html, Input, Output, dash_table  # pip install dash (version 2.0.0 or higher) 
from collections import OrderedDict
from plotly.subplots import make_subplots

app = Dash(__name__)

# ------------------------------------------------------------------------------

# costs dataframe cleaning and preprocessing 
df2 = pd.read_csv("data/P&F Costs Data/P&F Costs Simplified.csv", delimiter=",", encoding="utf-8", header=0)
df2.reset_index(inplace=True)
df2 = df2.rename(columns={'lost_productivity': 'Lost Productivity', 'informal_caregiver': 'Informal Caregiver', 'out_of_pocket': 'Out of Pocket', 
                          'cost_value': 'Total'})

df = px.data.election()
geojson = px.data.election_geojson()


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
                # multi select?
                dcc.Dropdown(className="multi_slct-ha", id="multi_slct-ha",
                options=[
                    {"label": "Northern", "value": "Northern"},
                    {"label": "Interior", "value": "Interior"},
                    {"label": "Vancouver Coastal", "value": "Vancouver Coastal"},
                    {"label": "Fraser", "value": "Fraser"},
                    {"label": "Vancouver Island", "value": "Vancouver Island"}],
                        multi=True,
                        placeholder="Select health authorities",
                ),
                dcc.RadioItems(className="plot-comparator", id="plot-comparator",
                    options=[
                        {'label': 'Age', 'value': 'age'},
                        {'label': 'Service Type', 'value': 'service_type'},
                    ],
                ),
                dcc.Dropdown(className="plot-basis", id="plot-basis", 
                    multi=False,
                ),
                html.Br(),

                # stacked bar
                dcc.Graph(id='grouped_bar'),
                html.Div(id="test")
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
    cost_summary = pd.DataFrame({'Cost Category': values, "Amount": dff.iloc[:4,index].values})

    # move total sum to end of df
    first_row = cost_summary.head(1)
    cost_summary = cost_summary.iloc[1:]
    cost_summary = pd.concat([cost_summary, first_row], ignore_index=True)

    return cost_summary.to_dict('records')


# cascading plot dropdown
@app.callback(
    Output('plot-basis', 'options'),
    [Input('plot-comparator', 'value')]
)
def update_plot_basis(comparator):
    if comparator == "age":
        options = [
            {"label": "Emergency Care", "value": "emergency"},
            {"label": "Family Doctor", "value": "family medicine"},
            {"label": "Virtual Care", "value": "virtual"},
            {"label": "Hospitalization", "value": "hospitalization"}
        ]
    else:
        options = [
            {"label": "0-14 years", "value": "0-14"},
            {"label": "15-64 years", "value": "15-64"},
            {"label": "65+ years", "value": "65+"}
        ]
    return options

# stacked bar graph responsive to basis and comparator
@app.callback(
    Output("grouped_bar", "figure"), 
    [Input(component_id='multi_slct-ha', component_property='value'),
     Input(component_id='plot-comparator', component_property='value'),
     Input(component_id='plot-basis', component_property='value'),]
)
def grouped_bar(health_auths, comparator, basis):
    ha_list = []
    groups = []

    if (comparator == "age"):
        groups = ["0-14", "15-64", "65+"]
    else:
        groups = ["emergency", "family medicine", "virtual", "hospitalization"]

    listCosts =[]
    dff = df2.copy() #always make a copy of df
    dff =dff[["service_type", "health_authority", "ctas_admit", "age", "Total"]]

    if health_auths is not None: 
        for ha in health_auths:
            ha_list.append(ha)

        for group in groups:
            # age
            cost_list = []
            for ha in ha_list:
                if (comparator == "age"):
                    if (basis == "virtual"):
                        total = dff[(dff["service_type"] == "virtual")
                            & (dff["age"] == group)]["Total"].values[0] 
                    else:
                        total = dff[(dff["health_authority"] == ha) & (dff["service_type"] == basis)
                            & (dff["age"] == group)]["Total"].values[0]
                else:
                    if (group == "virtual"):
                          total = dff[(dff["service_type"] == "virtual")
                            & (dff["age"] == basis)]["Total"].values[0]         
                    else:             
                        total = dff[(dff["health_authority"] == ha) & (dff["service_type"] == group)
                            & (dff["age"] == basis)]["Total"].values[0] 
                     
                total = total[1:].replace(",", "").strip()
                cost_list.append(float(total))
            listCosts.append(cost_list) #list of lists

    # for each ha, append that total cost to y value chart
    fig = go.Figure()
    for i in range(len(groups)):
        hover_text = [f"Health Authority: {ha} Total Cost: {cost:,.2f}" for ha, cost in zip(ha_list, listCosts[i])]
        fig.add_trace(go.Bar(
            name=groups[i],
            x=ha_list,
            y=listCosts[i],
            hovertemplate="%{hovertext}",
            hovertext=hover_text,
            customdata=hover_text  # Use hover text as click data
        ))

    fig.update_layout(barmode='group')
    return fig

@app.callback(
    Output("test", "children"),
    [Input("grouped_bar", "clickData")]
)
def handle_hover(hover_data):
    if hover_data is not None:
        # Process the hover data
        # Access relevant information from hover_data and perform desired actions
        return f"Hovered Data: {hover_data}"
    else:
        return "No hover data"

# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=True) 