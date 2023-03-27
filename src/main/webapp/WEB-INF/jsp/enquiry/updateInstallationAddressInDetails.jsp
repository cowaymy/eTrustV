<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Footable/js/footable.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/footable.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerMain.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerCommon3.css"/>


<script>
    let interval;
    let areaJson;

    function resize(){
        $("#banner").width(screen.width + "px");
        $("#banner").height(screen.height *0.7+ "px");
    }

    window.addEventListener('resize', function(event){
        resize();
    });

    //Combo Box Choose Message
    let optionState = {chooseMessage: " 1.States "};
    let optionCity = {chooseMessage: "2. City"};
    let optionPostCode = {chooseMessage: "3. Post Code"};
    let optionArea = {chooseMessage: "4. Area"};

    $(document).ready(function() {
     //Filed Init
     fn_initAddress();
     CommonCombo.make('mState', "/enquiry/selectMagicAddressComboList.do", '' , '', optionState);

    //Enter Event
    $('#searchSt').keydown(function (event) {
        if (event.which === 13) {    //enter
            fn_addrSearch();
        }
    });

    $("#addrDtl").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});
    $("#streetDtl").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});

    });//Document Ready Func End


    function fn_initAddress(){

        $('#mCity').append($('<option>', { value: '', text: '2. City' }));
        $('#mCity').val('');
        $("#mCity").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
        $('#mPostCd').val('');
        $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});
    }

    function fn_selectState(selVal){
        let tempVal = selVal;

        if('' == selVal || null == selVal){
            //전체 초기화
            fn_initAddress();

        }else{
            $("#mCity").attr({"disabled" : false  , "class" : "form-control"});

            $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
            $('#mPostCd').val('');
            $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

            $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
            $('#mArea').val('');
            $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

            //Call ajax
            let cityJson = {state : tempVal}; //Condition
            CommonCombo.make('mCity', "/enquiry/selectMagicAddressComboList.do", cityJson, '' , optionCity);
        }
    }

    function fn_selectCity(selVal){
        let tempVal = selVal;

        if('' == selVal || null == selVal){

             $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
             $('#mPostCd').val('');
             $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

             $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
             $('#mArea').val('');
             $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        }else{

             //$("#mPostCd").attr({"disabled" : false  , "class" : "form-control"});
             $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
             $('#mPostCd').val('');
             $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

             $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
             $('#mArea').val('');
             $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

            //Call ajax
            let postCodeJson = {state : $("#mState").val() , city : tempVal}; //Condition
            CommonCombo.make('mPostCd', "/enquiry/selectMagicAddressComboList.do", postCodeJson, '' , optionPostCode);
        }
    }

    function fn_selectPostCode(selVal){
        let tempVal = selVal;

        if('' == selVal || null == selVal){

            $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
            $('#mArea').val('');
            $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

        }else{
            $("#mArea").attr({"disabled" : false  , "class" : "form-control"});
            //Call ajax
            areaJson = {state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
            CommonCombo.make('mArea', "/enquiry/selectMagicAddressComboList.do", areaJson, '' , optionArea);
        }
    }

    //Get Area Id
    function fn_getAreaId(){
        let statValue = $("#mState").val();
        let cityValue = $("#mCity").val();
        let postCodeValue = $("#mPostCd").val();
        let areaValue = $("#mArea").val();

        if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){

            let jsonObj = { statValue : statValue ,
                                  cityValue : cityValue,
                                  postCodeValue : postCodeValue,
                                  areaValue : areaValue
                                };
            Common.ajax("GET", "/enquiry/getAreaId.do", jsonObj, function(result) {
                 $("#areaId").val(result.areaId);
            });
        }
    }

    function fn_addrSearch(){

        if (FormUtil.isEmpty($("#mState").val())) {
            document.getElementById("MsgAlert").innerHTML =  "Please select State.";
            $("#alertModalClick").click();
            return false;
        }

        if (FormUtil.isEmpty($("#mCity").val())) {
            document.getElementById("MsgAlert").innerHTML =  "Please select City.";
            $("#alertModalClick").click();
            return false;
        }

        if($("#searchSt").val() == ''){
            document.getElementById("MsgAlert").innerHTML =  "Please key in the area search.";
            $("#alertModalClick").click();
            return false;
        }

       $("#mPostCd").attr({"disabled" : false  , "class" : "form-control"});

       searchMagicAddressPopJsonList();

    }

    function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){

        if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){

            $("#mArea").attr({"disabled" : false  , "class" : "form-control"});
            $("#mCity").attr({"disabled" : false  , "class" : "form-control"});
            $("#mPostCd").attr({"disabled" : false  , "class" : "form-control"});
            $("#mState").attr({"disabled" : false  , "class" : "form-control"});

            CommonCombo.make('mState', "/enquiry/selectMagicAddressComboList.do", '' , mstate, optionState);

            let cityJson = {state : mstate}; //Condition
            CommonCombo.make('mCity', "/enquiry/selectMagicAddressComboList.do", cityJson, mcity , optionCity);

            let postCodeJson = {state : mstate , city : mcity};
            CommonCombo.make('mPostCd', "/enquiry/selectMagicAddressComboList.do", postCodeJson, mpostcode , optionCity);

            areaJson = {groupCode : mpostcode, state : mstate , city : mcity , postcode : mpostcode};
            CommonCombo.make('mArea', "/enquiry/selectMagicAddressComboList.do", areaJson, marea , optionArea);

            $("#areaId").val(areaid);
            $("#_searchDiv").remove();
        }else{
            document.getElementById("MsgAlert").innerHTML =  'Please check your address.';
            $("#alertModalClick").click();
        }
    }

    function fn_chkItemVal(){

        if(FormUtil.isEmpty($('#addrDtl').val())) {
             document.getElementById("MsgAlert").innerHTML = "Please Fill In Address 1*";
             $("#alertModalClick").click();
             return false;
         }

        if(FormUtil.isEmpty($('#mState').val())) {
             document.getElementById("MsgAlert").innerHTML = "Please Choose State";
             $("#alertModalClick").click();
             return false;
        }

        if(FormUtil.isEmpty($('#mCity').val())) {
            document.getElementById("MsgAlert").innerHTML = "Please Choose City";
            $("#alertModalClick").click();
            return false;
        }

        if(FormUtil.isEmpty($('#mArea').val())) {
            document.getElementById("MsgAlert").innerHTML = "Please Choose Area";
            $("#alertModalClick").click();
            return false;
       }
    }

    $(function() {

         if(FormUtil.isEmpty('${SESSION_INFO.custId}')|| "${exception}" == "401") {
              window.top.Common.showLoader();
              window.top.location.href = '/enquiry/updateInstallationAddress.do';
         }

        resize();
        let x = document.querySelector('.bottom_msg_box');
        x.style.display = "none";

        let maskedPhoneNo;
        maskedPhoneNo = "${phoneNo}".substr(-4).padStart("${phoneNo}".length, '*');
        document.getElementById('phoneNo').innerHTML=maskedPhoneNo;

        let orderNo = document.getElementById('orderNo');
        let productInfo = document.getElementById('productInfo');
        let currentAddr = document.getElementById('currentAddr');
        orderNo.innerHTML += '${orderNo}';
        productInfo.innerHTML += '${productDesc}';
        currentAddr.innerHTML += '${addrDtl}' + ' ' + '${street}' + ' ' + '${mailArea}' + ' ' + '${mailPostCode}' + ' ' + '${mailCity}' + ' ' + '${mailState}' + ' ' + '${mailCnty}';

        $('#btnUpdate').click(function(evt) {

	            var isVal = true;

	            isVal = fn_chkItemVal();

	            if(isVal == false){
	                return;
	            }else{
		                 let params = {
		                		 custId : '${SESSION_INFO.custId}',
		                		 orderNo:  '${orderNo}'
		                 };
		                 Common.ajax("GET","/enquiry/checkExistRequest.do", params , function (result){
		                     if(result.data.result > 0){
		                         document.getElementById("MsgConfirm").innerHTML =  "You have submmitted the update request before for this order number: " + '${orderNo}' + " Confirm to proceed update new request?";
		                         $("#confirmModalClick").click();
		                     }
		                     else{
		                         getTacNo();
		                     }
		             });
		        }
         });

        $('#btnResend').click(function(evt) {
            Common.ajax("GET","/enquiry/getTacNo.do",{orderNo: "${orderNo}"}  , function (result){
            	if(result.code = "00"){
            		$("#tacNo").val("");
            		startCountdown(0,1);
            		startCountdown(180,0);
            	}
            });
        });

        $('#btnHelp').click(function(evt) {
        	  clearInterval(interval);
              $("#myModalTac").modal('hide');
              createAlert('Please try again or contact Coway Careline 1-800-888-111. Thank you.',goCustomerInfoPage);
        });



        $('#btnContinue').click(function(evt) {
                    //console.log($("#tacForm").serializeJSON());
                    let param = {};
                    params = {
                            orderNo : "${orderNo}",
                            tacNo : $("#tacNo").val(),
                            insCustId : "${SESSION_INFO.custId}",
                            areaId : $("#areaId").val(),
                            addrDtl : $("#addrDtl").val(),
                            streetDtl : $("#streetDtl").val(),
                            phoneNo : "${phoneNo}"
                    };

                    Common.ajax("GET","/enquiry/verifyTacNo.do", params , function (result){
                    	Common.showLoader();
                        if(result.code =="00"){

                        	document.getElementById("MsgComplete").innerHTML = result.message;
                        	Common.removeLoader();
                            $("#completeModalClick").click();

                            let counterClose = 5;

                            const intervalClose = setInterval(() => {
                              counterClose--;
                              if (counterClose < 0 ) {
                            	  goCustomerInfoPage();
                              }
                            }, 1000);

                        }
                        else{
                            $("#tacNo").val("");
                        	startCountdown(0,1); //stop countdown
                            document.getElementById("MsgAlert").innerHTML = result.message;
                            Common.removeLoader();
                            $("#alertModalClick").click();
                        }
                    });
              });

       });

       function getTacNo(){
    	   let paramsGetTac = {
    			   tacNo : $("#tacNo").val(),
    			   orderNo : "${orderNo}",
    			   custId : "${SESSION_INFO.custId}",
    			   mobileNo : "${phoneNo}"
    	   };

            Common.ajax("GET","/enquiry/getTacNo.do", paramsGetTac , function (result){
	            if(result.code =="00"){
	            	 $('#myModalTac').modal({backdrop: 'static', keyboard: false});
	        	     $("#tacNo").val("");
	        	     startCountdown(0,1);
	        	     startCountdown(180,0);
	            }
	            else{
	            	document.getElementById("MsgAlert").innerHTML =  result.message;
	                $("#alertModalClick").click();
	            }
        });
    }

     const createAlert = (text, fn) => {
           //create modal here
             document.getElementById("MsgAlert").innerHTML = text;
             $("#alertModalClick").click();

             if(fn!=null){
                 $('#myModalAlert').on('hide.bs.modal', function (event) {
                     fn();
                 })
             } else {
            	 $('#myModalAlert').on('hide.bs.modal', function (event) {
                 })
             }
       };

    function startCountdown(seconds, flag) {
    	if(flag==0){
            let counter = seconds;

             interval = setInterval(() => {
              document.getElementById('countDown').innerHTML=counter;
              counter--;
              if (counter < 0 ) {
                clearInterval(interval);
                $("#myModalTac").modal('hide');
                createAlert('Your TAC number is expired. Please click "Resend TAC" to get new code.',goTacVerificationPage);
              }
            }, 1000);
    	}
    	else{
    		clearInterval(interval);
    		document.getElementById('countDown').innerHTML=0;
    	}
    }

    function goCustomerInfoPage(){
        $("#tacForm").attr("target", "");
        $("#tacForm").attr({
            action: getContextPath() + "/enquiry/selectCustomerInfo.do",
            method: "POST"
        }).submit();
    }

   function goTacVerificationPage(){
	   $("#tacNo").val("");
       startCountdown(0,1);
       startCountdown(180,0);
       $('#myModalTac').modal({backdrop: 'static', keyboard: false});
       $('#myModalAlert').on('hide.bs.modal', function (event) {})
   }


   function searchMagicAddressPopJsonList(){

       let params = {
               searchSt: $("#searchSt").val(),
               city: $("#mCity").val(),
               state: $("#mState").val(),
               searchStreet : $("#searchSt").val()
       };

       Common.ajax("GET", "/enquiry/searchMagicAddressPopJsonList.do", params, function(result) {

       let $modal = $("#editor-modal"),
       $editor = $("#editor"),
       $editorTitle = $("#editor-title"),
       ft = FooTable.init("#showcase-example-1", {

             paging: {
                 size: 5
             },
             columns: [
             { name: "area",
                 title: "Area",
             },
             {
                name: "areaId",
                title: "Area Id",
                visible: false,
                filterable: false
             },
             {
                 name: "iso",
                 title: "ISO",
                 visible: false,
                 filterable: false
              },
             { name: "postcode", title: "Postcode" },
             {
                name: "city",
                title: "City",
                breakpoints: " xs sm",
                style: {
                   width: 300,
                   overflow: "hidden",
                   textOverflow: "ellipsis",
                   wordBreak: "keep-all",
                   whiteSpace: "nowrap"
                 }
             },
             {
                 name: "state",
                 title: "State",
                 breakpoints:  "xs sm",
                 style: {
                   maxWidth: 200,
                   overflow: "hidden",
                   textOverflow: "ellipsis",
                   wordBreak: "keep-all",
                   whiteSpace: "nowrap"
                 }
             },
             {
                 name: "fullAddress",
                 title: "Full Address",
                 breakpoints:  "lg md xs sm",
                 style: {
                   maxWidth: 200,
                   overflow: "hidden",
                   textOverflow: "ellipsis",
                   wordBreak: "keep-all",
                   whiteSpace: "nowrap"
                 }
             }],
            rows:
                 $.map( result, function( val, i ) {
                     return {
                       area: val.area,
                       areaId: val.areaId,
                       postcode: val.postcode,
                       city: val.city,
                       state: val.state,
                       fullAddress: val.fullAddress,
                       iso: val.iso
                     }
              }),
       })

       $('#showcase-example-1').on('expand.ft.row', function(e, ft, row) {
    	   $("#area").val(row.value.area);
    	   $("#areaId").val(row.value.areaId);
    	   $("#city").val(row.value.city);
    	   $("#postcode").val(row.value.postcode);
    	   $("#state").val(row.value.state);
    	   $("#iso").val(row.value.iso);

    	   let expandElement = $(row.$el);
           $('#showcase-example-1').find('tr').each(function(){
               if (this.getAttribute("data-expanded")){
                   this.click();
               }else{
            	   expandElement.toggleClass('toggleColor2',false);
            	   expandElement.toggleClass('toggleColor',true);
               }
           });
        });

       $('#showcase-example-1').on('collapse.ft.row', function(e, ft, row) {
    	   let collapseElement = $(row.$el);
    	   collapseElement.toggleClass('toggleColor',false);
    	   collapseElement.toggleClass('toggleColor2',true);
       });
    });

    $("#customerModalClick").click();

   }

   function resetAreaId(){
	   $("#areaId").val("");
   }

   function setAreaInfo(){
	   fn_addMaddr($("#area").val(), $("#city").val(), $("#postcode").val(), $("#state").val(), $("#areaId").val(), $("#iso").val());
   }

</script>


<%@ include file="/WEB-INF/jsp/enquiry/navigation.jsp" %>

<div id="updateDetails">
      <div style="position:relative">
        <img src="../resources/images/common/customerinfo4.jpg"  id="banner">
        <div class="banner-caption">
                <div class="container">
		                <div class="row">
		                    <div class="m-lg-5 col-sm-6" style="position:relative">
		                         <br class="visible-xs">
		                         <h3 class="fontSetting fontSize1">Update Installation Address</h3>
		                         <p style="color: #60A4DA!important" class="fontSetting fontSize2">Unparalleled Customer Experience</p>
		                         <p style="line-height:1.5" class="fontSetting fontSize3">With nationwide coverage, Coway's HEART Service is just one of the many reasons why we are the No.1 brand in wellness and healthy living.</p>
		                        </div>
		                </div>
                </div>
            </div>
      </div>
</div>
<br/>
<div class="container" id="updateDetailsPage">
<div class="row">
  <div class="col-md-4 mb-4">
    <div class="card mb-4">
      <div class="card-header py-3">
        <h5 class="mb-0">Summary</h5>
      </div>
      <br>
      <br>
      <div class="card-body">
        <ul class="list-group list-group-flush">
	          <li class="list-group-item d-flex justify-content-between align-items-center px-0">
	                  <div>
	                         <label>Order No :</label>
	                         <span id="orderNo" style= "text-align:left !important "></span>
	                  </div>
	          </li>

	           <li class="list-group-item d-flex justify-content-between align-items-center px-0">
	                   <div>
	                         <label>Products :</label>
	                         <span id="productInfo" style= "text-align:left !important "></span>
	                  </div>
	          </li>

	          <li class="list-group-item d-flex justify-content-between align-items-center px-0">
	                   <div>
	                         <label>Current Installation Address :</label><br>
	                         <span id="currentAddr" style= "text-align:left !important; text-transform: uppercase; "></span>
	                  </div>
	          </li>
        </ul>
        </ul>
        <br/>
         <p class="btn btn-primary btn-lg btn-block"  id="btnUpdate" ><a href="javascript:void(0);" style="color:white">Update</a></p>
      </div>
    </div>
  </div>

  <div class="col-md-8 mb-4 text-left">
      <div class="card mb-4">
          <div class="card-header py-3">
            <h5  class="mb-0">New Installation Address Details</h5>
          </div>

          <div class="card-body">
                   <form id="insAddressForm">
                       <input type="hidden" id="areaId" name="areaId">
                       <input type="hidden" value="${SESSION_INFO.custId}" id="_insCustId" name="insCustId">
                       <input type="hidden" name="addrCustAddId" id="addrCustAddId">
                       <input type="hidden" name="orderId" id="orderId" value="${orderId}">
                       <input type="hidden" name="orderNo"  value="${orderNo}">
                       <input type="hidden" id="area" name="area">
                       <input type="hidden" id="city" name="city">
                       <input type="hidden" id="state" name="state">
                       <input type="hidden" id="postcode" name="postcode">
                       <input type="hidden" id="iso" name="iso">

                        <div class="row mb-4">
                            <div class="col">
                                  <div class="form-outline">
                                      <label class="form-label" >Address 1<span class="must text-danger">*</span></label>
                                      <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="form-control" maxlength="100" />
                                   </div>
                                  <div class="form-outline mt-3">
                                      <label class="form-label" >Address 2</label>
                                      <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="form-control" maxlength="100" />
                                   </div>

                                   <div class="form-outline mt-3">
                                      <label class="form-label" >State</label>
                                      <select class="form-control" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
                                  </div>

                                   <div class="form-outline mt-3">
                                        <label class="form-label" >City</label>
                                        <select class="form-control" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
                                   </div>

                                   <div class="form-outline mt-3">
                                          <label class="form-label" >Area Search</label>
                                          <div class="row">
                                             <div class="col-md-11 col-sm-11">
                                                  <input type="text" " id="searchSt" name="searchSt" class="form-control" />
                                              </div>

                                              <div class="col-md-1 col-sm-1">
                                                   <a href="javascript:void(0);" class="search_btn" onclick="fn_addrSearch()"><img id="searchIcon" src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                                              </div>
                                          </div>
                                    </div>

                                    <div class="form-outline mt-3">
                                          <label class="form-label" >Postcode</label>
                                          <select class="form-control" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
                                    </div>

                                    <div class="form-outline mt-3">
                                         <label class="form-label" >Area</label>
                                         <select class="form-control" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select>
                                    </div>

                                    <div class="form-outline mt-3">
                                          <label class="form-label" >Country</label>
                                          <input type="text" id="country" name="country" class="form-control" value="Malaysia" readonly />
                                    </div>
                         </div>
                   </form>
          </div>
      </div>
  </div>
  </div>
</div>



 <!-- Open Modal Screen Window  -->

<!-- 1. Area Information -->
<input type="button" id="customerModalClick" data-toggle="modal" data-target="#customerMagicAddress"  hidden  />
<div class="modal" id="customerMagicAddress">
        <div class="modal-content" style="height:auto;">
            <div class="modal-header">
                <h4 class="modal-title">Area Information</h4>
            </div>
            <div class="modal-body" id="MsgCustomer" style="height: auto;position:relative;">
                <div style="width: 100%; ">
                    <table id="showcase-example-1" class="table" data-paging="true"></table>
                </div>
             </div>
             <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                            <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal"  onclick="setAreaInfo()">Choose</button>
                          </div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                           <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal"  onclick="resetAreaId()">Close</button>
                          </div>
                    </div>
                </div>
            </div>
    </div>
</div>

<!-- 2. Tac Modal -->
<input type="button" id="tacModalClick" data-toggle="modal" data-target="#myModalTac"  hidden  />
<div class="modal" id="myModalTac">
<div class="container body-content">
    <div class="container">
        <div class="row">
            <div class="col-xs-12 col-md-6 offset-md-3">
                <div class="card">
                    <div class="text-center card-header" style="background:#25527c">
                        <div class="card-header text-white" style="text-align:center;color:white">
                            <h2><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"/></h2>
                            <div>
                               <h6 style="text-align:justify;color:white">
                                To proceed with the update installation address, a Transaction Authorization Code (TAC) has been sent to your registered mobile phone (<span id="phoneNo" style="text-align:justify;color:white"></span>).
                                Enter it below and then click "Continue".
                                Please leave the dialog box open on this page while waiting for TAC.
                           </h6>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <form role="form" id="tacForm">
                        <input type="hidden" name="orderNo"  value="${orderNo}">
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="form-group">
                                        <div style="text-align:center;font-size:12px;font-weight:bold;">Enter TAC received via SMS</div>
                                        <br>
                                        <input type="password" class="form-control"  name="tacNo" id="tacNo"/>
                                        <br>
                                        <div style="text-align:right;font-size:12px;font-weight:bold;">TAC will expire in <u class="must text-danger"><span class="must text-danger" id="countDown"></span></u> secs</div>
                                        <br>
                                    </div>
                                </div>

                                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                        <h6 id="btnResend"><u>Resend TAC</u></h6>
                                        <h6 id="btnHelp"><u>Need help?</u></h6>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div>
	                    <div class="row" >
		                            <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
		                                  <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal"  style="width:100%;background:#25527c !important" onclick=>Cancel</button>
		                            </div>
		                            <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
		                                  <button type="button"  id="btnContinue"  class="btn btn-primary btn-block float-right" data-dismiss="modal"  style="width:100%;background:#25527c !important" >Continue</button>
		                            </div>
	                    </div>
                    </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>



<!-- 3. Alert Msg -->
<input type="button" id="alertModalClick" data-toggle="modal" data-target="#myModalAlert"  hidden/>
<div class="modal" id="myModalAlert">
    <div class="modal-dialog">
        <div class="modal-content setHeight">
            <div class="modal-header">
                <h4 class="modal-title">System Information</h4>
            </div>
            <div class="modal-body" id="MsgAlert"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal">Close</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 4. Confirm Resubmit -->
<input type="button" id="confirmModalClick" data-toggle="modal" data-target="#myModalConfirm"  hidden/>
<div class="modal" id="myModalConfirm">
    <div class="modal-dialog">
        <div class="modal-content setHeight">
            <div class="modal-header">
                <h4 class="modal-title">System Information</h4>
            </div>
            <div class="modal-body" id="MsgConfirm"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                                <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" onclick="getTacNo()">Confirm</button>
                          </div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal">Close</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- 5. Complete and Back to Main -->
<input type="button" id="completeModalClick" data-toggle="modal" data-target="#myModalComplete"  hidden/>
<div class="modal" id="myModalComplete">
    <div class="modal-dialog ">
        <div class="modal-content setHeight">
            <div class="modal-header">
                <h4 class="modal-title">System Information</h4>
            </div>
            <div class="modal-body" id="MsgComplete"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" onclick="goCustomerInfoPage()">Close</button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>