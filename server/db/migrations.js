var MONGO_URL = process.env.MONGO_URL || 'localhost/uliheckmann';

const db = require('monk')(MONGO_URL);

const Settings = db.get('settings');
const Sections = db.get('sections');

var promises = []

var settingsPromise = Settings.update({}, {$setOnInsert: {background_color: '#004344', background_music: '../../media/soundtrack32.mp3'}}, {upsert: true});
promises.push(settingsPromise);

var sectionPromises = [{
  title: 'cars',
  parent: 'portfolio',
  enabled: true,
  hover_image: '../../media/menu_fill_portfolio_cars.jpg'
},
{
  title: 'people',
  parent: 'portfolio',
  enabled: true,
  hover_image: '../../media/menu_fill_portfolio_people.jpg'
},
{
  title: 'moods',
  parent: 'portfolio',
  enabled: true,
  hover_image: '../../media/menu_fill_portfolio_moods.jpg'
},
{
  title: 'cars',
  parent: 'archive',
  enabled: true,
  hover_image: '../../media/menu_fill_archive_cars.jpg'
},
{
  title: 'people',
  parent: 'archive',
  enabled: true,
  hover_image: '../../media/menu_fill_archive_people.jpg'
},
{
  title: 'contact',
  parent: null,
  enabled: true,
  hover_image: '../../media/menu_fill_contact.jpg'
},
{
  title: 'clients',
  parent: null,
  enabled: true,
  hover_image: '../../media/menu_fill_clients.jpg'
}].map(function (section) {
  return Sections.update({title: section.title, parent: section.parent}, {$setOnInsert: section}, {upsert: true});
});

promises.push(Promise.all(sectionPromises));


Promise.all(promises).then(function () {
  console.log('Migrations Done');
  process.exit();
}, function(err) {
  console.log('Migrations Failed ', err);
});
