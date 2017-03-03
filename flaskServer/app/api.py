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
	  return jsonify({'success':'user created', 'id':u.id})

@app.route('/api/add_apartment', methods = ['POST'])
def add_apartment():
	  json = request.get_json()
	  aptname = json['aptname']
	  latitude = json['latitude']
	  longitude = json['longitude']
	  a = models.Apartment(aptname=aptname, latitude=latitude, longitude=longitude)
	  db.session.add(a)
	  db.session.commit()
	  return jsonify({'success':'apartment created!', 'id':a.id})

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
			  print 'user {} added to apartment {}'.format(user.username, aid)
	  return jsonify({'success':'users added to apartment!'})
	else:
	  return jsonify({'error':'apartment does not exist!'})

@app.route('/api/apartment_location', methods = ['GET'])
def apartment_location():
  aid = request.args.get('aid')
  apartment = models.Apartment.query.get(aid)
  return jsonify({'latitude':apartment.latitude, 'longitude':apartment.longitude})

@app.route('/api/update_user_location_status', methods = ['POST'])
def update_user_location_status():
  json = request.get_json()
  uid = json['uid']
  at_home = json['at_home']
  user = models.User.query.get(uid)
  user.at_home = at_home
  db.session.commit()
  return jsonify({'success':'user {} now has at_home status {}'.format(user.username, user.at_home)})

@app.route('/api/user_location_status', methods = ['GET'])
def user_location_status():
  uid = request.args.get('uid')
  user = models.User.query.get(uid)
  return jsonify({'at_home':user.at_home})

@app.route('/api/door_opened', methods = ['POST'])
def door_opened():
	  json = request.get_json()
	  aid = json['aid']
	  apartment = models.Apartment.query.get(aid)
	  if apartment is None:
	  	return jsonify({'error':'apartment id does not exist!'})
	  else:
	    users = apartment.users
	    users_at_home = []
	    for user in users:
	      if user.at_home == True:
	        users_at_home.append(user.username)
	    if not users_at_home:
	      twil = Messenger.Messenger()
	      for user in users:
	        message = "Your door is open!!! :O"
	        twil.sendMessage(user.phone, message)
	        print 'sent {} to {}'.format(message, user.phone)
	      return jsonify({'success':'apartment alerted!'})
	    else:
	      return jsonify({'users_at_home':users_at_home, 'info': 'no one alerted'})
	  #...get phone numbers for each of the users in that apartment, and call twilio to alert
	  #...later could add check to determine if any users are in the apartment before using twilio alerts