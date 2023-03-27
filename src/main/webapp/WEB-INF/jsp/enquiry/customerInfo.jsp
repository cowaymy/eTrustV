<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/dataTable1.10.2.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/dataTable/js/bootstrap.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerMain.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerCommon2.css"/>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,1,0" />


<script>
    $(function() {

    	  if(FormUtil.isEmpty('${SESSION_INFO.custId}') || "${exception}" == "401") {
                window.top.Common.showLoader();
                window.top.location.href = '/enquiry/updateInstallationAddress.do';
        }

    	 document.getElementById("setHeight").style.minHeight = screen.height + "px";

         let x = document.querySelector('.bottom_msg_box');
         x.style.display = "none";

         let totalCnt = document.getElementById('totalCnt');
         totalCnt.setAttribute("data-to", '${totalCnt}');

         initialize();
        });


    function initialize(){
        Common.ajax("GET","/enquiry/getCustomerInfo.do", {custId : '${SESSION_INFO.custId}'} , function (result){

            if(result.code =="00"){
                let details = document.getElementById('details');

                for (var i = 0; i < result.data.length ; i++)
                {
                    details.innerHTML +=
                        '<tr>'
                    + '<td style="text-align:center;">' + result.data[i].salesOrdNo + '</td>'
                    + '<td>' + result.data[i].stkDesc + '</td>'
                    + '<td>'
                    + result.data[i].instAddrDtl + ' '
                    + result.data[i].instStreet + ' '
                    + result.data[i].instArea + ' '
                    + result.data[i].instPostcode + ' '
                    + result.data[i].instCity + ' '
                    + result.data[i].instState + ' '
                    + result.data[i].instCountry
                    +'</td>'
                    +'<td style="text-align:center;"><a href="../enquiry/updateInstallationAddressInDetails.do?orderNo='+result.data[i].salesOrdNo+'"><span class="material-symbols-outlined">edit</span></a></td>'
                    + '</tr>';
                }
            }
            customizeDatatable();
        });
    }

    function customizeDatatable(){
         $('#example').DataTable({iDisplayLength: 3});
         $('#example_length').hide();
    }

    function goDetailsPage(){
        $("#mainPage").attr("target", "");
        $("#mainPage").attr({
            action: getContextPath() + "/enquiry/updateInstallationAddressInDetails.do",
            method: "POST"
        }).submit();
    }
    (function ($) {
        $.fn.countTo = function (options) {
            options = options || {};

            return $(this).each(function () {
                // set options for current element
                var settings = $.extend({}, $.fn.countTo.defaults, {
                    from:            $(this).data('from'),
                    to:              $(this).data('to'),
                    speed:           $(this).data('speed'),
                    refreshInterval: $(this).data('refresh-interval'),
                    decimals:        $(this).data('decimals')
                }, options);

                // how many times to update the value, and how much to increment the value on each update
                var loops = Math.ceil(settings.speed / settings.refreshInterval),
                    increment = (settings.to - settings.from) / loops;

                // references & variables that will change with each update
                var self = this,
                    $self = $(this),
                    loopCount = 0,
                    value = settings.from,
                    data = $self.data('countTo') || {};

                $self.data('countTo', data);

                // if an existing interval can be found, clear it first
                if (data.interval) {
                    clearInterval(data.interval);
                }
                data.interval = setInterval(updateTimer, settings.refreshInterval);

                // initialize the element with the starting value
                render(value);

                function updateTimer() {
                    value += increment;
                    loopCount++;

                    render(value);

                    if (typeof(settings.onUpdate) == 'function') {
                        settings.onUpdate.call(self, value);
                    }

                    if (loopCount >= loops) {
                        // remove the interval
                        $self.removeData('countTo');
                        clearInterval(data.interval);
                        value = settings.to;

                        if (typeof(settings.onComplete) == 'function') {
                            settings.onComplete.call(self, value);
                        }
                    }
                }

                function render(value) {
                    var formattedValue = settings.formatter.call(self, value, settings);
                    $self.html(formattedValue);
                }
            });
        };

        $.fn.countTo.defaults = {
            from: 0,               // the number the element should start at
            to: 0,                 // the number the element should end at
            speed: 1000,           // how long it should take to count between the target numbers
            refreshInterval: 100,  // how often the element should be updated
            decimals: 0,           // the number of decimal places to show
            formatter: formatter,  // handler for formatting the value before rendering
            onUpdate: null,        // callback method for every time the element is updated
            onComplete: null       // callback method for when the element finishes updating
        };

        function formatter(value, settings) {
            return value.toFixed(settings.decimals);
        }
    }(jQuery));

    jQuery(function ($) {
      // custom formatting example
      $('.count-number').data('countToOptions', {
        formatter: function (value, options) {
          return value.toFixed(options.decimals).replace(/\B(?=(?:\d{3})+(?!\d))/g, ',');
        }
      });

      // start all the timers
      $('.timer').each(count);

      function count(options) {
        var $this = $(this);
        options = $.extend({}, options || {}, $this.data('countToOptions') || {});
        $this.countTo(options);
      }
    });
</script>

<%@ include file="/WEB-INF/jsp/enquiry/navigation.jsp" %>

<div class="text-center">
            <div class="counter">
      <i class="fa fa-lightbulb-o fa-2x"></i>
      <h2 class="timer count-title count-number" id="totalCnt" data-speed="1000"></h2>
       <p class="count-text ">Total In Product</p>
</div>

<section class="intro" style="font-size:30px!important">
  <div class="bg-image h-100 pt-3" style="background-image: url(../resources/images/common/customerinfo2.jpg);">
    <div class="mask d-flex align-items-center h-100">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-12">
            <div class="card mask-custom">
              <div class="card-body" id="getHeight">
                <div class="table-responsive">
						<table id="example" class="table table-striped table-bordered" style="width:100%;">
						        <thead>
						            <tr>
						                <th style="width:15%; vertical-align: middle; text-align:center;">Order No</th>
						                <th style="width:25%; vertical-align: middle; text-align:center;">Products</th>
						                <th style="width:40%; vertical-align: middle; text-align:center;">Current Installation Address</th>
						                <th style="width:15%; vertical-align: middle; text-align:center;">Action</th>
						            </tr>
						        </thead>
						        <tbody id ="details">
						        </tbody>
						  </table>
                </div>
              </div>
            </div>
          </div>
           <div id="setHeight"></div>
        </div>
      </div>
    </div>
  </div>
</section>