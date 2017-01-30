import csv
import json
import time
import tweepy
import traceback

#TODO: take rate limit into account

# You must use Python 2.7.x
# Rate limit chart for Twitter REST API - https://dev.twitter.com/rest/public/rate-limits
def loadKeys(key_file):
    # TODO: put in your keys and tokens in the keys.json file,
    #       then implement this method for loading access keys and token from keys.json
    # rtype: str <api_key>, str <api_secret>, str <token>, str <token_secret>

    #Loading key file
    f = open(key_file, 'r')
    data = json.load(f);
    return data['api_key'],data['api_secret'],data['token'],data['token_secret']

# Assusme that we only have 2 kinds of request - ask for followers and ask for friends
# i.e.,  the method itself doesn't need any additional args
def limit_handled(cursor):
    
    while True:
        try:
            yield cursor.next()
        except tweepy.RateLimitError:
            print "Got Rate limit error - sleeping for 60s"
            time.sleep(60)
        except tweepy.TweepError:
            if tweepy.TweepError.message[0]['code'] == 401:
                print 'Private user; Moving on...'
                break
        except Exception as e: 
            traceback.print_exc()
            
            
def getFollowers(api, root_user, no_of_followers):
    primary_followers = []
    
    while True:
        try:
            print 'Finding followers for ' + root_user
            for user in tweepy.Cursor(api.followers, screen_name=root_user).items(no_of_followers):
                primary_followers.append((user.screen_name, root_user))
            break
        
        except tweepy.RateLimitError:
                print "Rate Limit Error. Sleeping for 60s..."
                time.sleep(60)
                continue
            
        except tweepy.TweepError:
            print 'Got TweepError - could be 401. Break loop'
            traceback.print_exc()
            break
        
        except Exception as genE:
            print 'Got general error - no idea what happened. break loop'
            traceback.print_exc()
            break
        
    return primary_followers

def getFollowers1(api, root_user, no_of_followers):
    primary_followers = []
    
    print "finding followers for " + root_user
    
    for user in limit_handled(tweepy.Cursor(api.followers, screen_name=root_user).items(no_of_followers)):
        primary_followers.append((user.screen_name, root_user))
            
    return primary_followers

# Q1.b - 5 Marks
# api: ref to the Twitter api
# root user: username of root user
# no_of_followers: max num of followers to fetch
# API LIMIT: 15 reqs/15mins => Sol: sleep 60s after every request
def getFollowers2(api, root_user, no_of_followers):
    # TODO: implement the method for fetching 'no_of_followers' followers of 'root_user'
    # rtype: list containing entries in the form of a tuple (follower, root_user)
        
    #TODO: double check rate limit stuff => handle this
    primary_followers = []
    counter = 0
    
    for user in tweepy.Cursor(api.followers, screen_name=root_user).items():
        if counter == no_of_followers:
            break
        else:
            primary_followers.append((user.screen_name, root_user))
            print root_user + "'s follower: " + user.screen_name
            counter += 1
            
    # Add code here to populate primary_followers
    return primary_followers

# Q1.b - 7 Marks
def getSecondaryFollowers(api, followers_list, no_of_followers):
    # TODO: implement the method for fetching 'no_of_followers' followers for each entry in followers_list
    # rtype: list containing entries in the form of a tuple (follower, followers_list[i])    

    print "\n\nFinding secondary followers\n"
    
    secondary_followers = []
    
    # Add code here to populate secondary_followers
    for follower_tuple in followers_list:
        #Get 10 followers for the current user
        secondary_followers.extend(getFollowers(api, follower_tuple[0], no_of_followers))
        
    return secondary_followers

def getFriends(api, root_user, no_of_friends):
    primary_friends = []
    counter = 0
    print "Finding friends for " + root_user
    
    for user in limit_handled(tweepy.Cursor(api.friends, screen_name=root_user).items()):
        if counter == no_of_friends:
            print "Found enough friends. Exiting..."
            break
        else:
            primary_friends.append((root_user, user.screen_name))
            counter += 1
            
    return primary_friends

# Q1.c - 5 Marks
def getFriends2(api, root_user, no_of_friends):
    # TODO: implement the method for fetching 'no_of_friends' friends of 'root_user'
    # rtype: list containing entries in the form of a tuple (root_user, friend)
    
    #Get root_user obj
    #root_user_obj = api.get_user(root_user)
    
    counter = 0
    primary_friends = []
    
    #for friend in root_user_obj.friends():
    #    if counter >= 10:
    #        break
    #    else:
    #        counter += 1
    #        primary_friends.append((root_user, friend))
    
    for user in tweepy.Cursor(api.friends, screen_name=root_user).items():
        if counter == no_of_friends:
            break
        else:
            primary_friends.append((root_user, user.screen_name))
            print root_user + "'s friend: " + user.screen_name
            counter += 1
    
    # Add code here to populate primary_friends
    return primary_friends

# Q1.c - 7 Marks
def getSecondaryFriends(api, friends_list, no_of_friends):
    # TODO: implement the method for fetching 'no_of_friends' friends for each entry in friends_list
    # rtype: list containing entries in the form of a tuple (friends_list[i], friend)
    secondary_friends = []
    
    # Add code here to populate secondary_friends
    for friend_tuple in friends_list:
        secondary_friends.extend(getFriends(api, friend_tuple[1], no_of_friends))
    
    return secondary_friends

# Q1.b, Q1.c - 6 Marks
def writeToFile(data, output_file):
    # write data to output_file
    # rtype: None
    
    f = open(output_file, 'w')
    for line in data:
        f.write(line[0] + ', ' + line[1] + '\n')
    
    pass

"""
NOTE ON GRADING:

We will import the above functions
and use testSubmission() as below
to automatically grade your code.

You may modify testSubmission()
for your testing purposes
but it will not be graded.

It is highly recommended that
you DO NOT put any code outside testSubmission()
as it will break the auto-grader.

Note that your code should work as expected
for any value of ROOT_USER.
"""

def testSubmission():
    KEY_FILE = 'keys.json'
    OUTPUT_FILE_FOLLOWERS = 'followers.csv'
    OUTPUT_FILE_FRIENDS = 'friends.csv'

    ROOT_USER = 'PoloChau'
    NO_OF_FOLLOWERS = 10
    NO_OF_FRIENDS = 10

    api_key, api_secret, token, token_secret = loadKeys(KEY_FILE)

    auth = tweepy.OAuthHandler(api_key, api_secret)
    auth.set_access_token(token, token_secret)
    api = tweepy.API(auth)

    primary_followers = getFollowers(api, ROOT_USER, NO_OF_FOLLOWERS)
    secondary_followers = getSecondaryFollowers(api, primary_followers, NO_OF_FOLLOWERS)
    followers = primary_followers + secondary_followers

    #primary_friends = getFriends(api, ROOT_USER, NO_OF_FRIENDS)
    #secondary_friends = getSecondaryFriends(api, primary_friends, NO_OF_FRIENDS)
    #secondary_friends = []
    #friends = primary_friends + secondary_friends

    writeToFile(followers, OUTPUT_FILE_FOLLOWERS)
    #writeToFile(friends, OUTPUT_FILE_FRIENDS)


if __name__ == '__main__':
    testSubmission()

