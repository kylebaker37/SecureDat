from app import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    password = db.Column(db.String(64), index=False, unique=False)
    email = db.Column(db.String(120), index=True, unique=True)
    phone = db.Column(db.String(10), index=True, unique=False)
    aid = db.Column(db.Integer, db.ForeignKey('apartment.id'))

    def __init__(self, username, password, email, phone):
        self.username = username
        self.password = password
        self.phone = phone
        self.email = email

    def add_to_apartment(self, aid):
    	  self.aid = aid

    def __repr__(self):
        return '<User %r>' % (self.username)

class Apartment(db.Model):
  id = db.Column(db.Integer, primary_key=True)
  aptname = db.Column(db.String(64), index=True, unique=False)
  latitude = db.Column(db.String(64), index=False, unique=False)
  longitude = db.Column(db.String(64), index=False, unique=False)
  users = db.relationship('User', backref='apartment', lazy='select')    

  def __repr__(self):
    return '<Apartment %r>' % (self.aptname)

#TODO: later if we get to it... invites to apartments... 
#class JoinPermission(db.Model):
