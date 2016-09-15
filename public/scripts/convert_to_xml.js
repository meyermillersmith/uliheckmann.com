var fs = require('fs');
var _ = require('underscore');

function getFill(fill) {
  return fill === 1;
}

function getAlign(align) {
  return align === 'R' ? 'right' : 'left';
}

var filenameMap = {
  'people': 'portfolio_people',
  'cars': 'portfolio_cars',
  'archive.cars': 'archive_cars',
  'archive.people': 'archive_people'
};

var titleMap = {
  'people': 'people',
  'cars': 'cars',
  'archive.cars': 'archivecars',
  'archive.people': 'archivepeople'
};

var items = JSON.parse(fs.readFileSync('data.json', 'utf8'));
// console.log(items);

var groupedItems = _.groupBy(items, 'pname');
console.log(_.keys(groupedItems));

for(type in groupedItems) {
  outputXML(type, groupedItems[type]);
}


function outputXML(type, items) {
  var itemsObject = {};

  items.forEach(function(item) {
    if(!itemsObject[item.id]) itemsObject[item.id] = {};
    itemsObject[item.id][item.name] = item;
  });

  var xml = `<?xml version="1.0" encoding="ISO-8859-1"?>
  <!DOCTYPE Gallery SYSTEM "../dtd/gallery.dtd">
  <Gallery>
  	<Title>${titleMap[type]}</Title>
  `;

  for(id in itemsObject) {
    var item = itemsObject[id]
    // console.log(item['preview']);
    var file = item['file'];
    var preview = item['preview'];


    xml += `
      <MediaFile id="${id}">
          <File mediaType="${file.mediaType}" src="../..${file.src}" width="${file.width}" height="${file.height}" align="${getAlign(file.align)}" enableFill="${getFill(file.enableFill)}"/>
          <PreviewFile mediaType="${preview.mediaType}" src="../..${preview.src}" width="${preview.width}" height="${preview.height}"/>
          <Caption/>
      </MediaFile>
    `;
  }

  xml += `
  </Gallery>
  `;
  // console.log(filenameMap[type], titleMap[type]);
  // console.log(xml);

  fs.writeFile(`./output/${filenameMap[type]}.xml`, xml, function(err) {
      if(err) return console.log(err);
      console.log(`${type} was saved!`);
  });
}
