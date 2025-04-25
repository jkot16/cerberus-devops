from flask import Flask, jsonify, render_template_string
import os

app = Flask(__name__)

LOG_FILE = "/app/cerberus.log"


@app.route('/')
def home():
    return "Hello from Cerberus"

@app.route('/ping')
def ping():
    return jsonify({"status": "ok"})

@app.route('/status')
def status():
    logs = []
    if os.path.exists(LOG_FILE):
        with open(LOG_FILE, 'r') as f:
            logs = f.readlines()[-10:]

    html = f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <link rel="icon" href="/static/favicon.ico">
        <title>Cerberus Status</title>
        <style>
            body {{
                background-color: #000000;
                color: white;
                font-family: 'Segoe UI', sans-serif;
                padding: 2em;
                text-align: center;
            }}
            img {{
                width: 350px;
                filter: drop-shadow(0 0 10px #000);
                animation: pulse 2s infinite;
                margin-bottom: 20px;
            }}
            h1 {{
                margin-bottom: 20px;
                font-size: 1.8em;
                color: #fff;
                text-shadow: 0 0 10px #ff6a00;
            }}
            pre {{
                background: #1e1e1e;
                padding: 1em;
                border-radius: 10px;
                max-width: 800px;
                margin: 0 auto;
                text-align: left;
                overflow-x: auto;
            }}
            @keyframes pulse {{
                0%   {{ filter: drop-shadow(0 0 5px #ff6a00); }}
                50%  {{ filter: drop-shadow(0 0 25px #ff6a00); }}
                100% {{ filter: drop-shadow(0 0 5px #ff6a00); }}
            }}
        </style>
    </head>
    <body>
        <img src="/static/cerberus-logo.png" alt="Cerberus Logo" />
        <h1>Status logs</h1>
        <pre>{''.join(logs)}</pre>
    </body>
    </html>
    """
    return render_template_string(html)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
