<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_order;
var complianceList;
$(document).ready(function(){
	fn_registerOrderGrid();
	   doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1388, inputId : 1, separator : '-'}, '', 'comfup', 'S'); //Reason Code
	   doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1389, inputId : 1, separator : '-'}, '', 'caseCategory', 'S'); //Reason Code
	   doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1391, inputId : 1, separator : '-'}, '', 'finalAction', 'S'); //Reason Code
	   doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1390, inputId : 1, separator : '-'}, '', 'docType', 'S'); //Reason Code
	   
	   AUIGrid.bind(myGridID_order, "removeRow", auiRemoveRowHandler);
	   
	   $("#hideContent").hide();
	   
	   
	   $("#caseCategory").change(function(){
	       if($("#caseCategory").val() == '2144' ){
	    	   $("select[name=docType]").removeAttr("disabled");
	    	   $("select[name=docType]").removeClass("w100p disabled");
	    	   $("select[name=docType]").addClass("w100p");
	        }else{
	        	 $("#docType").val("");
	        	 $("select[name=docType]").attr('disabled', 'disabled');
	             $("select[name=docType]").addClass("disabled");
	             //$("select[name=docType]").addClass("w100p");
	        }   
		   
	   });
	  
	   
});

function fn_searchMember(){
	Common.popupDiv("/common/memberPop.do", null, null , true , '');
}

function fn_loadOrderSalesman(memId, memCode) {
	
	$("#memberCode").val(memCode);
	$("#memberId").val(memId);
    console.log(' memId:'+memId);
    console.log(' memCd:'+memCode);
    $("#tabDetail").show();
    $(".btnHid").hide();
    $("#reselectBtn").show();
    
    if(memCode.substring())
    fn_searchMemberDetail(memId);
}

function fn_searchMemberDetail(memCode){
	Common.ajax("GET", "/organization/compliance/getMemberDetail.do", {memberCode : memCode}, function(result) {
        console.log("성공.");
        
        if(result.memType == "1" || result.memType == "2" ||  result.memType == "3"){
            
            $("#ord1").html(result.orgCode+" (Organization Code)");
            $("#ord2").html(result.grpCode + " (Group Code)" );
            $("#ord3").html(result.deptCode + " (Department Code)");
            $("#code").html(result.memCode);
            $("#name").html(result.name);
            $("#nric").html(result.nric);
            $("#mbNo").html(result.telMobile);
            $("#offNo").html(result.telOffice);
            $("#houNo").html(result.telHuse);
            $("#memberId").val(result.memId);
            $("input[name=memberCode]").attr('disabled', 'disabled');
        }else{
        	Common.alert("Only HP, Cody and CT can add to compliance call log");
        }
    });
}

function auiRemoveRowHandler(){}
function fn_registerOrderGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "salesOrdNo",
        headerText : "OrderNo",
        editable : false,
        width : 130
    }, {
        dataField : "c1",
        headerText : "OrderDate",
        editable : false,
        width : 130
    }, {
        dataField : "codeName",
        headerText : "App Type",
        editable : false,
        width : 130
    }, {
        dataField : "stkDesc",
        headerText : "Product",
        editable : false,
        width : 130
    }, {
        dataField : "name",
        headerText : "Status",
        editable : false,
        style : "my-column",
        width : 130
    }, {
        dataField : "name1",
        headerText : "CustomerName",
        editable : false,
        width : 130
    }, {
        dataField : "salesOrdId",
        headerText : "a",
        editable : false,
        width : 0
    }, {
        dataField : "nric",
        headerText : "NRIC/Company",
        editable : false,
        width : 130
    }, {
        dataField : "",
        headerText : "",
        width : 170,
        renderer : {
              type : "ButtonRenderer",
              labelText : "Remove",
              onclick : function(rowIndex, columnIndex, value, item) {
            	  removeRow(); 
                  }
        }  
    }, {
        dataField : "",
        headerText : "",
        width : 170,
        renderer : {
              type : "ButtonRenderer",
              labelText : "▶",
              onclick : function(rowIndex, columnIndex, value, item) {
                  
                  var salesOrdId = AUIGrid.getCellValue(myGridID_order, rowIndex, "salesOrdId");
                  Common.popupDiv("/organization/compliance/complianceOrderFullDetailPop.do?salesOrderId="+salesOrdId ,null, null , true , ''); 
                  }
        }      
 }];
     // 그리드 속성 설정
    var gridPros = {
        
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
             editable            : false,            
             fixedColumnCount    : 1,            
             showStateColumn     : false,             
             displayTreeOpen     : false,            
             selectionMode       : "singleRow",  //"multipleCells",            
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_order = AUIGrid.create("#grid_wrap_register", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false
    
};

function fn_newOrder(){
	var success = true;
	
	if($("#orderNo").val() == ""){
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order No' htmlEscape='false'/>");
		return false;
	}
	Common.ajax("GET", "/organization/compliance/getCheckOrderNo.do", {orderNo : $("#orderNo").val()}, function(result) {
        console.log("성공.");
	 
        if(result != null){
        	success = false;
        	Common.alert("<spring:message code='sys.common.alert.validation' arguments='' htmlEscape='false'/>");
        }
	});
       if(success){
    	   Common.ajax("GET", "/organization/compliance/getComplianceOrderDetail.do", {orderNo : $("#orderNo").val()}, function(result) {
              
               AUIGrid.setGridData(myGridID_order, result);
           });
       }
}

function fn_validation(){
	var msg = "";
	if($("#action").val() == ''){
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Action' htmlEscape='false'/>");
        return false;
	}
	if($("#recevCaseDt").val() == ''){
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='received date' htmlEscape='false'/>");
        return false;
    }
	if($("#caseCategory").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='case category' htmlEscape='false'/>");
        return false;
    }
	if($("#caseCategory").val() == '2144' && $("#docType").val() == '' ){
        msg += " - Plaese select a type of document. <br />"
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='type of document' htmlEscape='false'/>");
        return false;
    }
	if($("#complianceRem").val() == '' ){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Compliance remark' htmlEscape='false'/>");
        return false;
    }
	
	if($("#hidFileName").val() == '' ){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='attachment' htmlEscape='false'/>");
        return false;
    }
	
	
	return true;
}

function fn_save(){
	if(fn_validation()){
		 var jsonObj =  GridCommon.getGridData(myGridID_order);
         jsonObj.form = $("#saveForm").serializeJSON();
		Common.ajax("POST", "/organization/compliance/saveCompliance.do", jsonObj, function(result) {
	        console.log("성공.");
	        Common.alert("Compliance call Log saved.<br /> Case No : "+result.data+"<br />");
	    });	
	}
}

function fn_resize(){
	AUIGrid.resize(myGridID_order,1000,300);
}

function removeRow(){
    AUIGrid.removeRow(myGridID_order, "selectedIndex");
    AUIGrid.removeSoftRows(myGridID_order);
}

function fn_uploadfile(){
	Common.popupDiv("/organization/compliance/uploadAttachPop.do"  , null, null , true , 'fileUploadPop');
}

function fn_reselect(){
	$(".btnHid").show();
	$("#reselectBtn").hide();
	$("#memberCode").val('');
	$("#tabDetail").hide();
	$("input[name=memberCode]").removeAttr("disabled");
}
function fn_clear(){
	$("#action").val("");
	$("#caseCategory").val("");
	$("#complianceRem").val("");
	$("#recevCaseDt").val("");
}
function fn_confirm(){
	if($("#memberCode").val() == ""){
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='Member Code' htmlEscape='false'/>");
		return false;
	}else{
		$("#tabDetail").show();
	    $(".btnHid").hide();
	    $("#reselectBtn").show();
	    $("input[name=memberCode]").attr('disabled', 'disabled');
		var paramMemCode = $("#memberCode").val();
		fn_searchMemberDetail(paramMemCode);
	}
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Compliance Call Log</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->


<aside class="title_line"><!-- title_line start -->
<h3>Select Member Code for New Compliance Case</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Code</th>
    <td>
    
    <input type="text" title="" placeholder="" class="" id="memberCode" name="memberCode" />
    <p class="btn_sky"><a href="#" class="btnHid" onclick="javascript:fn_confirm()">Confirm</a></p>
    <p class="btn_sky"><a href="#" onclick="javascript:fn_searchMember()" class="btnHid">Search</a></p>
    <p class="btn_sky"><a href="#" onclick="javascript:fn_reselect()" style="display:none" id="reselectBtn">Reselect</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->


<section class="tap_wrap"  style="display:none" id="tabDetail"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Member View</a></li>
    <li><a href="#" onclick=" javascirpt:AUIGrid.resize(myGridID_order, 950,300);">Register Order</a></li>
    <li><a href="#">Compliance Register</a></li>
    <li><a href="#" id="hideContent">Compliance Remark</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Salesman Info</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="3">Order Made By</th>
    <td>
    <span id="ord1"></span>
    </td>
</tr>
<tr>
    <td>
    <span id="ord2"></span>
    </td>
</tr>
<tr>
    <td>
    <span id="ord3"></span>
    </td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td>
    <span id="code"></span>
    </td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td>
    <span id="name"></span>
    </td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td>
    <span id="nric"></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td>
    <span id="mbNo"></span>
    </td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td>
    <span id="offNo"></span>
    </td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td>
    <span id="houNo"></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</div><!-- border_box end -->

</div>

<div style="width:50%;">

<!-- <div class="border_box">border_box start

</div>border_box end
 -->
</div>

</div><!-- divine_auto end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">New Order No</th>
    <td>
    <input type="text" title="" placeholder="" class="" id="orderNo" name="orderNo"/>
    <p class="btn_sky"><a href="#" onclick="javascript:fn_newOrder()">Confirm New Order</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_register" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<form action="#" method="post" id="saveForm">
<input type="hidden" title="" placeholder="" class="" id="memberId" name="memberId"/>
<input type="hidden" title="" placeholder="" class="" id="hidFileName" name="hidFileName"/>
<input type="hidden" title="" placeholder="" class="" id="groupId" name="groupId"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Case Status</th>
    <td colspan="3">
    <select class="w100p disabled" disabled="disabled" id="caseStatus" name="caseStatus">
        <option value="1">Active</option>
        <option value="60">In Progress</option>
        <option value="36">Closed</option>
        <option value="10">Cancel</option>
    </select>
    </td>
    <th scope="row">Case Category</th>
    <td>
    <select class="w100p" id="caseCategory" name="caseCategory">
    </select>
    </td>
    <th scope="row">Type of Document</th>
    <td>
    <select class="w100p disabled" disabled="disabled" id="docType" name="docType">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Action</th>
    <td colspan="3">
    <select class="" id="action" name="action">
        <option value="">Action</option>
        <option value="56">Call In</option>
        <option value="57">Call Out</option>
        <option value="58">Internal Feedback</option>
    </select>
    </td>
    <th scope="row">Finding</th>
    <td colspan="3">
    <label><input type="radio" name="finding" /><span>Genuine</span></label>
    <label><input type="radio" name="finding" /><span>Non Genuine </span></label>
    </td>
</tr>
<tr>
    <th scope="row">Compliance F/Up</th>
    <td colspan="3">
    <select class="w100p disabled" disabled="disabled" id="comfup" name="comfup">
    </select>
    </td>
    <th scope="row">Collection Amount</th>
    <td colspan="3">
    <input type="text" title="" placeholder="" class="readonly" readonly="readonly" id="collAmount" name="collAmount"/>
    </td>
</tr>
<tr>
    <th scope="row">Case Received Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="recevCaseDt" name="recevCaseDt" />
    </td>
    <th scope="row">Case Closed Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date disabled"  disabled="disabled" id="recevCloDt" name="recevCloDt"/>
    </td>
    <th scope="row">Final Action</th>
    <td colspan="3">
    <select class="disabled" disabled="disabled"  id="finalAction" name="finalAction">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Person In Charge</th>
    <td colspan="3">
    <select class="w100p"  id="changePerson" name="changePerson">
        <option value="18522">NICKY</option>
        <option value="32807">EUGENE</option>
        <option value="34026">OOI BENG EAN</option>
        <option value="56056">WONG WENG KIT</option>
        <option value="57202">KATE</option>
        <option value="59697">PAVITRA</option>
    </select>
    </td>
    <th scope="row"></th>
    <td colspan="3">
    </td>
</tr>
<tr>
    <th scope="row">Compliance Remark</th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="" id="complianceRem" name="complianceRem"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_save()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_clear()">Clear</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_uploadfile()">Upload Attachment</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
tap4
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
