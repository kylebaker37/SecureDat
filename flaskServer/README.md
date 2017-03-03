/////////////////////
Running server
/////////////////////

$python server.py <host> <port>

/////////////////////
Server Endpoints API
/////////////////////

Users:
//TODO: return status indicating failure if not unique
/api/add_user (POST)
- body: json
- args:
	- 'username' : String
	- 'password' : String
	- 'email' : String
	- 'phone' : String
- returns json:
	- 'id' : Int

/api/update_user_location_status (POST)
- body: json
- args:
	- 'uid' : Int
	- 'at_home' : Boolean
- returns json
	- 'success' with corresponding message

/api/user_location_status (GET)
- url params:
	- 'uid'
- returns json
	- 'at_home' : Boolean


Apartments:
//TODO: return status indicating failure if not unique
/api/add_apartment (POST)
- body: json
- args:
	- 'aptname' : String
	- 'latitude' : Float
	- 'longitude' : Float
- returns json:
	- 'id' : Int

/api/add_users_to_apartment (POST)
- body: json
- args:
	- 'aid' : Int
	- 'uids' : [Int]
- returns json
	- 'success' OR 'error' (with messages)

/api/apartment_location (GET)
- takes 1 url parm:
	- 'aid'
- returns json
	- 'latitude' : Float
	- 'longitude' : Float


Events:
/api/door_opened (POST)
- body: json
- args:
	- 'aid' : Int
- returns json
	- 'success' when apartment alerted
	- 'error' when apartment doesn't exist or other problem
	- 'users_at_home' : [String]
		- (when no one alerted)
