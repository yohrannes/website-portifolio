import flask
from flask import Flask, abort, render_template, request, redirect, jsonify, render_template_string, send_from_directory
import subprocess
import os

from prometheus_flask_exporter import PrometheusMetrics
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

# Intern routes
# Start flask
app = flask.Flask(__name__)
app.config["DEBUG"] = True

# Start prometheus
metrics = PrometheusMetrics(app)

# Start opentelemetry
trace_exporter = OTLPSpanExporter(endpoint="http://localhost:2525")
provider = TracerProvider()
processor = BatchSpanProcessor(trace_exporter)
provider.add_span_processor(processor)

# Flask instrumentation
FlaskInstrumentor().instrument_app(app)

@app.route('/pod-info')
def get_server_info():
    #hostname = os.popen('hostname').read().strip().lower()
    #date_command = 'date +"%Y-%m-%d %H:%M:%S"'
    #last_updated = os.popen(date_command).read().strip().lower()
    #response = f"oke cluster pod - {hostname} - up at {last_updated}"
    response = f"temporary oci instance"
    return response

@app.template_filter('nl2br') # Filter to use in route response
def nl2br(s):
    return s.replace('\n', '<br>\n')

#@app.route('/auto-deploy-log')
#def get_auto_deploy_log():
#    log_file_path = '/var/log/get-last-commit.log'
#    try:
#        with open(log_file_path, 'r') as file:
#            log_content = file.read()
#    except FileNotFoundError:
#        log_content = 'Log file not found.'
#    response = render_template_string('<pre>{{ log_content }}</pre>', log_content=log_content) # Puting line breaks in the HTML response using <pre> tag
#    return response

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/contact')
def contact():
    return render_template('getintouch.html')

@app.route('/whoami')
def whoami():
    return render_template('whoami.html')

@app.route('/devops')
def websitespecs():
    return render_template('devops.html')

@app.route('/books')
def biblic_readings():
    return render_template('books.html')

# Redirects routes

@app.route('/gcp')
def gcp_skills_redirect():
    return redirect('https://www.cloudskillsboost.google/public_profiles/d446290c-301d-4cec-bf2c-c1e1ba9752f1')

@app.route('/linkedin')
def linkedin_redirect():
    return redirect('https://www.linkedin.com/in/yohrannes')

@app.route('/repo')
def repo_redirect():
    return redirect('https://github.com/yohrannes/website-portifolio')

@app.route('/github')
def github_redirect():
    return redirect('https://github.com/yohrannes')

@app.route('/gitlab')
def gitlab_redirect():
    return redirect('https://gitlab.com/yohrannes')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port="5000")
#    app.run(host="0.0.0.0", debug=True, port="5000")