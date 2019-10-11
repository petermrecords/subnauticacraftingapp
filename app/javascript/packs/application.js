// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(na/me, true)

// bootstrap
import 'bootstrap'
import '../stylesheets/application'
// jquery
import $ from 'jquery';
global.$ = jQuery;
// select2
import 'select2';
import 'select2/dist/css/select2.css';
import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css'

$(document).ready(function() {
  
  // materials list filtering
  $("#add-materials").on("change", "#material-type-select", function() {
    var selectedType = this.value;
    var listId = $("#list_material_listable_id").val();
    $.ajax({
      url: "/materials/select",
      method: "GET",
      data: { material_type: selectedType, list: listId }
    });
  });

  $("#list_material_material").select2({
    theme: 'bootstrap4'
  });

});