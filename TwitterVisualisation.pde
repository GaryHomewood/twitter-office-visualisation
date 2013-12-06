import processing.opengl.*;
import java.util.Properties;

float r = 0;
float rdelta = 1;
int pulseCount = 1;

int screenNameIdx = 0;
// twitter users being followed
String[] screenNames = { "GaryHomewood", "rayui", "paulcarvill", "agentdeal", "cordial", "wearymadness", "Kained", "TheRealRiaz",  "naturalgrump", "lexbefriends", "kylife", "jul14n", "dan_bradshaw" };

// floorplan; desk, empty space or a tweeter
String[][] floor1 = {
    { "", "desk", "desk", "desk", "", "@naturalgrump", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "@rayui", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "", "", "", "", "", "", "", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "@wearymadness", "", "desk", "desk", "desk", "", "desk"},
    { "", "@dan_bradshaw", "@jul14n", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
};

String[][] floor2 = {
    {"", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    {"", "desk", "desk", "desk", "", "desk", "@kylife", "desk", "", "desk"}, 
    {"", "desk", "@lexbefriends", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    {"", "desk", "desk", "@TheRealRiaz", "", "desk", "desk", "desk", "", "desk"}, 
    {"", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    {"", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    {"", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    {"", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    {"", "", "", "", "", "", "", "", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    {"", "desk", "desk", "desk", "", "desk", "@cordial", "desk", "", "desk"}, 
    {"", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    {"", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
};

String[][] floor3 = {
    {"", "desk", "desk", "desk", "", "@agentdeal", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "@GaryHomewood", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "", "", "", "", "", "", "", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
};

String[][] floor4 = {
    {"", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""}, 
    { "", "desk", "desk", "desk", "", "@Kained", "desk", "desk", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""}, 
    {"", "desk", "desk", "desk", "", "desk", "desk", "@paulcarvill", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""}, 
    { "", "", "", "", "", "", "", "", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""}, 
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", "desk"},
    { "", "desk", "desk", "desk", "", "desk", "desk", "desk", "", ""},
};

String tweet = "";
TwitterStream twitterStream;
StatusListener listener;

void setup() {
    size(800, 600, OPENGL);
    background(255);
    lights();
    frameRate(20);
    smooth();
    getStream();
}

/**
* set up the twitter stream, watching the specified list of users
*/
void getStream() {
    // twitter stream listener
    listener = new StatusListener() {
        public void onStatus(Status status) {
            System.out.println("@" + status.getUser().getScreenName() + " - " + status.getText());
            pulseCount = 0;
            tweet = "@" + status.getUser().getScreenName() + " - " + status.getText();
        }

        public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
            System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
        }

        public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
            System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
        }

        public void onScrubGeo(long userId, long upToStatusId) {
            System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
        }

        public void onException(Exception ex) {
            ex.printStackTrace();
        }
        
        public void onStallWarning(StallWarning w) {
        }
    };

    ConfigurationBuilder cb = getConfigurationBuilder();
    twitterStream = new TwitterStreamFactory(cb.build()).getInstance();
    twitterStream.addListener(listener);
  
    // users to follow
    long[] followArray = getUsersToFollow();
  
    // kewords to track, not used
    String[] trackArray = {};
  
    // filter() method internally creates a thread which manipulates TwitterStream and calls listener methods continuously.
    twitterStream.filter(new FilterQuery(0, followArray));
}

/**
* convert a list of twitter handles to a list of twitter ids
*/
long[] getUsersToFollow() {
    // get an array of twitter user ids
    ArrayList<Long> follow = new ArrayList<Long>();

    try {
        ConfigurationBuilder cb = getConfigurationBuilder();
        Twitter twitter = new TwitterFactory(cb.build()).getInstance();
        ResponseList<User> users = twitter.lookupUsers(screenNames);
        for (User user : users) {
            if (user.getStatus() != null) {
                follow.add((user.getId()));
            } else {
              // the user is protected
            }
        }
    } catch (TwitterException ex) {
        ex.printStackTrace();
        System.out.println("Failed to lookup users: " + ex.getMessage());
    }

    // convert 
    long[] followArray = new long[follow.size()];
    for (int i = 0; i < follow.size(); i++) {
        followArray[i] = follow.get(i);
    }
    return followArray;
}

/**
* get a configuration builder for authenticated calls to twitter
*/
ConfigurationBuilder getConfigurationBuilder() {
    ConfigurationBuilder cb = new ConfigurationBuilder();
  
    try {
        // load a configuration from a file inside the data folder
        Properties props = new Properties();
        props.load(openStream("conf.properties"));
        cb.setDebugEnabled(true)
            .setOAuthConsumerKey(props.getProperty("twitter4j.OAuthConsumerKey", ""))
            .setOAuthConsumerSecret(props.getProperty("twitter4j.OAuthConsumerSecret", ""))
            .setOAuthAccessToken(props.getProperty("twitter4j.OAuthAccessToken", ""))
            .setOAuthAccessTokenSecret(props.getProperty("twitter4j.OAuthAccessTokenSecret", ""));
    } catch (Exception ex) {
        System.out.println("Failed to init: " + ex.getMessage());
    }
    return cb;
}

void draw() {
    // the drawing loop
    background(0);
    stroke(127, 127, 127);
    strokeWeight(1);
    translate(350, height/2, 0);

    // rotate map on the y axis with the mouse
    if (mouseX == 0) {
        rotateY(0.435);
    } else {
        rotateY(map(mouseX, 0, width, 0, PI));
    }

    // draw the 3D map, floor by floor
    translate(-150, 150, -100);
    drawFloor(1, floor1);
    translate(0, -90, 0);
    drawFloor(2, floor2);
    translate(0, -70, 0);
    drawFloor(3, floor3);
    translate(0, -80, 0);
    drawFloor(4, floor4);
}

void drawFloor(int floorNumber, String[][] floorPlan) {
    // iterate through all points for a floor
    int rows = floorPlan.length;
    int cols = floorPlan[0].length;
  
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          String user = floorPlan[i][j];

          if (user.length() == 0) {
              // no desk; draw a small cross
              if (tweeter(tweet)) {
                  // dimmed if there's a tweet being displayed
                  stroke(100);
              } else {
                  stroke(192);
              }
              int a = 2;
              line(a * -1, 0, 0, a, 0, 0);
              line(0, a * -1, 0, 0, a, 0);
              line(0, 0, a * -1, 0, 0, a);
          } else if (user.startsWith("@")) {
              // tweeting desk in red
              stroke(#CD2626);
              fill(#F1001C);
              box(20, 1, 10);

              // if this desk is tweeting, display a pulsing orb and a tweet 
              if (tweet.startsWith(user)) {
                  translate(0, 0, 0);
                  stroke(0, 0, 255);
                  fill(0, 0, 255);
                  r += rdelta;
                  
                  if ((r > 8) || (r < 1)) {
                      rdelta = rdelta * -1;
                  }
                  
                  if (r < 1) {
                      pulseCount++;
                  }
                  
                  if (pulseCount < 6) {
                      textSize(18);
                      fill(#4099ff);
                      text(tweet, -8, -15, 0);
                      noStroke();
                      lights();
                      fill(64, 153, 255);
                      sphere(r);
                      noLights();
                  } else {
                      tweet = "";
                  }
                  
                  translate(0, 0, 0);
              }
          } else {
              // desk
              if (tweeter(tweet)) {
                  // dimmed if there's a tweet being displayed
                  stroke(50);  
                  fill(75);
              } else {
                  stroke(192);
                  fill(150);
              }
              box(20, 1, 10);
          }
          translate(30, 0, 0);
        }
        
        translate(-300, 0, 20);
    }
    //reset to origin
    translate(0, 0, -300);
}

/**
* check a captured tweet
*/
boolean tweeter(String tweet) {
    // see if the captured tweet is from someone being followed
    boolean tweeter = false;
    if (tweet.length() > 0) {
        // get the screenname from the tweet
        String screenName = tweet.substring(1, tweet.indexOf(" ") );
        for (String following : screenNames) {
            if (following.equals(screenName)) {
                tweeter = true;
                break;
            }
        }
    }
    return tweeter;
}

void keyPressed() {
    // demo a tweet being received
    if ((keyCode == RIGHT) || (keyCode == LEFT)) {
        pulseCount = 0;
        tweet = "@" + screenNames[screenNameIdx] + " has tweeted...";
        if (keyCode == RIGHT) {
            screenNameIdx++;
            if (screenNameIdx == screenNames.length) {
                screenNameIdx = 0;
            }
        } else if (keyCode == LEFT) {
            screenNameIdx--;
            if (screenNameIdx == -1) {
                screenNameIdx = screenNames.length - 1;
            }
        }
    }

    // save a screenshot
    if (keyCode == DOWN) {
        saveFrame("tweeters-####.png");
    }
  
    println(tweet);
}
