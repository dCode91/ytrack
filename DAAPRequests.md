

# login #
  * **Request** daap://server/login
  * **Params**
    * **pairing-guid** hexadecimal value of the pairing code (e.g. 0x549361C47D6CDA53)
  * **Response** mlog
  * **Description** Provides session information to use for the rest of the session.  If `requiresLogin` is set in the server-info, then from this point on, a basic http authentication header needs to be included with the request.  It is basically a header of the form:

Authentication: base64encodedusernamepassword

where the base64 encoded password is the string: `username:password` base64 encoded (obviously replacing username and password with the appropriate values).  Username appears to be meaningless.

  * **Content**
```
mlog
  mstt	status
  mlid	session id (used in remaining requests below)
```

# logout #
# content-codes #
  * **Request** daap://server/content-codes
  * **Response** mccr
  * **Description** Provides a dictionary of content codes, names, and size information.
  * **Content**
```
mccr
  mstt(4)		status
  mdcl(var)		dictionary entry (one for each type)
    mcna(var)	item name
    mcnm(4)	item number
    mcty(2)	item type
```
# server-info #
  * **Request** daap://server/server-info (or http://server:3689/)
  * **Response** msrv
  * **Description** Provides basic negotiation info on what the server does and doesn't support and protocols.
  * **Content**
```
msrv
  mstt(4) - status
  mpro(4) - dmap protocol version  
  minm(var) - server name
  apro(4) - daap protocol
  aeSV(4) - music sharing version
  ated(2) - does the server supports extradata?
  asgr(2) - 
  asse(8) - 
  aeMQ(1) - 
  aeFR(1) - 
  aeTr(1)
  aeSL(1)
  aeFP (1)
  aeSR(1)
  aeSX(8)
  msed(1)
  ceWM(var) - welcome message
  ceVO(1) - 
  msml - 
    msma - 
  mslr(1) - is login required?
  mstm - timeout interval
  msal(1) - does the server support auto-logout?
  msas(1) - authentication scheme
  msup(1) - does the server support update?
  mspi(1) - does the server support persistent ids?
  msex(1) - does the server support extensions?
  msbr(1) - does the server support browsing?
  msqy(1) - does the server support queries?
  msix(1) - does the server support indexing?
  msrs(1) - does the server support resolve?  (needs persistent ids)
  msdc(4) - databases count
  mstc(4) - utc time
  msto(4) -   utc offset
```

# databases #
  * **Request** daap://server/databases
  * **Params**
    * **session-id** session id
  * **Response** avdb
  * **Description** This provides a list of databases served up by the server.  At present, it appears that only one db per server is the norm, but it may be possible to have multiple servers. A database can then be queried to get either containers, groups or 'bags' of items grouped by a query (see [WritingQueries](WritingQueries.md))

  * **Content**
```
avdb
  mstt(4) - status
  muty - update type - always 0 for now
  mtco - total number of matching records
  mrco - total number of records returned
  mlcl - listing of records
    mlit - single record
      miid - database id (<dbid> in subsequent requests)
      mper - database persistent id
      minm - database name
      mimc - number of items (songs) in the database
      mctc - number of containers (playlists) in the database
```


# playlist list #
  * **Request** daap://server/databases/**_dbid_**/containers
  * **Params**
    * **session-id** session id
    * **meta** the DMAP and DAAP metadata you want to get as a list separated by commas
  * **Response** aply
  * **Description** This provides a list of the playlists. Here is the list of what Remote asks for : dmap.itemname,dmap.itemcount,dmap.itemid,dmap.persistentid,daap.baseplaylist,com.apple.itunes.special-playlist,com.apple.itunes.smart-playlist,com.apple.itunes.saved-genius,dmap.parentcontainerid,dmap.editcommandssupported,com.apple.itunes.jukebox-current,daap.songcontentdescription

  * **Content**
here the list corresponds to the items requested to the server but it could be longer if you requested more informations
```
aply
  mstt - status
  muty - update type(0)
  mtco - matched items
  mrco - items in response
  mlcl
    mlit - playlist entry (one per playlist)
      miid - the playlist's itemid (plid below)
      mper - the playlist's persistent id
      minm - the playlist's name
      mimc - the number of items in the playlist 
      abpl - if value is 1 (interpret it as true), this playlist is your base library (called Music in iTunes)
      mpco - parent container id
      meds - edit commands supported
      aeSP (optional) - boolean to indicate if this playlist is a 'Smart Playlist' 
      aePS (optional) - type identifier for the playlist. this could be one of the following values:
         1 podcast library
         2 iTunesDJ library
         4 Movies library
         5 TVShows library
         6 Music Library
         7 Books Library
         8 Purchased library
         9 PurchasedOnDeviceLibrary
         12 Genius library
         13 iTunesU library
         15 GeniusMixes library
         16 GenisMix library
      aeSG - saved Genius
      ceJI - jukebox current
      ascn - song content description
        
```

# container #
  * **Request** daap://server/databases/**_dbid_**/containers/**_container\_id_**/items
  * **Params**
    * **session-id** session id
    * **meta** the DMAP and DAAP metadata you want to get as a list separated by commas
    * **type** the type of items you request (e.g. music)
    * **sort** the column on which you sort (e.g. album,name,releasedate)
    * **query** query delimited by single quotes (e.g. 'daap.songalbumid:%qi') see [WritingQueries](WritingQueries.md)
  * **Response**
  * **Description** This provides a list of the tracks (or any other item if the container is anything else than a music playlist) with the requested metadata. Here is the list Remote asks for: dmap.itemname,dmap.itemid,daap.songartist,daap.songalbumid,daap.songalbum,daap.songartist,dmap.containeritemid,daap.songuserrating,daap.songtime,daap.songstoptime,daap.songtracknumber
  * **Content**
here the list corresponds to the items requested to the server but it could be longer (or shorter) if you requested more (or less) informations
```

        
```