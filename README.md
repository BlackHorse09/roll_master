# roll master

Roll Master Flutter Application 

## Objective

Objective of this game is to score maximum points by rolling a dice.

## Concept

In this application user get 10 chances to roll a dice. On every roll the score gets added to previous score. Once user is done playing 10 chances, they get added to the Leader Board where they get to see their positions on the basis of the score. User with highest score are on the top of the list. Users can also refresh their 10 chances and new score will be updated.

## Pages

1. Login Page
2. Registration Page
3. Home Page
4. Leader Board Page
5. Splash Page
6. Constants Page
7. Home Page Provider
8. Main.dart Page


# Login Page

-User can log in by entering email and password and can get to the Play Area. The data entered by user is validated by using Firebase Authentication Service 

# Registration Page

-User can register itself by providing first name, last name, email, password. All fields are required. The entries are stored in Firebase Authentication Tab of firebase also in this page we create a user doc with its initial information.

# Home Page

-Home Page is our play area where users can role dice. 
-Users are able to see their remaining chances, their total score, current dic image. Users can also see their profile and also can Logout. -Users can also refresh their chance. 
-In this page Custom Clipper class is used to draw the required UI Shape. 
-Also users can navigate to Leader Board Page from Home Page

# Leader Board Page
-This page shows the list of users who have played all their 10 chances. 
-The user with highest score is highlighted and resides on the first position of the list.
-Have used streams to fetch real time data from Firebase.

# Splash Page

-This page is the first page which gets displayed as soon as app has started. 
-After 2 seconds it navigates to Login Page or Home Page depending on the user whether he/she is logged In or not.

# Constants Page

-This page has 2 string values. These values are the name of the collections we are using when we are in production or in development.

# Home Page Provider

-This page contains all the operations performed while users interacting with dice.
-It calculates total score, total chances, Images of dce to be shown depending on the random value between 1-6.
-Apart from these operations it also updates the user doc depending on the score and chances if user quits the application in between.
-Leader Board Add Update is also done in this page.
-This page contains the implementation of Provider Pattern.


# Main.dart Page

-This page is the entry point of our dart code i.e it contains void main and runApp. 
-Providers are also created here.

## Local Storage

-For the local storage, SharedPreferences is used.
-Storing the unique document id and clicking on logout we are clearing our preferences.

## API 

-All API's are implemented using Firebase.
-Aunthentication with Email and Password is also done using Firebase.

## assets

# images
assets/

## KeyStore file detail
storePassword=roll123 , 
keyPassword=roll123 ,
keyAlias=upload

## Plugins

  ## default ios styling
  cupertino_icons: ^0.1.2   

  ## used this package to perform store and update data in Firestore Database	
  cloud_firestore: ^2.2.0

  ## used this package to perform email password Authentication using Firebase	
  firebase_auth: ^1.2.0

  ## used this package to perform Firebase Core API	
  firebase_core: ^1.2.0

  ## used this package to show ANimated Text (Splash Screen)
  animated_text_kit: ^4.2.1

  ## used this package to apply provider pattern in our project
  provider: ^5.0.0
	
  ## font awesome icons plugin
  font_awesome_flutter: ^9.1.0
  
  ## local storage
  shared_preferences: 
  
  ## gives package related information like Build Number, Version, etc
  package_info:
  
  ## for creating launcher icon
  flutter_launcher_icons: ^0.9.0
