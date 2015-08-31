# Encrypt your backups

### Desc
For encrypting and store n bckups on your host or on remote.

### Features
* Processing archives one at a time. 
* Encrypts that archive and storing it with encrypted key. 
* n Archives stored in <your_bck_location> (conf.sh).
* n Enc archives and enc keys are stored in <your_enc_location> (conf.sh).
* n Last archives will be cleared from <your_bck_location> on every runtime.
* n Last enc'ted archives & enc'ted keys will be cleared from <your_enc_location> on every runtime.
* Encryption using ssl described in this [gist](https://gist.github.com/truetamtam/dd75b9dc95f3244a78a0)