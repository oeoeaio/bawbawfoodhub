// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require smooth-scroll
//= require_tree ./application

$(document).ready(function() {
  $(document).foundation();

  // Fix for issue #4275 on zurb/foundation, use until pull #5988 or similar is merged
  $('[data-equalizer]').data('equalizer-init', Foundation.libs.equalizer.settings);

  $('#scroll-for-more a').smoothScroll({speed: 'auto', autoCoefficient: 1});
});
