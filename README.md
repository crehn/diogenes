# Diogenes

Diogenes is a simple commandline client for [PantaRhei](https://github.com/crehn/pantarhei).

## Prerequisites

* Ruby
* Bash
* [HTTPie](https://github.com/jkbrzt/httpie)

## Usage

Create a sip:
```sh
dio c title=foo sourceUri=http://example.com text="this is a test sip" +tag1 +tag2
```
or short:
```sh
dio c t=foo s=http://example.com te="this is a test sip" +tag1 +tag2
```

Query sips by tags:
```sh
dio r +tag1 -tag2
```

Update sip by guid:
```sh
dio u d7c5608f-aa48-4dfa-9506-79e86fd9378a
```

Delete sip by guid:
```sh
dio d d7c5608f-aa48-4dfa-9506-79e86fd9378a
```

Create sip interactively
```sh
dio ci
```
