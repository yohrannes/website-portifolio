import flask
from flask import Flask, render_template, jsonify, request

app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/')
def index(methods=['POST']):
  return render_template('index.html')
def toggle_element():
  global show_element
  if request.is_json and 'toggle' in request.json:
    show_element = not show_element

  return jsonify({'show_element': show_element})


if __name__ == "__main__":
  app.run(host="0.0.0.0", debug=True, port="5000")