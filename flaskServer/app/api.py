from flask import Flask, request, jsonify, Response, send_from_directory
from app import app, models, db
from helpers import Messenger

@app.route('/health_check', methods = ['GET'])
def health_check():
    return Response(response="OK", status=200)


@app.route('/api/add_user', methods = ['POST'])
def add_user():
  result = "error"
  message = "default failure message"
  uid = -1
  json = request.get_json()
  username = json['username']
  password = json['password']
  email = json['email']
  phone = json['phone']

  if(models.User.query.filter_by(username=username).first() is not None):
    message = "Username taken"
  elif(models.User.query.filter_by(email=email).first() is not None):
    message = "Email taken"
  else:
    u = models.User(username, password, email, phone)
    db.session.add(u)
    db.session.commit()
    result = "success"
    message = "User account successfully created!"
    uid = u.id
  return jsonify({'result':result, 'message':message, 'id':uid})

@app.route('/api/find_user_by_email', methods = ['GET'])
def find_user_by_email():
  email = request.args.get('email')
  user = models.User.query.filter_by(email=email).first()
  if user is not None: 
    return jsonify({'username':user.username, 'id':user.id, 'at_home': user.at_home, 'email':user.email, 'phone':user.phone, 'aid':user.aid})
  else:
     return jsonify({'username':'', 'id':'', 'at_home':'', 'email':'', 'phone':'', 'aid':''})

@app.route('/api/user', methods = ['GET'])
def user():
  uid = request.args.get('uid')
  user = models.User.query.get(uid)
  return jsonify({'username':user.username, 'id':user.id, 'at_home': user.at_home, 'email':user.email, 'phone':user.phone, 'aid':user.aid})

@app.route('/api/login', methods = ['POST'])
def login():
  json = request.get_json()
  username = json['username']
  password = json['password']
  user = models.User.query.filter_by(username=username).first()
  if user is None:
    return jsonify({'result':'error', 'message':'user does not exist'})
  elif (user.password != password):
    return jsonify({'result':'error', 'message':'password is incorrect'})
  else:
    return jsonify({'result':'success', 'id':user.id, 'username': user.username, 'aid':user.aid, 'email':user.email, 'phone': user.phone, 'at_home': user.at_home})

@app.route('/api/apartment', methods= ['GET'])
def apartment():
  aid = request.args.get('aid')
  a = models.Apartment.query.get(aid)
  userids = []
  usernames = []
  users_at_home = []
  for user in a.users:
    userids.append(user.id)
    usernames.append(user.username)
    users_at_home.append(user.at_home)
  return jsonify({'aptname':a.aptname, 'aid':a.id, 'latitude': a.latitude, 'longitude':a.longitude, 'userids':userids, 'usernames':usernames, 'users_at_home': users_at_home})

@app.route('/api/find_apartment', methods= ['GET'])
def find_apartment():
  aptname = request.args.get('aptname')
  apt = models.Apartment.query.filter_by(aptname=aptname).first()
  if apt is not None: 
    return jsonify({'aptname':apt.aptname, 'latitude':apt.latitude, 'longitude':apt.longitude, 'aid':apt.id})
  else:
     return jsonify({'aptname':'', 'latitude':0.0, 'longitude':0.0, 'aid':-1})

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
  if 'type' in json:
    tpe = json['type']
  else:
    tpe = 'door'
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
        if tpe == 'door':
          message = "Your door is open!!! :O"
        else:
          message = "Motion detected in your apartment!!! :O"
        twil.sendMessage(user.phone, message)
        print 'sent {} to {}'.format(message, user.phone)
      return jsonify({'success':'apartment alerted!'})
    else:
      return jsonify({'users_at_home':users_at_home, 'info': 'no one alerted'})
  #...get phone numbers for each of the users in that apartment, and call twilio to alert
  #...later could add check to determine if any users are in the apartment before using twilio alerts

@app.route('/api/update_vid_path', methods = ['POST'])
def update_vid_path():
  json = request.get_json()
  aid = json['aid']
  path = json['path']
  apartment = models.Apartment.query.get(aid)
  if apartment is None:
    return jsonify({'error':'apartment id does not exist!'})
  v = models.Video(path=path)
  db.session.add(v)
  apartment.vids.append(v)
  db.session.commit()
  return jsonify({'success':'video path updated'})

@app.route('/api/vid/<aid>/<filename>', methods = ['GET'])
def send_video(aid, filename):
  return send_from_directory('/Users/kyle/Desktop/', filename)
  # TODO - Set real file path on ras pi
  # TODO - Look into 206/Broken Pipe/Weird Errors

@app.route('/api/videos', methods = ['GET'])
def send_video_list():
  videos = models.Video.query.all()
  to_return = {'videos': []}
  for video in videos:
    to_return['videos'].append(video.path.split('/')[-1])
  return jsonify(to_return)

