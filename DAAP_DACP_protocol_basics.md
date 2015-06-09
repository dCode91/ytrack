# Introduction #

Here I have paraphrased existing documentation, trying to give details or correct things

# Protocol basics #

At it's heart, DAAP is the latest in a long line of protocols that
uses HTTP as it's underlying transport mechanism.  It appears to
prefer using the connection-oriented HTTP/1.1 - though there is also
some support, it seems, for HTTP/1.0.  This document will focus on the
HTTP/1.1 implementation, and assume that the HTTP/1.0 implementation
is around for some strange legacy reason.

While the requests are normal URLs (documented further below), the
responses have the mime-type application/x-dmap-tagged.  This type
appears to be a flattened form of a plist or xml formatted file.  (In
fact, it would be fairly trivial to write an x-dmap-tagged to xml
converter, with just a little bit of foreknowledge on the specific
tags).

The basic format of DAAP (expanded on below) is:

> `4 byte tag | size (4 byte int) | data`

where the length of the data is determined by the size.

Very early on in the DAAP conversation, a 'map' of content codes,
their long name, and their types gets sent back.  This map is used to
provide the basic description for a number of fields used in various
points further down.

An example, simple dmap-tagged block, the response to a /login
request:

```
	GET /login?pairing-guid=0x549361C47D6CDA53&hasFP=1 HTTP/1.1
Host	169.254.169.95:3689
User-Agent	Remote/271
Accept-Encoding	gzip
Client-Daap-Version	3.10
Viewer-Only-Client	1
Accept	*/*
Accept-Language	fr-fr
Connection	keep-alive
```
```
	HTTP/1.1 200 OK
Date	Mon, 07 Mar 2011 11:22:40 GMT
DAAP-Server	iTunes/10.1.2 (Mac OS X)
Content-Type	application/x-dmap-tagged
Content-Length	47
Content-Encoding	gzip
```


Here is the hexadecimal representation of the response body:

```
00000000  6d 6c 6f 67 00 00 00 18 6d 73 74 74 00 00 00 04   mlog    mstt    
00000010  00 00 00 c8 6d 6c 69 64 00 00 00 04 0f 44 4d 4a       mlid     DMJ
```

or:
```
mlog (24 bytes)
  mstt - 200  (4 bytes)
  mlid - 8158 (4 bytes)
```

For container types the data can, itself contain more code/size/data blocks.  Lists will contain multiple code/size/data blocks, one for each item in the list.

All sizes are in bytes and count only the following data block.

Note that the headers of the request must include
```
Viewer-Only-Client	1
```


## Glossary ##

  * **Container:** a container is a group of tracks. This group can be either a smart playlist, a user playlist, an album, ...
  * **Database:** a database is physically the root, the database of your DAAP server.
  * **Group:** a group may be a group of containers

## Additional notes ##

  * daap://server can be interchanged with http://server:3689 for purposes of coding/using command line utilities such as curl/wget to poke at things
  * The parameters have to passed to the request using HTTP GET style: http://server:3689/request?param1=value1&param2=value2
  * the mlcl tag is a list of items and contains items named mlit
  * the DACP requests can be distinguished from DAAP requests by the fact they use `ctrl-int` in the request url path. I interpret the name as 'control interruption'.