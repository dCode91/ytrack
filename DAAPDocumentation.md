
# Introduction #

This is an attempt to document the process to connect to DAAP server (mainly iTunes) and control the playback. All the following information has been figured out using a network dump program; the iTunes binary has not be reverse-engineered in any way, and neither have any of the libraries that it links to. In addition, we (the contributors to the project) make no claims that the following information is valid, so use it at your own risk.

This work also relies on several sources of informations which are:
  * [Jeff Sharkey](http://dacp.jsharkey.org/)
  * [another unofficial documentation](http://tapjam.net/daap/)
  * [daap.sourceforge.net](http://daap.sourceforge.net/docs/index.html)


# About protocols #

First of all about the stack. It's still unclear to me what's the difference between several acronyms but I'll try to define them:

**DAAP**: Digital Audio Access Protocol. I think this is the specification of the server in itself. Here is the description on wikipedia:
> A DAAP server is a specialized HTTP server, which performs two functions. It sends a list of songs and it streams requested songs to clients. There are also provisions to notify the client of changes to the server. Requests are sent to the server by the client in form of URLs and are responded to with data in application/x-dmap-tagged mime-type, which can be converted to XML by the client. iTunes uses the ZeroConf (also known as Bonjour) service to announce and discover DAAP shares on a local subnet. The DAAP service uses TCP port 3689 by default.

**DACP**:Digital Audio Control Protocol. This is explained on Wikipedia as being the protocol used the remote clients to connect to a DACP enabled server. From what I understand DACP protocol enables to take control of the server while DAAP is used for read-only use.

**DMAP**:Digital Metadata Access Protocol? The definition is unclear but I think this an acronym to group the definition of the metadata information exchanged between DAAP client and servers. There is more information on this when talking about content-codes below.

From all of this what I can say is that DACP is a 'write-only' superset of the 'read-only' DAAP and both use DMAP to exchange informations.

# Discovery #

As mentioned in Wikipedia, we use Bonjour (zeroConf) to discover a DAAP server. The service to discover is named `_touch-able._tcp`. Jeff Sharkey is also looking up for the `_dacp._tcp` service but I don't think this is useful (and I don't even remember what it returns).

The lookup will return you zero or more services. Each service is a DAAP server. You now have to resolve it to get more informations on the service and especially:
  * its library name
  * its IP address
  * its port

the library name is contained in the TXTRecordData for the service under the `CtlN` key. For the moment it's sufficient to go ahead and connect to the server.

# Pairing #
## Global explanation ##
The pairing process is pretty well explained on Jeff Sharkey's web site. Here is the interesting abstract:

> When a remote client first arrives on the network, it needs to pair itself with iTunes. It does this by advertising a _touch-remote._tcp.local with some TXT entries with information about the remote and a 64-bit Pair hex string:

```
DvNm=Android remote
RemV=10000
DvTy=iPod 
RemN=Remote 
txtvers=1 
Pair=0000000000000001
```

> Michael Croes observed this MDNS format a few weeks ago. In my experience iTunes doesn't like working with all-0 values, so I threw one bit in there to make it happy. Once this service appears on the network, iTunes shows it along the left-edge of its screen. When you click, it prompts you for a 4-digit PIN code. iTunes combines this PIN code with the MDNS Pair value above in what appears to be an MD5 sum. It returns the MD5 to the iPhone/iPod Touch asking "does this match?"

This is where it stopped at some point, but finally [Michael Paul Bailey figured this out](http://jinxidoru.blogspot.com/2009/06/itunes-remote-pairing-code.html) and it turned out that it boils down to just concatenating them together with the pin code digits separated by null characters.

## yTrack specifics ##
In yTrack, here is what I use to advertise the client on the network:
```m

GUID = arc4random() % ((unsigned)RAND_MAX + 1);
NSString * randomPairCode = [NSString stringWithFormat:@"%08X%08X",GUID,GUID];
UIDevice *device = [UIDevice currentDevice];
NSDictionary *dicton = [NSDictionary dictionaryWithObjects:
[NSArray arrayWithObjects: device.name,@"10000",device.model,@"Remote",@"1",randomPairCode,nil] forKeys:[NSArray arrayWithObjects:@"DvNm",@"RemV",@"DvTy",@"RemN",@"txtvers",@"Pair",nil]];
```

which means:
```
DvNm=<device.name>
RemV=10000
DvTy=<device.model> 
RemN=Remote 
txtvers=1 
Pair=<random pair code>
```

The Bonjour code is done by the excellent [HTTPServer](http://code.google.com/p/cocoahttpserver/) class written by Luke Steffen and Robbie Hanson.

When the user has finished entering the four digits, iTunes sends an HTTP request to the server started by yTrack containing the hash based on the digits the user has entered and the pairing code advertised by yTrack. I compute this same hash using the expected pin code and the advertised pairing code. If the user has entered the right digits then my hash and the hash from iTunes should be the same.

The pairing code has to be preciously stored as it is what will be needed to login