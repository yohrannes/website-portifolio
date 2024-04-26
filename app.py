import flask
from flask import Flask, render_template, request, redirect

app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/')
def index():
  return render_template('index.html')

@app.route('/gcp')
def gcp_skills_redirect():
    return redirect('https://www.cloudskillsboost.google/public_profiles/d446290c-301d-4cec-bf2c-c1e1ba9752f1')

if __name__ == "__main__":
  app.run(host="0.0.0.0", debug=True, port="5000")
