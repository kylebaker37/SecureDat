from app import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    password = db.Column(db.String(64), index=False, unique=False)
    email = db.Column(db.String(120), index=True, unique=True)
    phone = db.Column(db.String(10), index=True, unique=False)

    def __init__(self, username, password, email, phone):
        self.username = username
        self.password = password
        self.phone = phone
        self.email = email

    def __repr__(self):
        return '<User %r>' % (self.username)