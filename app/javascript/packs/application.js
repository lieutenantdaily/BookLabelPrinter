// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

//*****************************************************************************
$(document).on('turbolinks:load', function () {
//generate PDF Label **********************************************************    
    var url = $(location).attr('href');
    var url_o = url;

    url = url.replace("filter=keep&search", "search");
    url = url.replace("filter=reject&search", "search");
    url = url.replace("filter=missing&search", "search");
    url = url.replace("filter=review&search", "search");

    var url_repl = url.replace("&script=PRINT-VX", "");
    var url_filter_keep = url.replace("search", "filter=keep&search");
    var url_filter_reject = url.replace("search", "filter=reject&search");
    var url_filter_missing = url.replace("search", "filter=missing&search");
    var url_filter_review = url.replace("search", "filter=review&search");

    function print_labels() {
        $('.label-edit').detach();
        var doc = new jsPDF('l', 'mm', [28.575 * 2.3, 88.9 * 2.3]);
        doc.setFont("arial");
        var specialElementHandlers = {
            '#editor': function (element, renderer) {
                return true;
            }
        };

        doc.fromHTML($('#content').html(), 10, -10, {
            'width': 170,
                'elementHandlers': specialElementHandlers
        });
        doc.autoPrint();
        doc.save('labels.pdf');
        location.replace(url_repl);

        // var doc = new jsPDF('l', 'mm', [28.575 * 2.3, 88.9 * 2.3]);
        // doc.setFont("arial");
        // var specialElementHandlers = {
        //     '#editor': function (element, renderer) {
        //         return true;
        //     }
        // };

        // doc.addHTML($('#label')[0], function () {
        //     doc.autoPrint();
        //     doc.save('labels.pdf');
        // });
    }

    if ((/PRINT-VX/.test(url))) {
        print_labels();
    }


    $('#cmd, #print').click(function () {
        print_labels();
    });



// filter *********************************************************************

$('#all').click(function () {
    location.replace(url);
});

$('#keep').click(function () {
    location.replace(url_filter_keep);
});

$('#reject').click(function () {
    location.replace(url_filter_reject);
});

$('#missing').click(function () {
    location.replace(url_filter_missing);
});

$('#review').click(function () {
    location.replace(url_filter_review);
});




if ((/filter=keep/.test(url_o))) {
    $("#cmd").fadeOut(0);
    $("#print-check").fadeIn(0);
    $(".status").each(function() {
        if ($(this).val() == "Keep-Acceptable" || $(this).val() == "Keep-Good" || $(this).val() == "Keep-Very Good" || $(this).val() == "Keep-Like New" || $(this).val() == "Keep-New") {
        } else {
            $(this).parent().parent().parent().parent().detach();
        }
    });
}
if ((/filter=reject/.test(url_o))) {
    $("#cmd").fadeOut(0);
    $("#print-check").fadeIn(0);
    $(".status").each(function() {
        if ($(this).val() == "Reject-Red" || $(this).val() == "Reject-Blue" || $(this).val() == "Reject-Yellow") {
        } else {
            $(this).parent().parent().parent().parent().detach();
        }
    });
}
if ((/filter=missing/.test(url_o))) {
    $("#cmd").fadeOut(0);
    $("#print-check").fadeIn(0);
    $(".status").each(function() {
        if ($(this).val() == "Missing") {
        } else {
            $(this).parent().parent().parent().parent().detach();
        }
    });
}
if ((/filter=review/.test(url_o))) {
    $("#cmd").fadeOut(0);
    $("#print-check").fadeIn(0);
    $(".status").each(function() {
        if ($(this).val() == "Review") {
        } else {
            $(this).parent().parent().parent().parent().detach();
        }
    });
}


//generate PDF Label **********************************************************


    // $("input").keypress(function(event) {
    //     if (event.which == 13) {
    //         event.preventDefault();
    //         $("form_id_here").submit();
    //     }
    //   });

    // var h = $(window).height();
    // var w = $(window).width();


    // $(window).on('resize', function () {

    //     var h = $(window).height();
    //     var w = $(window).width();


    // });



    

    $('#upload-show').click(function () {
        $('#uploader').fadeIn(300);
        $('#uploader').animate({
            top: -50
        }, {
            duration: 300,
            queue: false
        });


    });

    $('#offers-upload-show').click(function () {
        $('#uploader').fadeIn(300);
        $('#uploader').animate({
            top: -50
        }, {
            duration: 300,
            queue: false
        });


    });


    $('#upload-hide').click(function () {
        $('#uploader').fadeOut(300);
        $('#uploader').animate({
            top: '-400px'
        }, {
            duration: 300,
            queue: false
        });


    });


//conditional formatting of labels *********************************************

    var status_text = $(".status :selected(Review)")
    var label_container = $(".label-container");
    var default_color = "#eee";
    var green = "#28a745";
    var blue = "#007bff";
    var yellow = "#ffc107";
    var red = "#dc3545";
    var purple = "#563d7c";
    var pink = "#702459";
    var print_check = "0";
    var icons = $(".print-check").detach();

    print_check = $("#print-check").text()

 


    $("#items-left").each(function() {
        if ($(this).text() == "0") {
            $(this).parent().removeClass("bg-warning");
            $(this).parent().removeClass("text-dark");
            $(this).parent().css("background", green);
            $(this).css({"color": "white", "font-weight": "bold"});
            $(this).parent().css({"color": "white", "font-weight": "bold"});
        }
    });

    $(".hidden-status").each(function() {
        if ($(this).text() == "Review-Keep") {
            $(this).parent().parent().parent().css("background", pink);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.keep').fadeIn(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.keep').children('.icon-wrap').css({"color": "white"});
        }
    });

    $(".status").each(function() {
        if ($(this).val() == "Keep-Acceptable" || $(this).val() == "Keep-Good" || $(this).val() == "Keep-Very Good" || $(this).val() == "Keep-Like New" || $(this).val() == "Keep-New") {
            $(this).parent().parent().parent().css("background", green);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').fadeIn(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').children('.icon-wrap').css({"color": "white"});
            if ( print_check == "1" ) {
                $(".print-check-button").append(icons);
            } 
        }
        if ($(this).val() == "Reject-Red") {
            $(this).parent().parent().parent().css("background", red);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeIn(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').children('.icon-wrap').css({"color": "white"});
        }
        if ($(this).val() == "Reject-Blue") {
            $(this).parent().parent().parent().css("background", blue);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeIn(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').children('.icon-wrap').css({"color": "white"});
        }
        if ($(this).val() == "Reject-Yellow") {
            $(this).parent().parent().parent().css("background", yellow);
            $(this).siblings('.label-edit-label').css({"color": "black", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeIn(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').children('.icon-wrap').css({"color": "black"});
        }
        if ($(this).val() == "Missing") {
            $(this).parent().parent().parent().css("background", purple);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').fadeIn(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').children('.icon-wrap').css({"color": "white"});
        }
    });
    $(".status").change(function() {
        if ($(this).val() == "Review") {
            $(this).parent().parent().parent().css("background", default_color);
            $(this).siblings('.label-edit-label').css({"color": "black", "font-weight": "normal"});
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.keep').fadeOut(0);
            if ( print_check == "1" ) {
                $(".print-check").detach();
            } else {
                $(".print-check-button").append(icons);
            }
        }
        if ($(this).val() == "Keep-Acceptable" || $(this).val() == "Keep-Good" || $(this).val() == "Keep-Very Good" || $(this).val() == "Keep-Like New" || $(this).val() == "Keep-New") {
            $(this).parent().parent().parent().css("background", green);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').fadeIn(500);
            $(this).parent().parent().parent().children('.label-image-container').children('.keep').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').children('.icon-wrap').css({"color": "white"});
            if ( print_check == "1" ) {
                $(".print-check-button").append(icons);
            } else {
                $(".print-check").detach();
            }
        }
        if ($(this).val() == "Reject-Red") {
            $(this).parent().parent().parent().css("background", red);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeIn(500);
            $(this).parent().parent().parent().children('.label-image-container').children('.keep').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').children('.icon-wrap').css({"color": "white"});
            if ( print_check == "1" ) {
                $(".print-check").detach();
            } else {
                $(".print-check-button").append(icons);
            }
        }
        if ($(this).val() == "Reject-Blue") {
            $(this).parent().parent().parent().css("background", blue);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeIn(500);
            $(this).parent().parent().parent().children('.label-image-container').children('.keep').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').children('.icon-wrap').css({"color": "white"});
            if ( print_check == "1" ) {
                $(".print-check").detach();
            } else {
                $(".print-check-button").append(icons);
            }
        }
        if ($(this).val() == "Reject-Yellow") {
            $(this).parent().parent().parent().css("background", yellow);
            $(this).siblings('.label-edit-label').css({"color": "black", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeIn(500);
            $(this).parent().parent().parent().children('.label-image-container').children('.keep').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').children('.icon-wrap').css({"color": "black"});
            if ( print_check == "1" ) {
                $(".print-check").detach();
            } else {
                $(".print-check-button").append(icons);
            }
        }
        if ($(this).val() == "Missing") {
            $(this).parent().parent().parent().css("background", purple);
            $(this).siblings('.label-edit-label').css({"color": "white", "font-weight": "bold"});
            $(this).parent().parent().parent().children('.label-image-container').children('.complete').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.reject').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').fadeIn(500);
            $(this).parent().parent().parent().children('.label-image-container').children('.keep').fadeOut(0);
            $(this).parent().parent().parent().children('.label-image-container').children('.warn').children('.icon-wrap').css({"color": "white"});
            if ( print_check == "1" ) {
                $(".print-check").detach();
            } else {
                $(".print-check-button").append(icons);
            }
        }
    });


//Price Compare *************************************************************

    $('#other-message').fadeOut(0);

    $("#price_destination").change(function() {
        if ($(this).val() == "Other") {
            $('#other-message').fadeIn(300);            
        }
        if ($(this).val() == "Textbook Recycling") {
            $('#other-message').fadeOut(300);            
        }

    });

});
//******************************************************************************

