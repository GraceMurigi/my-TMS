 $(window).on("scroll", function() {
            if ($(this).scrollTop() > 10) {
                $("nav.navbar").addClass("mybg-dark");
                $("nav.navbar").addClass("navbar-shrink");
                $(".navbar-dark .navbar-toggler").css({"background-color" : "#0F1626"});

            } else {
                $("nav.navbar").removeClass("mybg-dark");
                $("nav.navbar").removeClass("navbar-shrink");
                $(".navbar-brand").css({
                    "color": "#fff"
                 });
                $(".navbar-dark .navbar-toggler").css({"background-color" : "transparent"});
                
            }
        });
$.datepicker.setDefaults({
  showOn: "both",
  buttonImageOnly: true,
  buttonImage: "calendar.gif",
  buttonText: "Calendar"
});
$.datepicker.setDefaults( $.datepicker.regional[ "en" ] );
$.datepicker.formatDate( "DD, MM d, yy", new Date( 2007, 7 - 1, 14 ), {
  dayNamesShort: $.datepicker.regional[ "fr" ].dayNamesShort,
  dayNames: $.datepicker.regional[ "fr" ].dayNames,
  monthNamesShort: $.datepicker.regional[ "fr" ].monthNamesShort,
  monthNames: $.datepicker.regional[ "fr" ].monthNames
});
        $(document).ready(function() {

            $(function() {

                $(document).on('scroll', function() {

                    if ($(window).scrollTop() > 100) {
                        $('.scroll-top-wrapper').addClass('show');
                    } else {
                        $('.scroll-top-wrapper').removeClass('show');
                    }
                });

                $('.scroll-top-wrapper').on('click', scrollToTop);
            });

            function scrollToTop() {
                verticalOffset = typeof(verticalOffset) != 'undefined' ? verticalOffset : 0;
                element = $('body');
                offset = element.offset();
                offsetTop = offset.top;
                $('html, body').animate({
                    scrollTop: offsetTop
                }, 500, 'linear');
            }

        });


// for my faqs

jQuery(document).ready(function($){
    //update these values if you change these breakpoints in the style.css file (or _layout.scss if you use SASS)
    var MqM= 768,
        MqL = 1024;

    var faqsSections = $('.cd-faq-group'),
        faqTrigger = $('.cd-faq-trigger'),
        faqsContainer = $('.cd-faq-items'),
        faqsCategoriesContainer = $('.cd-faq-categories'),
        faqsCategories = faqsCategoriesContainer.find('a'),
        closeFaqsContainer = $('.cd-close-panel');
    
    //select a faq section 
    faqsCategories.on('click', function(event){
        event.preventDefault();
        var selectedHref = $(this).attr('href'),
            target= $(selectedHref);
        if( $(window).width() < MqM) {
            faqsContainer.scrollTop(0).addClass('slide-in').children('ul').removeClass('selected').end().children(selectedHref).addClass('selected');
            closeFaqsContainer.addClass('move-left');
            $('body').addClass('cd-overlay');
        } else {
            $('body,html').animate({ 'scrollTop': target.offset().top - 19}, 200); 
        }
    });

    //close faq lateral panel - mobile only
    $('body').bind('click touchstart', function(event){
        if( $(event.target).is('body.cd-overlay') || $(event.target).is('.cd-close-panel')) { 
            closePanel(event);
        }
    });
    faqsContainer.on('swiperight', function(event){
        closePanel(event);
    });

    //show faq content clicking on faqTrigger
    faqTrigger.on('click', function(event){
        event.preventDefault();
        $(this).next('.cd-faq-content').slideToggle(200).end().parent('li').toggleClass('content-visible');
    });

    //update category sidebar while scrolling
    $(window).on('scroll', function(){
        if ( $(window).width() > MqL ) {
            (!window.requestAnimationFrame) ? updateCategory() : window.requestAnimationFrame(updateCategory); 
        }
    });

    $(window).on('resize', function(){
        if($(window).width() <= MqL) {
            faqsCategoriesContainer.removeClass('is-fixed').css({
                '-moz-transform': 'translateY(0)',
                '-webkit-transform': 'translateY(0)',
                '-ms-transform': 'translateY(0)',
                '-o-transform': 'translateY(0)',
                'transform': 'translateY(0)',
            });
        }   
        if( faqsCategoriesContainer.hasClass('is-fixed') ) {
            faqsCategoriesContainer.css({
                'left': faqsContainer.offset().left,
            });
        }
    });

    function closePanel(e) {
        e.preventDefault();
        faqsContainer.removeClass('slide-in').find('li').show();
        closeFaqsContainer.removeClass('move-left');
        $('body').removeClass('cd-overlay');
    }

    function updateCategory(){
        updateCategoryPosition();
        updateSelectedCategory();
    }

    function updateCategoryPosition() {
        var top = $('.cd-faq').offset().top,
            height = jQuery('.cd-faq').height() - jQuery('.cd-faq-categories').height(),
            margin = 20;
        if( top - margin <= $(window).scrollTop() && top - margin + height > $(window).scrollTop() ) {
            var leftValue = faqsCategoriesContainer.offset().left,
                widthValue = faqsCategoriesContainer.width();
            faqsCategoriesContainer.addClass('is-fixed').css({
                'left': leftValue,
                'top': margin,
                '-moz-transform': 'translateZ(0)',
                '-webkit-transform': 'translateZ(0)',
                '-ms-transform': 'translateZ(0)',
                '-o-transform': 'translateZ(0)',
                'transform': 'translateZ(0)',
            });
        } else if( top - margin + height <= $(window).scrollTop()) {
            var delta = top - margin + height - $(window).scrollTop();
            faqsCategoriesContainer.css({
                '-moz-transform': 'translateZ(0) translateY('+delta+'px)',
                '-webkit-transform': 'translateZ(0) translateY('+delta+'px)',
                '-ms-transform': 'translateZ(0) translateY('+delta+'px)',
                '-o-transform': 'translateZ(0) translateY('+delta+'px)',
                'transform': 'translateZ(0) translateY('+delta+'px)',
            });
        } else { 
            faqsCategoriesContainer.removeClass('is-fixed').css({
                'left': 0,
                'top': 0,
            });
        }
    }

    function updateSelectedCategory() {
        faqsSections.each(function(){
            var actual = $(this),
                margin = parseInt($('.cd-faq-title').eq(1).css('marginTop').replace('px', '')),
                activeCategory = $('.cd-faq-categories a[href="#'+actual.attr('id')+'"]'),
                topSection = (activeCategory.parent('li').is(':first-child')) ? 0 : Math.round(actual.offset().top);
            
            if ( ( topSection - 20 <= $(window).scrollTop() ) && ( Math.round(actual.offset().top) + actual.height() + margin - 20 > $(window).scrollTop() ) ) {
                activeCategory.addClass('selected');
            }else {
                activeCategory.removeClass('selected');
            }
        });
    }
});