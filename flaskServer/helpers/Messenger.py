import twilio
from twilio.rest import TwilioRestClient

class Messenger(object):
	"""docstring for Messenger"""
	def __init__(self):
		super(Messenger, self).__init__()
		account_sid = "AC859c36858cd31251e284bf87f5ca5033"
		auth_token = "01fbfd9a6732270d6613031503916447"
		self.client = TwilioRestClient(account_sid, auth_token)

	def sendMessage(self, number, msg):
		sentMessage = self.client.messages.create(to=number, from_="+14088981727",body=msg)