import flask
from flask import Flask, render_template, request, redirect, jsonify
import subprocess
import os

# Intern routes

app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/server-info')
def get_server_info():
    hostname = os.popen('hostname').read().strip()
    date_command = 'date +"%Y-%m-%d %H:%M:%S"'  # Customize date format
    last_updated = os.popen(date_command).read().strip()
    return jsonify({'hostname': hostname, 'last_updated': last_updated})

@app.route('/')
def index():
  return render_template('index.html')

@app.route('/contact')
def contact():
    return render_template('getintouch.html')

@app.route('/whoami')
def whoami():
    return render_template('whoami.html')

@app.route('/websitespecs')
def websitespecs():
    return render_template('website-specs.html')

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

if __name__ == "__main__":
  app.run(host="0.0.0.0", debug=True, port="5000")
