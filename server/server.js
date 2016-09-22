
var express = require('express');
var fileUpload = require('express-fileupload');
var sizeOf = require('image-size');
var Jimp = require("jimp");
var uuid = require('node-uuid');
var path = require('path');


var fs = require('fs');
var exphbs  = require('express-handlebars');
var http = require('http');
var auth = require('basic-auth');
var bodyParser = require('body-parser');


var app = express();
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
app.use(fileUpload());

var NODE_ENV = process.env.NODE_ENV || 'development';
var UPLOAD_PATH = process.env.UPLOAD_PATH || 'public/uploads';
var MONGO_URL = process.env.MONGO_URL || 'localhost/uliheckmann';
var CMS_USERNAME = process.env.CMS_USERNAME || 'uli';
var CMS_PASSWORD = process.env.CMS_PASSWORD || 'heckmann';


var hbs = exphbs.create({
    helpers: {
      raw: function(options){return options.fn();},
      json_stringify: function(obj){return JSON.stringify(obj)}
    }
});

app.engine('handlebars', hbs.engine);

app.set('view engine', 'handlebars');
app.set('views', 'server/views');

app.use('/uploads', express.static(UPLOAD_PATH));
app.use(express.static('public'));
app.use(express.static('bower_components'));



const db = require('monk')(MONGO_URL);
const Settings = db.get('settings');
const Sections = db.get('sections');
const PortfolioImages = db.get('portfolio_images');



app.get(['/', '/index.html'], function(req, res) {
  Settings.findOne().then(function (settings) {
    res.render('index', settings);
  });
});


app.get('/cms', function(req, res) {
  if(NODE_ENV === 'production') {
    var credentials = auth(req)
    if (!credentials || credentials.name !== CMS_USERNAME || credentials.pass !== CMS_PASSWORD) {
      res.statusCode = 401
      res.setHeader('WWW-Authenticate', 'Basic realm="example"')
      res.end('Access denied')
    } else {
      Settings.findOne().then(function(settings) {
        res.render('cms', {settings: settings});
      });
    }
  } else {
    Settings.findOne().then(function(settings) {
      res.render('cms', {settings: settings});
    });
  }
});

app.post('/cms/api/settings', function(req, res) {

  var promises = [];
  var data = {};

  var background_color = req.body.background_color;
  if(background_color) {
    data.background_color = background_color;
  }

  if(req.files && req.files.background_music_file) {
    var musicPromise = new Promise(function(resolve, reject) {
      var file = req.files.background_music_file;
      var fileExt = path.extname(file.name);
      var fileId = uuid.v4();
      var fileName = `${fileId}${fileExt}`;
      var finalFilePath = path.join(UPLOAD_PATH, fileName);

      file.mv(finalFilePath, function(err) {
        if(err) return reject({status: 'fail', error: err});
        data = Object.assign(data, {
          background_music: `/uploads/${fileName}`,
          background_color: background_color
        });
        resolve();
      });
    });
    promises.push(musicPromise);
  }

  if(req.files && req.files.hover_file) {
    console.log('hover_file ', req.files.hover_file);
    var hoverPromise = new Promise(function(resolve, reject) {
      var file = req.files.hover_file;
      var fileExt = path.extname(file.name);
      var fileId = uuid.v4();
      var fileName = `${fileId}${fileExt}`;
      var finalFilePath = path.join(UPLOAD_PATH, fileName);

      file.mv(finalFilePath, function(err) {
        if(err) return reject({status: 'fail', error: err});
        data = Object.assign(data, {
          hover_image: `/uploads/${fileName}`
        });
        resolve();
      });
    });
    promises.push(hoverPromise);
  }

  Promise.all(promises).then(() => {
    Settings.findOneAndUpdate({}, {$set: data}).then((updatedDoc) => {
      updatedDoc.status = 'success';
      res.send(updatedDoc);
    });
  });
});


app.get(`/cms/api/section/:id`, function(req, res) {
  var id = req.params.id;
  var idSplit = id.split('_');
  var parent = idSplit.length === 2 ? idSplit[0] : null;
  var title = idSplit.length === 2 ? idSplit[1] : idSplit[0];

  Sections.findOne({title: title, parent: parent})
  .then(function(section) {
    PortfolioImages.find({section_id: section._id.toString()}, {sort: {'position': 1}})
    .then(function(images) {
      section.images = images;
      res.send(section);
    })
  });
});


app.post(`/cms/api/section/:id`, function(req, res) {
  var id = req.params.id;

  if(req.files) {
    var file = req.files.file;
    var fileName = file.name
    var finalFilePath = path.join(UPLOAD_PATH, fileName);

    file.mv(finalFilePath, function(err) {
      var dimensions = sizeOf(finalFilePath);
      if(err) return res.status(500).send({status: 'fail', error: err});

      Sections.findOneAndUpdate({_id: id}, {$set: {hover_image: `/uploads/${fileName}`}}).then((updatedDoc) => {
        res.send({status: 'success', file: `/uploads/${fileName}`});
      });

    });
  }

  if(req.body.enabled) {
    Sections.findOneAndUpdate({_id: id}, {$set: {enabled: req.body.enabled === 'true'}}).then((updatedDoc) => {
      res.send({status: 'success', enabled: req.body.enabled === 'true'});
    });
  }
});


app.post(`/cms/api/section/:id/add-image`, function(req, res) {
  var id = req.params.id;


  if(req.files) {
    var file = req.files.file;
    var fileExt = path.extname(file.name);
    var fileId = uuid.v4();
    var fileName = `${fileId}${fileExt}`;

    var finalFilePath = path.join(UPLOAD_PATH, fileName);
    file.mv(finalFilePath, function(err) {
      if(err) return res.status(500).send({status: 'fail', error: err});

      PortfolioImages.count().then(function(count) {
        var dimensions = sizeOf(finalFilePath);

        Jimp.read(finalFilePath).then(function (image) {
          image.resize(88, 100)
           .write(path.join(UPLOAD_PATH, `${fileId}_thumb${fileExt}`));

           PortfolioImages.insert({
             path: `/uploads/${fileName}`,
             path_thumb: `/uploads/${fileId}_thumb${fileExt}`,
             section_id: id,
             position: count
           })
           .then(function(image) {
             image.status = 'success';
             res.send(image);
           });
        }).catch(function (err) {
            console.error(err);
        });

      });

    });
  }
});

app.post(`/cms/api/section/:id/remove-image/:image_id`, function(req, res) {
  var id = req.params.id;
  var image_id = req.params.image_id;

  PortfolioImages.remove({_id: image_id})
  // .then(function() {
    res.send({status: 'success'});
  // })
  // .fail(function(err) {
  //   if(err) return res.status(500).send({status: 'fail', error: err});
  // });
});

app.post(`/cms/api/section/:id/update-image/:image_id`, function(req, res) {
  var id = req.params.id;
  var image_id = req.params.image_id;
  console.log(req.body);
  if(req.body && req.body.fill) req.body.fill = req.body.fill == 'true';
  PortfolioImages.findOneAndUpdate({_id: image_id}, {$set: req.body})
  .then(function() {
    res.send({status: 'success'});
  })
  // .fail(function(err) {
  //   if(err) return res.status(500).send({status: 'fail', error: err});
  // });
});



app.post(`/cms/api/section/:id/reorder-images`, function(req, res) {
  var id = req.params.id;
  var images = req.body.images;

  var promises = images.map(function(image_id, index) {
    return PortfolioImages.findOneAndUpdate({_id: image_id}, {$set: {position: index}});
  });


  Promise.all(promises).then(function() {

    res.send({status: 'success'});
  }, function(err) {

    return res.status(500).send({status: 'fail', error: err});
  });

});


app.get(`/api/navigation.xml`, function(req, res) {
  var navigation = {};
  Sections.find({enabled: true}).then(function(sections) {
    sections.forEach(function(section) {
      if(section.parent === null) return navigation[section.title] = section;
      navigation[section.parent] = navigation[section.parent] || {};
      navigation[section.parent][section.title] = section;
    });

    Settings.findOne().then(function (settings) {
      res.render('xmls/navigation.xml.handlebars', {navigation: navigation, settings: settings});
    });
  });
});


app.get('/api/assets.xml', function(req, res) {
  Settings.findOne().then(function(settings) {
    res.render('xmls/assets.xml.handlebars', settings);
  });
});


[
// 'archive_cars.xml',
// 'archive_people.xml',
// 'portfolio_cars.xml',
// 'portfolio_moods.xml',
// 'portfolio_people.xml',
'clients.xml',
'contact.xml'].forEach((file) => {
  app.get(`/api/${file}`, function(req, res) {
    res.render(`xmls/${file}.handlebars`);
  });
});


app.get(`/api/:id.xml`, function(req, res) {
  var id = req.params.id;
  var idSplit = id.split('_');
  var parent = idSplit.length === 2 ? idSplit[0] : null;
  var title = idSplit.length === 2 ? idSplit[1] : idSplit[0];

  Sections.findOne({title: title, parent: parent})
  .then(function(section) {
    PortfolioImages.find({section_id: section._id.toString()}, {sort: {'position': 1}})
    .then(function(images) {
      section.images = images;

      res.render(`xmls/section.xml.handlebars`, section);
    });
  });
});


var listener = app.listen(process.env.PORT || 3000, '127.0.0.1', function () {
  console.log('Server Started');
});
