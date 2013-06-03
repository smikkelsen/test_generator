// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery_nested_form
//= require chosen-jquery
//= require chosen
//= require_tree .


// model tests

$(document).ready(function () {
    $('#btnAddCol').click(function (e) {
//        e.preventDefault();
        var newTr = '<tr><td><input name="name[]" style="width:40%;" type="text" value="" /></td><td><input checked="checked" id="column__index__" name="index[]" type="checkbox" value="true" /></td><td><img alt="Delete-icon24x24" class="btnDel clickable" src="/assets/delete-icon24x24.png" /></td></tr>';

        $('#columns').append(newTr);


    });

    $(".nested_form_attributes").on("click", ".btnDel", function () {
        var row = $(this).closest(".fields");
        row.remove();
    });

    $("#accordion").accordion({
        heightStyle: "content",
        collapsible: true,
        active: false
    });


//    $('.nested_form_attributes').on('click', '.unique_bool', function () {
//        var unique_scope_div = $(this).parent().parent().parent().next().find('.unique_scope');
//        var unique_scope_field = unique_scope_div.find('.chosen');
//        if ($(this).is(':checked') == false) {
//            unique_scope_div.hide();
//            unique_scope_field.val('').trigger("liszt:updated");
//        } else {
//            unique_scope_div.show();
//        }
//    });
//
//    $(".unique_bool").each(function () {
//        var unique_scope_div = $(this).parent().parent().parent().next().find('.unique_scope');
//        var unique_scope_field = unique_scope_div.find('.chosen');
//        if ($(this).is(':checked') == false) {
//            unique_scope_div.hide();
//            unique_scope_field.val('').trigger("liszt:updated");
//        } else {
//            unique_scope_div.show();
//        }
//    });

    // tool tip
    $(function () {
        $(".tooltip").tipTip({
            defaultPosition: "bottom",
            edgeOffset: 8
        });
    });

});