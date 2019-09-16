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


//generate PDF Label **********************************************************
$(document).on('turbolinks:load', function () {

    

    $('#cmd').click(function () {
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

    });

});
//******************************************************************************

//Show/Hide New Post Widget **********************************************************
$(document).on('turbolinks:load', function () {

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
            top: 0
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


    


});
//******************************************************************************