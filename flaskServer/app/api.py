from flask import Flask, request, jsonify
from app import app, models, db

@app.route('/api/get_messages', methods = ['POST'])
def get_messages():
    json = request.get_json()
    if json['user'] == "larry":
        return jsonify({'messages':['test1', 'test2']})
    return jsonify({'error':'no user found'})

@app.route('/api/add_user', methods = ['POST'])
def add_user():
	  json = request.get_json()
	  username = json['username']
	  password = json['password']
	  email = json['email']
	  phone = json['phone']
	  u = models.User(username, password, email, phone)
	  db.session.add(u)
	  db.session.commit()
	  return jsonify({'updated':'user added!'})