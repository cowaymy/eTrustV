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
var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false,
        selectionMode : "multipleRows"
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){

    
});

var emailAddrLayout = [ 
                       {
                           dataField : "name",
                           headerText : "Status",
                           editable : false,
                           width : 80
                       }, {
                           dataField : "fullAddr",
                           headerText : "Address",
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
                           headerText : "Status",
                           editable : false,
                       }, {
                           dataField : "name2",
                           headerText : "Name",
                           editable : false,
                       }, {
                           dataField : "nric",
                           headerText : "NRIC",
                           editable : false
                       }, {
                           dataField : "codeName",
                           headerText : "Race",
                           editable : false,
                       },{
                           dataField : "gender",
                           headerText : "Gender",
                           editable : false,
                       },{
                           dataField : "telM1",
                           headerText : "Tel(Mobile)",
                           editable : false,
                       },{
                           dataField : "telR",
                           headerText : "Tel(Residence)",
                           editable : false,
                       },{
                           dataField : "telf",
                           headerText : "Tel(Fax)",
                           editable : false,
                       },{
                           dataField : "custCntcId",
                           headerText : "custCntcId",
                           editable : false,
                           visible : false
                       }];

	function fn_goBillGrp(){
		location.href = "initBillGroupManagement.do";
	}
	
	function fn_addNewGroup(){
		var custBillId = "157922";
		var valid = true;
        var message = "";
        
        if($("#post").is(":checked") == false && $("#sms").is(":checked") == false && $("#estm").is(":checked") == false ){
            
            valid = false;
            message += "* Please select at least one billing type.<br />";
        }else{
        	if($("#sms").is(":checked") && custTypeId == "965"){
                
                valid = false;
                message += "* SMS is not allow for company type customer.<br />";
            }
        }
        
        if($("#estm").is(":checked")){
        	
        	if($("#email").val() == ""){
        		valid = false;
        		message += "* Please key in the email address.<br />";
        	}
        }
		
        if($("#addrId").val() == ""){
        	valid = false;
        	message += "* Please select an address.<br />";
        }
        
        if($("#contactId").val()  == ""){
        	valid = false;
        	message += "* Please select a contact person.<br />";
        }
        
        if(valid){
        	Common.ajax("GET","/payment/saveAddNewGroup.do", {"custBillId":custBillId}, function(result){
                console.log(result);
                
            });
        }else{
        	Common.alert(message);
        }
	}
	
	function fn_estmEvent(){
	    
		if($("#estm").is(":checked")){
			$("#email").attr('disabled', false);
		}else{
			$("#email").attr('disabled', true);
		}
	}
	
	function fn_selectMailAddr(){
	    AUIGrid.destroy(emailAddrPopGridID); 
	    var custBillCustId = $("#custBillCustId").val();
	    $("#selectMaillAddrPop").show();
	    emailAddrPopGridID = GridCommon.createAUIGrid("selMaillAddrGrid", emailAddrLayout,null,gridPros);
	    Common.ajax("GET","/payment/selectCustMailAddrList.do", {"custBillCustId":custBillCustId}, function(result){
	        console.log(result);
	        AUIGrid.setGridData(emailAddrPopGridID, result);
	        
	        //Grid 셀 클릭시 이벤트
	        AUIGrid.bind(emailAddrPopGridID, "cellClick", function( event ){
	            selectedGridValue = event.rowIndex;
	            
	            $("#changeMail_newAddr").val(AUIGrid.getCellValue(emailAddrPopGridID , event.rowIndex , "fullAddr"));
	            $("#custAddId").val(AUIGrid.getCellValue(emailAddrPopGridID , event.rowIndex , "custAddId"));
	            
	            $("#selectMaillAddrPop").hide();
	            AUIGrid.destroy(emailAddrPopGridID);
	            Common.alert("<b>New address selected.<br/>Click save to confirm change address.</b>");
	
	        });
	    });
	}
	
	function fn_addNewAddr() {
	    var custBillCustId = $("#custBillCustId").val();
	    Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', {"custId" : custBillCustId,  "callParam" : "billGroup"}, null , true ,'_editDiv2New');
	}
	
	function fn_addNewConPerson(){
	    var custBillCustId = $("#custBillCustId").val(); 
	    Common.popupDiv('/sales/customer/updateCustomerNewContactPop.do', {"custId":custBillCustId, "callParam" : "billGroup"}, null , true ,'_editDiv3New');
	}
	
	function fn_selectContPerson(){
	    
	    AUIGrid.destroy(contPersonPopGridID); 
	    var custBillCustId = $("#custBillCustId").val();
	    $("#selectContPersonPop").show();
	    contPersonPopGridID = GridCommon.createAUIGrid("selContPersonGrid", contPersonLayout,null,gridPros);
	    Common.ajax("GET","/payment/selectContPersonList.do", {"custBillCustId":custBillCustId}, function(result){
	        console.log(result);
	        AUIGrid.setGridData(contPersonPopGridID, result);
	        
	        //Grid 셀 클릭시 이벤트
	        AUIGrid.bind(contPersonPopGridID, "cellClick", function( event ){
	            selectedGridValue = event.rowIndex;
	            
	            $("#custCntcId").val(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "custCntcId"));//히든값
	            $("#newContactPerson").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "name2"));
	            $("#newMobNo").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telM1"));
	            $("#newOffNo").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telO"));
	            $("#newResNo").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telR"));
	            $("#newFaxNo").text(AUIGrid.getCellValue(contPersonPopGridID , event.rowIndex , "telf"));
	            
	            
	            $("#selectContPersonPop").hide();
	            AUIGrid.destroy(contPersonPopGridID);
	            Common.alert("<b>New contact person selected.<br />Click save to confirm change contact person.</b>");
	
	        });
	    });
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
	    $("#contKeyword").val("");
	}
	
	function fn_keywordClear2(){
	    
	    $("#contKeyword").val("");
	}
    
</script>
<body>
<form action="" id="myForm">
<div id="wrap"><!-- wrap start -->
<section id="content"><!-- content start -->
	<ul class="path">
	        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
	        <li>Payment</li>
	        <li>Billing Group</li>
	        <li>Create New Group</li>
	</ul>
<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Create New Group</h2>
</aside><!-- title_line end -->
<section class="search_table"><!-- search_table start -->
<!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
				        <li><p class="link_btn"><a href="#">menu1</a></p></li>
				        <li><p class="link_btn"><a href="#">menu2</a></p></li>
				        <li><p class="link_btn"><a href="#">menu3</a></p></li>
				        <li><p class="link_btn"><a href="#">menu4</a></p></li>
				        <li><p class="link_btn"><a href="#">menu5</a></p></li>
				        <li><p class="link_btn"><a href="#">menu6</a></p></li>
				        <li><p class="link_btn"><a href="#">menu7</a></p></li>
				        <li><p class="link_btn"><a href="#">menu8</a></p></li>
			         </ul>
                    <ul class="btns">
				        <li><p class="link_btn type2"><a href="javascript:fn_goBillGrp();">Manage Existing Group</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->
</section><!-- search_table end -->

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
    <td id="mainOrder" colspan="3">
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
    <label><input type="checkbox"  id="post"  name="post"/><span>Post</span></label>
    <label><input type="checkbox"  id="sms"  name="sms"/><span>SMS</span></label>
    <label><input type="checkbox"  id="estm" name="estm" onclick="fn_estmEvent();"/><span>E-Statement</span></label>
    </td>
    <th scope="row">Email</th>
    <td>
        <input type="text"  id="email" name="email" disabled="disabled"/>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea rows="" cols="" id="remark"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns">
    <li><p class="btn_blue2"><a href="javascript:fn_addNewAddr();">Add New Address</a></p></li>
    <li><p class="btn_blue2"><a href="javascript:fn_selectMailAddr();">Select Mailing Address</a></p></li>
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
    <li><p class="btn_blue2"><a href="javascript:fn_addNewConPerson();">Add New Contact</a></p></li>
    <li><p class="btn_blue2"><a href="javascript:fn_selectContPerson();">Select Contact Person</a></p></li>
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
    <td colspan="3" id="contractPerson">
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
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="javascript:fn_addNewGroup();">SAVE</a></p></li>
</ul>
</section><!-- content end -->
</section><!-- container end -->
<hr />
</div><!-- wrap end -->
<div id="selectMaillAddrPop" class="popup_wrap size_mid" style="display: none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Customer Address - Customer Address</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="fn_custAddrClose();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:fn_searchAddrKeyword();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="javascript:fn_keywordClear();"><span class="clear"></span>Clear</a></p></li>
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
    <input type="text" id="custAddr" title="" placeholder="Keyword" class="w100p" />
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
    <li><p class="btn_blue2"><a href="#" onclick="fn_contPerPopClose();">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:fn_searchContactKeyword();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="javascript:fn_keywordClear2();"><span class="clear"></span>Clear</a></p></li>
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
    <input type="text" id="contKeyword" title="" placeholder="Keyword" class="w100p" />
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