var TW = TW || {};
TW.views = TW.views || {};
TW.views.tasks = TW.views.tasks || {};
TW.views.tasks.gis = TW.views.tasks.gis || {};
TW.views.tasks.gis.match_georeference = TW.views.tasks.gis.match_georeference || {};

Object.assign(TW.views.tasks.gis.match_georeference, {

  init: function() {


//        send polygon or circle to controller from right-hand draw map
//        reconfigure drawn map to mimic asserted distributions behavior
//        construct callback to transition from draw map to selecting map

    var ce_map = [];        // map and item containers are cross-pollinating each other
    var ce_last = null;     // causing drawn areas to be erased, but left as features in form
    var gr_map = [];        // drawn georeference search area
    var gr_last = null;     // last item drawn
    var selectable_gr_map = [];        // selectable gr map
    var selected_gr_map = [];        // selected gr map
///////////////////////////////////////////////////////////
//   collecting event (left) side handlers
///////////////////////////////////////////////////////////

    $(".filter-ce").click(function (event) {
      // unhide this form
      $("#_filter_ce_form").removeAttr("hidden");
      // hide everything else:  tag; drawing; recent;
      $("#_tag_ce_form").attr("hidden", true);
      $("#_draw_ce_form").attr("hidden", true);
      $("#_recent_ce_form").attr("hidden", true);
      $('#_selecting_ce_form').attr('hidden', true);
      $("#result_from_post").attr("hidden", true);

      event.preventDefault();
    });

    // this DOM object represents the form for retrieving the filtering data for
    // selecting collecting events. In this case
    //      div.id = '_filter_ce_form'
    //      form.id = 'filtering_ce_data'
    $("#filtering_ce_data").on("ajax:success", function (e, data, status, local_data) {    // first/outermost ajax callback.
        // make a local object of the selecting form so we can use it later
        var selecting = $('#_selecting_ce_form');
        // unhide the local div
        selecting.removeAttr('hidden');
        // see what the message was, if anything
        var message = local_data.responseJSON['message'];
        if (message.length) {
          selecting.html(message);
        }
        else {
          // shove the returning html into the local form
          selecting.html(local_data.responseJSON['html']);      // render the table
// plant the id for the submit
          $("#create").click(function (event) {      // register the click handler for the form button
              $("#georeference_id").val($("#selected_georeference_id").val());  // get the stored value from center map form for the submit
            }
          );
          $("#create_georeferences").on("ajax:success", function (e, data, status, local_data) {    // second/innermost ajax callback.
              $("#_filter_ce_form").attr("hidden", true);
              $("#result_from_post").removeAttr("hidden");
              message = local_data.responseJSON['message'];
              if (message.length) {
                $("#result_from_post").html(message);    // shove the 3rd phase returning error message into the local form
              }
              else {
                // shove the returning html into the local form
                $("#result_from_post").html(local_data.responseJSON['html']);    // shove the 3rd phase returning html into the local form
              }
            }    // end second/innermost ajax callback.
          ).on("ajax:error", function (e, xhr, status, error) {
            $("#new_article").append("<p>ERROR</p>");
          })
        }
        // hide the filter div
        //$("#_filter_ce_form").attr("hidden", true);
        return true;
      }             // end first/outermost ajax callback.
    ).on("ajax:error", function (e, xhr, status, error) {
      $("#new_article").append("<p>ERROR</p>");
    });

    $(".tag-ce").click(function (event) {
      // unhide this form
      $("#_tag_ce_form").removeAttr("hidden");
      // hide everything else: filter; drawing; recent;
      $("#_filter_ce_form").attr("hidden", true);
      $("#_draw_ce_form").attr("hidden", true);
      $("#_recent_ce_form").attr("hidden", true);
      $('#_selecting_ce_form').attr('hidden', true);
      $("#result_from_post").attr("hidden", true);

      event.preventDefault();
    });

    // this DOM object represents the form for retrieving the keyword for
    // selecting collecting events. In this case
    //      div.id = '_tag_ce_form'
    //      form.id = 'tagged_ce_keyword'
    $("#tagged_ce_keyword").on("ajax:success", function (e, data, status, local_data) {    // first/outermost ajax callback.
        // make a local object of the selecting form so we can use it later
        var selecting = $('#_selecting_ce_form');
        // unhide the local div
        selecting.removeAttr('hidden');
        // see what the first response message was, if anything
        var message = local_data.responseJSON['message'];
        if (message.length) {
          selecting.html(message);
        }
        else {
          // shove the returning html into the local form
          selecting.html(local_data.responseJSON['html']);
// plant the id for the submit
          $("#create").click(function (event) {      // register the click handler for the made-from-scratch-button
              $("#georeference_id").val($("#selected_georeference_id").val());  // get the stored value from center map form
            }
          );
          $("#create_georeferences").on("ajax:success", function (e, data, status, local_data) {    // second/innermost ajax callback.
              $("#_tag_ce_form").attr("hidden", true);
              $("#result_from_post").removeAttr("hidden");
              message = local_data.responseJSON['message'];
              if (message.length) {
                $("#result_from_post").html(message);    // shove the 3rd phase returning error message into the local form
              }
              else {
                // shove the returning html into the local form
                $("#result_from_post").html(local_data.responseJSON['html']);    // shove the 3rd phase returning html into the local form
              }
            }    // end second/innermost ajax callback.
          ).on("ajax:error", function (e, xhr, status, error) {
            $("#new_article").append("<p>ERROR</p>");
          })
        }
        // hide the tag div
        //$("#_tag_ce_form").attr("hidden", true);
        return true;
      }             // end first/outermost ajax callback.
    ).on("ajax:error", function (e, xhr, status, error) {
      $("#new_article").append("<p>ERROR</p>");
    });

    $(".draw-ce").click(function (event) {

      $("#_draw_ce_form").removeAttr("hidden");        // unhide the draw div
      // hide everything else: filter; tag; recent;
      $("#_filter_ce_form").attr("hidden", true);
      $("#_tag_ce_form").attr("hidden", true);
      $("#_recent_ce_form").attr("hidden", true);
      $('#_selecting_ce_form').attr('hidden', true);
      $("#result_from_post").attr("hidden", true);
      TW.vendor.lib.google.maps.loadGoogleMapsAPI().then(function() {
        ce_map = TW.vendor.lib.google.maps.draw.initializeGoogleMapWithDrawManager("#_draw_ce_form");  //set up a blank draw canvas
        TW.vendor.lib.google.maps.draw.singleDrawnFeatureToMapListeners(ce_map, ce_last, "#ce_geographic_item_attributes_shape");
      })
      event.preventDefault();
    });

    $("#_draw_ce_form").on("ajax:success", function (e, data, status, local_data) {    // first/outermost ajax callback.

//  on successful upload and processing of polygon or shape file,
//  instantiate a selecting form and map
        var selecting = $('#_selecting_ce_form');
        selecting.removeAttr('hidden');        // unhide the local div
        // see what the message was, if anything
        var message = local_data.responseJSON['message'];
        if (message.length) {
          selecting.html(message);
        }
        else {
          // shove the returning html into the local form
          selecting.html(local_data.responseJSON['html']);

// plant the id for the submit in the found ce form
          $("#create").click(function (event) {      // register the click handler for the ajaxy-button
              $("#georeference_id").val($("#selected_georeference_id").val());  // get the stored value from center map form
            }
          );
          $("#create_georeferences").on("ajax:success", function (e, data, status, local_data) {    // second/innermost ajax callback.
              $("#_draw_ce_form").attr("hidden", true);
              $("#result_from_post").removeAttr("hidden");
              message = local_data.responseJSON['message'];
              if (message.length) {
                $("#result_from_post").html(message);    // shove the 3rd phase returning error message into the local form
              }
              else {
                // shove the returning html into the local form
                $("#result_from_post").html(local_data.responseJSON['html']);    // shove the 3rd phase returning html into the local form
              }
            }    // end second/innermost ajax callback.
          ).on("ajax:error", function (e, xhr, status, error) {
              $("#new_article").append("<p>ERROR</p>");
            }
          );
        }
        //$("#_draw_ce_form").attr("hidden", true);   // hide map
        return true;
      }             // end first/outermost ajax callback.
    ).on("ajax:error", function (e, xhr, status, error) {
      $("#new_article").append("<p>ERROR</p>");
    });

    $(".recent-ce").click(function (event) {

      // unhide this form
      $("#_recent_ce_form").removeAttr("hidden");
      // hide everything else: filter; tag; drawing;
      $("#_filter_ce_form").attr("hidden", true);
      $("#_tag_ce_form").attr("hidden", true);
      $("#_draw_ce_form").attr("hidden", true);
      $('#_selecting_ce_form').attr('hidden', true);
      $("#result_from_post").attr("hidden", true);

      event.preventDefault();
    });

    //  search for recent collecting events success
    $("#recent_ce_count").on("ajax:success", function (e, data, status, local_data) {    // first/outermost ajax callback.
        // make a local object of the selecting form so we can use it later
        var selecting = $('#_selecting_ce_form');
        // unhide the local div
        selecting.removeAttr('hidden');
        // see what the message was, if anything
        var message = local_data.responseJSON['message'];
        if (message.length) {
          selecting.html(message);
        }
        else {
          // shove the returning html into the local form
          selecting.html(local_data.responseJSON['html']);      // render the table
// plant the id for the submit
          $("#create").click(function (event) {      // register the click handler for the form button
              $("#georeference_id").val($("#selected_georeference_id").val());  // get the stored value from center map form for the submit
            }
          );
          $("#create_georeferences").on("ajax:success", function (e, data, status, local_data) {    // second/innermost ajax callback.
              $("#_recent_ce_form").attr("hidden", true);
              $("#result_from_post").removeAttr("hidden");
              message = local_data.responseJSON['message'];
              if (message.length) {
                $("#result_from_post").html(message);    // shove the 3rd phase returning error message into the local form
              }
              else {
                // shove the returning html into the local form
                $("#result_from_post").html(local_data.responseJSON['html']);    // shove the 3rd phase returning html into the local form
              }
            }    // end second/innermost ajax callback.
          ).on("ajax:error", function (e, xhr, status, error) {
            $("#new_article").append("<p>ERROR</p>");
          })
        }
        // hide the filter div
        // $("#_recent_ce_form").attr("hidden", true);
        return true;
      }             // end first/outermost ajax callback.
    ).on("ajax:error", function (e, xhr, status, error) {
      $("#new_article").append("<p>ERROR</p>");
    });

///////////////////////////////////////////////////////////
//   georeference (right) side handlers
///////////////////////////////////////////////////////////

    $(".filter-gr").click(function (event) {

      $("#_filter_gr_form").removeAttr("hidden");        // unhide the draw div
      // hide everything else:  tag; drawing; recent;
      $("#_tag_gr_form").attr("hidden", true);
      $("#_draw_gr_form").attr("hidden", true);
      $("#_recent_gr_form").attr("hidden", true);
      $('#_selecting_gr_form').attr('hidden', true);

      event.preventDefault();
    });
    // this DOM object represents the form for retrieving the filtering data for
    // selecting georeferences. In this case
    //      div.id = '_filter_gr_form'
    //      form.id = 'filtering_gr_data'    ???
    $("#filtering_gr_data").on("ajax:success", function (e, data, status, local_data) {
      // make a local object of the selecting form so we can use it later
      var selecting = $('#_selecting_gr_form');
      // unhide the local div
      selecting.removeAttr('hidden');
      // see what the message was, if anything
      var message = local_data.responseJSON['message'];
      if (message.length) {
        selecting.html(message);
      }
      else {
        selecting.html(local_data.responseJSON['html']);        // shove the returning html into the local form
        // start the map process
        selectable_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_select_gr_form").data('map-canvas'), $("#_select_gr_form").data('feature-collection'));
        add_match_georeferences_map_listeners(selectable_gr_map);
        if ($("#_select_gr_form").data('feature-collection').features.length == 1) {

          selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), $("#_select_gr_form").data('feature-collection'));
        }
        else {
          selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), $("#_selected_gr_form").data('feature-collection'));
        }
      }
      //$("#_filter_gr_form").attr("hidden", true);
      return true;
    }).on("ajax:error", function (e, xhr, status, error) {
      $("#new_article").append("<p>ERROR</p>");
    });

    $(".tag-gr").click(function (event) {

      $("#_tag_gr_form").removeAttr("hidden");        // unhide the draw div
      // hide everything else: filter; drawing; recent;
      $("#_filter_gr_form").attr("hidden", true);
      $("#_draw_gr_form").attr("hidden", true);
      $("#_recent_gr_form").attr("hidden", true);
      $('#_selecting_gr_form').attr('hidden', true);

      event.preventDefault();
    });
    // this DOM object represents the form for retrieving the keyword for
    // selecting collecting events. In this case
    //      div.id = '_tag_gr_form'
    //      form.id = 'tagged_gr_keyword'
    $("#tagged_gr_keyword").on("ajax:success", function (e, data, status, local_data) {
      // make a local object of the selecting form so we can use it later
      var selecting = $('#_selecting_gr_form');
      selecting.removeAttr('hidden');        // unhide the local div
      var message = local_data.responseJSON['message'];         // see what the message was, if anything
      if (message.length) {
        selecting.html(message);
      }
      else {
        selecting.html(local_data.responseJSON['html']);        // shove the returning html into the local form
        // start the map process
        selectable_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_select_gr_form").data('map-canvas'), $("#_select_gr_form").data('feature-collection'));
        add_match_georeferences_map_listeners(selectable_gr_map);
        if ($("#_select_gr_form").data('feature-collection').features.length == 1) {

          selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), $("#_select_gr_form").data('feature-collection'));
        }
        else {
          selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), $("#_selected_gr_form").data('feature-collection'));
        }
      }
      //$("#_tag_gr_form").attr("hidden", true);    // hide submitted tag form no more, leave until acted upon
      return true;
    }).on("ajax:error", function (e, xhr, status, error) {
      $("#new_article").append("<p>ERROR</p>");
    });

    $(".draw-gr").click(function (event) {

      $("#_draw_gr_form").removeAttr("hidden");        // unhide the draw div
      // hide everything else: filter; tag; recent;
      $("#_filter_gr_form").attr("hidden", true);
      $("#_tag_gr_form").attr("hidden", true);
      $("#_recent_gr_form").attr("hidden", true);
      $('#_selecting_gr_form').attr("hidden", true);

      TW.vendor.lib.google.maps.loadGoogleMapsAPI().then(function() {
        gr_map = TW.vendor.lib.google.maps.draw.initializeGoogleMapWithDrawManager("#_draw_gr_form");  //set up a blank draw canvas
        TW.vendor.lib.google.maps.draw.singleDrawnFeatureToMapListeners(gr_map, gr_last, "#gr_geographic_item_attributes_shape");
      });
      event.preventDefault();
    });

    $("#_draw_gr_form").on("ajax:success", function (e, data, status, local_data) {

//  on successful upload and processing of polygon or shape file,
//  instantiate a selecting form and map
        var selecting = $('#_selecting_gr_form');   // outer wrapper
        selecting.removeAttr('hidden');        // unhide the found items wrapper div
        // see what the message was, if anything
        var message = local_data.responseJSON['message'];
        if (message.length) {
          selecting.html(message);          // write any message to the wrapper div
        }
        else {
          selecting.html(local_data.responseJSON['html']);          // shove the returning html into the synthesized _select_gr_form via partial
          //var child_form = $("#" + $("#_selecting_gr_form").children(0).attr("id"));
          var child_form = selecting.children(0);   // we know this container only has one child
          // map object below renders the response feature collection from child form data-object to right hand result canvas
          var selected_area = JSON.parse($(gr_geographic_item_attributes_shape).attr('value'));
          selected_area.properties = {fillOpacity: 0.05, strokeColor: "black", strokeOpacity: 0.2, strokeWeight: 0.1};
          child_form.data('feature-collection').features.push(selected_area);
          selectable_gr_map = TW.vendor.lib.google.maps.initializeMap(child_form.data('map-canvas'), child_form.data('feature-collection'));
          //////selectable_gr_map = initializeComplexMap($("#_select_gr_form").data('map-canvas'), $("#_select_gr_form").data('feature-collection'));
          add_match_georeferences_map_listeners(selectable_gr_map);   // listen on features in right hand result map
          if (child_form.data('feature-collection').features.length == 1) {
            //  render the center map (literally _selected_gr_form) with the same feature collection
            //$("#_selected_gr_form").data('feature-collection').features.push($(gr_geographic_item_attributes_shape).attr('value'));
            selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), child_form.data('feature-collection'));
          }
          else {
            // render an empty center map by using its default STATIC degenerate feature colletion
            //$("#_selected_gr_form").data('feature-collection').features.push($(gr_geographic_item_attributes_shape).attr('value'));
            selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), $("#_selected_gr_form").data('feature-collection'));
          }
        }
        return true;
      }
    ).on("ajax:error", function (e, xhr, status, error) {
      $("#new_article").append("<p>ERROR</p>");
    });

    $(".recent-gr").click(function (event) {

      // unhide this form
      $("#_recent_gr_form").removeAttr("hidden");
      // hide everything else: filter; tag; drawing;
      $("#_filter_gr_form").attr("hidden", true);
      $("#_tag_gr_form").attr("hidden", true);
      $("#_draw_gr_form").attr("hidden", true);
      $('#_selecting_gr_form').attr('hidden', true);

      event.preventDefault();
    });

    $("#recent_gr_count").on("ajax:success", function (e, data, status, local_data) {
      var selecting = $('#_selecting_gr_form');
      selecting.removeAttr('hidden');
      // see what the message was, if anything
      var message = local_data.responseJSON['message'];
      if (message.length) {
        selecting.html(message);
      }
      else {
        selecting.html(local_data.responseJSON['html']);        // shove the returning html into the local response form
        // start the map process
        selectable_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_select_gr_form").data('map-canvas'), $("#_select_gr_form").data('feature-collection'));
        add_match_georeferences_map_listeners(selectable_gr_map);
        if ($("#_select_gr_form").data('feature-collection').features.length == 1) {

          selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), $("#_select_gr_form").data('feature-collection'));
        }
        else {
          selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), $("#_selected_gr_form").data('feature-collection'));
        }
      }
      //$("#_recent_gr_form").attr("hidden", true);
      return true;
    }).on("ajax:error", function (e, xhr, status, error) {
      $("#new_article").append("<p>ERROR</p>");
    });

    $("#btn_clear_selection").click(function (event) {
      selected_gr_map = TW.vendor.lib.google.maps.initializeMap($("#_selected_gr_form").data('map-canvas'), $("#_selected_gr_form").data('feature-collection'));
        event.preventDefault();
      }
    );
  


   // Datepicker fix

  $(document).on('turbolinks:load', function() {
    if ($("#st_datepicker").length) {  // see if we need a datepicker for start date
      var d = new Date();
      var n = d.getFullYear();
      var dateInput = $("#st_datepicker");
      var format = 'dd-MM-yy';

      $("#st_datepicker").datepicker({changeMonth: true, changeYear: true, yearRange: "1700:" + n });
      dateInput.datepicker({dateFormat: format});
      dateInput.datepicker('setDate', $.datepicker.parseDate(format, dateInput.val()));
    }
    if ($("#en_datepicker").length) {  /// see if we need a datepicker for end date
      var d = new Date();
      var n = d.getFullYear();
      var dateInput = $("#en_datepicker");
      var format = 'yy-mm-dd';

      $("#en_datepicker").datepicker({changeMonth: true, changeYear: true, yearRange: "1700:" + n });
      dateInput.datepicker({dateFormat: format});
      dateInput.datepicker('setDate', $.datepicker.parseDate(format, dateInput.val()));
    }
  });



  function add_click_services_to_match_georeferences_map(map, event) {     // click event passed in
    // clears previous map data features
    $.get('drawn_georeferences', $('form#_select_gr_form').serialize(), function (local_data) {
        //map.data.forEach(function(feature) {map.data.remove(feature);});    // clear the map.data
        map = TW.vendor.lib.google.maps.initializeMap("show_gr_canvas", local_data['feature_collection']);
        map.data.addGeoJson(local_data['feature_collection']);      // add the geo features corresponding to the forms
      },
      'json' // I expect a JSON response
    );
  }


  function add_match_georeferences_map_listeners(map) {      // 4 listeners, one for map as a whole 3 for map.data features
    // When the user clicks, set 'isColorful', changing the color of the feature.
    var selected_map;
    map.data.addListener('click', function (event) {
      if (event.feature.getProperty('isColorful')) {           // reset selected color if
        event.feature.setProperty('isColorful', false);     // previously selected
        event.feature.setProperty('fillColor', "#440000");  // to dimmer red
      }
      else {      // if not already "Colorful", make it so
        event.feature.setProperty('isColorful', true);
        event.feature.setProperty('fillColor', "#CC0000");  //brighter red
        // selectable area has been clicked, get the feature
        //  var selected_feature_georeference_id = event.feature["A"].georeference.id;      // unfortunate Google maps reference
        if (event.feature.getProperty('georeference')) {
          var selected_feature_georeference_id = event.feature.getProperty('georeference').id;      // unfortunate Google maps reference
          $("#selected_georeference_id").val(selected_feature_georeference_id);           // plant the clicked ID in a safe place
  //    literal-based hide the "instructions" div
          $("#_filter_gr_form").attr("hidden", true);   //CLEAR EVERYTHING (all gr-selectors) if we click a found feature
          $("#_tag_gr_form").attr("hidden", true);
          $("#_draw_gr_form").attr("hidden", true);
          $("#_recent_gr_form").attr("hidden", true);
          $("#_selected_gr_form").removeAttr("hidden");   // literal-based reveal the map
          var feature_collection = $("#_select_gr_form").data('feature-collection');      // literal-based form data reference
          for (var i = 0; i < feature_collection.features.length; i++) {                  // scan the feature_collection
            if (feature_collection.features[i].properties['georeference']) {
              if (selected_feature_georeference_id == feature_collection.features[i].properties['georeference'].id) {  // for the match
              var fc = {"type": "FeatureCollection", "features": []};         // construct the new feature collection for the target
              fc.features.push(feature_collection.features[i]);           // inject the matching feature found by georeference id
              selected_map = TW.vendor.lib.google.maps.initializeMap("selected_gr_canvas", fc);              // plot it on the center map, knowing literally where it is
              }
            }                                                  // selected_map can be used to bind other listeners
          }
        }
      }
      // DON'T: none to add at this point; add_click_services_to_match_georeferences_map(map, event);
    });

    // When the user hovers, tempt them to click by outlining the letters.
    // Call revertStyle() to remove all overrides. This will use the style rules
    // defined in the function passed to setStyle()
    map.data.addListener('mouseover', function (event) {
      map.data.revertStyle();
      map.data.overrideStyle(event.feature, {fillColor: '#880000'});  // mid-level red
      map.data.overrideStyle(event.feature, {strokeWeight: 2});       //embolden borders
      map.data.overrideStyle(event.feature, {icon: TW.vendor.lib.google.maps.mapIcons['brown']});       // highlight markers
    });

    map.data.addListener('mouseout', function (event) {
      map.data.revertStyle();
    });
  }
}
});           // add_listeners end

$(document).on('turbolinks:load', function() { 
  if ($('#match_georeference_widget').length) {
    TW.vendor.lib.google.maps.loadGoogleMapsAPI().then(function() {
      TW.views.tasks.gis.match_georeference.init(); 
    });
  }
});



