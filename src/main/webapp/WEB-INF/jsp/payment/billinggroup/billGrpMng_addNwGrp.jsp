<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
var emailAddrPopGridID;
var contPersonPopGridID;
var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 상태 칼럼 사용
        showStateColumn : false
};
var tinID = 0;

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){


});

var emailAddrLayout = [
                       {
                           dataField : "name",
                           headerText : "<spring:message code='pay.head.status'/>",
                           editable : false,
                           width : 80
                       }, {
                           dataField : "addr",
                           headerText : "<spring:message code='pay.head.address'/>",
                           editable : false
                       }, {
                           dataField : "custAddId",
                           headerText : "",
                           editable : false,
                           visible : false
                       }];

//AUIGrid 칼럼 설정
var contPersonLayout = [
                       {
                           dataField : "name",
                           headerText : "<spring:message code='pay.head.status'/>",
                           editable : false,
                       }, {
                           dataField : "name1",
                           headerText : "<spring:message code='pay.head.name'/>",
                           editable : false,
                       }, {
                           dataField : "nric",
                           headerText : "<spring:message code='pay.head.nric'/>",
                           editable : false
                       }, {
                           dataField : "codeName",
                           headerText : "<spring:message code='pay.head.race'/>",
                           editable : false,
                       },{
                           dataField : "gender",
                           headerText : "<spring:message code='pay.head.gender'/>",
                           editable : false,
                       },{
                           dataField : "telM1",
                           headerText : "<spring:message code='pay.head.mobile'/>",
                           editable : false,
                       },{
                           dataField : "telR",
                           headerText : "<spring:message code='pay.head.residence'/>",
                           editable : false,
                       },{
                           dataField : "telf",
                           headerText : "<spring:message code='pay.head.fax'/>",
                           editable : false,
                       },{
                           dataField : "custCntcId",
                           headerText : "<spring:message code='pay.head.custCntcId'/>",
                           editable : false,
                           visible : false
                       }];


	function fn_estmEvent(val){

		if(val == 3){
			$("#email").attr('disabled', false);
		}else{
			$("#email").val("");
			$("#email").attr('disabled', true);
		}
	}

	function fn_selectMailAddr(){

	    var custTypeId = $("#custTypeId").val();
	    var custAddr = $("#custAddr").val();

	    if(custTypeId == ""){
	    	Common.alert("<spring:message code='pay.alert.selectTheOrderFirst'/>");
	    }else{

	        Common.ajax("GET","/payment/selectCustMailAddrList.do", {"custBillCustId":custTypeId, "custAddr" : custAddr}, function(result){
	        	$("#selectMaillAddrPop").show();
	        	AUIGrid.destroy(emailAddrPopGridID);
	        	emailAddrPopGridID = GridCommon.createAUIGrid("selMaillAddrGrid", emailAddrLayout,null,gridPros);
	            AUIGrid.setGridData(emailAddrPopGridID, result);

	            //Grid 셀 클릭시 이벤트
	            AUIGrid.bind(emailAddrPopGridID, "cellClick", function( event ){
	                selectedGridValue = event.rowIndex;
	                $("#maillingAddr").text(AUIGrid.getCellValue(emailAddrPopGridID , event.rowIndex , "addr"));
	                $("#custAddId").val(AUIGrid.getCellValue(emailAddrPopGridID , event.rowIndex , "custAddId"));
	                $("#selectMaillAddrPop").hide();
	                AUIGrid.destroy(emailAddrPopGridID);

	            });
	        });
	    }
	}

	function fn_addNewAddr() {
	    var custTypeId = $("#custTypeId").val();

	    if(custTypeId == ""){
	    	Common.alert("<spring:message code='pay.alert.selectTheOrderFirst'/>");
	    }else{
	    	Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', {"custId" : custTypeId,  "callParam" : "billGroup"}, null , true ,'_editDiv2New');
	    }
	}

	function fn_addNewConPerson(){

	    var custTypeId = $("#custTypeId").val();
	    if(custTypeId == ""){

	    	Common.alert("<spring:message code='pay.alert.selectTheOrderFirst'/>");
	    }else{
	    	Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {"custId":custTypeId, "callParam" : "billGroup"}, null , true ,'_editDiv3New');
	    }
	}

	function fn_selectContPerson(){

	    var custTypeId = $("#custTypeId").val();
	    var personKeyword = $("#personKeyword").val();

	    if(custTypeId == ""){
	    	Common.alert("<spring:message code='pay.alert.selectTheOrderFirst'/>");
	    }else{

	        Common.ajax("GET","/payment/selectContPersonList.do", {"custBillCustId":custTypeId , "personKeyword" : personKeyword}, function(result){
	        	$("#selectContPersonPop").show();
	        	AUIGrid.destroy(contPersonPopGridID);
	            contPersonPopGridID = GridCommon.createAUIGrid("selContPersonGrid", contPersonLayout,null,gridPros);
	            AUIGrid.setGridData(contPersonPopGridID, result);

	            //Grid 셀 클릭시 이벤트
	            AUIGrid.bind(contPersonPopGridID, "cellClick", function( event ){
	                selectedGridValue = event.rowIndex;

	                $("#custCntcId").val(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "custCntcId"));//히든값
	                $("#contactPerson").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "name1"));
	                $("#mobileNumber").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telM1"));
	                $("#officeNumber").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telO"));
	                $("#residenceNumber").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telR"));
	                $("#faxNumber").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telf"));
	                $("#selectContPersonPop").hide();
	                AUIGrid.destroy(contPersonPopGridID);
	            });
	        });
	    }
	}

	function fn_custAddrClose(){
	    $("#selectMaillAddrPop").hide();
	    $("#custAddr").val("");
	}

	function fn_keywordClear(){
	    $("#custAddr").val("");
	}

	function fn_contPerPopClose(){
	    $("#selectContPersonPop").hide();
	    $("#personKeyword").val("");
	}

	function fn_keywordClear2(){
	    $("#personKeyword").val("");
	}

    function fn_orderSearch(){
    	Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "BILLING_ADD_NEW_GROUP", indicator : "SearchTrialNo"});
    }

    function fn_orderInfo(ordNo, ordId){
    	loadOrderInfo(ordNo, ordId);
    }

    function loadOrderInfo(ordNo, ordId){

    	Common.ajax("GET","/payment/selectLoadOrderInfo.do", {"salesOrdId" : ordId}, function(result){
            console.log(result);

            if(result.data.orderInfo != null){

            	if(result.data.orderInfo.appTypeId == "66" ||  (result.data.orderInfo.appTypeId != "66" && result.data.orderInfo.srvCntrctId > 0)){

                    $('#salesOrdId').val(result.data.orderInfo.salesOrdId);//히든값
                    $('#custTypeId').val(result.data.orderInfo.custId);//히든값
                    $('#custCntcId').val(result.data.contactInfo.custCntcId);//히든값

                    //BASIC INFO
                    $('#orderNo').val(result.data.orderInfo.salesOrdNo);
                    $('#customerId').text(result.data.orderInfo.custId);
                    $('#nric').text(result.data.orderInfo.nric);
                    $('#customerName').text(result.data.orderInfo.name);

                    //MAIL INFO
                    if(result.data.maillingInfo != null){
                    	$('#custAddId').val(result.data.maillingInfo.custAddId);//히든값
                    	$('#maillingAddr').text(result.data.maillingInfo.addr);
                    }else{
                    	//$('#custAddId').val("");//히든값
                        $('#maillingAddr').text("");
                    }

                    //CONTACT INFO
                    $('#contactPerson').text(result.data.contactInfo.code + " "+result.data.contactInfo.name2);
                    $('#mobileNumber').text(result.data.contactInfo.telM1);
                    $('#officeNumber').text();
                    $('#residenceNumber').text(result.data.contactInfo.telR);
                    $('#faxNumber').text(result.data.contactInfo.telf);

                    //E-INVOICE FOR CORPORATE
                    if(result.data.orderInfo.typeId == "965"){
                    	$("#isEInvoice").prop('checked', true); // Mandatory for corporate
                    	$("#isEInvoice").prop('disabled', true);
                    }
                    else{
                        $("#isEInvoice").prop('checked', false); // reset for non-corporate
                        $("#isEInvoice").prop('disabled', false);
                    }

                }else{
                    Common.alert("<spring:message code='pay.alert.notRentalType'/>");
                }

            }else{
            	Common.alert("<spring:message code='pay.alert.orderNotFound'/>");
            }
        });
    }

    function onblurOrderInfo(){

    	var inputOrdNo = $('#orderNo').val();

    	if($.trim($('#orderNo').val()) == ""){
    		return;
    	}

        Common.ajax("GET","/payment/selectLoadOrderInfo.do", {"salesOrdNo" : inputOrdNo}, function(result){
            console.log(result);

            if(result.data.orderInfo != null){

            	if(result.data.orderInfo.appTypeId == "66" ||  (result.data.orderInfo.appTypeId != "66" && result.data.orderInfo.srvCntrctId > 0)){

                    $('#salesOrdId').val(result.data.orderInfo.salesOrdId);//히든값
                    $('#custTypeId').val(result.data.orderInfo.custId);//히든값
                    $('#custCntcId').val(result.data.contactInfo.custCntcId);//히든값

                    //BASIC INFO
                    $('#orderNo').val(result.data.orderInfo.salesOrdNo);
                    $('#customerId').text(result.data.orderInfo.custId);
                    $('#nric').text(result.data.orderInfo.nric);
                    $('#customerName').text(result.data.orderInfo.name);
                    tinID = result.data.orderInfo.tinId;

                    //MAIL INFO
                    if(result.data.maillingInfo != null){
                    	$('#custAddId').val(result.data.maillingInfo.custAddId);//히든값
                    	$('#maillingAddr').text(result.data.maillingInfo.addr);
                    }else{
                    	//$('#custAddId').val("");//히든값
                        $('#maillingAddr').text("");
                    }

                    //CONTACT INFO
                    $('#contactPerson').text(result.data.contactInfo.code + " "+result.data.contactInfo.name2);
                    $('#mobileNumber').text(result.data.contactInfo.telM1);
                    $('#officeNumber').text();
                    $('#residenceNumber').text(result.data.contactInfo.telR);
                    $('#faxNumber').text(result.data.contactInfo.telf);

                  //E-INVOICE FOR CORPORATE
                    if(result.data.orderInfo.typeId == "965"){
                        $("#isEInvoice").prop('checked', true); // Mandatory for corporate
                        $("#isEInvoice").prop('disabled', true);
                    }
                    else{
                    	$("#isEInvoice").prop('checked', false); // reset for non-corporate
                    	$("#isEInvoice").prop('disabled', false);
                    }

                }else{
                	$('#orderNo').val("");
                	Common.alert("<spring:message code='pay.alert.notRentalType'/>");
                }

            }else{
            	displayReset();
            	Common.alert("<spring:message code='pay.alert.orderNotFound'/>");
            }
        });
    }

    function displayReset(){
    	$('#orderNo').val("");
        $('#customerId').text("");
        $('#nric').text("");
        $('#customerName').text("");
        $("#post").prop('checked', false);
        $("#estm").prop('checked', false);
        $("#sms").prop('checked', false);
        $("#isEInvoice").prop('checked', false);
        $('#email').val("");
        $("#email").prop('readonly', true);
        $('#remark').val("");
        $('#maillingAddr').text("");
        $('#contactPerson').text("");
        $('#mobileNumber').text("");
        $('#officeNumber').text("");
        $('#residenceNumber').text("");
        $('#faxNumber').text("");
    }

    function fn_createEvent(objId, eventType){
    	var e = jQuery.Event(eventType);
        $('#'+objId).trigger(e);
    }

    function fn_createNewGroup(){

    	var message = "";
        var valid = true;
        var salesOrdId = $('#salesOrdId').val();
        var custTypeId = $('#custTypeId').val();
        var custAddId = $('#custAddId').val();
        var custCntcId = $('#custCntcId').val();

        if(salesOrdId == ""){
        	valid = false;
        	message += "<spring:message code='pay.alert.selectAnOrder'/>";
        }

        if($("#post").is(":checked") == false && $("#sms").is(":checked") == false && $("#estm").is(":checked") == false ){

            valid = false;
            message += "<spring:message code='pay.alert.selectBillingType.'/>";
        }else{

        	if($("#changePop_sms").is(":checked") && custTypeId == "965"){

                valid = false;
                message += "<spring:message code='pay.alert.smsNotAllow.'/>";
            }

            if($("#estm").is(":checked")){

                if($("#email").val().trim() == ""){
                	valid = false;
                	message += "<spring:message code='pay.alert.emailAddress.'/>";
                }else{

                	if(FormUtil.checkEmail(($("#email").val().trim())) == true){
                        valid = false;
                        message += "<spring:message code='pay.alert.invalidEmail.'/>";
                     }
                }
            }
        }

        if($("#isEInvoice").is(":checked") == true && tinID == "0"){
            valid = false;
            message += "* E-Invoice is not allow. Please update customer's TIN number in Customer Management before choosing e-Invoice. <br />";
        }

        if(custAddId == ""){
            valid = false;
            message += "<spring:message code='pay.alert.selectAnAddress'/>";
        }

        if(custCntcId == ""){
            valid = false;
            message += "<spring:message code='pay.alert.selectContPerson.'/>";
        }

        if($("#post").is(":checked")){
        	$("#isPost").val(1);
        }else{
        	$("#isPost").val(0);
        }

        if($("#sms").is(":checked")){
        	$("#isSms").val(1);

        }else{
        	$("#isSms").val(0);
        }

        if($("#sms").is(":checked")){
        	$("#isEstm").val(1);
        }else{
        	$("#isEstm").val(0);
        }

        if($("#isEInvoice").is(":checked")){
        	$("#isEInv").val(1);
        }else{
        	$("#isEInv").val(0);
        }

        if(valid){

        	Common.ajax("POST","/payment/saveAddNewGroup.do", $("#newGroupForm").serializeJSON(), function(result){
                console.log(result);
                Common.alert(result.message);
                fn_disableControl();
            });

        }else{
        	Common.alert(message);
        }
    }

    function fn_disableControl(){
    	$('#_btnSave').hide();
    	$('#trialNoBtn').hide();
    	$("#orderNo").attr('disabled', true);
    	$("#sms").attr('disabled', true);
    	$("#post").attr('disabled', true);
    	$("#estm").attr('disabled', true);
    	$("#email").attr('disabled', true);
        $("#custBillRemark").attr('disabled', true);
        $('#addNewAddr').hide();
        $('#selectMailAddr').hide();
        $('#addNewContact').hide();
        $('#selectContPerson').hide();
    }

</script>
<body>
	<form action="" id="newGroupForm" name="newGroupForm">
		<input type="hidden" name="salesOrdId" id="salesOrdId">
		<input type="hidden" name="custTypeId" id="custTypeId">
		<input type="hidden" name="custAddId" id="custAddId">
		<input type="hidden" name="custCntcId" id="custCntcId">
		<input type="hidden" name="isPost" id="isPost">
    <input type="hidden" name="isSms" id="isSms">
    <input type="hidden" name="isEstm" id="isEstm">
    <input type="hidden" name="isEInv" id="isEInv">
		<div id="wrap"><!-- wrap start -->
			<section id="content"><!-- content start -->
				<ul class="path">
				        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
				</ul>
				<aside class="title_line"><!-- title_line start -->
					<p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
					<h2>Add New Group</h2>
				</aside><!-- title_line end -->
				<section class="search_result"><!-- search_result start -->
					<section class="tap_wrap"><!-- tap_wrap start -->
						<ul class="tap_type1">
						    <li><a href="#" class="on" id="basciInfo">Basic Info</a></li>
						    <li><a href="#">Mailing Address</a></li>
						    <li><a href="#">Contact Info</a></li>
						</ul>
						<article class="tap_area"><!-- tap_area start -->
							<table class="type1 mt10"><!-- table start -->
								<caption>table</caption>
								<colgroup>
								    <col style="width:160px" />
								    <col style="width:*" />
								    <col style="width:160px" />
								    <col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
									    <th scope="row">Main Order</th>
									    <td id="" colspan="">
									        <input type="text" name="orderNo" id="orderNo" class="w100p" onblur="onblurOrderInfo();">
									    </td>
									    <td colspan="2">
									        <a id="trialNoBtn" name="trialNoBtn" href="javascript:fn_orderSearch();" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
									    </td>
									</tr>
									<tr>
									    <th scope="row">Customer ID</th>
									    <td id="customerId">
									    </td>
									    <th scope="row">NRIC/Company No</th>
									    <td id="nric">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Customer Name</th>
									    <td colspan="3" id="customerName">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Billing Type</th>
									    <td colspan="">
									    <label><input type="radio"  id="post"  name="billingType"  onclick="fn_estmEvent(1);"/><span>Post</span></label>
									    <label><input type="radio"  id="sms"  name="billingType"  onclick="fn_estmEvent(2);"/><span>SMS</span></label>
									    <label><input type="radio"  id="estm" name="billingType"  onclick="fn_estmEvent(3);" checked="checked" /><span>E-Statement</span></label>
									    </td>
									    <th scope="row">Email</th>
									    <td>
									        <input type="text"  id="email" name="email" />
									    </td>
									</tr>
									<tr>
                                       <th scope="row">E-Invoice</th>
                                       <td colspan="3">
                                           <input id="isEInvoice" name="isEInvoice" type="checkbox""/>
                                       </td>
                                    </tr>
									<tr>
									    <th scope="row">Remark</th>
									    <td colspan="3"><textarea rows="" cols="" id="custBillRemark" name="custBillRemark"></textarea>
									    </td>
									</tr>
								</tbody>
							</table><!-- table end -->
						</article><!-- tap_area end -->
						<article class="tap_area"><!-- tap_area start -->
							<ul class="right_btns">
							    <li><p class="btn_blue2"><a href="javascript:fn_addNewAddr();" id="addNewAddr"><spring:message code='pay.btn.addNewAddress'/></a></p></li>
							    <li><p class="btn_blue2"><a href="javascript:fn_selectMailAddr();" id="selectMailAddr"><spring:message code='pay.btn.selectMailingAddress'/></a></p></li>
							</ul>
							<table class="type1 mt10"><!-- table start -->
								<caption>table</caption>
								<colgroup>
								    <col style="width:160px" />
								    <col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
									    <th scope="row">Mailing Address</th>
									    <td id="maillingAddr">
									    </td>
									</tr>
								</tbody>
							</table><!-- table end -->
						</article><!-- tap_area end -->
						<article class="tap_area"><!-- tap_area start -->
							<ul class="right_btns">
							    <li><p class="btn_blue2"><a href="javascript:fn_addNewConPerson();" id="addNewContact"><spring:message code='pay.btn.addNewContact'/></a></p></li>
							    <li><p class="btn_blue2"><a href="javascript:fn_selectContPerson();" id="selectContPerson"><spring:message code='pay.btn.selectContactPerson'/></a></p></li>
							</ul>
							<table class="type1 mt10"><!-- table start -->
								<caption>table</caption>
								<colgroup>
								    <col style="width:160px" />
								    <col style="width:*" />
								    <col style="width:160px" />
								    <col style="width:*" />
								</colgroup>
								<tbody>
									<tr>
									    <th scope="row">Contact Person</th>
									    <td colspan="3" id="contactPerson">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Mobile Number</th>
									    <td id="mobileNumber">
									    </td>
									    <th scope="row">Office Number</th>
									    <td id="officeNumber">
									    </td>
									</tr>
									<tr>
									    <th scope="row">Residence Number</th>
									    <td id="residenceNumber">
									    </td>
									    <th scope="row">Fax Number</th>
									    <td id="faxNumber">
									    </td>
									</tr>
								</tbody>
							</table><!-- table end -->
						</article><!-- tap_area end -->
					</section><!-- tap_wrap end -->
					<ul class="center_btns mt10">
					   <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
					    <li><p class="btn_blue2 big"><a href="javascript:fn_createNewGroup();" id="_btnSave"><spring:message code='sys.btn.save'/></a></p></li>
					   </c:if>
					</ul>
				</section><!-- content end -->
			</section><!-- container end -->
		  <hr />
		</div><!-- wrap end -->
		<div id="selectMaillAddrPop" class="popup_wrap size_mid" style="display: none"><!-- popup_wrap start -->
			<header class="pop_header"><!-- pop_header start -->
				<h1>Customer Address - Customer Address</h1>
				<ul class="right_opt">
				    <li><p class="btn_blue2"><a href="#" onclick="fn_custAddrClose();"><spring:message code='sys.btn.close'/></a></p></li>
				</ul>
			</header><!-- pop_header end -->
			<section class="pop_body"><!-- pop_body start -->
				<ul class="right_btns">
				    <li><p class="btn_blue"><a href="javascript:fn_selectMailAddr();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
				    <li><p class="btn_blue"><a href="javascript:fn_keywordClear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
				</ul>
				<table class="type1 mt10"><!-- table start -->
					<caption>table</caption>
					<colgroup>
					    <col style="width:160px" />
					    <col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
						    <th scope="row">Address Keyword</th>
						    <td>
						    <input type="text" id="custAddr" name="custAddr" title="" placeholder="Keyword" class="w100p" />
						    </td>
						</tr>
					</tbody>
				</table><!-- table end -->
				<article id="selMaillAddrGrid" class="grid_wrap mt30"><!-- grid_wrap start -->
				</article><!-- grid_wrap end -->
		  </section><!-- pop_body end -->
		</div><!-- popup_wrap end -->
		<div id="selectContPersonPop" class="popup_wrap size_mid" style="display: none"><!-- popup_wrap start -->
			<header class="pop_header"><!-- pop_header start -->
				<h1>We Bring Wellness - Customer Contact</h1>
				<ul class="right_opt">
				    <li><p class="btn_blue2"><a href="#" onclick="fn_contPerPopClose();"><spring:message code='sys.btn.close'/></a></p></li>
				</ul>
			</header><!-- pop_header end -->
			<section class="pop_body"><!-- pop_body start -->
				<ul class="right_btns">
				    <li><p class="btn_blue"><a href="javascript:fn_selectContPerson();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
				    <li><p class="btn_blue"><a href="javascript:fn_keywordClear2();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
				</ul>
				<table class="type1 mt10"><!-- table start -->
					<caption>table</caption>
					<colgroup>
					    <col style="width:160px" />
					    <col style="width:*" />
					</colgroup>
					<tbody>
						<tr>
						    <th scope="row">Contact Keyword</th>
						    <td>
						    <input type="text" id="personKeyword" name="personKeyword" title="" placeholder="Keyword" class="w100p" />
						    </td>
						</tr>
					</tbody>
				</table><!-- table end -->
				<article id="selContPersonGrid" class="grid_wrap mt30"><!-- grid_wrap start -->
				</article><!-- grid_wrap end -->
			</section><!-- pop_body end -->
		</div><!-- popup_wrap end -->
	</form>
</body>