All the requests take the form of http://server:3689/ctrl-int/1/command-name



# playstatusupdate #

  * **Request** /playstatusUpdate
    * **Params**
      * **revision-number** revision number
      * **session-id** session id
  * **Response** avdb
  * **Description** Jeff Sharkey says

> "Something important to note is the revision-number field. By starting with revision-number=1, we know that we'll always get a response. However, a new revision-number is returned in the cmsr field. If we request that new revision-number, our HTTP request hangs until the next server event happens, providing push event notification. For example, our request might hang until the user manually changes tracks on the computer, or pauses the track, or maybe a TCP timeout happens."

This is true but from what I've seen the request tends to return and completely reset the state of your session, forcing you to login again.

  * **Content**
```
cmst
  mstt(4) - status 
  cmsr(4) - revision-number 
  caps(1) - play status: 4=playing, 3=paused 
  cash(1) - shuffle status: 0=off, 1=on 
  carp(1) - repeat status: 0=none, 1=single, 2=all
  cavc(1) - <Unknown> 
  caas(4) - <Unknown> 
  caar(4) - <Unknown> 
  canp(16) - it has to be split in 4 sets of 4 bytes
    first 4 bytes - database id
    second 4 bytes - container id
    third 4 bytes - unsure (album-id?)
    fourth 4 bytes - item (song) id
  cann(var) - track name
  cana(var) - artist name
  canl(var) - album name 
  cang(0) - <Unknown>
  asai(8) - album-id 
  cmmk(4) - <Unknown> 
  cant(4) - remaining track time in ms 
  cast(4) - total track length in ms
```

# getproperty #

  * **Request** /getproperty
    * **Params**
      * **properties** properties list separated by commas
      * **session-id** session id
  * **Response** cmgt
  * **Description** edits a property. The properties that can be get and set are:
    * **dmcp.volume** volume
    * **dacp.shufflestate** shuffle state
    * **dacp.repeatstate** repeat state
    * **dacp.playingtime** play head position in the track

  * **Content**
```
cmgt
  mstt(4) - status 
  cmvo(4) - volume 
  cant(4) - remaining track time in ms 
  cast(4) - total track length in ms
  cash(1) - shuffle state
  carp(1) - repeat state
```

# setproperty #

  * **Request** /setproperty
    * **Params**
      * key-value pair (e.g. dmcp.volume=57)
      * **session-id** session id
  * **Response** 

&lt;empty&gt;


  * **Description** edits a property. The response body is empty which means that it is up to the client to verify that the new value has been correctly set. The properties that can be get and set are:
    * **dmcp.volume** volume
    * **dacp.shufflestate** shuffle state
    * **dacp.repeatstate** repeat state
    * **dacp.playingtime** play head position in the track

  * **Content**
```

```