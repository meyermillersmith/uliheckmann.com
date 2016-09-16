window.App = App || {};

App.Router = Backbone.Router.extend({
  routes: {
    "": "home",
    "section/:section": "section"
  },

  initialize: function() {
  },

  home: function() {
    if(this.currentView) this.currentView.remove();
    this.currentView = (new App.HomeView());
    this.currentView.render();
    $('.js-main-region').html(this.currentView.el);
  },

  section: function(section) {

    var _this = this;
    $.getJSON(`/cms/api/section/${section}`).then(function(response) {
      if(_this.currentView) _this.currentView.remove();
      _this.currentView = (new App.SectionView({model: response}));
      _this.currentView.render();
      $('.js-main-region').html(_this.currentView.el);
    });
  }
});

$(document).ready(function() {
  new App.Router();
  Backbone.history.start();
});



App.HomeView = Backbone.View.extend({
  events: {
    'click .js-home-submit-button': 'clickedSubmit',

  },

  template: Handlebars.compile($('.js-home-template').html()),

  clickedSubmit() {
    var _this = this;
    var formData = new FormData();

    var color = $('.js-bgcolor-input').val();
    if(color !== '') formData.append('background_color', color);

    var musicFiles = this.$('.js-music-file').get(0).files;
    if(musicFiles.length) {
      formData.append('background_music_file', musicFiles[0], musicFiles[0].name);
    }

    $.ajax({
      url: '/cms/api/settings',
      type: "POST",
      data: formData,
      processData: false,
      contentType: false
    })
    .then(function(response) {
      alert('Settings Updated');
      if(response.file) _this.$('.js-background-music').attr('src', response.file);
    })
    .fail(function(response) {
      alert(`Somthing went wrong with image upload. \n\n ${JSON.stringify(response, null, 2)}`);
    })

  },


  render: function() {
    this.$el.html(this.template({settings: window.App.settings}));
  }
});


App.SectionView = Backbone.View.extend({
  events: {
    'submit .js-hover-image-form': 'onHoverImageSubmit',
    'click .js-section-status-toggle': 'onStatusToggle',
    'change .js-gallery-new-image': 'addImage',
    'click .js-gallery-image-remove': 'clickedRemoveImage'
  },

  template: Handlebars.compile($('.js-section-template').html()),

  onHoverImageSubmit: function(event) {
    event.preventDefault();
    var _this = this;

    var hoverImageFiles = this.$('.js-hover-image-file').get(0).files;
    if(hoverImageFiles.length) {
      var formData = new FormData();
      formData.append('file', hoverImageFiles[0], hoverImageFiles[0].name);

      $.ajax({
        url: `/cms/api/section/${this.model._id}`,
        type: "POST",
        data: formData,
        processData: false,
        contentType: false
      })
      .then(function(response) {
        if(response.file) _this.$('.js-hover-image').attr('src', response.file);
      })
      .fail(function(response) {
        alert(`Somthing went wrong with image upload. \n\n ${JSON.stringify(response, null, 2)}`);
      })
    }

  },

  onStatusToggle: function() {
    var _this = this;
    this.model.enabled = !this.model.enabled;

    $.post(`/cms/api/section/${this.model._id}`, {enabled: this.model.enabled})
    .then(function(response) {
      _this.$('.js-section-status').html(response.enabled ? 'enabled' : 'disabled');
      _this.$('.js-section-status-toggle').html(response.enabled ? 'Disable it.' : 'Enable it.');
    })
    .fail(function(response) {
      alert(`Somthing went wrong with status change. \n\n ${JSON.stringify(response, null, 2)}`);
    })
  },



  addImage: function() {
    var _this = this;
    var formData = new FormData();
    var files = this.$('.js-gallery-new-image').get(0).files;
    if(files.length) {
      formData.append('file', files[0], files[0].name);

      $.ajax({
        url: `/cms/api/section/${this.model._id}/add-image`,
        type: "POST",
        data: formData,
        processData: false,
        contentType: false
      })
      .then(function(response) {
        if(response.file) {
          _this.$('.gallery').append(`<li data-id='${response.id}' style='background-image: url("${response.file}")'><i class='gallery__image-remove js-gallery-image-remove'></i></li>`)
        }
      })
      .fail(function(response) {
        alert(`Somthing went wrong with image upload. \n\n ${JSON.stringify(response, null, 2)}`);
      })


    }
  },

  clickedRemoveImage: function(event) {
    var $target = $(event.target).closest('li');
    var image_id = $target.data('id')
    $target.remove();
    $.post(`/cms/api/section/${this.model._id}/remove-image/${image_id}`);
  },

  render: function() {
    var _this = this;
    this.$el.html(this.template(this.model));

    if(this.model.parent) {
      var el = this.$('#gallery').get(0);
      var sortable = Sortable.create(el, {
        onEnd: function () {
          var order = sortable.toArray();
          $.post(`/cms/api/section/${_this.model._id}/reorder-images`, {images: order});
        }
      });
    }
    return this;
  }

});
