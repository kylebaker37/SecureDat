from flask import Flask, request, jsonify, Response
from app import app, models, db
from helpers import Messenger

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
	  return jsonify({'success!':'user created', 'id':u.id})

@app.route('/api/add_apartment', methods = ['POST'])
def add_apartment():
	  json = request.get_json()
	  aptname = json['aptname']
	  latitude = json['latitude']
	  longitude = json['longitude']
	  a = models.Apartment(aptname=aptname, latitude=latitude, longitude=longitude)
	  db.session.add(a)
	  db.session.commit()
	  return jsonify({'success!':'apartment created!', 'id':a.id})

@app.route('/api/add_users_to_apartment', methods = ['POST'])
def add_users_to_apartment():
	json = request.get_json()
	aid = json['aid']
	uids = json['uids']
	apartment = models.Apartment.query.get(aid)
	if apartment is not None:
	  for uid in uids:
		  user = models.User.query.get(uid)
		  if user is not None:
			  apartment.users.append(user)
			  db.session.commit()
			  print 'user {} added to apartment {}'.format(uid, aid)
	  return jsonify({'success!':'users added to apartment!'})
	else:
	  return jsonify({'error!':'apartment does not exist!'})

@app.route('/api/door_opened', methods = ['POST'])
def door_opened():
	  json = request.get_json()
	  aid = json['aid']
	  print 'aid: {}'.format(aid)
	  apartment = models.Apartment.query.get(aid)
	  print 'apartment: {}'.format(apartment)
	  if apartment is None:
	  	return jsonify({'error!':'apartment id does not exist!'})
	  else:
	    users = apartment.users
	    print 'users: {}'.format(users)
	    twil = Messenger.Messenger()
	    for user in users:
	      message = "Your door is open!!! :O"
	      twil.sendMessage(user.phone, message)
	      print 'sent {} to {}'.format(message, user.phone)
	    return jsonify({'success!':'apartment alerted!'})
	  #...get phone numbers for each of the users in that apartment, and call twilio to alert
	  #...later could add check to determine if any users are in the apartment before using twilio alerts