from flask import Flask, request, jsonify, Response
from app import app, models, db

@app.route('/health_check', methods = ['GET'])
def health_check():
    return Response(response="OK", status=200)


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

@app.route('/api/door_opened', methods = ['GET'])
def door_opened():
	  json = request.get_json()
	  aid = json['aid']
	  return jsonify({'success!':'apartment alerted!'})
	  #...get phone numbers for each of the users in that apartment, and call twilio to alert
	  #...later could add check to determine if any users are in the apartment before using twilio alerts