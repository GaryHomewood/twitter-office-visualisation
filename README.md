# Twitter Office Visualisation

A 3D rotatable schematic of an office, which animates when a twitter user from a predefined list tweets.  

![image](images/layout.png?raw=true)

![image](images/layout-when-tweeting.png?raw=true)



## OAuth credentials

Connects to Twitter with OAuth, so requires a properties file in the data folder for the sketch:

conf.properties

	# api keys for twitter
	twitter4j.OAuthConsumerKey = <your consumer key>
	twitter4j.OAuthConsumerSecret = <your cosumer secret> 	
	twitter4j.OAuthAccessToken = <your access token>
	twitter4j.OAuthAccessTokenSecret = <your access secret>
	