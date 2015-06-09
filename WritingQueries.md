# Introduction #

Queries are used in the DAAP protocol to narrow the informations you want to get from the server. You can think of them as SQL queries.

# Details #

My knowledge on this is rather incomplete. But here are the things that I noted:

the general form of a query is
```
'key:value'
```

query statements can be grouped by adding parenthesis:

```
('key:value','key2:value2')
```

| **operator** | **description** |
|:-------------|:----------------|
|:             |equals           |
|,             |OR operator      |
|+             |AND operator     |
|!             |NOT operator     |

here are a few examples and their description:

|`daap.songalbumid:459`|gets the songs for a specific album|
|:---------------------|:----------------------------------|
|`'com.apple.itunes.mediakind:8'`|gets the items of a specific media kind|
|`('com.apple.itunes.mediakind:1','com.apple.itunes.mediakind:32')`|gets the items for 2 specific media kinds|
|`(('com.apple.itunes.mediakind:4','com.apple.itunes.mediakind:6')+'daap.songalbum!:')`|gets the items for 2 specific media kinds as soon as the songalbum (the album name) field is not empty|
