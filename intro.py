from dash import Dash, dcc, html # pip install dash (version 2.0.0 or higher) 
import dash

app = Dash(__name__,use_pages=True)


# ------------------------------------------------------------------------------
# app layout: contains dash components and html
app.layout = html.Div(className="main-content", children=[
    html.H1( children=["PATIENT & FAMILY HEALTHCARE COSTS ACROSS BRITISH COLUMBIA"]),
    html.Div(className="navbar", children=[ 
        html.Div(
            dcc.Link(
            f"{page['name']}",
            href=page["relative_path"],
            className="navbar-link"  # Add the CSS class name to the link
            )
        )
        for page in dash.page_registry.values()
    ]),
    dash.page_container
])

# ------------------------------------------------------------------------------
# Connect the Plotly graphs with Dash Components
# each callback has inputs and outputs, along with a function with arguments that realte to each input


# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=True) 