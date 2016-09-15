# uliheckmann.com

## Requirements

mongodb, node, bower


## Installation

```bash
git clone git@github.com:meyermillersmith/uliheckmann.com.git
cd uliheckmann.com
npm install
bower install
```


## Running

### Locally
```bash
sudo mkdir -p /data/db; sudo mongod
node server/db/migrations;  node server/server.js
```


### Production
```bash
sudo mkdir -p /data/db; sudo mongod
MONGO_URL='localhost/uliheckmann' node server/db/migrations; NODE_ENV=production MONGO_URL='localhost/uliheckmann' UPLOAD_PATH=‘/path/to/uploads’ node server/server.js
```
