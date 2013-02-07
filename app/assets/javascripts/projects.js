$(document).ready(function () {

    $(".pm_category_help_hide").hide('fast');
    $("pm_category_help").show('fast');

    $(".pm_category_help").click(function () {
        $(".pm_category_help_text").show('fast');
        $(".pm_category_help").hide('fast');
        $(".pm_category_help_hide").show('fast');
    });

    $(".pm_category_help_hide").click(function () {
        $(".pm_category_help_text").hide('fast');
        $(".pm_category_help_hide").hide('fast');
        $(".pm_category_help").show('fast');

    });

});

