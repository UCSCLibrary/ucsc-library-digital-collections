
//JS for LibAnswers widget
var springSpace = springSpace || {};
springSpace.la = springSpace.la  || {};
springSpace.la.fbcss_loaded = springSpace.la.fbcss_loaded || 0;

var springSpace=springSpace||{};springSpace.regex={email:/^<?(['a-zA-Z0-9_=\.\-\+&!#\$%\*\?\^\|\{\}\~])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,6})+>?$/i,url:/^((mailto|https?):)*\/\/.+/i,phone:/^\+?[0-9]{10,}$/,date:/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/,datetime:/^[0-9]{4}-[0-9]{2}-[0-9]{2}\s[0-9]{1,2}:[0-9]{2}(:[0-9]{2})?$/,color:/^#([a-f0-9A-F]{6}|[a-f0-9A-F]{3})$/};
if (typeof springSpace.la.widget_6282 == 'undefined') {

    springSpace.la.widget_6282 = function() {
        this.id = 6282;
        this.iid = 1773;
        this.$container = springSpace.jq('#s-la-widget-feedback-'+this.id);
        this.apiDomain = 'https://api2.libanswers.com';
        this.css_url = 'https://api2.libanswers.com/css2.43.5/LibAnswers_widget_feedback.css';
        this.customcss = "label.radio-inline:nth-of-type(3) {display:none;}";
        this.chaton = "Chat with Us";
        this.widgethtml = "<section id=\"s-la-widget-body-6282\"><div class=\"row\"><div class=\"col-sm-8\"><h1 id=\"s-la-widget-modal-label\" class=\"modal-title\" style=\"display:inline-block; margin-right: 15px;\"><\/h1><\/div><\/div><\/div><div id=\"s-la-widget-pane-faq\" class=\"s-la-widget-pane pane-left hidden\" aria-hidden=\"true\"><\/div><div class=\"row\">\n\t\t\t<div class=\"col-sm-7\"><div id=\"s-la-widget-pane-form\" class=\"s-la-widget-pane pane-left\"><div id=\"s-la-askform-6282\" class=\"s-la-askform s-la-askform-qu-2687\">\n    <form name=\"s-la-askform-form_6282\" id=\"s-la-askform-form_6282\"\n        method=\"POST\" enctype=\"multipart\/form-data\">\n        <input type=\"hidden\" name=\"instid\" value=\"1773\">\n        <input type=\"hidden\" name=\"quid\" value=\"2687\">\n        <input type=\"hidden\" name=\"qlog\" value=\"0\">\n        <input type=\"hidden\" name=\"source\" value=\"4\">\n        <input type=hidden name=\"assign\" value=\"0\">\n        <input type=hidden name=\"product_id\" value=\"6282\">\n        <input type=hidden name=\"tag\" value=\"Digital Collections\">\n                        <input type=\"hidden\" name=\"ip\" value=1 \/>\n        \n        <div class=\"form-group qtype_wrap\">\n                                            <label class=\"radio-inline\">\n                    <input type=\"radio\" name=\"qtype\" id=\"qtype_6282_\" value=\"\" checked=checked>\n                    A Question\n                <\/label>\n                                            <label class=\"radio-inline\">\n                    <input type=\"radio\" name=\"qtype\" id=\"qtype_6282_problem\" value=\"problem\" >\n                    A Problem\n                <\/label>\n                                            <label class=\"radio-inline\">\n                    <input type=\"radio\" name=\"qtype\" id=\"qtype_6282_idea\" value=\"idea\" >\n                    An Idea\n                <\/label>\n                                            <label class=\"radio-inline\">\n                    <input type=\"radio\" name=\"qtype\" id=\"qtype_6282_comment\" value=\"comment\" >\n                    Comment\n                <\/label>\n                    <\/div>\n\n        <div class=\"form-group pquestion_wrap\">\n            <label for=\"pquestion_6282\" class=\"control-label sr-only\">Subject<\/label>\n            <input type=\"text\" class=\"form-control\" name=\"pquestion\" id=\"pquestion_6282\" placeholder=\"Subject\" \/>\n        <\/div>\n\n        <div class=\"form-group pdetails_wrap\">\n            <label for=\"pdetails_6282\" class=\"control-label sr-only\">Details<\/label>\n            <textarea class=\"form-control\" name=\"pdetails\" rows=4 id=\"pdetails_6282\" placeholder=\"Details\"><\/textarea>\n        <\/div>\n\n        <div class=\"form-group pemail_wrap\">\n            <label for=\"pemail_6282\" class=\"control-label sr-only\">Your Email<\/label>\n            <input class=\"form-control\" type=text id=\"pemail_6282\" name=\"pemail\" value=\"\" required placeholder=\"Your Email\" \/>\n        <\/div>\n\n                <div class=\"sr-only s-la-askform-capt\">\n            <label for=\"secretcode\">Leave this field blank<\/label>\n            <input id=\"secretcode\" type=\"text\" value=\"\" name=\"secretcode\" \/>\n        <\/div>\n        \n        <div class=\"form-group\">\n            <button id=\"s-la-askform-submit-6282\" class=\"btn btn-primary s-la-askform-button\" type=\"submit\">\n                Submit\n            <\/button>\n        <\/div>\n            <\/form>\n<\/div>\n<\/div><div id=\"s-la-widget-pane-chat\" class=\"s-la-widget-pane pane-left hidden\" aria-hidden=\"true\"><\/div><\/div>\n\n\t\t\t<div class=\"col-sm-5\"><div id=\"s-la-widget-pane-results\" class=\"s-la-widget-pane pane-right hidden\" aria-hidden=\"true\"><h2>Search Results<\/h2>\n\t\t\t\t\t<div id=\"s-la-widget-results\"><ol class=\"list-unstyled\"><\/ol><\/div>\n\t\t\t\t\t<a id=\"s-la-widget-results-clear\" href=\"#\" class=\"pull-right\">(clear results)<\/a>\n\t\t\t\t<\/div><div id=\"s-la-widget-pane-faqlist\" class=\"s-la-widget-pane pane-right\" aria-hidden=\"false\"><h2>FAQs<\/h2><div id=\"s-la-content-faqlist-6282\" class=\"s-la-content-faqlist s-la-content\"><ul class=\"list-unstyled\"><li class=\"s-la-faq-listing\">\n\t\t\t<div class=s-la-faq-listing-q>\n\t\t\t\t<a href=\"https:\/\/answers.library.ucsc.edu\/digitalcollections\/faq\/274268\" data-faqid=\"274268\">What are the Digital Collections?<\/a>\n\t\t\t<\/div>\n\t\t<\/li><li class=\"s-la-faq-listing\">\n\t\t\t<div class=s-la-faq-listing-q>\n\t\t\t\t<a href=\"https:\/\/answers.library.ucsc.edu\/digitalcollections\/faq\/274270\" data-faqid=\"274270\">How do I report a problem when using the Digital Collections?<\/a>\n\t\t\t<\/div>\n\t\t<\/li><li class=\"s-la-faq-listing\">\n\t\t\t<div class=s-la-faq-listing-q>\n\t\t\t\t<a href=\"https:\/\/answers.library.ucsc.edu\/digitalcollections\/faq\/274274\" data-faqid=\"274274\">I see the item I'm interested in online, but for my research I need to see the physical object. How can I find out more about it?<\/a>\n\t\t\t<\/div>\n\t\t<\/li><li class=\"s-la-faq-listing\">\n\t\t\t<div class=s-la-faq-listing-q>\n\t\t\t\t<a href=\"https:\/\/answers.library.ucsc.edu\/digitalcollections\/faq\/274277\" data-faqid=\"274277\">How do I report a correction or provide additional information about an item in the digital collections?<\/a>\n\t\t\t<\/div>\n\t\t<\/li><li class=\"s-la-faq-listing\">\n\t\t\t<div class=s-la-faq-listing-q>\n\t\t\t\t<a href=\"https:\/\/answers.library.ucsc.edu\/digitalcollections\/faq\/274275\" data-faqid=\"274275\">I'm conducting research. Can you help me find more information about a particular topic?<\/a>\n\t\t\t<\/div>\n\t\t<\/li><\/ul><\/div>\n\t\t\t\t\t<div id=\"s-la-faqlist-search\"><a href=\"https:\/\/answers.library.ucsc.edu\/search\" target=\"_blank\">See all FAQs<\/a><\/div>\n\t\t\t\t<\/div><\/div>\n\t\t<\/div><\/section>";
        this.activator = "<button id=s-la-widget-activator-6282 class=\"btn btn-default s-la-widget-activator\" type=button >Feedback<\/button>";
        this.question = {};
        this.chatwidget = {};
        this.cascadeServer = "https:\/\/chat-us.libanswers.com";
        this.group_limiter = '6214';
        this.faq_template = "<h2>{{question}}<\/h2>\r\n{{#details}}<p>{{{details}}}<\/p>{{\/details}}\r\n{{#hastopics}}<div class=\"s-la-faq-listing-meta s-la-faq-listing-topics\"><span class=\"metalabel\">Topics<\/span> <ul class=\"list-inline metavalue\" aria-label=\"Topics\">{{\/hastopics}}{{#topics}}<li><span class=\"label label-topic\"><a href=\"{{url}}\">{{name}}<\/a><\/span><\/li>{{\/topics}}{{#hastopics}}<\/ul><\/div>{{\/hastopics}}\r\n<hr>\r\n<div class=\"s-la-faq-answer\">{{{answer}}}<\/div>\r\n{{#haslinks}}<div class=\"s-la-faq-links\"><h3>Links<\/h3><ul>{{\/haslinks}}\r\n{{#links}}<li><a href=\"{{url}}\">{{title}}<\/a><\/li>{{\/links}}\r\n{{#haslinks}}<\/ul><\/div>{{\/haslinks}}\r\n\r\n{{#hasfiles}}<div class=\"s-la-faq-files\"><h3>Files<\/h3><ul>{{\/hasfiles}}\r\n{{#files}}<li><a href=\"{{url}}\">{{title}}<\/a><\/li>{{\/files}}\r\n{{#hasfiles}}<\/ul><\/div>{{\/hasfiles}}\r\n\r\n{{#hasmedia}}<div class=\"s-la-faq-media\"><h3>Media<\/h3><ul class=\"list-unstyled\">{{\/hasmedia}}\r\n{{#media}}{{{content}}}{{\/media}}\r\n{{#hasmedia}}<\/ul><\/div>{{\/hasmedia}}\r\n<hr>\r\n<div class=\"s-la-faq-url text-right\"><a href=\"{{url.public}}\">View FAQ page<\/a><\/div>";
        this.lg_site_id = 0;

        if (springSpace.la.fbcss_loaded == 0) {
            if(document.createStyleSheet) {
                try { document.createStyleSheet(this.css_url); } catch (e) { }
            }
            else {
                var css_link = springSpace.jq("<link>", {
                    rel: "stylesheet",
                    type: "text/css",
                    href: this.css_url
                });
                css_link.appendTo('head');
            }
            springSpace.la.fbcss_loaded = 1;
        }
        if (this.customcss !== '') {
            springSpace.jq('<style>'+this.customcss+'</style>').appendTo('head');
        }

        var that = this; //for inside event handlers

        //search event
        this.typeahead_source = function(query, cb) {
            if (that.throttle) {
                clearTimeout(that.throttle);
            }
            if (that.search_xhr) { that.search_xhr.abort(); }
            that.throttle = setTimeout( function() {
                that.search_xhr = springSpace.jq.get(
                    that.apiDomain + '/1.0/combosearch/'+encodeURIComponent(query),
                    { limit: 5, iid: that.iid, group_ids: that.group_limiter, lg_site_id: that.lg_site_id },
                    function (d) {
                        if (!d) { return; }
                        that.displayResults(d);
                    },
                    'jsonp'
                );
              }, 500); //wait before running this
        }

        this.displayResults = function(results){
            var content = '';
            var faq_content = '';
            var guide_content = '';
            if (results.la.search && results.la.search.results && results.la.search.results.length > 0) {
                for(i=0; i < results.la.search.results.length; i++) {
                    var faq = results.la.search.results[i];
                    faq_content += '<li class="s-la-faq-listing"><div class="s-la-faq-listing-q"><a href="#" data-faqid="'+faq.id+'"><span class="sr-only">FAQ:</span><span class="s-la-widget-icon-faq" aria-hidden=true>?</span> '+faq.question+'</a></div></li>';
                }
            }

            if (results.lg.search && results.lg.search.results && results.lg.search.results.length > 0) {
                for(i=0; i < results.lg.search.results.length; i++) {
                    var guide = results.lg.search.results[i];
                    // @todo change the class here?
                    guide_content += '<li class="s-la-guide-listing"><div class="s-la-guide-listing-q"><a href="http://'+results.lg_domains[guide.site_id]+guide.url+'">'+guide.name+': '+guide.page_name+'</a></div></li>';
                }
            }

            content = faq_content + guide_content;

            if (content == '') {
                content += '<li class="s-la-faq-listing">No results found.</li>';
            }

            springSpace.jq('#s-la-widget-results ol').empty().html(content);
            that.prepFAQList();
            springSpace.jq('#s-la-widget-results-clear').on('click', function(e){ e.preventDefault(); that.showPane('faqlist'); });
            that.showPane('results');
        }

        this.showFaqList = function(w) {
            if (w == 'results') {
                springSpace.jq('#s-la-widget-results').removeClass('hidden').attr('aria-hidden', false);
                springSpace.jq('#s-la-content-faqlist-'+that.id).addClass('hidden').attr('aria-hidden', true);
            } else {
                springSpace.jq('#s-la-content-faqlist-'+that.id).removeClass('hidden').attr('aria-hidden', false);
                springSpace.jq('#s-la-widget-results').addClass('hidden').attr('aria-hidden', true);
            }

        }

        //FAQ related
        this.getFAQ = function(faqid) {
            springSpace.jq.get(
                that.apiDomain+'/1.0/faqs/'+faqid+'?iid='+that.iid,
                function(d) {
                    var output = springSpace.mustache.render(that.faq_template, d.faqs[0]);
                    that.displayFAQ(output);
                },
                'jsonp'
            );
        }

        this.displayFAQ = function(d) {
            var $close = springSpace.jq('<button></button>').attr({ type: 'button' }).addClass('btn btn-default s-la-widget-pane-close').html('&times;').on('click', function(e){
                springSpace.jq('#s-la-widget-body-'+that.id+' #s-la-widget-pane-faq').addClass('hidden').attr('aria-hidden', 'true');
            });
            var $section = springSpace.jq('<section></section>').append($close).append(d);
            springSpace.jq('#s-la-widget-body-'+that.id+' #s-la-widget-pane-faq').empty().append($section).removeClass('hidden').attr('aria-hidden', 'false');
            springSpace.jq('#s-la-widget-body-'+that.id+' #s-la-widget-pane-faq a').attr('target', '_blank');
        }


        //set question form
        this.prepQuestionForm = function() {
            var that = this;

            this.question.divselector = '#s-la-askform-'+this.id;
            this.question.$form = springSpace.jq(this.question.divselector+' form');
            if (this.question.$form.length == 0) { return; }
            if (typeof this.question.$form == 'undefined') { return; }
            this.question.queue_id = 2687;
            this.question.errormsg = {"emailaddress":"Invalid email address.","reqfields":"Please answer all required questions.","general":"Error: Please try again.","tech":"Error: Unknown browser\/network error. Please reload the page and try again. If you are still experiencing this error, please check your network connection and\/or try a different browser."};

            //qtype
/*
            this.question.$form.find('input[name=qtype]').on('change', function(e) {
                if (springSpace.jq(this).val() == 'idea') {
                    springSpace.jq('#s-la-widget-body-'+that.id+' #s-la-widget-pane-faqlist').addClass('hidden').attr('aria-hidden', true);
                    springSpace.jq('#s-la-widget-body-'+that.id+' #s-la-widget-pane-idealist').removeClass('hidden').attr('aria-hidden', false);
                } else {
                    springSpace.jq('#s-la-widget-body-'+that.id+' #s-la-widget-pane-idealist').addClass('hidden').attr('aria-hidden', true);
                    springSpace.jq('#s-la-widget-body-'+that.id+' #s-la-widget-pane-faqlist').removeClass('hidden').attr('aria-hidden', false);
                }
            });
*/

            //!enable autocomplete on form subject field
            this.question.$form.find('input[name=pquestion]').on('keyup', function(e){
                var val = springSpace.jq(this).val();
                if (val.length >= 3) {
                    that.typeahead_source(val);
                }

            });

            //!submit the form
            this.question.$form.submit(function(e){
                e.preventDefault();
                var incomplete = 0; var $focus = '';
                //reset validation
                var $this = springSpace.jq(this);
                $this.find('.has-error').removeClass('has-error');
                $this.find('label .error-message').remove();
                $this.find('label.control-label').addClass('sr-only');
                $this.find('.form-control').attr('aria-invalid', false);
                springSpace.jq('#s-la-askform-alert').remove();

                var $details = $this.find('textarea[name=pdetails]');
                if ($details.val().trim() === ''){
                    that.question.markError($details, that.question.errormsg.reqfields);
                    $focus = $details;
                }

                var $email = $this.find('input[name=pemail]');
                var emailask = springSpace.jq.trim( $email.val() );
                if (emailask !== '' && !emailask.match(springSpace.regex.email)) {
                    that.question.markError($email, that.question.errormsg.emailaddress);
                    if ($focus === '') { $focus = $email; }
                }
                if ( springSpace.jq(this).find('.has-error').length > 0 ) {
                    $focus.focus();
                    return false;
                }

                var $submitbutton = $this.find('button[type=submit]');
                var buttontext = $submitbutton.html();
                $submitbutton.html('Loading...').attr('disabled', true);

                var $data = $this.serializeArray();
                $data.push({
                    name: 'referer',
                    value: window.location.href
                });

                springSpace.jq.ajax({
                    type: 'POST',
                    url: that.apiDomain+'/1.0/feedback/submit',
                    data: $data,
                    dataType: 'json'
                }).done(function(data) {
                    that.question.formAlert('success', data.message, that.question.$form);
                    that.question.$form[0].reset();
                }).fail(function(jqXhr) {
                    var error = '';
                    var status = jqXhr.status;
                    if (jqXhr.responseText) {
                        try {
                            var response = JSON.parse(jqXhr.responseText);
                            if (response.error) {
                                error = response.error;
                            }
                        } catch (e) {
                            // in case the json is bad
                        }
                    }
                    if (error === '' && status !== 0) {
                        error = 'Error ' + status;
                    }
                    if (error === '') {
                        error = that.question.errormsg.tech;
                    }
                    that.question.formAlert('error', error, that.question.$form);
                }).always(function() {
                    $submitbutton.html(buttontext).removeAttr('disabled');
                });
            });

            //set an error (msg) for the input
            this.question.markError = function($input, msg) {
                var msg_div = springSpace.jq('<div class="error-message"></div>').html(msg);
                $input.attr('aria-invalid', true).parents('div.form-group').addClass('has-error').find('label').append(msg_div).removeClass('sr-only');
            }
            //alerts post submit
            this.question.formAlert = function(type, msg, $div) {
                if (typeof msg == 'undefined' || msg == '') { msg = (type=='error') ? 'Error' : 'Success.'; }
                var aclass = (type=='error') ? 'alert-danger' : 'alert-success';
                springSpace.jq('<div id="s-la-askform-alert" class="alert '+aclass+'" role="alert">'+msg+'</div>').insertAfter($div);
                return this;
            }
        } //end prepQuestionForm

        //pane switcher
        this.showPane = function(w) {
            //right columns
            if (w=='faqlist' || w=='results') {
                springSpace.jq('#s-la-widget-body-'+this.id+' .s-la-widget-pane.pane-right').addClass('hidden').attr('aria-hidden', true);
                springSpace.jq('#s-la-widget-body-'+this.id+' #s-la-widget-pane-'+w).removeClass('hidden').attr('aria-hidden', false);
                return;
            }
            springSpace.jq('#s-la-widget-body-'+this.id+' .s-la-widget-pane.pane-left').addClass('hidden').attr('aria-hidden', true);
            springSpace.jq('#s-la-widget-body-'+this.id+' #s-la-widget-pane-'+w).removeClass('hidden').attr('aria-hidden', false);
        }

        
        /** adjust faq list working */
        this.prepFAQList = function() {
            var that = this;
            springSpace.jq('#s-la-widget-results li a, #s-la-widget-pane-faqlist li a').on('click', function(e){
                e.preventDefault();
                var faqid = springSpace.jq(e.currentTarget).attr('data-faqid');
                if (faqid > 0) {
                    that.getFAQ(faqid);
                } else {
                    window.open( springSpace.jq(e.currentTarget).attr('href') );
                }
            });
        }

        //write out content
                    //!embed the html and attach event handlers
            this.$container.addClass('s-la-widget s-la-widget-embed').html(this.widgethtml);
            this.prepQuestionForm();
            this.prepFAQList();
                    
    } //end springSpace.la.widget

}

//!define the loader if we haven't already (in another widget)
if (typeof springSpace.la.fbwidget_loader == 'undefined') {
    springSpace.la.fbwidget_loader = function(widget_id) {
        this.widget_id = widget_id;
        var that = this;
        /** check jquery version up to (not including) second decimal, is the current version >= minimum version */
        this.minVersion = function(minv, curr) {
            var curr = curr || window.jQuery.fn.jquery;
            var c = curr.split('.');
            var m = minv.split('.');
            if (parseInt(c[0], 10) > parseInt(m[0], 10)) { return true; }
            else if (parseInt(c[0], 10) < parseInt(m[0], 10)) { return false; }
            else {
                if (typeof c[1] == 'undefined') { c[1] = 0; }
                if (typeof m[1] == 'undefined') { m[1] = 0; }
                if (parseInt(c[1], 10) > parseInt(m[1], 10)) { return true; }
                else if (parseInt(c[1], 10) < parseInt(m[1], 10)) { return false; }
                else { return true; }
            }
        }
        /** load jquery into the page if necessary (IE<11) */
        this.loadJquery = function(){
            var script_tag = document.createElement('script');
            script_tag.setAttribute("type","text/javascript");
            script_tag.setAttribute("src", "https://v2.libanswers.com/js2.43.5/jquery.min.js");
            if (script_tag.readyState) {
                script_tag.onreadystatechange = function () {
                    if (this.readyState == 'complete' || this.readyState == 'loaded') {
                        that.scriptLoadHandler();
                    }
                };
            } else {
                script_tag.onload = that.scriptLoadHandler;
            }
            (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script_tag);
        }
        /** Called once jQuery has loaded */
        this.scriptLoadHandler = function() {
            springSpace.jq = window.jQuery.noConflict(true);
            that.jsHandler();
        }
        /** run the libraries included (Zepto, Bootstrap Modal, and Mustache) */
        this.jsHandler = function() {
            var Zepto=function(){var s,a,c,i,u,n,r=[],l=r.slice,o=r.filter,h=window.document,f={},e={},d={"column-count":1,columns:1,"font-weight":1,"line-height":1,opacity:1,"z-index":1,zoom:1},p=/^\s*<(\w+|!)[^>]*>/,m=/^<(\w+)\s*\/?>(?:<\/\1>|)$/,v=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,g=/^(?:body|html)$/i,y=/([A-Z])/g,b=["val","css","html","text","data","width","height","offset"],t=h.createElement("table"),x=h.createElement("tr"),w={tr:h.createElement("tbody"),tbody:t,thead:t,tfoot:t,td:x,th:x,"*":h.createElement("div")},E=/complete|loaded|interactive/,C=/^[\w-]*$/,T={},S=T.toString,$={},k=h.createElement("div"),j={tabindex:"tabIndex",readonly:"readOnly",for:"htmlFor",class:"className",maxlength:"maxLength",cellspacing:"cellSpacing",cellpadding:"cellPadding",rowspan:"rowSpan",colspan:"colSpan",usemap:"useMap",frameborder:"frameBorder",contenteditable:"contentEditable"},A=Array.isArray||function(t){return t instanceof Array};function N(t){return null==t?String(t):T[S.call(t)]||"object"}function O(t){return"function"==N(t)}function P(t){return null!=t&&t==t.window}function D(t){return null!=t&&t.nodeType==t.DOCUMENT_NODE}function R(t){return"object"==N(t)}function I(t){return R(t)&&!P(t)&&Object.getPrototypeOf(t)==Object.prototype}function _(t){return"number"==typeof t.length}function G(t){return t.replace(/::/g,"/").replace(/([A-Z]+)([A-Z][a-z])/g,"$1_$2").replace(/([a-z\d])([A-Z])/g,"$1_$2").replace(/_/g,"-").toLowerCase()}function M(t){return t in e?e[t]:e[t]=new RegExp("(^|\\s)"+t+"(\\s|$)")}function z(t,e){return"number"!=typeof e||d[G(t)]?e:e+"px"}function B(t){return"children"in t?l.call(t.children):c.map(t.childNodes,function(t){if(1==t.nodeType)return t})}function U(t,e){return null==e?c(t):c(t).filter(e)}function F(t,e,n,i){return O(e)?e.call(t,n,i):e}function Z(t,e,n){null==n?t.removeAttribute(e):t.setAttribute(e,n)}function q(t,e){var n=t.className||"",i=n&&n.baseVal!==s;if(e===s)return i?n.baseVal:n;i?n.baseVal=e:t.className=e}function L(e){try{return e?"true"==e||"false"!=e&&("null"==e?null:+e+""==e?+e:/^[\[\{]/.test(e)?c.parseJSON(e):e):e}catch(t){return e}}return $.matches=function(t,e){if(!e||!t||1!==t.nodeType)return!1;var n=t.webkitMatchesSelector||t.mozMatchesSelector||t.oMatchesSelector||t.matchesSelector;if(n)return n.call(t,e);var i,r=t.parentNode,o=!r;return o&&(r=k).appendChild(t),i=~$.qsa(r,e).indexOf(t),o&&k.removeChild(t),i},u=function(t){return t.replace(/-+(.)?/g,function(t,e){return e?e.toUpperCase():""})},n=function(n){return o.call(n,function(t,e){return n.indexOf(t)==e})},$.fragment=function(t,e,n){var i,r,o;return m.test(t)&&(i=c(h.createElement(RegExp.$1))),i||(t.replace&&(t=t.replace(v,"<$1></$2>")),e===s&&(e=p.test(t)&&RegExp.$1),e in w||(e="*"),(o=w[e]).innerHTML=""+t,i=c.each(l.call(o.childNodes),function(){o.removeChild(this)})),I(n)&&(r=c(i),c.each(n,function(t,e){-1<b.indexOf(t)?r[t](e):r.attr(t,e)})),i},$.Z=function(t,e){return(t=t||[]).__proto__=c.fn,t.selector=e||"",t},$.isZ=function(t){return t instanceof $.Z},$.init=function(t,e){var n,i;if(!t)return $.Z();if("string"==typeof t)if("<"==(t=t.trim())[0]&&p.test(t))n=$.fragment(t,RegExp.$1,e),t=null;else{if(e!==s)return c(e).find(t);n=$.qsa(h,t)}else{if(O(t))return c(h).ready(t);if($.isZ(t))return t;if(A(t))i=t,n=o.call(i,function(t){return null!=t});else if(R(t))n=[t],t=null;else if(p.test(t))n=$.fragment(t.trim(),RegExp.$1,e),t=null;else{if(e!==s)return c(e).find(t);n=$.qsa(h,t)}}return $.Z(n,t)},(c=function(t,e){return $.init(t,e)}).extend=function(e){var n,t=l.call(arguments,1);return"boolean"==typeof e&&(n=e,e=t.shift()),t.forEach(function(t){!function t(e,n,i){for(a in n)i&&(I(n[a])||A(n[a]))?(I(n[a])&&!I(e[a])&&(e[a]={}),A(n[a])&&!A(e[a])&&(e[a]=[]),t(e[a],n[a],i)):n[a]!==s&&(e[a]=n[a])}(e,t,n)}),e},$.qsa=function(t,e){var n,i="#"==e[0],r=!i&&"."==e[0],o=i||r?e.slice(1):e,s=C.test(o);return D(t)&&s&&i?(n=t.getElementById(o))?[n]:[]:1!==t.nodeType&&9!==t.nodeType?[]:l.call(s&&!i?r?t.getElementsByClassName(o):t.getElementsByTagName(e):t.querySelectorAll(e))},c.contains=h.documentElement.contains?function(t,e){return t!==e&&t.contains(e)}:function(t,e){for(;e=e&&e.parentNode;)if(e===t)return!0;return!1},c.type=N,c.isFunction=O,c.isWindow=P,c.isArray=A,c.isPlainObject=I,c.isEmptyObject=function(t){var e;for(e in t)return!1;return!0},c.inArray=function(t,e,n){return r.indexOf.call(e,t,n)},c.camelCase=u,c.trim=function(t){return null==t?"":String.prototype.trim.call(t)},c.uuid=0,c.support={},c.expr={},c.map=function(t,e){var n,i,r,o,s=[];if(_(t))for(i=0;i<t.length;i++)null!=(n=e(t[i],i))&&s.push(n);else for(r in t)null!=(n=e(t[r],r))&&s.push(n);return 0<(o=s).length?c.fn.concat.apply([],o):o},c.each=function(t,e){var n,i;if(_(t)){for(n=0;n<t.length;n++)if(!1===e.call(t[n],n,t[n]))return t}else for(i in t)if(!1===e.call(t[i],i,t[i]))return t;return t},c.grep=function(t,e){return o.call(t,e)},window.JSON&&(c.parseJSON=JSON.parse),c.each("Boolean Number String Function Array Date RegExp Object Error".split(" "),function(t,e){T["[object "+e+"]"]=e.toLowerCase()}),c.fn={forEach:r.forEach,reduce:r.reduce,push:r.push,sort:r.sort,indexOf:r.indexOf,concat:r.concat,map:function(n){return c(c.map(this,function(t,e){return n.call(t,e,t)}))},slice:function(){return c(l.apply(this,arguments))},ready:function(t){return E.test(h.readyState)&&h.body?t(c):h.addEventListener("DOMContentLoaded",function(){t(c)},!1),this},get:function(t){return t===s?l.call(this):this[0<=t?t:t+this.length]},toArray:function(){return this.get()},size:function(){return this.length},remove:function(){return this.each(function(){null!=this.parentNode&&this.parentNode.removeChild(this)})},each:function(n){return r.every.call(this,function(t,e){return!1!==n.call(t,e,t)}),this},filter:function(e){return O(e)?this.not(this.not(e)):c(o.call(this,function(t){return $.matches(t,e)}))},add:function(t,e){return c(n(this.concat(c(t,e))))},is:function(t){return 0<this.length&&$.matches(this[0],t)},not:function(e){var n=[];if(O(e)&&e.call!==s)this.each(function(t){e.call(this,t)||n.push(this)});else{var i="string"==typeof e?this.filter(e):_(e)&&O(e.item)?l.call(e):c(e);this.forEach(function(t){i.indexOf(t)<0&&n.push(t)})}return c(n)},has:function(t){return this.filter(function(){return R(t)?c.contains(this,t):c(this).find(t).size()})},eq:function(t){return-1===t?this.slice(t):this.slice(t,+t+1)},first:function(){var t=this[0];return t&&!R(t)?t:c(t)},last:function(){var t=this[this.length-1];return t&&!R(t)?t:c(t)},find:function(t){var n=this;return t?"object"==typeof t?c(t).filter(function(){var e=this;return r.some.call(n,function(t){return c.contains(t,e)})}):1==this.length?c($.qsa(this[0],t)):this.map(function(){return $.qsa(this,t)}):c()},closest:function(t,e){var n=this[0],i=!1;for("object"==typeof t&&(i=c(t));n&&!(i?0<=i.indexOf(n):$.matches(n,t));)n=n!==e&&!D(n)&&n.parentNode;return c(n)},parents:function(t){for(var e=[],n=this;0<n.length;)n=c.map(n,function(t){if((t=t.parentNode)&&!D(t)&&e.indexOf(t)<0)return e.push(t),t});return U(e,t)},parent:function(t){return U(n(this.pluck("parentNode")),t)},children:function(t){return U(this.map(function(){return B(this)}),t)},contents:function(){return this.map(function(){return l.call(this.childNodes)})},siblings:function(t){return U(this.map(function(t,e){return o.call(B(e.parentNode),function(t){return t!==e})}),t)},empty:function(){return this.each(function(){this.innerHTML=""})},pluck:function(e){return c.map(this,function(t){return t[e]})},show:function(){return this.each(function(){var t,e,n;"none"==this.style.display&&(this.style.display=""),"none"==getComputedStyle(this,"").getPropertyValue("display")&&(this.style.display=(t=this.nodeName,f[t]||(e=h.createElement(t),h.body.appendChild(e),n=getComputedStyle(e,"").getPropertyValue("display"),e.parentNode.removeChild(e),"none"==n&&(n="block"),f[t]=n),f[t]))})},replaceWith:function(t){return this.before(t).remove()},wrap:function(e){var n=O(e);if(this[0]&&!n)var i=c(e).get(0),r=i.parentNode||1<this.length;return this.each(function(t){c(this).wrapAll(n?e.call(this,t):r?i.cloneNode(!0):i)})},wrapAll:function(t){if(this[0]){var e;for(c(this[0]).before(t=c(t));(e=t.children()).length;)t=e.first();c(t).append(this)}return this},wrapInner:function(r){var o=O(r);return this.each(function(t){var e=c(this),n=e.contents(),i=o?r.call(this,t):r;n.length?n.wrapAll(i):e.append(i)})},unwrap:function(){return this.parent().each(function(){c(this).replaceWith(c(this).children())}),this},clone:function(){return this.map(function(){return this.cloneNode(!0)})},hide:function(){return this.css("display","none")},toggle:function(e){return this.each(function(){var t=c(this);(e===s?"none"==t.css("display"):e)?t.show():t.hide()})},prev:function(t){return c(this.pluck("previousElementSibling")).filter(t||"*")},next:function(t){return c(this.pluck("nextElementSibling")).filter(t||"*")},html:function(n){return 0 in arguments?this.each(function(t){var e=this.innerHTML;c(this).empty().append(F(this,n,t,e))}):0 in this?this[0].innerHTML:null},text:function(n){return 0 in arguments?this.each(function(t){var e=F(this,n,t,this.textContent);this.textContent=null==e?"":""+e}):0 in this?this[0].textContent:null},attr:function(e,n){var t;return"string"!=typeof e||1 in arguments?this.each(function(t){if(1===this.nodeType)if(R(e))for(a in e)Z(this,a,e[a]);else Z(this,e,F(this,n,t,this.getAttribute(e)))}):this.length&&1===this[0].nodeType?!(t=this[0].getAttribute(e))&&e in this[0]?this[0][e]:t:s},removeAttr:function(t){return this.each(function(){1===this.nodeType&&t.split(" ").forEach(function(t){Z(this,t)},this)})},prop:function(e,n){return e=j[e]||e,1 in arguments?this.each(function(t){this[e]=F(this,n,t,this[e])}):this[0]&&this[0][e]},data:function(t,e){var n="data-"+t.replace(y,"-$1").toLowerCase(),i=1 in arguments?this.attr(n,e):this.attr(n);return null!==i?L(i):s},val:function(e){return 0 in arguments?this.each(function(t){this.value=F(this,e,t,this.value)}):this[0]&&(this[0].multiple?c(this[0]).find("option").filter(function(){return this.selected}).pluck("value"):this[0].value)},offset:function(o){if(o)return this.each(function(t){var e=c(this),n=F(this,o,t,e.offset()),i=e.offsetParent().offset(),r={top:n.top-i.top,left:n.left-i.left};"static"==e.css("position")&&(r.position="relative"),e.css(r)});if(!this.length)return null;var t=this[0].getBoundingClientRect();return{left:t.left+window.pageXOffset,top:t.top+window.pageYOffset,width:Math.round(t.width),height:Math.round(t.height)}},css:function(t,e){if(arguments.length<2){var n,i=this[0];if(!i)return;if(n=getComputedStyle(i,""),"string"==typeof t)return i.style[u(t)]||n.getPropertyValue(t);if(A(t)){var r={};return c.each(t,function(t,e){r[e]=i.style[u(e)]||n.getPropertyValue(e)}),r}}var o="";if("string"==N(t))e||0===e?o=G(t)+":"+z(t,e):this.each(function(){this.style.removeProperty(G(t))});else for(a in t)t[a]||0===t[a]?o+=G(a)+":"+z(a,t[a])+";":this.each(function(){this.style.removeProperty(G(a))});return this.each(function(){this.style.cssText+=";"+o})},index:function(t){return t?this.indexOf(c(t)[0]):this.parent().children().indexOf(this[0])},hasClass:function(t){return!!t&&r.some.call(this,function(t){return this.test(q(t))},M(t))},addClass:function(n){return n?this.each(function(t){if("className"in this){i=[];var e=q(this);F(this,n,t,e).split(/\s+/g).forEach(function(t){c(this).hasClass(t)||i.push(t)},this),i.length&&q(this,e+(e?" ":"")+i.join(" "))}}):this},removeClass:function(e){return this.each(function(t){if("className"in this){if(e===s)return q(this,"");i=q(this),F(this,e,t,i).split(/\s+/g).forEach(function(t){i=i.replace(M(t)," ")}),q(this,i.trim())}})},toggleClass:function(n,i){return n?this.each(function(t){var e=c(this);F(this,n,t,q(this)).split(/\s+/g).forEach(function(t){(i===s?!e.hasClass(t):i)?e.addClass(t):e.removeClass(t)})}):this},scrollTop:function(t){if(this.length){var e="scrollTop"in this[0];return t===s?e?this[0].scrollTop:this[0].pageYOffset:this.each(e?function(){this.scrollTop=t}:function(){this.scrollTo(this.scrollX,t)})}},scrollLeft:function(t){if(this.length){var e="scrollLeft"in this[0];return t===s?e?this[0].scrollLeft:this[0].pageXOffset:this.each(e?function(){this.scrollLeft=t}:function(){this.scrollTo(t,this.scrollY)})}},position:function(){if(this.length){var t=this[0],e=this.offsetParent(),n=this.offset(),i=g.test(e[0].nodeName)?{top:0,left:0}:e.offset();return n.top-=parseFloat(c(t).css("margin-top"))||0,n.left-=parseFloat(c(t).css("margin-left"))||0,i.top+=parseFloat(c(e[0]).css("border-top-width"))||0,i.left+=parseFloat(c(e[0]).css("border-left-width"))||0,{top:n.top-i.top,left:n.left-i.left}}},offsetParent:function(){return this.map(function(){for(var t=this.offsetParent||h.body;t&&!g.test(t.nodeName)&&"static"==c(t).css("position");)t=t.offsetParent;return t})}},c.fn.detach=c.fn.remove,["width","height"].forEach(function(i){var r=i.replace(/./,function(t){return t[0].toUpperCase()});c.fn[i]=function(e){var t,n=this[0];return e===s?P(n)?n["inner"+r]:D(n)?n.documentElement["scroll"+r]:(t=this.offset())&&t[i]:this.each(function(t){(n=c(this)).css(i,F(this,e,t,n[i]()))})}}),["after","prepend","before","append"].forEach(function(e,s){var a=s%2;c.fn[e]=function(){var e,i,r=c.map(arguments,function(t){return"object"==(e=N(t))||"array"==e||null==t?t:$.fragment(t)}),o=1<this.length;return r.length<1?this:this.each(function(t,e){i=a?e:e.parentNode,e=0==s?e.nextSibling:1==s?e.firstChild:2==s?e:null;var n=c.contains(h.documentElement,i);r.forEach(function(t){if(o)t=t.cloneNode(!0);else if(!i)return c(t).remove();i.insertBefore(t,e),n&&function t(e,n){n(e);for(var i=0,r=e.childNodes.length;i<r;i++)t(e.childNodes[i],n)}(t,function(t){null==t.nodeName||"SCRIPT"!==t.nodeName.toUpperCase()||t.type&&"text/javascript"!==t.type||t.src||window.eval.call(window,t.innerHTML)})})})},c.fn[a?e+"To":"insert"+(s?"Before":"After")]=function(t){return c(t)[e](this),this}}),$.Z.prototype=c.fn,$.uniq=n,$.deserializeValue=L,c.zepto=$,c}();window.Zepto=Zepto,void 0===window.$&&(window.$=Zepto),function(l){function u(t){return"string"==typeof t}var h,e=1,f=Array.prototype.slice,d=l.isFunction,p={},o={},n="onfocusin"in window,i={focus:"focusin",blur:"focusout"},m={mouseenter:"mouseover",mouseleave:"mouseout"};function v(t){return t._zid||(t._zid=e++)}function s(t,e,n,i){if((e=g(e)).ns)var r=(o=e.ns,new RegExp("(?:^| )"+o.replace(" "," .* ?")+"(?: |$)"));var o;return(p[v(t)]||[]).filter(function(t){return t&&(!e.e||t.e==e.e)&&(!e.ns||r.test(t.ns))&&(!n||v(t.fn)===v(n))&&(!i||t.sel==i)})}function g(t){var e=(""+t).split(".");return{e:e[0],ns:e.slice(1).sort().join(" ")}}function y(t,e){return t.del&&!n&&t.e in i||!!e}function b(t){return m[t]||n&&i[t]||t}function x(r,t,e,o,s,a,c){var n=v(r),u=p[n]||(p[n]=[]);t.split(/\s/).forEach(function(t){if("ready"==t)return l(document).ready(e);var n=g(t);n.fn=e,n.sel=s,n.e in m&&(e=function(t){var e=t.relatedTarget;if(!e||e!==this&&!l.contains(this,e))return n.fn.apply(this,arguments)});var i=(n.del=a)||e;n.proxy=function(t){if(!(t=C(t)).isImmediatePropagationStopped()){t.data=o;var e=i.apply(r,t._args==h?[t]:[t].concat(t._args));return!1===e&&(t.preventDefault(),t.stopPropagation()),e}},n.i=u.length,u.push(n),"addEventListener"in r&&r.addEventListener(b(n.e),n.proxy,y(n,c))})}function w(e,t,n,i,r){var o=v(e);(t||"").split(/\s/).forEach(function(t){s(e,t,n,i).forEach(function(t){delete p[o][t.i],"removeEventListener"in e&&e.removeEventListener(b(t.e),t.proxy,y(t,r))})})}o.click=o.mousedown=o.mouseup=o.mousemove="MouseEvents",l.event={add:x,remove:w},l.proxy=function(t,e){var n=2 in arguments&&f.call(arguments,2);if(d(t)){function i(){return t.apply(e,n?n.concat(f.call(arguments)):arguments)}return i._zid=v(t),i}if(u(e))return n?(n.unshift(t[e],t),l.proxy.apply(null,n)):l.proxy(t[e],t);throw new TypeError("expected function")},l.fn.bind=function(t,e,n){return this.on(t,e,n)},l.fn.unbind=function(t,e){return this.off(t,e)},l.fn.one=function(t,e,n,i){return this.on(t,e,n,i,1)};var a=function(){return!0},E=function(){return!1},r=/^([A-Z]|returnValue$|layer[XY]$)/,t={preventDefault:"isDefaultPrevented",stopImmediatePropagation:"isImmediatePropagationStopped",stopPropagation:"isPropagationStopped"};function C(i,r){return!r&&i.isDefaultPrevented||(r=r||i,l.each(t,function(t,e){var n=r[t];i[t]=function(){return this[e]=a,n&&n.apply(r,arguments)},i[e]=E}),(r.defaultPrevented!==h?r.defaultPrevented:"returnValue"in r?!1===r.returnValue:r.getPreventDefault&&r.getPreventDefault())&&(i.isDefaultPrevented=a)),i}function T(t){var e,n={originalEvent:t};for(e in t)r.test(e)||t[e]===h||(n[e]=t[e]);return C(n,t)}l.fn.delegate=function(t,e,n){return this.on(e,t,n)},l.fn.undelegate=function(t,e,n){return this.off(e,t,n)},l.fn.live=function(t,e){return l(document.body).delegate(this.selector,t,e),this},l.fn.die=function(t,e){return l(document.body).undelegate(this.selector,t,e),this},l.fn.on=function(e,r,n,o,s){var a,c,i=this;return e&&!u(e)?(l.each(e,function(t,e){i.on(t,r,n,e,s)}),i):(u(r)||d(o)||!1===o||(o=n,n=r,r=h),!d(n)&&!1!==n||(o=n,n=h),!1===o&&(o=E),i.each(function(t,i){s&&(a=function(t){return w(i,t.type,o),o.apply(this,arguments)}),r&&(c=function(t){var e,n=l(t.target).closest(r,i).get(0);if(n&&n!==i)return e=l.extend(T(t),{currentTarget:n,liveFired:i}),(a||o).apply(n,[e].concat(f.call(arguments,1)))}),x(i,e,o,n,r,c||a)}))},l.fn.off=function(t,n,e){var i=this;return t&&!u(t)?(l.each(t,function(t,e){i.off(t,n,e)}),i):(u(n)||d(e)||!1===e||(e=n,n=h),!1===e&&(e=E),i.each(function(){w(this,t,e,n)}))},l.fn.trigger=function(t,e){return(t=u(t)||l.isPlainObject(t)?l.Event(t):C(t))._args=e,this.each(function(){t.type in i&&"function"==typeof this[t.type]?this[t.type]():"dispatchEvent"in this?this.dispatchEvent(t):l(this).triggerHandler(t,e)})},l.fn.triggerHandler=function(n,i){var r,o;return this.each(function(t,e){(r=T(u(n)?l.Event(n):n))._args=i,r.target=e,l.each(s(e,n.type||n),function(t,e){if(o=e.proxy(r),r.isImmediatePropagationStopped())return!1})}),o},"focusin focusout focus blur load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select keydown keypress keyup error".split(" ").forEach(function(e){l.fn[e]=function(t){return 0 in arguments?this.bind(e,t):this.trigger(e)}}),l.Event=function(t,e){u(t)||(t=(e=t).type);var n=document.createEvent(o[t]||"Events"),i=!0;if(e)for(var r in e)"bubbles"==r?i=!!e[r]:n[r]=e[r];return n.initEvent(t,i,!0),C(n)}}(Zepto),function(dh){var gh,hh,eh=0,fh=window.document,ih=/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,jh=/^(?:text|application)\/javascript/i,kh=/^(?:text|application)\/xml/i,lh="application/json",mh="text/html",nh=/^\s*$/,oh=fh.createElement("a");function qh(t,e,n,i){if(t.global)return r=e||fh,o=n,s=i,a=dh.Event(o),dh(r).trigger(a,s),!a.isDefaultPrevented();var r,o,s,a}function th(t,e){var n=e.context;if(!1===e.beforeSend.call(n,t,e)||!1===qh(e,n,"ajaxBeforeSend",[t,e]))return!1;qh(e,n,"ajaxSend",[t,e])}function uh(t,e,n,i){var r=n.context,o="success";n.success.call(r,t,o,e),i&&i.resolveWith(r,[t,o,e]),qh(n,r,"ajaxSuccess",[e,n,t]),wh(o,e,n)}function vh(t,e,n,i,r){var o=i.context;i.error.call(o,n,e,t),r&&r.rejectWith(o,[n,e,t]),qh(i,o,"ajaxError",[n,i,t||e]),wh(e,n,i)}function wh(t,e,n){var i,r=n.context;n.complete.call(r,e,t),qh(n,r,"ajaxComplete",[e,n]),(i=n).global&&!--dh.active&&qh(i,null,"ajaxStop")}function xh(){}function zh(t,e){return""==e?t:(t+"&"+e).replace(/[&?]{1,2}/,"?")}function Bh(t,e,n,i){return dh.isFunction(e)&&(i=n,n=e,e=void 0),dh.isFunction(n)||(i=n,n=void 0),{url:t,data:e,success:n,dataType:i}}oh.href=window.location.href,dh.active=0,dh.ajaxJSONP=function(n,i){if(!("type"in n))return dh.ajax(n);function t(t){dh(a).triggerHandler("error",t||"abort")}var r,o,e=n.jsonpCallback,s=(dh.isFunction(e)?e():e)||"jsonp"+ ++eh,a=fh.createElement("script"),c=window[s],u={abort:t};return i&&i.promise(u),dh(a).on("load error",function(t,e){clearTimeout(o),dh(a).off().remove(),"error"!=t.type&&r?uh(r[0],u,n,i):vh(null,e||"error",u,n,i),window[s]=c,r&&dh.isFunction(c)&&c(r[0]),c=r=void 0}),!1===th(u,n)?t("abort"):(window[s]=function(){r=arguments},a.src=n.url.replace(/\?(.+)=\?/,"?$1="+s),fh.head.appendChild(a),0<n.timeout&&(o=setTimeout(function(){t("timeout")},n.timeout))),u},dh.ajaxSettings={type:"GET",beforeSend:xh,success:xh,error:xh,complete:xh,context:null,global:!0,xhr:function(){return new window.XMLHttpRequest},accepts:{script:"text/javascript, application/javascript, application/x-javascript",json:lh,xml:"application/xml, text/xml",html:mh,text:"text/plain"},crossDomain:!1,timeout:0,processData:!0,cache:!0},dh.ajax=function(wi){var zi,Mh,vi,xi=dh.extend({},wi||{}),yi=dh.Deferred&&dh.Deferred();for(gh in dh.ajaxSettings)void 0===xi[gh]&&(xi[gh]=dh.ajaxSettings[gh]);(Mh=xi).global&&0==dh.active++&&qh(Mh,null,"ajaxStart"),xi.crossDomain||((zi=fh.createElement("a")).href=xi.url,zi.href=zi.href,xi.crossDomain=oh.protocol+"//"+oh.host!=zi.protocol+"//"+zi.host),xi.url||(xi.url=window.location.toString()),(vi=xi).processData&&vi.data&&"string"!=dh.type(vi.data)&&(vi.data=dh.param(vi.data,vi.traditional)),!vi.data||vi.type&&"GET"!=vi.type.toUpperCase()||(vi.url=zh(vi.url,vi.data),vi.data=void 0);var Ai=xi.dataType,Bi=/\?.+=\?/.test(xi.url);if(Bi&&(Ai="jsonp"),!1!==xi.cache&&(wi&&!0===wi.cache||"script"!=Ai&&"jsonp"!=Ai)||(xi.url=zh(xi.url,"_="+Date.now())),"jsonp"==Ai)return Bi||(xi.url=zh(xi.url,xi.jsonp?xi.jsonp+"=?":!1===xi.jsonp?"":"callback=?")),dh.ajaxJSONP(xi,yi);function Ei(t,e){Di[t.toLowerCase()]=[t,e]}var Ii,Ci=xi.accepts[Ai],Di={},Fi=/^([\w-]+:)\/\//.test(xi.url)?RegExp.$1:window.location.protocol,Gi=xi.xhr(),Hi=Gi.setRequestHeader;if(yi&&yi.promise(Gi),xi.crossDomain||Ei("X-Requested-With","XMLHttpRequest"),Ei("Accept",Ci||"*/*"),(Ci=xi.mimeType||Ci)&&(-1<Ci.indexOf(",")&&(Ci=Ci.split(",",2)[0]),Gi.overrideMimeType&&Gi.overrideMimeType(Ci)),(xi.contentType||!1!==xi.contentType&&xi.data&&"GET"!=xi.type.toUpperCase())&&Ei("Content-Type",xi.contentType||"application/x-www-form-urlencoded"),xi.headers)for(hh in xi.headers)Ei(hh,xi.headers[hh]);if(Gi.setRequestHeader=Ei,!(Gi.onreadystatechange=function(){if(4==Gi.readyState){Gi.onreadystatechange=xh,clearTimeout(Ii);var Mi,Ni=!1;if(200<=Gi.status&&Gi.status<300||304==Gi.status||0==Gi.status&&"file:"==Fi){Ai=Ai||((si=(si=xi.mimeType||Gi.getResponseHeader("content-type"))&&si.split(";",2)[0])&&(si==mh?"html":si==lh?"json":jh.test(si)?"script":kh.test(si)&&"xml")||"text"),Mi=Gi.responseText;try{"script"==Ai?eval(Mi):"xml"==Ai?Mi=Gi.responseXML:"json"==Ai&&(Mi=nh.test(Mi)?null:dh.parseJSON(Mi))}catch(t){Ni=t}Ni?vh(Ni,"parsererror",Gi,xi,yi):uh(Mi,Gi,xi,yi)}else vh(Gi.statusText||null,Gi.status?"error":"abort",Gi,xi,yi)}var si})===th(Gi,xi))return Gi.abort(),vh(null,"abort",Gi,xi,yi),Gi;if(xi.xhrFields)for(hh in xi.xhrFields)Gi[hh]=xi.xhrFields[hh];var Ji=!("async"in xi)||xi.async;for(hh in Gi.open(xi.type,xi.url,Ji,xi.username,xi.password),Di)Hi.apply(Gi,Di[hh]);return 0<xi.timeout&&(Ii=setTimeout(function(){Gi.onreadystatechange=xh,Gi.abort(),vh(null,"timeout",Gi,xi,yi)},xi.timeout)),Gi.send(xi.data?xi.data:null),Gi},dh.get=function(){return dh.ajax(Bh.apply(null,arguments))},dh.post=function(){var t=Bh.apply(null,arguments);return t.type="POST",dh.ajax(t)},dh.getJSON=function(){var t=Bh.apply(null,arguments);return t.dataType="json",dh.ajax(t)},dh.fn.load=function(t,e,n){if(!this.length)return this;var i,r=this,o=t.split(/\s/),s=Bh(t,e,n),a=s.success;return 1<o.length&&(s.url=o[0],i=o[1]),s.success=function(t){r.html(i?dh("<div>").html(t.replace(ih,"")).find(i):t),a&&a.apply(r,arguments)},dh.ajax(s),this};var Ch=encodeURIComponent;dh.param=function(t,e){var n=[];return n.add=function(t,e){dh.isFunction(e)&&(e=e()),null==e&&(e=""),this.push(Ch(t)+"="+Ch(e))},function n(i,t,r,o){var s,a=dh.isArray(t),c=dh.isPlainObject(t);dh.each(t,function(t,e){s=dh.type(e),o&&(t=r?o:o+"["+(c||"object"==s||"array"==s?t:"")+"]"),!o&&a?i.add(e.name,e.value):"array"==s||!r&&"object"==s?n(i,e,r,t):i.add(t,e)})}(n,t,e),n.join("&").replace(/%20/g,"+")}}(Zepto),function(o){o.fn.serializeArray=function(){var n,i,e=[],r=function(t){if(t.forEach)return t.forEach(r);e.push({name:n,value:t})};return this[0]&&o.each(this[0].elements,function(t,e){i=e.type,(n=e.name)&&"fieldset"!=e.nodeName.toLowerCase()&&!e.disabled&&"submit"!=i&&"reset"!=i&&"button"!=i&&"file"!=i&&("radio"!=i&&"checkbox"!=i||e.checked)&&r(o(e).val())}),e},o.fn.serialize=function(){var e=[];return this.serializeArray().forEach(function(t){e.push(encodeURIComponent(t.name)+"="+encodeURIComponent(t.value))}),e.join("&")},o.fn.submit=function(t){if(0 in arguments)this.bind("submit",t);else if(this.length){var e=o.Event("submit");this.eq(0).trigger(e),e.isDefaultPrevented()||this.get(0).submit()}return this}}(Zepto),function(a){var c={},o=a.fn.data,u=a.camelCase,l=a.expando="Zepto"+ +new Date,h=[];function s(t,e,n){var i,r,o=t[l]||(t[l]=++a.uuid),s=c[o]||(c[o]=(i=t,r={},a.each(i.attributes||h,function(t,e){0==e.name.indexOf("data-")&&(r[u(e.name.replace("data-",""))]=a.zepto.deserializeValue(e.value))}),r));return void 0!==e&&(s[u(e)]=n),s}a.fn.data=function(e,t){return void 0===t?a.isPlainObject(e)?this.each(function(t,n){a.each(e,function(t,e){s(n,t,e)})}):0 in this?function(t,e){var n=t[l],i=n&&c[n];if(void 0===e)return i||s(t);if(i){if(e in i)return i[e];var r=u(e);if(r in i)return i[r]}return o.call(a(t),e)}(this[0],e):void 0:this.each(function(){s(this,e,t)})},a.fn.removeData=function(n){return"string"==typeof n&&(n=n.split(/\s+/)),this.each(function(){var t=this[l],e=t&&c[t];e&&a.each(n||e,function(t){delete e[n?u(this):t]})})},["remove","empty"].forEach(function(e){var n=a.fn[e];a.fn[e]=function(){var t=this.find("*");return"remove"===e&&(t=t.add(this)),t.removeData(),n.call(this)}})}(Zepto),function(n){"__proto__"in{}||n.extend(n.zepto,{Z:function(t,e){return t=t||[],n.extend(t,n.fn),t.selector=e||"",t.__Z=!0,t},isZ:function(t){return"array"===n.type(t)&&"__Z"in t}});try{getComputedStyle(void 0)}catch(t){var e=getComputedStyle;window.getComputedStyle=function(t){try{return e(t)}catch(t){return null}}}}(Zepto),function(l){var h=Array.prototype.slice;function f(t){var r=[["resolve","done",l.Callbacks({once:1,memory:1}),"resolved"],["reject","fail",l.Callbacks({once:1,memory:1}),"rejected"],["notify","progress",l.Callbacks({memory:1})]],o="pending",s={state:function(){return o},always:function(){return a.done(arguments).fail(arguments),this},then:function(){var e=arguments;return f(function(o){l.each(r,function(t,i){var r=l.isFunction(e[t])&&e[t];a[i[1]](function(){var t=r&&r.apply(this,arguments);if(t&&l.isFunction(t.promise))t.promise().done(o.resolve).fail(o.reject).progress(o.notify);else{var e=this===s?o.promise():this,n=r?[t]:arguments;o[i[0]+"With"](e,n)}})}),e=null}).promise()},promise:function(t){return null!=t?l.extend(t,s):s}},a={};return l.each(r,function(t,e){var n=e[2],i=e[3];s[e[1]]=n.add,i&&n.add(function(){o=i},r[1^t][2].disable,r[2][2].lock),a[e[0]]=function(){return a[e[0]+"With"](this===a?s:this,arguments),this},a[e[0]+"With"]=n.fireWith}),s.promise(a),t&&t.call(a,a),a}l.when=function(t){function e(e,n,i){return function(t){n[e]=this,i[e]=1<arguments.length?h.call(arguments):t,i===r?u.notifyWith(n,i):--c||u.resolveWith(n,i)}}var r,n,i,o=h.call(arguments),s=o.length,a=0,c=1!==s||t&&l.isFunction(t.promise)?s:0,u=1===c?t:f();if(1<s)for(r=new Array(s),n=new Array(s),i=new Array(s);a<s;++a)o[a]&&l.isFunction(o[a].promise)?o[a].promise().done(e(a,i,o)).fail(u.reject).progress(e(a,n,r)):--c;return c||u.resolveWith(i,o),u.promise()},l.Deferred=f}(Zepto),function(f){f.Callbacks=function(i){i=f.extend({},i);var e,n,r,o,s,a,c=[],u=!i.once&&[],l=function(t){for(e=i.memory&&t,n=!0,a=o||0,o=0,s=c.length,r=!0;c&&a<s;++a)if(!1===c[a].apply(t[0],t[1])&&i.stopOnFalse){e=!1;break}r=!1,c&&(u?u.length&&l(u.shift()):e?c.length=0:h.disable())},h={add:function(){if(c){var t=c.length,n=function(t){f.each(t,function(t,e){"function"==typeof e?i.unique&&h.has(e)||c.push(e):e&&e.length&&"string"!=typeof e&&n(e)})};n(arguments),r?s=c.length:e&&(o=t,l(e))}return this},remove:function(){return c&&f.each(arguments,function(t,e){for(var n;-1<(n=f.inArray(e,c,n));)c.splice(n,1),r&&(n<=s&&--s,n<=a&&--a)}),this},has:function(t){return!(!c||!(t?-1<f.inArray(t,c):c.length))},empty:function(){return s=c.length=0,this},disable:function(){return c=u=e=void 0,this},disabled:function(){return!c},lock:function(){return u=void 0,e||h.disable(),this},locked:function(){return!u},fireWith:function(t,e){return!c||n&&!u||(e=[t,(e=e||[]).slice?e.slice():e],r?u.push(e):l(e)),this},fire:function(){return h.fireWith(this,arguments)},fired:function(){return!!n}};return h}}(Zepto),"__proto__"in{}&&void 0===springSpace.jq&&(springSpace.jq=Zepto),function(o){"use strict";if(void 0===o.fn.modal){var s=function(t,e){this.options=e,this.$body=o(document.body),this.$element=o(t),this.$dialog=this.$element.find(".modal-dialog"),this.$backdrop=null,this.isShown=null,this.originalBodyPad=null,this.scrollbarWidth=0,this.ignoreBackdropClick=!1,this.options.remote&&this.$element.find(".modal-content").load(this.options.remote,o.proxy(function(){this.$element.trigger("loaded.bs.modal")},this))};s.VERSION="3.3.7",s.TRANSITION_DURATION=300,s.BACKDROP_TRANSITION_DURATION=150,s.DEFAULTS={backdrop:!0,keyboard:!0,show:!0},s.prototype.toggle=function(t){return this.isShown?this.hide():this.show(t)},s.prototype.show=function(n){var i=this,t=o.Event("show.bs.modal",{relatedTarget:n});this.$element.trigger(t),this.isShown||t.isDefaultPrevented()||(this.isShown=!0,this.checkScrollbar(),this.setScrollbar(),this.$body.addClass("modal-open"),this.escape(),this.resize(),this.$element.on("click.dismiss.bs.modal",'[data-dismiss="modal"]',o.proxy(this.hide,this)),this.$dialog.on("mousedown.dismiss.bs.modal",function(){i.$element.one("mouseup.dismiss.bs.modal",function(t){o(t.target).is("#"+i.$element.attr("id"))&&(i.ignoreBackdropClick=!0)})}),this.backdrop(function(){var t=o.support.transition&&i.$element.hasClass("fade");i.$element.parent().length||i.$element.appendTo(i.$body),i.$element.show().scrollTop(0),i.adjustDialog(),t&&i.$element[0].offsetWidth,i.$element.addClass("in"),i.enforceFocus();var e=o.Event("shown.bs.modal",{relatedTarget:n});t?i.$dialog.one("bsTransitionEnd",function(){i.$element.trigger("focus").trigger(e)}).emulateTransitionEnd(s.TRANSITION_DURATION):i.$element.trigger("focus").trigger(e)}))},s.prototype.hide=function(t){t&&t.preventDefault(),t=o.Event("hide.bs.modal"),this.$element.trigger(t),this.isShown&&!t.isDefaultPrevented()&&(this.isShown=!1,this.escape(),this.resize(),o(document).off("focusin.bs.modal"),this.$element.removeClass("in").off("click.dismiss.bs.modal").off("mouseup.dismiss.bs.modal"),this.$dialog.off("mousedown.dismiss.bs.modal"),o.support.transition&&this.$element.hasClass("fade")?this.$element.one("bsTransitionEnd",o.proxy(this.hideModal,this)).emulateTransitionEnd(s.TRANSITION_DURATION):this.hideModal())},s.prototype.enforceFocus=function(){o(document).off("focusin.bs.modal").on("focusin.bs.modal",o.proxy(function(t){document===t.target||this.$element[0]===t.target||this.$element.has(t.target).length||this.$element.trigger("focus")},this))},s.prototype.escape=function(){this.isShown&&this.options.keyboard?this.$element.on("keydown.dismiss.bs.modal",o.proxy(function(t){27==t.which&&this.hide()},this)):this.isShown||this.$element.off("keydown.dismiss.bs.modal")},s.prototype.resize=function(){this.isShown?o(window).on("resize.bs.modal",o.proxy(this.handleUpdate,this)):o(window).off("resize.bs.modal")},s.prototype.hideModal=function(){var t=this;this.$element.hide(),this.backdrop(function(){t.$body.removeClass("modal-open"),t.resetAdjustments(),t.resetScrollbar(),t.$element.trigger("hidden.bs.modal")})},s.prototype.removeBackdrop=function(){this.$backdrop&&this.$backdrop.remove(),this.$backdrop=null},s.prototype.backdrop=function(t){var e=this,n=this.$element.hasClass("fade")?"fade":"";if(this.isShown&&this.options.backdrop){var i=o.support.transition&&n;if(this.$backdrop=o(document.createElement("div")).addClass("modal-backdrop "+n).appendTo(this.$body),this.$element.on("click.dismiss.bs.modal",o.proxy(function(t){this.ignoreBackdropClick?this.ignoreBackdropClick=!1:t.target===t.currentTarget&&("static"==this.options.backdrop?this.$element[0].focus():this.hide())},this)),i&&this.$backdrop[0].offsetWidth,this.$backdrop.addClass("in"),!t)return;i?this.$backdrop.one("bsTransitionEnd",t).emulateTransitionEnd(s.BACKDROP_TRANSITION_DURATION):t()}else if(!this.isShown&&this.$backdrop){this.$backdrop.removeClass("in");var r=function(){e.removeBackdrop(),t&&t()};o.support.transition&&this.$element.hasClass("fade")?this.$backdrop.one("bsTransitionEnd",r).emulateTransitionEnd(s.BACKDROP_TRANSITION_DURATION):r()}else t&&t()},s.prototype.handleUpdate=function(){this.adjustDialog()},s.prototype.adjustDialog=function(){var t=this.$element[0].scrollHeight>document.documentElement.clientHeight;this.$element.css({paddingLeft:!this.bodyIsOverflowing&&t?this.scrollbarWidth:"",paddingRight:this.bodyIsOverflowing&&!t?this.scrollbarWidth:""})},s.prototype.resetAdjustments=function(){this.$element.css({paddingLeft:"",paddingRight:""})},s.prototype.checkScrollbar=function(){var t=window.innerWidth;if(!t){var e=document.documentElement.getBoundingClientRect();t=e.right-Math.abs(e.left)}this.bodyIsOverflowing=document.body.clientWidth<t,this.scrollbarWidth=this.measureScrollbar()},s.prototype.setScrollbar=function(){var t=parseInt(this.$body.css("padding-right")||0,10);this.originalBodyPad=document.body.style.paddingRight||"",this.bodyIsOverflowing&&this.$body.css("padding-right",t+this.scrollbarWidth)},s.prototype.resetScrollbar=function(){this.$body.css("padding-right",this.originalBodyPad)},s.prototype.measureScrollbar=function(){var t=document.createElement("div");t.className="modal-scrollbar-measure",this.$body.append(t);var e=t.offsetWidth-t.clientWidth;return this.$body[0].removeChild(t),e};var t=o.fn.modal;o.fn.modal=a,o.fn.modal.Constructor=s,o.fn.modal.noConflict=function(){return o.fn.modal=t,this},o(document).on("click.bs.modal.data-api",'[data-toggle="modal"]',function(t){var e=o(this),n=e.attr("href"),i=o(e.attr("data-target")||n&&n.replace(/.*(?=#[^\s]+$)/,"")),r=i.data("bs.modal")?"toggle":o.extend({remote:!/#/.test(n)&&n},i.data(),e.data());e.is("a")&&t.preventDefault(),i.one("show.bs.modal",function(t){t.isDefaultPrevented()||i.one("hidden.bs.modal",function(){e.is(":visible")&&e.trigger("focus")})}),a.call(i,r,this)})}function a(i,r){return this.each(function(){var t=o(this),e=t.data("bs.modal"),n=o.extend({},s.DEFAULTS,t.data(),"object"==typeof i&&i);e||t.data("bs.modal",e=new s(this,n)),"string"==typeof i?e[i](r):n.show&&e.show(r)})}}(springSpace.jq),function(t,e){"object"==typeof exports&&"undefined"!=typeof module?module.exports=e():"function"==typeof define&&define.amd?define('Mustache',e):(t=t||self).Mustache=e()}(this,function(){"use strict";var e=Object.prototype.toString,T=Array.isArray||function(t){return"[object Array]"===e.call(t)};function h(t){return"function"==typeof t}function S(t){return t.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g,"\\$&")}function l(t,e){return null!=t&&"object"==typeof t&&e in t}var i=RegExp.prototype.test;var r=/\S/;function $(t){return e=r,n=t,!i.call(e,n);var e,n}var n={"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;","/":"&#x2F;","`":"&#x60;","=":"&#x3D;"};var k=/\s*/,j=/\s+/,A=/\s*=/,N=/\s*\}/,O=/#|\^|\/|>|\{|&|=|!/;function s(t,e){if(!t)return[];var n,i,r,o=!1,s=[],a=[],c=[],u=!1,l=!1,h="",f=0;function d(){if(u&&!l)for(;c.length;)delete a[c.pop()];else c=[];l=u=!1}function p(t){if("string"==typeof t&&(t=t.split(j,2)),!T(t)||2!==t.length)throw new Error("Invalid tags: "+t);n=new RegExp(S(t[0])+"\\s*"),i=new RegExp("\\s*"+S(t[1])),r=new RegExp("\\s*"+S("}"+t[1]))}p(e||D.tags);for(var m,v,g,y,b,x,w=new P(t);!w.eos();){if(m=w.pos,g=w.scanUntil(n))for(var E=0,C=g.length;E<C;++E)$(y=g.charAt(E))?(c.push(a.length),h+=y):(o=l=!0,h+=" "),a.push(["text",y,m,m+1]),m+=1,"\n"===y&&(d(),h="",f=0,o=!1);if(!w.scan(n))break;if(u=!0,v=w.scan(O)||"name",w.scan(k),"="===v?(g=w.scanUntil(A),w.scan(A),w.scanUntil(i)):"{"===v?(g=w.scanUntil(r),w.scan(N),w.scanUntil(i),v="&"):g=w.scanUntil(i),!w.scan(i))throw new Error("Unclosed tag at "+w.pos);if(b=">"==v?[v,g,m,w.pos,h,f,o]:[v,g,m,w.pos],f++,a.push(b),"#"===v||"^"===v)s.push(b);else if("/"===v){if(!(x=s.pop()))throw new Error('Unopened section "'+g+'" at '+m);if(x[1]!==g)throw new Error('Unclosed section "'+x[1]+'" at '+m)}else"name"===v||"{"===v||"&"===v?l=!0:"="===v&&p(g)}if(d(),x=s.pop())throw new Error('Unclosed section "'+x[1]+'" at '+w.pos);return function(t){for(var e,n=[],i=n,r=[],o=0,s=t.length;o<s;++o)switch((e=t[o])[0]){case"#":case"^":i.push(e),r.push(e),i=e[4]=[];break;case"/":r.pop()[5]=e[2],i=0<r.length?r[r.length-1][4]:n;break;default:i.push(e)}return n}(function(t){for(var e,n,i=[],r=0,o=t.length;r<o;++r)(e=t[r])&&("text"===e[0]&&n&&"text"===n[0]?(n[1]+=e[1],n[3]=e[3]):(i.push(e),n=e));return i}(a))}function P(t){this.string=t,this.tail=t,this.pos=0}function a(t,e){this.view=t,this.cache={".":this.view},this.parent=e}function t(){this.templateCache={_cache:{},set:function(t,e){this._cache[t]=e},get:function(t){return this._cache[t]},clear:function(){this._cache={}}}}P.prototype.eos=function(){return""===this.tail},P.prototype.scan=function(t){var e=this.tail.match(t);if(!e||0!==e.index)return"";var n=e[0];return this.tail=this.tail.substring(n.length),this.pos+=n.length,n},P.prototype.scanUntil=function(t){var e,n=this.tail.search(t);switch(n){case-1:e=this.tail,this.tail="";break;case 0:e="";break;default:e=this.tail.substring(0,n),this.tail=this.tail.substring(n)}return this.pos+=e.length,e},a.prototype.push=function(t){return new a(t,this)},a.prototype.lookup=function(t){var e,n,i,r=this.cache;if(r.hasOwnProperty(t))e=r[t];else{for(var o,s,a,c=this,u=!1;c;){if(0<t.indexOf("."))for(o=c.view,s=t.split("."),a=0;null!=o&&a<s.length;)a===s.length-1&&(u=l(o,s[a])||(n=o,i=s[a],null!=n&&"object"!=typeof n&&n.hasOwnProperty&&n.hasOwnProperty(i))),o=o[s[a++]];else o=c.view[t],u=l(c.view,t);if(u){e=o;break}c=c.parent}r[t]=e}return h(e)&&(e=e.call(this.view)),e},t.prototype.clearCache=function(){void 0!==this.templateCache&&this.templateCache.clear()},t.prototype.parse=function(t,e){var n=this.templateCache,i=t+":"+(e||D.tags).join(":"),r=void 0!==n,o=r?n.get(i):void 0;return null==o&&(o=s(t,e),r&&n.set(i,o)),o},t.prototype.render=function(t,e,n,i){var r=this.getConfigTags(i),o=this.parse(t,r),s=e instanceof a?e:new a(e,void 0);return this.renderTokens(o,s,n,t,i)},t.prototype.renderTokens=function(t,e,n,i,r){for(var o,s,a,c="",u=0,l=t.length;u<l;++u)a=void 0,"#"===(s=(o=t[u])[0])?a=this.renderSection(o,e,n,i,r):"^"===s?a=this.renderInverted(o,e,n,i,r):">"===s?a=this.renderPartial(o,e,n,r):"&"===s?a=this.unescapedValue(o,e):"name"===s?a=this.escapedValue(o,e,r):"text"===s&&(a=this.rawValue(o)),void 0!==a&&(c+=a);return c},t.prototype.renderSection=function(t,e,n,i,r){var o=this,s="",a=e.lookup(t[1]);if(a){if(T(a))for(var c=0,u=a.length;c<u;++c)s+=this.renderTokens(t[4],e.push(a[c]),n,i,r);else if("object"==typeof a||"string"==typeof a||"number"==typeof a)s+=this.renderTokens(t[4],e.push(a),n,i,r);else if(h(a)){if("string"!=typeof i)throw new Error("Cannot use higher-order sections without the original template");null!=(a=a.call(e.view,i.slice(t[3],t[5]),function(t){return o.render(t,e,n,r)}))&&(s+=a)}else s+=this.renderTokens(t[4],e,n,i,r);return s}},t.prototype.renderInverted=function(t,e,n,i,r){var o=e.lookup(t[1]);if(!o||T(o)&&0===o.length)return this.renderTokens(t[4],e,n,i,r)},t.prototype.indentPartial=function(t,e,n){for(var i=e.replace(/[^ \t]/g,""),r=t.split("\n"),o=0;o<r.length;o++)r[o].length&&(0<o||!n)&&(r[o]=i+r[o]);return r.join("\n")},t.prototype.renderPartial=function(t,e,n,i){if(n){var r=this.getConfigTags(i),o=h(n)?n(t[1]):n[t[1]];if(null!=o){var s=t[6],a=t[5],c=t[4],u=o;0==a&&c&&(u=this.indentPartial(o,c,s));var l=this.parse(u,r);return this.renderTokens(l,e,n,u,i)}}},t.prototype.unescapedValue=function(t,e){var n=e.lookup(t[1]);if(null!=n)return n},t.prototype.escapedValue=function(t,e,n){var i=this.getConfigEscape(n)||D.escape,r=e.lookup(t[1]);if(null!=r)return("number"==typeof r&&i===D.escape?String:i)(r)},t.prototype.rawValue=function(t){return t[1]},t.prototype.getConfigTags=function(t){return T(t)?t:t&&"object"==typeof t?t.tags:void 0},t.prototype.getConfigEscape=function(t){return t&&"object"==typeof t&&!T(t)?t.escape:void 0};var D={name:"mustache.js",version:"4.1.0",tags:["{{","}}"],clearCache:void 0,escape:void 0,parse:void 0,render:void 0,Scanner:void 0,Context:void 0,Writer:void 0,set templateCache(t){o.templateCache=t},get templateCache(){return o.templateCache}},o=new t;return D.clearCache=function(){return o.clearCache()},D.parse=function(t,e){return o.parse(t,e)},D.render=function(t,e,n,i){if("string"!=typeof t)throw new TypeError('Invalid template! Template should be a "string" but "'+(T(r=t)?"array":typeof r)+'" was given as the first argument for mustache#render(template, view, partials)');var r;return o.render(t,e,n,i)},D.escape=function(t){return String(t).replace(/[&<>"'`=\/]/g,function(t){return n[t]})},D.Scanner=P,D.Context=a,D.Writer=t,D});
//# sourceMappingURL=LibAnswers_fbwidget.min.js.map
            //put mustache into scope we can use
            springSpace.mustache = this.Mustache;
            //we need a blank line there else code wont run
            that.loadWidget();
        }
        /** called once we have all the js loaded/activated */
        this.loadWidget = function () {
            springSpace.jq(document).ready(function(){
                springSpace.la['widget_'+that.widget_id+'_inst'] = new springSpace.la['widget_'+that.widget_id]();
            });
        }
        /** action starts here */
        if ('__proto__' in {}) {
            //This is NOT IE<11 so we can just use Zepto
            this.jsHandler();
            return;
        } else {
            //IE<11
            if (typeof springSpace.jq == "undefined") {
                if (window.jQuery === undefined) {
                    this.loadJquery();
                } else {
                    if (this.minVersion('1.10', window.jQuery.fn.jquery)) {
                        springSpace.jq = window.jQuery;
                        this.jsHandler();
                    } else {
                        this.loadJquery();
                    }
                }
            } else {
                this.jsHandler();
            }
        }
    }
}

document.addEventListener("turbolinks:load", function() {
  springSpace.la.load_6282 = new springSpace.la.fbwidget_loader(6282);
});
