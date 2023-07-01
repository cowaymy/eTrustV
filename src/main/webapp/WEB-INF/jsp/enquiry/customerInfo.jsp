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

<style>
	.thClass{
		vertical-align: middle;
		text-align:center;
		padding: 10px 0 !important;
	}

	th, td {
	   line-height:1.5 !important;
	   font-size: 16px !important;
	}

	.modalCnt {
	   font-size:16px !important;
	   line-height:1.5 !important;
	}
</style>

<script>
	function setModalContent(content){
		return `<div class="row">
				        <div class="col-sm-12 logo">
				        <img src="${pageContext.request.contextPath}/resources/images/common/trueaddress_logo.png" alt="Coway">
				      </div>
				    </div>
				    <div class="text-danger p-3 modalCnt">` + content + `</div>`;
	}

    let twoTimesSubmission = "Dear customer, you have submitted multiple submissions. Do you need further assistance? <br/><br/>  Our friendly staff is always ready to help. Kindly call Coway Careline at 1800-888-111. Thank you.";

    let notREG = "Dear customer, the selected order number has a high outstanding bill. Please remit your payment in order to proceed for detail updates. <br/><br/> For more information, kindly call Coway Careline at 1800-888-111. Thank you";

    let outOfWarranty = "Dear customer, kindly be informed that your product warranty has expired. <br/><br/> For more information, kindly call Coway Careline at 1800-888-111. Thank you."

    $(function() {

    	 if(FormUtil.isEmpty('${SESSION_INFO.custId}') || "${exception}" == "401") {
                window.top.Common.showLoader();
                window.top.location.href = '/enquiry/trueaddress.do';
         }

         let x = document.querySelector('.bottom_msg_box');
         x.style.display = "none";

         let totalCnt = document.getElementById('totalCnt');
         totalCnt.setAttribute("data-to", '${totalCnt}');

         initialize();

         $('#myModalAlert').on('shown.bs.modal', function (e) {
        	 let alertButton = document.querySelector("#myModalAlert");
        	 alertButton.style.display = "flex";
             document.querySelector(".modal").style.flexDirection = "row";
             document.querySelector(".modal-dialog").style.width = "90%";
             document.querySelector(".modalCnt").style.border = "1px solid #ccc";
             document.querySelector(".modalCnt").style.borderRadius = "25px";
             document.querySelector(".modalCnt").style.wordSpacing = "5px";
         });
    });

    function validate(order,chkService, stus,appType){
    	 Common.ajax("GET","/enquiry/getSubmissionTimes.do", {orderNo : order} , function (result, textStatus, jqXHR){
    		 if(jqXHR.status == "200"){
    			 if(result!=null && result.validChk > 1){
                     document.getElementById("MsgAlert").innerHTML =  setModalContent(twoTimesSubmission);
                     $("#alertModalClick").click();
                     return;
    		     }
                 else if(appType =="REN" && (stus =="SUS" || stus =="INV")){
                     document.getElementById("MsgAlert").innerHTML =  setModalContent(notREG);
                     $("#alertModalClick").click();
                     return;
	            }else if(!chkService){
	                 document.getElementById("MsgAlert").innerHTML =  setModalContent(outOfWarranty);
	                 $("#alertModalClick").click();
	                 return;
	            }else{
	                goDetailsPage(order);
	            }
    		 }

    	 });





    }




    function initialize(){
        Common.ajax("GET","/enquiry/getCustomerInfo.do", {custId : '${SESSION_INFO.custId}'} , function (result){

            if(result.code =="00"){
                let details = document.getElementById('details');

                for (var i = 0; i < result.data.length ; i++)
                {
                    details.innerHTML +=
                        '<tr>'
                    + '<td style="text-align:center;">' + result.data[i].salesOrdNo + ' <br/> ('+result.data[i].stkDesc +')</td>'
                    + '<td>'
                    + result.data[i].instAddrDtl + ' '
                    + result.data[i].instStreet + ' '
                    + result.data[i].instArea + ' '
                    + result.data[i].instPostcode + ' '
                    + result.data[i].instCity + ' '
                    + result.data[i].instState + ' '
                    + result.data[i].instCountry
                    +'</td>'
                    +'<td style="text-align:center;"><a href="javascript:validate('+ result.data[i].salesOrdNo + ',' + result.data[i].chkService + ',' + `'`+ result.data[i].rentalStus + `'`+ `,'`+ result.data[i].appType + `'`+')"><span class="material-symbols-outlined">edit</span></a></td>'
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

    function goDetailsPage(order){
    	window.location = "/enquiry/updateInstallationAddressInDetails.do?orderNo="+order;
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
       <p class="count-text" style="line-height:1.5">Total In Product</p>
</div>

  <div class="card pt-5" style="min-height: 100vh;background: rgba(134, 169, 191, 0.76)">
     <div class="table-responsive">
		<table id="example" class="table table-striped table-bordered" style="line-height:1.5 !important;">
		        <thead>
		            <tr>
		                <th class="thClass" style="width:25%">Order</th>
		                <th class="thClass" style="width:60%">Address</th>
		                <th class="thClass"></th>
		            </tr>
		        </thead>
		        <tbody id ="details"></tbody>
		  </table>
    </div>
  </div>

<input type="button" id="alertModalClick" data-toggle="modal" data-target="#myModalAlert" hidden />
<div class="modal" id="myModalAlert">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body" id="MsgAlert"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" style="width:100%;">Close</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>