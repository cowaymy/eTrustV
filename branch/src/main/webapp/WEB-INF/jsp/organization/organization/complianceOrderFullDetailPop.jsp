<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var compliRemGridID;
$(document).ready(function(){
    doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1388, inputId : 1, separator : '-'}, '', 'cmbComfup', 'S'); //Reason Code
    
    fn_complianceRemarkGridPop();
});
function fn_complianceRemarkGridPop() {
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
    compliRemGridID = AUIGrid.create("#grid_wrap_compliRem", columnLayout, gridPros);
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
function fn_validation(){
	if($("#cmbAction").val() == ''){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Action' htmlEscape='false'/>");
        return false;
    }
	if($("#cmbComfup").val() == ""){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='compliance follow up' htmlEscape='false'/>");
        return false;
    }
	if($("#txtComplianceRem").val() == ""){
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Compliance remark' htmlEscape='false'/>");
        return false;
    }
	return true;
}
function fn_save(){
	if(fn_validation()){
		 Common.ajax("POST", "/organization/compliance/saveOrderMaintence.do", $("#saveOrdForm").serializeJSON(), function(result) {
	        console.log("성공.");
	        console.log("data : " + result);
	        if(result.data){
	        	Common.confirm("Do you want to sync this remark to related order?", fn_orderSave);
	        }else{
	        	 Common.alert("Saving data prepration failed");
	        }
	    }); 
	}
}

function fn_orderSave(){
	Common.ajax("POST", "/organization/compliance/saveOrderMaintenceSync.do", $("#saveOrdForm").serializeJSON(), function(result) {
		 if(result.data){
             Common.confirm("Data Sync Successful");
         }else{
              Common.alert("Sync data failed.");
         }
	});
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Full Detail</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<form id="frmLedger" name="frmLedger" action="#" method="post">
    <input id="ordId" name="ordId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
</form>
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
<section class="tap_wrap" id="tabDetail"><!-- tap_wrap start -->
<ul class="tap_type1">
    <!-- <li><a href="#" class="on">Member View</a></li> -->
    <li><a href="#" >Compliance Register</a></li>
    <li><a href="#" onclick="javascirpt:AUIGrid.resize(compliRemGridID, 950,300);">Compliance Remark</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<form action="#" method="post" id="saveOrdForm">
<input id="orderId" name="orderId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
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
    <th scope="row">Action</th>
    <td colspan="3">
    <select class="" id="cmbAction" name="action">
        <option value="">Action</option>
        <option value="56">Call In</option>
        <option value="57">Call Out</option>
        <option value="58">Internal Feedback</option>
    </select>
    </td>
     <th scope="row">Compliance F/Up</th>
    <td colspan="3">
    <select class="w100p"  id="cmbComfup" name="comfup">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Compliance Remark</th>
    <td colspan="7">
    <textarea cols="20" rows="5" placeholder="" id="txtComplianceRem" name="complianceRem"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_save()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_clear()">Clear</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<div id="grid_wrap_compliRem" style="width: 100%; height: 100px; margin: 0 auto;"></div>
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->