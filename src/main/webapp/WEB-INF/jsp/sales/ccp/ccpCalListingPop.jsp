<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javascript">

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
} 
$("#dpDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
$("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

$.fn.clearForm = function() {
	$("#cmbCCPFeedbackCode").multipleSelect("checkAll");
	
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
        $("#dpDateFr").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
        $("#dpDateTo").val(date+"/"+(new Date().getMonth()+1)+"/"+new Date().getFullYear());
    });
};

function validRequiredField(){
	
	var valid = true;
	var message = "";
	
	if(($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0) || ($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
		valid = false;
		message = "* Please key in the Order Date.\n";
	}
	
	if(valid == false){
		Common.alert("CCP Generate Summary" + DEFAULT_DELIMITER + message);
	}
	
	return valid;
}

function btnGenerate_Click(){
	if(validRequiredField() == true){
		fn_report("PDF");
	}	
}

function btnGenExcel_Click(){
	if(validRequiredField() == true){
        fn_report("EXCEL");
    }   
}

function fn_report(viewType){
	
	$("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");
	
	var orderNoFrom = "";
	var orderNoTo = "";
	var orderDateFrom = "";
	var orderDateTo = "";
	var branchRegion = "";
	var keyInBranch = "";
	var groupCode = "";
    var ccpProgStatus = "";
    var ccpPointFrom = "";
    var ccpPointTo = "";
    var rejStatus = "";
    var actTaken = "";
    var sortBy = "";
    var selectSQL = "";
    var whereSQL = "";
    var extraWhereSQL = "";
    var orderBySQL = "";
    var fullSQL = "";
    
    var runNo = 0;
    
    
    if(!($("#dpDateFr").val() == null || $("#dpDateFr").val().length == 0) && !($("#dpDateTo").val() == null || $("#dpDateTo").val().length == 0)){
    	whereSQL += " AND som.SALES_DT BETWEEN TO_DATE('"+$("#dpDateFr").val()+"', 'dd/MM/YY') AND TO_DATE('"+$("#dpDateTo").val()+"', 'dd/MM/YY') ";
    }
    
    if(!($("#txtOrderNumberFrom").val() == null || $("#txtOrderNumberFrom").val().length == 0) && !($("#txtOrderNumberTo").val() == null || $("#txtOrderNumberTo").val().length == 0)){
    	whereSQL += " AND som.SALES_ORD_NO BETWEEN '"+$("#txtOrderNumberFrom").val()+"' AND '"+$("#txtOrderNumberTo").val()+"' ";
    }
    
    if($("#cmbRegion :selected").index() > 0){
    	whereSQL += " AND b.REGN_ID = '"+$("#cmbRegion :selected").val()+"' ";
    }
    
    if($("#cmbbranch :selected").index() > 0){
        whereSQL += " AND b.BRNCH_ID = '"+$("#cmbbranch :selected").val()+"' ";
    }
    
    if(!($("#txtGrpCode").val() == null || $("#txtGrpCode").val().length == 0)){
    	whereSQL += " AND som.GRP_CODE = '"+$("#txtGrpCode").val()+"' ";
    }
    
    if($("#cmbprogress :selected").index() > 0){
    	whereSQL += " AND ccp.CCP_STUS_ID = '"+$("#cmbprogress :selected").val()+"' ";
    }
    
    if(!($("#txtPointFrom").val() == null || $("#txtPointFrom").val().length == 0) && !($("#txtPointTo").val() == null || $("#txtPointTo").val().length == 0)){
    	whereSQL += " AND ccp.fCcpTotalPoint BETWEEN '"+$("#txtOrderNumberFrom").val()+"' AND '"+$("#txtOrderNumberTo").val()+"' ";
    }
    
    if($("#cmbHold :selected").index() > 0){
    	if($("#cmbHold :selected").val() == "Yes"){
    		whereSQL += " AND ccp.CCP_IS_HOLD = 1 ";
    	}else{
    		whereSQL += " AND ccp.CCP_IS_HOLD = 0 ";
    	}
    }
    
    if($("#cmbCCPFeedbackCode :selected").length > 0){
    	whereSQL += " AND (";
    	$('#cmbCCPFeedbackCode :selected').each(function(i, mul){ 
    		if(runNo > 0){
    			actTaken = ", "+$(mul).text().trim();
    			whereSQL += " OR ccp.CCP_RESN_ID = '"+$(mul).val()+"' ";
    		}else{
    			actTaken = $(mul).text().trim();
                whereSQL += " ccp.CCP_RESN_ID = '"+$(mul).val()+"' ";
    		}
    		
    		runNo += 1;
    	});
    	whereSQL += ") ";
    }
    
    if($("#cmbCCPFeedbackCode :selected").index() > 0){
    	actTaken = $("#cmbCCPFeedbackCode :selected").text().trim();
    	whereSQL += " AND ccp.CCP_RESN_ID = '"+$("#cmbCCPFeedbackCode :selected").val()+"' ";
    }
    
    if($("#cmbRjtStatus :selected").index() > 0){
        whereSQL += " AND ccp.CCP_RJ_STUS_ID = '"+$("#cmbRjtStatus :selected").val()+"' ";
    }
    
    if(!($("#txtUpdator").val().trim() == null || $("#txtUpdator").val().trim().length == 0)){
    	whereSQL += " AND u.USER_NAME = '"+$("#txtUpdator").val().trim()+"' ";
    }
    
    if($("#cmbCustType :selected").index() > 0){
        whereSQL += " AND c.TYPE_ID = '"+$("#cmbCustType :selected").val()+"' ";
    }
    
    if($("#cmbDSCBranch :selected").index() > 0){
        whereSQL += " AND i.BRNCH_ID = '"+$("#cmbDSCBranch :selected").val()+"' ";
    }
    
    if($("#cmbProduct :selected").index() > 0){
        whereSQL += " AND sod.ITM_STK_ID = '"+$("#cmbProduct :selected").val()+"' ";
    }
    
    if(!($("#dpTimeHour").val() == null || $("#dpTimeHour").val().length == 0)){
    	var ampm = $("#dpTimeHour").val().substring(6, 8);
    	var hour = parseInt($("#dpTimeHour").val().substring(0, 2));
    	if(ampm == "PM"){
    		hour += 12;
    	}
    	
    	whereSQL += " AND SUBSTR(TO_CHAR(som.CRT_DT , 'yyyy-MM-DD HH24:MI:SS'), 12, 2) = '"+hour+"' ";
    }
    
    if($("#cmbSort :selected").index() > 0){
    	if($("#cmbSort :selected").val() == "1"){
    		orderBySQL += " ORDER BY b.CODE, som.SALES_ORD_NO";   
    	}else if($("#cmbSort :selected").val() == "2"){
    		orderBySQL += " ORDER BY b.CODE, som.SALES_ORD_NO";
        }else if($("#cmbSort :selected").val() == "3"){
        	orderBySQL += " ORDER BY som.SALES_DT, som.SALES_ORD_NO"; 
        }else if($("#cmbSort :selected").val() == "4"){
        	orderBySQL += " ORDER BY som.SALES_ORD_NO";  
        }else if($("#cmbSort :selected").val() == "5"){
            orderBySQL += " ORDER BY ccp.CCP_STUS_ID, som.SALES_ORD_NO";
        }else if($("#cmbSort :selected").val() == "6"){
        	orderBySQL += " ORDER BY ccp.CCP_ID, som.SALES_ORD_NO";
        }else if($("#cmbSort :selected").val() == "7"){
        	orderBySQL += " ORDER BY c.NAME, som.SALES_ORD_NO";
        }else if($("#cmbSort :selected").val() == "8"){
        	orderBySQL += " ORDER BY dsc.CODE, som.SALES_ORD_NO";
        }else if($("#cmbSort :selected").val() == "9"){
        	orderBySQL += " ORDER BY stk.STK_DESC, som.SALES_ORD_NO";
        }
    }
    
    
    orderNoFrom = ($("#txtOrderNumberFrom").val().trim() == null || $("#txtOrderNumberFrom").val().trim().length == 0) ? "" : $("#txtOrderNumberFrom").val().trim();
    orderNoTo = ($("#txtOrderNumberFrom").val().trim() == null || $("#txtOrderNumberTo").val().trim().length == 0) ? "" : $("#txtOrderNumberTo").val().trim(); 
   
    var frArr = $("#dpDateFr").val().split("/");
    var dpDateFr = frArr[1]+"/"+frArr[0]+"/"+frArr[2]; // MM/dd/yyyy
    orderDateFrom = (dpDateFr == null || dpDateFr.length == 0) ? "" : dpDateFr;
    var toArr = $("#dpDateTo").val().split("/");
    var dpDateTo = toArr[1]+"/"+toArr[0]+"/"+toArr[2]; // MM/dd/yyyy
    orderDateTo = (dpDateTo == null || dpDateTo.length == 0) ? "" : dpDateTo;
    
    branchRegion = ($("#cmbRegion :selected").index() > 0) ? $("#cmbRegion :selected").text().trim() : "";
    keyInBranch = ($("#cmbbranch :selected").index() > 0) ? $("#cmbbranch :selected").text().trim() : "";
    groupCode = ($("#txtGrpCode").val().trim() == null || $("#txtGrpCode").val().trim().length == 0) ? "" : $("#txtGrpCode").val().trim();
    ccpProgStatus = ($("#cmbprogress :selected").index() > 0) ? $("#cmbprogress :selected").text().trim() : "";
    ccpPointFrom = ($("#txtPointFrom").val().trim() == null || $("#txtPointFrom").val().trim().length == 0) ? "" : $("#txtPointFrom").val().trim();
    ccpPointTo = ($("#txtPointTo").val().trim() == null || $("#txtPointTo").val().trim().length == 0) ? "" : $("#txtPointTo").val().trim();
    rejStatus = ($("#cmbRjtStatus :selected").index() > 0) ? $("#cmbRjtStatus :selected").text().trim() : "";
   
    if($("#cmbSort :selected").index() > 0){
        if($("#cmbSort :selected").val() == "1"){
        	sortBy = "Region";
        }else if($("#cmbSort :selected").val() == "2"){
        	sortBy = "Branch";
        }else if($("#cmbSort :selected").val() == "3"){
        	sortBy = "Order Date";
        }else if($("#cmbSort :selected").val() == "4"){
        	sortBy = "Order Number";
        }else if($("#cmbSort :selected").val() == "5"){
        	sortBy = "CCP Progress Status";
        }else if($("#cmbSort :selected").val() == "6"){
        	sortBy = "Username";
        }else if($("#cmbSort :selected").val() == "7"){
        	sortBy = "Customer Name";
        }else if($("#cmbSort :selected").val() == "8"){
        	sortBy = "DSC Branch Code";
        }else if($("#cmbSort :selected").val() == "9"){
        	sortBy = "Product";
        }else{
        	sortBy = "";
        }
    }	
    	
    
    $("#reportDownFileName").val("CCPListing_PDF_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    if(viewType == "PDF"){
        $("#viewType").val("PDF");
        $("#reportFileName").val("/sales/CCPListing_New.rpt");
    }else if(viewType == "EXCEL"){
        $("#viewType").val("EXCEL");
        $("#reportFileName").val("/sales/CCPListing_Excel.rpt");
    }
    
    $("#V_ORDERNOFROM").val(orderNoFrom);
    $("#V_ORDERNOTO").val(orderNoTo);
    $("#V_ORDERDATEFROM").val(orderDateFrom);
    $("#V_ORDERDATETO").val(orderDateTo);
    $("#V_BRANCHREGION").val(branchRegion);
    $("#V_KEYINBRANCH").val(keyInBranch);
    $("#V_GROUPCODE").val(groupCode);
    $("#V_CCPPROGSTATUS").val(ccpProgStatus);
    $("#V_CCPPOINTFROM").val(ccpPointFrom);
    $("#V_CCPPOINTTO").val(ccpPointTo);
    $("#V_ACTTAKEN").val(actTaken);
    $("#V_REJSTATUS").val(rejStatus);
    $("#V_SORTBY").val(sortBy);
    $("#V_SELECTSQL").val("");
    $("#V_WHERESQL").val(whereSQL);
    $("#V_EXTRAWHERESQL").val("");
    $("#V_ORDERBYSQL").val(orderBySQL);
    $("#V_FULLSQL").val("");
    
   
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
    
    Common.report("form", option);
	
}


CommonCombo.make('cmbbranch', '/sales/ccp/getBranchCodeList', '' , '');
CommonCombo.make('cmbDSCBranch', '/sales/ccp/selectDscCodeList', '', '');
CommonCombo.make('cmbRegion', '/sales/ccp/getRegionCodeList', {codeId : 49} , '', '');
doGetProductCombo('/common/selectProductCodeList.do', '', '', 'cmbProduct', 'S'); //Product Code
CommonCombo.make('cmbCCPFeedbackCode', '/sales/ccp/selectReasonCodeFbList', '' , '', {type: 'M'});

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CCP Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="Order No (From)" class="w100p" id="txtOrderNumberFrom"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="Order No (To)" class="w100p" id="txtOrderNumberTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Order Date</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateFr"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Region</th>
    <td>
    <select class="" id="cmbRegion"></select>
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <select class="" id="cmbbranch"></select>
    </td>
</tr>
<tr>
    <th scope="row">Group Code</th>
    <td><input type="text" title="" placeholder="Group Code" class="" id="txtGrpCode"/></td>
</tr>
<tr>
    <th scope="row">CCP Status</th>
    <td>
    <select class="" id="cmbprogress">
        <option data-placeholder="true" hidden>CCP Progress</option>
        <option value="1">ACT - Active (Including Pending)</option>
        <option value="5">APV - Approved</option>
        <option value="6">RJT - Rejected</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">CC Point</th>
    <td>
    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="" placeholder="CCP Ponit (From)" class="w100p" id="txtPointFrom"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="CCP Ponit (To)" class="w100p" id="txtPointTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">On Hold Case</th>
    <td>
    <select class="" id="cmbHold">
        <option data-placeholder="true" hidden>CCP On-hold Case</option>
        <option value="Yes">Yes</option>
        <option value="No">No</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Reject Status</th>
    <td>
    <select class="" id="cmbRjtStatus">
        <option data-placeholder="true" hidden>Reject Status</option>
        <option value="18">CANF - Cancel Fund Transfer</option>
        <option value="10">CAN - Cancelled</option>
        <option value="13">CA1Y - Convert To Advance 1 Year</option>
        <option value="17">CANR - Cancel Refund</option>
        <option value="Yes">CA2Y - Convert To Advance 2 Years</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td>
    <select class="" id="cmbCCPFeedbackCode"></select>
    </td>
</tr>
<tr>
    <th scope="row">Last Updator</th>
    <td><input type="text" title="" placeholder="Last Updator (Username)" class="" id="txtUpdator"/></td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
    <td>
    <select class="" id="cmbCustType">
        <option data-placeholder="true" hidden>Customer Type</option>
        <option value="965">Company</option>
        <option value="964">Individual</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td>
    <select class="" id="cmbDSCBranch"></select>
    </td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>
    <select class="" id="cmbProduct"></select>
    </td>
</tr>
<tr>
    <th scope="row">Key in Hour</th>
    <td>
    <div class="time_picker" ><!-- time_picker start -->
    <input type="text" title="" placeholder="Key in Hour(hh:mm:tt)" class="time_date" id="dpTimeHour"/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->
    </td>
</tr>
<tr>
    <th scope="row">Sorting</th>
    <td>
    <select class="" id="cmbSort">
        <option data-placeholder="true" hidden>Sorting By</option>
        <option value="1">Sorting By Region</option>
        <option value="2">Sorting By Branch</option>
        <option value="3">Sorting By Order Date</option>
        <option value="4">Sorting By Order Number</option>
        <option value="5">Sorting By CCP Progress Status</option>
        <option value="6">Sorting By Username</option>
        <option value="7">Sorting By Customer Name</option>
        <option value="8">Sorting By DSC Branch</option>
        <option value="9">Sorting By Product</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenerate_Click()">Generate PDF</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript: btnGenExcel_Click()">Generate Excel</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#form').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_ORDERNOTO" name="V_ORDERNOTO" value="" />
<input type="hidden" id="V_ORDERDATEFROM" name="V_ORDERDATEFROM" value="" />
<input type="hidden" id="V_ORDERDATETO" name="V_ORDERDATETO" value="" />
<input type="hidden" id="V_BRANCHREGION" name="V_BRANCHREGION" value="" />
<input type="hidden" id="V_KEYINBRANCH" name="V_KEYINBRANCH" value="" />
<input type="hidden" id="V_GROUPCODE" name="V_GROUPCODE" value="" />
<input type="hidden" id="V_CCPPROGSTATUS" name="V_CCPPROGSTATUS" value="" />
<input type="hidden" id="V_CCPPOINTFROM" name="V_CCPPOINTFROM" value="" />
<input type="hidden" id="V_CCPPOINTTO" name="V_CCPPOINTTO" value="" />
<input type="hidden" id="V_REJSTATUS" name="V_REJSTATUS" value="" />
<input type="hidden" id="V_ACTTAKEN" name="V_ACTTAKEN" value="" />
<input type="hidden" id="V_SORTBY" name="V_SORTBY" value="" />
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
<input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
<input type="hidden" id="V_ORDERNOFROM" name="V_ORDERNOFROM" value="" />
<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />


</form>

</section><!-- content end -->
     
</section><!-- container end -->

</div><!-- popup_wrap end -->