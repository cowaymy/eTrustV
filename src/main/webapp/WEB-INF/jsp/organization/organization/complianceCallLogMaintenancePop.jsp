<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID_order;
var myGridID_remark;
var complianceList;
$(document).ready(function(){
	$("#hiddenBtn").hide();
    fn_registerOrderGrid();
    fn_orderDetailCompliance();
    fn_complianceRemarkGrid()
    fn_complianceRemark();
    
       doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1388, inputId : 1, separator : '-'}, '', 'comfup', 'S'); //Reason Code
       doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1389, inputId : 1, separator : '-'}, '', 'caseCategory', 'S'); //Reason Code
       doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1391, inputId : 1, separator : '-'}, '', 'finalAction', 'S'); //Reason Code
       doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1390, inputId : 1, separator : '-'}, '', 'docType', 'S'); //Reason Code
       
       AUIGrid.bind(myGridID_order, "removeRow", auiRemoveRowHandler);
       
       
       AUIGrid.bind(myGridID_order, "cellClick", function(event) {
    	   orderNo =  AUIGrid.getCellValue(myGridID_order, event.rowIndex, "salesOrdNo");
       });
       
       
       $("#cmbCaseStatus").change(function(){ 
    	   //class="disabled" disabled="disabled"
    	   if($("#cmbCaseStatus").val() == '36' ){
    		   
    		   $("#comfup").val("");
    		   
    		   $("select[name=action]").removeAttr("disabled");
               $("select[name=action]").removeClass("w100p disabled");
               $("select[name=action]").addClass("w100p");
               
               $("select[name=comfup]").attr('disabled', 'disabled');
               $("select[name=comfup]").addClass("disabled");
               
               $("select[name=caseCategory]").attr('disabled', 'disabled');
               $("select[name=caseCategory]").addClass("disabled");
               
               $("select[name=docType]").attr('disabled', 'disabled');
               $("select[name=docType]").addClass("disabled");
               
               $("input[name=recevCaseDt]").attr('disabled', 'disabled');
               $("input[name=recevCaseDt]").addClass("disabled");
               
               $("input[name=recevCloDt]").removeAttr("disabled");
               $("input[name=recevCloDt]").removeClass("j_date disabled");
               $("input[name=recevCloDt]").addClass("j_date");
               
               $("select[name=finding]").removeAttr("disabled");
               $("select[name=finding]").removeClass("w100p disabled");
               $("select[name=finding]").addClass("w100p");
               
               $("input[name=collAmount]").removeAttr("readonly");
               $("input[name=collAmount]").removeClass("readonly");
               $("input[name=collAmount]").addClass("w100p");
               
               $("select[name=finalAction]").removeAttr("disabled");
               $("select[name=finalAction]").removeClass("w100p disabled");
               $("select[name=finalAction]").addClass("w100p");
               
               
    	   }
    	   
    	   if($("#cmbCaseStatus").val() == '10' ){
               $("#comfup").val("");
               
               $("select[name=comfup]").attr('disabled', 'disabled');
               $("select[name=comfup]").addClass("disabled");
               
               $("select[name=action]").attr('disabled', 'disabled');
               $("select[name=action]").addClass("disabled");
               
               $("input[name=recevCaseDt]").attr('disabled', 'disabled');
               $("input[name=recevCaseDt]").addClass("disabled");
               
               $("input[name=recevCloDt]").attr('disabled', 'disabled');
               $("input[name=recevCloDt]").addClass("disabled");
               
               $("select[name=caseCategory]").attr('disabled', 'disabled');
               $("select[name=caseCategory]").addClass("disabled");
               
               $("select[name=docType]").attr('disabled', 'disabled');
               $("select[name=docType]").addClass("disabled");
               
               $("select[name=finding]").attr('disabled', 'disabled');
               $("select[name=finding]").addClass("disabled");
               
               $("input[name=collAmount]").attr('disabled', 'disabled');
               $("input[name=collAmount]").addClass("disabled");
               
               $("select[name=finalAction]").attr('disabled', 'disabled');
               $("select[name=finalAction]").addClass("disabled");

           }
    	   
    	   if($("#cmbCaseStatus").val() == '60' ){
               $("#comfup").val("");
               
               $("select[name=comfup]").removeAttr("disabled");
               $("select[name=comfup]").removeClass("w100p disabled");
               $("select[name=comfup]").addClass("w100p");
               
               $("select[name=action]").removeAttr("disabled");
               $("select[name=action]").removeClass("w100p disabled");
               $("select[name=action]").addClass("w100p");

               $("input[name=recevCaseDt]").attr('disabled', 'disabled');
               $("input[name=recevCaseDt]").addClass("disabled");
               
               $("input[name=recevCloDt]").attr('disabled', 'disabled');
               $("input[name=recevCloDt]").addClass("disabled");
               
               $("select[name=caseCategory]").attr('disabled', 'disabled');
               $("select[name=caseCategory]").addClass("disabled");
               
               $("select[name=docType]").attr('disabled', 'disabled');
               $("select[name=docType]").addClass("disabled");
               
               $("select[name=finding]").attr('disabled', 'disabled');
               $("select[name=finding]").addClass("disabled");
               
               $("input[name=collAmount]").attr('disabled', 'disabled');
               $("input[name=collAmount]").addClass("disabled");
               
               $("select[name=finalAction]").attr('disabled', 'disabled');
               $("select[name=finalAction]").addClass("disabled");

           } 
    	   
    	   if($("#cmbCaseStatus").val() == '87' ){
    		   $("#hiddenBtn").show();
               $("#comfup").val("");
               
               $("select[name=comfup]").attr('disabled', 'disabled');
               $("select[name=comfup]").addClass("disabled");
               
               $("select[name=action]").attr('disabled', 'disabled');
               $("select[name=action]").addClass("disabled");
               
               $("input[name=recevCaseDt]").attr('disabled', 'disabled');
               $("input[name=recevCaseDt]").addClass("disabled");
               
               $("input[name=recevCloDt]").attr('disabled', 'disabled');
               $("input[name=recevCloDt]").addClass("disabled");
               
               $("select[name=caseCategory]").attr('disabled', 'disabled');
               $("select[name=caseCategory]").addClass("disabled");
               
               $("select[name=docType]").attr('disabled', 'disabled');
               $("select[name=docType]").addClass("disabled");
               
               $("select[name=finding]").attr('disabled', 'disabled');
               $("select[name=finding]").addClass("disabled");
               
               $("input[name=collAmount]").attr('disabled', 'disabled');
               $("input[name=collAmount]").addClass("disabled");
               
               $("select[name=finalAction]").attr('disabled', 'disabled');
               $("select[name=finalAction]").addClass("disabled");

           }  
       });
       
       /* $("#caseCategory").change(function(){
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
       }); */
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
    fn_searchMemberDetail(memCode);
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
        dataField : "cmplncId",
        headerText : "",
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
            	  
            	  orderNo =  AUIGrid.getCellValue(myGridID_order, rowIndex , "salesOrdId");
            	    
            	    AUIGrid.removeRow(myGridID_order, "selectedIndex");
            	    AUIGrid.removeSoftRows(myGridID_order);

            	    Common.ajax("GET", "/organization/compliance/deleteOrderDetail.do",{orderNo : orderNo, complianceId :  "${complianceValue.cmplncId }"} , function(result) {
            	        console.log("성공.");
            	        if(result.data){
            	            fn_orderDetailCompliance();
            	            AUIGrid.resize(myGridID_order, 950,300);
            	        }else{
            	            Common.alert("Fail to remove this order, please try agian");
            	        }
            	        
            	    });
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


function fn_complianceRemarkGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "name",
        headerText : "Case Status",
        editable : false,
        width : 80
    }, {
        dataField : "resnDesc",
        headerText : "Compliance F/Up",
        editable : false,
        width : 130
    }, {
        dataField : "name1",
        headerText : "Action",
        editable : false,
        width : 130
    }, {
        dataField : "cmplncColctAmt",
        headerText : "Amount",
        editable : false,
        width : 100
    }, {
        dataField : "cmplncRem",
        headerText : "Remark",
        editable : false,
        style : "my-column",
        width : 200
    }, {
        dataField : "userName",
        headerText : "Creator",
        editable : false,
        width : 130
    }, {
        dataField : "c1",
        headerText : "Create Date",
        editable : false,
        width : 130
 }];
     // 그리드 속성 설정
    var gridPros = {
        
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
             editable            : false,            
                     
             showStateColumn     : false,             
             displayTreeOpen     : false,            
             selectionMode       : "singleRow",  //"multipleCells",            
             headerHeight        : 30,       
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력  
          // 워드랩 적용 
             wordWrap : true


    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_remark = AUIGrid.create("#grid_wrap_remark", columnLayout, gridPros);
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

function fn_orderDetailCompliance(){
	 Common.ajax("GET", "/organization/compliance/orderDetailComplianceId.do", {complianceId : "${complianceValue.cmplncId }"}, function(result) {
         console.log("성공.");
         AUIGrid.setGridData(myGridID_order, result);
         
     }); 
}
function fn_complianceRemark(){
    Common.ajax("GET", "/organization/compliance/complianceRemark.do", {complianceId : "${complianceValue.cmplncId }"}, function(result) {
        console.log("성공.");
        AUIGrid.setGridData(myGridID_remark, result);
        
    }); 
}


function fn_validation(){
	if($("#cmbCaseStatus").val() == '60' ||$("#cmbCaseStatus").val() == '36'  ){
		if($("#action").val() == ''){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='action' htmlEscape='false'/>");
	        return false;
		}
	}
	if($("#cmbCaseStatus").val() == "60"){
		if($("#comfup").val() == ""){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='compliance follow up' htmlEscape='false'/>");
            return false;
        }
	}
	if($("#cmbCaseStatus").val() == "36"){
		if($("#collAmount").val() == ""){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='collection amount' htmlEscape='false'/>");
            return false;
        }
		if($("#finalAction").val() == ""){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='final action' htmlEscape='false'/>");
            return false;
        }
		if($("#recevCloDt").val() == ""){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='closed date' htmlEscape='false'/>");
            return false;
        }
	}
	if($("#cmbCaseStatus").val() == "87"){
		if($("#hidFileName").val() == ""){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='attachment' htmlEscape='false'/>");
            return false;
        }
	}
	
	if($("#changePerson").val() == ""){
		Common.alert("<spring:message code='sys.common.alert.validation' arguments='person in charge' htmlEscape='false'/>");
        return false;
	}
	if($("#complianceRem").val() == ""){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Compliance remark' htmlEscape='false'/>");
        return false;
    }
    return true;
}

function fn_save(){
    if(fn_validation()){
        Common.ajax("POST", "/organization/compliance/saveMaintenceCompliance.do",$("#saveForm").serializeJSON() , function(result) {
            console.log("성공.");
            if(result.data){
                Common.alert("Compliance call Log saved.<br />");
            }else{
            	Common.alert("Compliance call Log saved Fail.<br />");
            }
        }); 
    }
}

function fn_resize(){
    AUIGrid.resize(myGridID_order,1000,300);
}

function removeRow(){
	
	
}

function fn_uploadfile(){
    Common.popupDiv("/organization/compliance/uploadAttachPop.do"  , null, null , true , 'fileUploadPop');
}


function fn_clear(){
    $("#action").val("");
    $("#caseCategory").val("");
    $("#complianceRem").val("");
    $("#recevCaseDt").val("");
}

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
           Common.ajaxSync("GET", "/organization/compliance/getComplianceOrderDetail.do", {orderNo : $("#orderNo").val()}, function(result) {
               AUIGrid.setGridData(myGridID_order, result);
           });
       }
       
       if(success){
    	   var jsonObj={};
    	   jsonObj.all =  AUIGrid.getGridData(myGridID_order);
           $("#cmplncOrdId").val("${complianceValue.cmplncId }");
           jsonObj.form =  $("#orderSearch").serializeArray(); ;
           Common.ajax("POST", "/organization/compliance/saveComplianceOrderDetail.do", jsonObj, function(result) {
               
           });
       }
       
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Compliance Call Log Maintenance</h1>
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
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Case No</th>
    <td>
    <input type="text" title="" placeholder="" class="" value="${complianceValue.cmplncNo }"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->


<section class="tap_wrap" id="tabDetail"><!-- tap_wrap start -->
<ul class="tap_type1">
    <!-- <li><a href="#" class="on">Member View</a></li> -->
    <li><a href="#" class="on" onclick=" javascirpt:AUIGrid.resize(myGridID_order, 950,300);">Register Order</a></li>
    <li><a href="#" >Compliance Register</a></li>
    <li><a href="#" onclick="javascirpt:AUIGrid.resize(myGridID_remark, 950,300);">Compliance Remark</a></li>
</ul>
<article class="tap_area"><!-- tap_area start -->
<form id = "orderSearch">
<input type="hidden" id="cmplncOrdId" name="complianceId"/>
</form>
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
<input type="hidden" title="" placeholder="" class="" id="hidComplianceId" name="complianceId" value="${complianceValue.cmplncId }"/>

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
    <select class="w100p" id="cmbCaseStatus" name="caseStatus">
        <option value="60">In Progress</option>
        <option value="87">Add New Attachment</option>
        <option value="36">Closed</option>
        <option value="10">Cancel</option>
    </select>
    </td>
    <th scope="row">Case Category</th>
    <td>
    <select class="w100p disabled" disabled="disabled"  id="caseCategory" name="caseCategory">
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
    <label><input type="radio" name="finding" value="1"/><span>Genuine</span></label>
    <label><input type="radio" name="finding" value="0"/><span>Non Genuine </span></label>
    </td>
</tr>
<tr>
    <th scope="row">Compliance F/Up</th>
    <td colspan="3">
    <select class="w100p"  id="comfup" name="comfup">
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
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date disabled"  disabled="disabled" id="recevCaseDt" name="recevCaseDt" />
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
    <li id="hiddenBtn"><p class="btn_blue2 big"><a href="#" onclick="">Upload Attachment</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<div id="grid_wrap_remark" style="width: 100%; height: 300px; margin: 0 auto;"></div>
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
