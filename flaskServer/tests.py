#!flask/bin/python
import os
import unittest

from config.development import basedir
from app import app, db
from app.models import User, Apartment

class UserTests(unittest.TestCase):
    def setUp(self):
        app.config['TESTING'] = True
        app.config['WTF_CSRF_ENABLED'] = False
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'test.db')
        self.app = app.test_client()
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()

    def test_user_create(self):
        u = User('john', 'password', 'john@example.com', '9254402540')
        db.session.add(u)
        db.session.commit()
        users = User.query.all()
        
        u = users[0]
        assert u.username == 'john'
        assert u.password == 'password'
        assert u.email == 'john@example.com'
        assert u.phone == '9254402540'

class ApartmentTests(unittest.TestCase):
    def setUp(self):
        app.config['TESTING'] = True
        app.config['WTF_CSRF_ENABLED'] = False
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'test.db')
        self.app = app.test_client()
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()

    def test_apartment_create(self):
        a = Apartment(aptname='squad')
        db.session.add(a)
        db.session.commit()
        apartments = Apartment.query.all()
        
        a = apartments[0]
        assert a.aptname == 'squad'
        assert a.users == []

if __name__ == '__main__':
    unittest.main()