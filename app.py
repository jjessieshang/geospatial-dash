from dash import Dash, dcc, html, callback, Input, Output, State # pip install dash (version 2.0.0 or higher) 
import dash
import dash_bootstrap_components as dbc

app = Dash(__name__,use_pages=True, external_stylesheets=[dbc.themes.BOOTSTRAP])


# ------------------------------------------------------------------------------
# app layout: contains dash components and html
app.layout = html.Div(className="main-content", children=[
    html.H1(children=["cost SHARING FOR HEALTH SERVICES ACROSS BRITISH COLUMBIA"]),
    html.Div(className="navbar", children=[
        html.Div([
            dcc.Link(
                f"{page['name']}", 
                href=page["relative_path"],
                className="navbar-link"
            )
            for page in dash.page_registry.values()
        ]),
        html.Button(" ? ", id="open", className="help"),  # Apply the same class as page links
        dbc.Modal(
            [
                dbc.ModalHeader("Need Help?"),
                dbc.ModalBody(children=[
                    html.H3("Costing Page"),
                    html.P("Customize the analysis using the left panel - select the health authorities of interest, comparison parameters, and cost visitation category. Then interact with the graph to view detailed information."),
                    html.P("Age: cost sharing varies across age categories"),
                    html.P("Visitation Type: family practictioner, virtual, etc"),
                    html.Img(src="assets/graph-instr.jpg", className="img-fluid"),  # Replace with the actual image path

                    html.Br(),
                    html.Br(),
                    html.H3("Map Page"),
                    html.P("Customize the analysis using the left panel - select the health authorities of interest, comparison parameters, and cost visitation category. Then interact with the graph to view detailed information."),
                    html.P("Distance: Street distance"),
                    html.P("Duration: Times calculated from real traffic data"),
                    html.Img(src="assets/map.jpg", className="img-fluid")  # Replace with the actual image path
                ]),
                dbc.ModalFooter(
                    dbc.Button("Done", id="close", className="ml-auto")
                ),
            ],
            id="modal",
            size="lg",
            scrollable=True,
        ),
    ], 
    ),
    dash.page_container,
    html.Footer(className="footer", children=[
        html.P(html.A("Digital Emergency Medicine", href="https://digem.med.ubc.ca/")),
        html.P("The University of British Columbia"),
        html.P("Developed by: Jessie Shang"),
    ])
])

# ------------------------------------------------------------------------------
# Connect the Plotly graphs with Dash Components
# each callback has inputs and outputs, along with a function with arguments that realte to each input

# modal
@callback(
    Output("modal", "is_open"),
    [Input("open", "n_clicks"), Input("close", "n_clicks")],
    [State("modal", "is_open")],
)
def toggle_modal(n1, n2, is_open):
    if n1 or n2:
        return not is_open
    return is_open

# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=False, host="0.0.0.0", port=8080) 