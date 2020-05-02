from publisher import *

def test_create_tweepy_client():
    api = create_tweepy_client()
    assert api.verify_credentials()


