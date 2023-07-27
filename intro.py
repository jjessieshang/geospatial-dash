import pandas as pd
import plotly.express as px  # (version 4.7.0 or higher)
import plotly.graph_objects as go
from dash import Dash, dcc, html, Input, Output, dash_table, ctx  # pip install dash (version 2.0.0 or higher) 
import dash

app = Dash(__name__,use_pages=True)

# ------------------------------------------------------------------------------

# costs dataframe cleaning and preprocessing 
df2 = pd.read_csv("data/P&F Costs Data/P&F Costs Simplified.csv", delimiter=",", encoding="utf-8", header=0)
df2.reset_index(inplace=True)
df2 = df2.rename(columns={'lost_productivity': 'Lost Productivity', 'informal_caregiver': 'Informal Caregiver', 'out_of_pocket': 'Out of Pocket', 
                          'cost_value': 'Total'})

# ------------------------------------------------------------------------------
# app layout: contains dash components and html
app.layout = html.Div(className="main-content", children=[
    html.H1(className="dash-title", children=["PATIENT & FAMILY HEALTHCARE COSTS ACROSS BRITISH COLUMBIA"]),
    html.Div(className="main-row", children=[
        html.Div(className="column1", children=[
            html.H3(className="section-title", 
                    children=["Geospatial Costing Dashboard"]),
            html.P(className="section-description", 
                children=["Explore the estimated costs that patients and their families pay for four types of care across British Columbia. Click on the bar graph to view a breakdown of the visitation costs."]),
            html.Br(),
            # dropdown menus
            html.Label(className="select-label", children="Select Health Authorities"),
            # multi select?
            dcc.Dropdown(className="options", id="multi_slct-ha",
            options=[
                {"label": "Northern", "value": "Northern"},
                {"label": "Interior", "value": "Interior"},
                {"label": "Vancouver Coastal", "value": "Vancouver Coastal"},
                {"label": "Fraser", "value": "Fraser"},
                {"label": "Vancouver Island", "value": "Vancouver Island"}],
                    multi=True,
            ),
            html.Br(),
            html.Label(className="select-label", children="Select Comparator"),
            dcc.RadioItems(className="options", id="plot-comparator",
                options=[
                    {'label': 'Age', 'value': 'age'},
                    {'label': 'Service Type', 'value': 'service_type'},
                ],
            ),
            html.Br(),
            html.Label(className="select-label", children="Select Visitation Category"),
            dcc.Dropdown(className="options", id="plot-basis", 
                multi=False,
            ),

            html.Button(className="reset",
                        id="reset",
                        children=["RESET"])
        ]),

        html.Div(className="column2", children=[
                # stacked bar
                html.Div(className="plot", children=[
                    html.H3(className="component-title", id="plot-title"),
                    html.Hr(),
                    dcc.Graph(id='grouped_bar'),
                ]),

                # NEW TABLE
                html.Div(className="table", 
                    children=[
                        html.H3(className="component-title", id="table-title",
                                children=["Cost Subunit Breakdown"]),
                        html.P(className="section-title", id="table-description"),
                        html.Hr(),
                        dash_table.DataTable(
                        id="table",
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
                ]),
                html.Div(
                    [
                        html.Div(
                            dcc.Link(
                                f"{page['name']} - {page['path']}", href=page["relative_path"]
                            )
                        )
                        for page in dash.page_registry.values()
                    ]
                ),
                                # stacked bar
                # html.Div(className="plot2", children=[
                #     fig7.show()
                # ]),
        ]),
    ]),
    dash.page_container
])

# ------------------------------------------------------------------------------
# Connect the Plotly graphs with Dash Components
# each callback has inputs and outputs, along with a function with arguments that realte to each input

# cascading plot dropdown
@app.callback(
    Output('plot-basis', 'options'),
    [Input('plot-comparator', 'value')]
)
def update_plot_basis(comparator):
    if comparator == "age":
        options = [
            {"label": "Emergency Care", "value": "emergency"},
            {"label": "Family Medicine", "value": "family medicine"},
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
    colors = ['#0055B7', '#00A7E1', '#6EC4E8', '#97D4E9']

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
        # Create your custom JSON data for each point
        if comparator == "age":
            custom_json_data = [{"health authority": ha, "service type": basis, "age": groups[i]} for ha in zip(ha_list)]
            hover_text = [f"{ha}, Cost: {cost:,.2f}" for ha, cost in zip(ha_list, listCosts[i])]
        else:
            custom_json_data = [{"health authority": ha, "service type": groups[i], "age": basis} for ha in zip(ha_list)]
            hover_text = [f"{ha}, Cost: {cost:,.2f}" for ha, cost in zip(ha_list, listCosts[i])]

        fig.add_trace(go.Bar(
            name=groups[i],
            marker_color=colors[i],
            x=ha_list,
            y=listCosts[i],
            hovertemplate="%{hovertext}",
            hovertext=hover_text,
            customdata=custom_json_data  # Use hover text as click data
        ))
    fig.update_layout(
        barmode='group', 
        template="simple_white",
        legend=dict(
        orientation="h",
        yanchor="bottom",
        y=1.02,
        xanchor="right",
        x=1),
        margin=dict(t=50, b=50, l=50, r=30)
    )
    
    fig.update_yaxes(tickprefix="$", showgrid=True)

    fig.update_layout(legend=dict(
    orientation="h",
    yanchor="bottom",
    y=1.02,
    xanchor="right",
    x=1
))
    return fig

# costs table entries
@app.callback(
    [Output("table", "data"), 
     Output("table-description", "children")],
    [Input("grouped_bar", "clickData")]
)
def graph_update_table(click_data):
    dff = df2.copy() #always make a copy of df
    dff =dff[["service_type", "health_authority", "ctas_admit", "age", "Total", "Lost Productivity", "Informal Caregiver","Out of Pocket"]]

    if click_data is not None:
        # Access relevant information from hover_data and perform desired actions
        data = click_data["points"][0]["customdata"]
        service_slctd = data['service type']
        ha_slctd = data['health authority'][0]
        age_slctd = data['age']

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
            index = dff.loc["ctas_admit"].tolist().index('1-3')
            index2 = dff.loc["ctas_admit"].tolist().index('4-5')
        else:
            index = 0

        values = ["Total", "Lost Productivity", "Informal Caregiver","Out of Pocket"]
        cost_summary = pd.DataFrame({'Cost Category': values, "Amount": dff.iloc[:4,index].values})

         # move total sum to end of df
        first_row = cost_summary.head(1)
        cost_summary = cost_summary.iloc[1:]
        cost_summary = pd.concat([cost_summary, first_row], ignore_index=True)

        if (service_slctd == "emergency"):
            cost_summary['CTAS Level'] = ['1-3', '1-3', '1-3', '1-3']

            additional_rows_df = pd.DataFrame({'Cost Category': values, "Amount": dff.iloc[:4, index2].values})
            first_row = additional_rows_df.head(1)
            additional_rows_df = additional_rows_df.iloc[1:]
            additional_rows_df = pd.concat([additional_rows_df, first_row], ignore_index=True)
            additional_rows_df['CTAS Level'] = ['4-5', '4-5', '4-5', '4-5']

            # Concatenate the additional rows with the cost_summary DataFrame
            cost_summary = pd.concat([cost_summary, additional_rows_df], ignore_index=True)

            # Create a multi-index by combining 'Category' and 'Cost Category'
            cost_summary.set_index(['CTAS Level', 'Cost Category'], inplace=True)
            cost_summary.reset_index(inplace=True)
        return cost_summary.to_dict('records'), f"Health Authority: {ha_slctd} | Service Type: {service_slctd} | Age: {age_slctd}"
    else:
        # Return an empty table with a 2x2 structure
        empty_table_data = {
            'Column 1': ['', ''],
            'Column 2': ['', '']
        }
        empty_table = pd.DataFrame(empty_table_data)

        return empty_table.to_dict('records'), ""
    
# responsive plot title
@app.callback(
    Output("plot-title", "children"),
    [Input(component_id='plot-comparator', component_property='value'),
     Input(component_id='plot-basis', component_property='value'),]
)
def handle_hover(comparator, basis):
    button_clicked = ctx.triggered_id
    if (basis is not None) and (button_clicked == 'plot-basis'):
        if (comparator == "age"):
            head = "Service Type:"
        else:
            head = "Age:"

        return f"Total Single Visitation Cost ({head} {basis})"
    else:
        return "Total Single Visitation Cost"
    

# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=True) 