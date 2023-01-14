<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<!--  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script> -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<style>
.navbar {
  margin-bottom: 0;
  border-radius: 0;
}

.navbar, .navbar-toggle {background: #25527c !important; color: white;}

.text-white{color:white !important;}

.marginTop{margin-top:10px;}


</style>
<script>

//Combo Box Choose Message
var optionState = {chooseMessage: " 1.States "};
var optionCity = {chooseMessage: "2. City"};
var optionPostCode = {chooseMessage: "3. Post Code"};
var optionArea = {chooseMessage: "4. Area"};

 $(document).ready(function() {

     //Filed Init
     fn_initAddress();
     CommonCombo.make('mState', "/enquiry/selectMagicAddressComboList.do", '' , '', optionState);
     /* ### Get Cust AddrID ####*/
     //fn_getCustAddrId();

    //Enter Event
    $('#searchSt').keydown(function (event) {
        if (event.which === 13) {    //enter
        	fn_addrSearch();
        }
    });

    $("#addrDtl").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});
    $("#streetDtl").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});

    // 20190925 KR-OHK Moblie Popup Setting
    Common.setMobilePopup(false, false, '');

});//Document Ready Func End


function fn_getCustAddrId(){

    var getparam = $("#_insCustId").val();

    $.ajax({

        type: "GET",
        url : getContextPath() + "/sales/customer/selectCustomerMainAddr",
        data : {getparam : getparam},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
                $("#tempAddrId").val(data.custAddId);
                $("#tempAreaId").val(data.areaId);
        },
        error: function(){
            //Common.alert("Get Address Id was Failed!");
        },
        complete: function(){
        }
    });

}

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
    var tempVal = selVal;

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
        var cityJson = {state : tempVal}; //Condition
        CommonCombo.make('mCity', "/enquiry/selectMagicAddressComboList.do", cityJson, '' , optionCity);
    }
}

function fn_selectCity(selVal){
    var tempVal = selVal;

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
        var postCodeJson = {state : $("#mState").val() , city : tempVal}; //Condition
        CommonCombo.make('mPostCd', "/enquiry/selectMagicAddressComboList.do", postCodeJson, '' , optionPostCode);
    }
}

function fn_selectPostCode(selVal){
    var tempVal = selVal;

    if('' == selVal || null == selVal){

        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "form-control disabled"});

    }else{
        $("#mArea").attr({"disabled" : false  , "class" : "form-control"});
        //Call ajax
        var areaJson = {state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
        CommonCombo.make('mArea', "/enquiry/selectMagicAddressComboList.do", areaJson, '' , optionArea);
    }
}

//Get Area Id
function fn_getAreaId(){
    var statValue = $("#mState").val();
    var cityValue = $("#mCity").val();
    var postCodeValue = $("#mPostCd").val();
    var areaValue = $("#mArea").val();

    if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){

        var jsonObj = { statValue : statValue ,
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
    // null state
    if (FormUtil.isEmpty($("#mState").val())) {
        Common.alert("Please select State.");
        return false;
    }
    // null city
    if (FormUtil.isEmpty($("#mCity").val())) {
        Common.alert("Please select City.");
        return false;
    }
    if($("#searchSt").val() == ''){
        Common.alert("Please search.");
        return false;
    }
    Common.popupDiv('/enquiry/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv');

   $("#mPostCd").attr({"disabled" : false  , "class" : "form-control"});

}

function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){

    if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){

        $("#mArea").attr({"disabled" : false  , "class" : "form-control"});
        $("#mCity").attr({"disabled" : false  , "class" : "form-control"});
        $("#mPostCd").attr({"disabled" : false  , "class" : "form-control"});
        $("#mState").attr({"disabled" : false  , "class" : "form-control"});

        //Call Ajax

        CommonCombo.make('mState', "/enquiry/selectMagicAddressComboList.do", '' , mstate, optionState);

        var cityJson = {state : mstate}; //Condition
        CommonCombo.make('mCity', "/enquiry/selectMagicAddressComboList.do", cityJson, mcity , optionCity);

        var postCodeJson = {state : mstate , city : mcity}; //Condition
        CommonCombo.make('mPostCd', "/enquiry/selectMagicAddressComboList.do", postCodeJson, mpostcode , optionCity);

        var areaJson = {groupCode : mpostcode};
        var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
        CommonCombo.make('mArea', "/enquiry/selectMagicAddressComboList.do", areaJson, marea , optionArea);

        $("#areaId").val(areaid);
        $("#_searchDiv").remove();
    }else{
        Common.alert('<spring:message code="sal.alert.msg.addrCheck" />');
    }
}

$(function() {
    let x = document.querySelector('.bottom_msg_box');
    x.style.display = "none";

    let maskedPhoneNo;
    maskedPhoneNo = "${phoneNo}".substr(-4).padStart("${phoneNo}".length, '*');
    document.getElementById('phoneNo').innerText=maskedPhoneNo;

    startCountdown(180);

    let orderNo = document.getElementById('orderNo');
    let productInfo = document.getElementById('productInfo');
    let currentAddr = document.getElementById('currentAddr');
    orderNo.innerHTML += '${orderNo}';
    productInfo.innerHTML += '${productDesc}';
    currentAddr.innerHTML += '${addrDtl}' + '${street}' + '${mailArea}' + '${mailPostCode}' + '${mailCity}' + '${mailState}' + '${mailCnty}';

    $('#btnUpdate').click(function(evt) {
		     Common.ajax("GET","/enquiry/checkExistRequest.do", $("#insAddressForm").serializeJSON() , function (result){
			     if(result.data.result > 0){
			    	 Common.alert("You have submmitted the update request before for this order number: " + '${orderNo}' + " Confirm to proceed update new request?",getTacNo);
			     }
			     else{
			    	 getTacNo();
			     }
		 });
     });

    $('#btnResend').click(function(evt) {
        Common.ajax("GET","/enquiry/getTacNo.do",{orderNo: "${orderNo}"}  , function (result){});
    });

    $('#btnContinue').click(function(evt) {
		        console.log($("#tacForm").serializeJSON());
		        var param = {};
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
		            console.log(result);
		            if(result.code =="00"){
		                Common.alert(result.message, goCustomerInfoPage);
		            }
		            else{
		                Common.alert(result.message);
		            }
		        });
		  });

   });

   function getTacNo(){
	    Common.ajax("GET","/enquiry/getTacNo.do", $("#insAddressForm").serializeJSON() , function (result){
	    console.log(result);
	 if(result.code =="00"){
	        Common.alert(result.message,goTacVerificationPage);
	    }
	    else{
	        Common.alert(result.message);
	    }
	});
   }

function startCountdown(seconds) {
    let counter = seconds;

    const interval = setInterval(() => {
      document.getElementById('countDown').innerText=counter;
      counter--;

      if (counter < 0 ) {
        clearInterval(interval);
        Common.alert('Your TAC number is expired. Please click "Resend TAC" to get new code.');
      }
    }, 1000);
}

function goCustomerInfoPage(){
    $("#tacForm").attr("target", "");
    $("#tacForm").attr({
        action: getContextPath() + "/enquiry/selectCustomerInfo.do",
        method: "POST"
    }).submit();
}

   function goTacVerificationPage(){
	   $("#modal").click();
// 	   console.log("tttt")
// 	   $("#insAddressForm").attr("target", "");
//        $("#insAddressForm").attr({
//            action: getContextPath() + "/enquiry/tacVerification.do",
//            method: "POST"
//        }).submit();
   }


</script>

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#"><span><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway2.png" alt="Coway" /></span></a>

    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav" class="text-white">
        <li><a class="text-white">Home</a></li>
        <li><a class="text-white">Customer Info</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
           <li><a class="text-white">Welcome , ${SESSION_INFO.custName}</a></li>
           <li><a href="${pageContext.request.contextPath}/enquiry/updateInstallationAddress.do" class="text-white">Log Out</a></li>
      </ul>
    </div>
  </div>
</nav>

<div id="updateInstallationDetailsPage">
<div class="jumbotron" style="width:100%">
  <div class="container text-center">
    <h3>Update Address</h3>
  </div>
</div>

<div class="container">
<div class="row">
  <div class="col-md-8 mb-4 text-left">
    <div class="card mb-4">
      <div class="card-header py-3">
        <h5>New Installation Address Details</h5>
      </div>
      <br>
      <br>
      <div class="card-body">
        <form id="insAddressForm">
            <input type="hidden" id="areaId" name="areaId">
            <input type="hidden" value="${SESSION_INFO.custId}" id="_insCustId" name="insCustId">
            <input type="hidden" name="addrCustAddId" id="addrCustAddId">
            <input type="hidden" name="orderId" id="orderId" value="${orderId}">
            <input type="hidden" name="orderNo"  value="${orderNo}">
          <div class="row mb-4">
            <div class="col">
              <div class="form-outline">
              <label class="form-label" >Address 1<span class="must text-danger">*</span></label>
              <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="form-control" maxlength="100" />
            </div>
            </div>

            <div class="col marginTop">
              <div class="form-outline">
              <label class="form-label" >Address 2</label>
                <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="form-control" maxlength="100" />
              </div>
            </div>

           <div class="col marginTop">
	             <div class="form-outline">
		              <label class="form-label" >State</label>
		              <select class="form-control" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
	             </div>
            </div>

	        <div class="col marginTop">
	              <div class="form-outline">
	                  <label class="form-label" >City</label>
	                  <select class="form-control" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
	              </div>
	        </div>

	        <div class="col marginTop">
                  <div class="form-outline">
                      <label class="form-label" >Area Search</label>
                      <div class="row">
                         <div class="col-md-11">
                      <input type="text" " id="searchSt" name="searchSt" class="form-control" />
                      </div>

                      <div class="col-md-1">
                      <a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                      </div>
                      </div>
                  </div>
            </div>



             <div class="col marginTop">
              <div class="form-outline">
              <label class="form-label" >Postcode</label>
                <select class="form-control" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
              </div>
            </div>

              <div class="col marginTop">
              <div class="form-outline">
              <label class="form-label" >Area</label>
            <select class="form-control" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select>
              </div>
            </div>

            <div class="col marginTop">
              <div class="form-outline">
              <label class="form-label" >Country</label>
              <input type="text" id="country" name="country" class="form-control" value="Malaysia" readonly />
              </div>
            </div>




          </div>
           <br/>
        </form>
      </div>
    </div>
  </div>

  <div class="col-md-4 mb-4">
    <div class="card mb-4">
      <div class="card-header py-3">
        <h5 class="mb-0">Summary</h5>
      </div>
      <br>
      <br>
      <div class="card-body">
        <ul class="list-group list-group-flush">
          <li
            class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pb-0">
            Order No : <span id="orderNo"></span>
          </li>
          <li class="list-group-item d-flex justify-content-between align-items-center px-0">
             Products : <span id="productInfo"></span>
          </li>
          <li
            class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 mb-3">
            <div>Current Installation Address : <br><span id="currentAddr"></span>
            </div>

          </li>
        </ul>
         <p class="btn btn-primary btn-lg btn-block"  id="btnUpdate" ><a href="javascript:void(0);" style="color:white">Update</a></p>
      </div>
    </div>
  </div>
</div>
</div>
</div>


<div class="container">
  <h2>Modal Example</h2>
  <!-- Trigger the modal with a button -->
  <button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal" id="modal">Open Modal</button>

  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">

      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Modal Header</h4>
        </div>
        <div class="modal-body">
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
                                        <h6><u>Need help?</u></h6>
                                </div>


                            </div>

                        </form>
                    </div>
                    <div>
                    <div class="row" >
                    <div class="col-lg-6 col-md-6 mb-3  float-left" style="text-align:center">
                            <p class="button"  id="btnCancel" ><a href="javascript:void(0);" style="color:white">Cancel</a></p>
                        </div>
                        <div class="col-lg-6 col-md-6 mb-3" style="text-align:center">
                            <p class="button"  id="btnContinue" ><a href="javascript:void(0);" style="color:white">Continue</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</div>

