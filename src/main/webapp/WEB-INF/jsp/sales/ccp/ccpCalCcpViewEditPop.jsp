<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

var optionUnit = { isShowChoose: false};

$(document).ready(function() {
    var mst = getMstId();
    
    var ordUnitSelVal = $("#_ordUnitSelVal").val();
    var rosUnitSelVal = $("#_rosUnitSelVal").val();
    var susUnitSelVal = $("#_susUnitSelVal").val();
    var custUnitSelVal = $("#_custUnitSelVal").val();
    
    getUnitCombo(mst, 212  , ordUnitSelVal , '_ordUnit');
    getUnitCombo(mst, 213  , rosUnitSelVal , '_ordMth');
    getUnitCombo(mst, 216  , susUnitSelVal , '_ordSuspen');
    getUnitCombo(mst, 210  , custUnitSelVal , '_ordExistingCust');  
    
   
    CommonCombo.make("_statusEdit", "/sales/ccp/getCcpStusCodeList", '', '' , optionUnit); //Status
    
    doGetCombo('/sales/ccp/selectReasonCodeFbList', '', '','_reasonCodeEdit', 'S'); //Reason
    loadIncomeRange(); //Income Range ComboBox
    
    bind_RetrieveData();
    
    
});//Doc Ready Func End

function  bind_RetrieveData(){

	//Ccp Status
	var ccpStus = $("#_ccpStusId").val();
	$("#_statusEdit").val(ccpStus);
	
	//pre Value
	$("#_isPreVal").val("1");
	
	//bind and Setting by CcpStatus
	if(ccpStus == "1"){
		
		$("#_incomeRangeEdit").attr("disabled" , false);
		
		$("#_rejectStatusEdit").val('');
		$("#_rejectStatusEdit").attr("disabled" , "disabled");
		
		$("#_reasonCodeEdit").attr("disabled" , false);
		$("#_spcialRem").attr("disabled" , false);
		$("#_pncRem").attr("disabled" , false);
		$("#_onHoldCcp").attr("disabled" , false);
		$("#_summon").attr("disabled" , false);
		$("#_letterOfUdt").attr("disabled" , false);
		
		if(isAllowSendSMS() == true){
			
		}
		
		
		/* 
       ;
       

        this.chkIsHold.Enabled = true;
        this.chkIsSummons.Enabled = true;
        this.chkIsLOU.Enabled = true;

        if (this.IsAllowSendSMS())
        {
            PanelSMS.Visible = true;
            btnSendSMS.Checked = true;
            txtSMSMessage.Enabled = true;
            this.SetSMSMessage();
        }
		 */
		
	}
}

function isAllowSendSMS(){
	
	var isAllow = true;
	//var salesmanMemTypeID  = 0;
	
	
}

function loadIncomeRange(){
	
	var ccpId = $("#_editCcpId").val();
	var paramObj ={editCcpId : ccpId};
	//param : editCcpId
	 CommonCombo.make("_incomeRangeEdit", "/sales/ccp/getLoadIncomeRange", paramObj , '' , optionUnit); //Status
	 
	var rentPayModeId = $("#_rentPayModeId").val();
	var applicantTypeId = $("#_applicantTypeId").val();
	
	if(rentPayModeId == 131){
		
		if(applicantTypeId == 964){
			$("#_incomeRangeEdit").val("29");
		}else{
			$("#_incomeRangeEdit").val("22");
		}
		
	}
}


function getMstId(){
    
    var mstId = $("#_ccpMasterId").val();
    if(mstId == 0){
        mstId = 1;
    }else{
        mstId = 2;
    }
    
    return mstId;
}

function getUnitCombo(mst , ctgryVal, selVal ,comId){
    
    /* var unitJson = {ccpMasterId : mst ,  screCtgryTypeId : ctgryVal};
    var optionUnit = { isShowChoose: false};
    var selectVal = ''; 
    selectVal = selVal.trim();
    CommonCombo.make(comId, "/sales/ccp/getOrderUnitList", unitJson, selectVal , optionUnit);  */
    unitCombo("/sales/ccp/getOrderUnitList", mst, ctgryVal , selVal, comId, 'S');
    
}

function unitCombo(url, mst , ctgryVal , selCode, obj , type, callbackFn){

    $.ajax({
        type : "GET",
        url : getContextPath() + url,
        data : {ccpMasterId : mst ,  screCtgryTypeId : ctgryVal},
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
            var rData = data;
            doDefCombo(rData, selCode, obj , type,  callbackFn);
        },
        error: function(jqXHR, textStatus, errorThrown){
            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
        },
        complete: function(){
        }
    });
} ;

//그리드 속성 설정
var gridPros = {
    usePaging           : true,         //페이징 사용
    pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
    editable            : false,            
    fixedColumnCount    : 0,            
    showStateColumn     : true,             
    displayTreeOpen     : false,            
    selectionMode       : "singleRow",  //"multipleCells",            
    headerHeight        : 30,       
    useGroupingPanel    : false,        //그룹핑 패널 사용
    skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
    noDataMessage       : "No order found.",
    groupingMessage     : "Here groupping"
};
    
function chgTab(tabNm) {
    switch(tabNm) {
        case 'custInfo' :
            AUIGrid.resize(custInfoGridID, 942, 380);
            if(AUIGrid.getRowCount(custInfoGridID) <= 0) {
                fn_selectOrderSameRentalGroupOrderList();
            }
            break;
        case 'memInfo' :
            AUIGrid.resize(memInfoGridID, 942, 380);
            if(AUIGrid.getRowCount(memInfoGridID) <= 0) {
                fn_selectMembershipInfoList();
            }
            break;
        case 'docInfo' :
            AUIGrid.resize(docGridID, 942, 380);
            if(AUIGrid.getRowCount(docGridID) <= 0) {
                fn_selectDocumentList();
            }
            break;
        case 'callLogInfo' :
            AUIGrid.resize(callLogGridID, 942, 380);
            if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                fn_selectCallLogList();
            }
            break;
        case 'payInfo' :
            AUIGrid.resize(payGridID, 942, 380);
            if(AUIGrid.getRowCount(payGridID) <= 0) {
                fn_selectPaymentList();
            }
            break;
        case 'transInfo' :
            AUIGrid.resize(transGridID, 942, 380);
            if(AUIGrid.getRowCount(transGridID) <= 0) {
                fn_selectTransList();
            }
            break;
        case 'autoDebitInfo' :
            AUIGrid.resize(autoDebitGridID, 942, 380);
            if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                fn_selectAutoDebitList();
            }
            break;
        case 'discountInfo' :
            AUIGrid.resize(discountGridID, 942, 380);
            if(AUIGrid.getRowCount(discountGridID) <= 0) {
                fn_selectDiscountList();
            }
            break;
    };
}

</script>
<div id="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Order View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="_editForm">
    <input type="text" name="editCcpId" id="_editCcpId" value="${ccpId}"/>
    
    <!--  from Basic -->
    <input type="hidden"  name="editOrdId" value="${orderDetail.basicInfo.ordId}">
    <input type="hidden" name="editAppTypeCode" value="${orderDetail.basicInfo.appTypeCode }">
    <input type="hidden" name="editOrdStusId" value="${orderDetail.basicInfo.ordStusId}">
    
    <!-- from SalesMan (HP/CODY) -->
    <input type="hidden" name="editSalesMemTypeId" > <!-- 추후 검색 -->
    
    <!-- from GSTCertInfo -->
    <input type="hidden" name="editEurcFilePathName" value="${orderDetail.gstCertInfo.eurcFilePathName}">
    
    <!-- Cust Type Id  > Ccp Master Id -->
    <input type="hidden" name="ccpMasterId" value="${ccpMasterId}" id="_ccpMasterId">
    
    <!-- from FieldMap -->
    <input type="hidden" id="_ordUnitSelVal" value="${fieldMap.ordUnitSelVal}">
    <input type="hidden" id="_rosUnitSelVal" value="${fieldMap.rosUnitSelVal}">
    <input type="hidden" id="_susUnitSelVal" value="${fieldMap.susUnitSelVal}">
    <input type="hidden" id="_custUnitSelVal" value="${fieldMap.custUnitSelVal}">
    
     <!-- from IncomMap -->
     <input type="hidden" id="_rentPayModeId" name="rentPayModeId" value="${incomMap.rentPayModeId}">
     <input type="hidden" id="_applicantTypeId" name="applicantTypeId" value="${incomMap.applicantTypeId}">
     
     <!-- from ccpInfoMap  -->
     <input type="hidden" id="_ccpStusId" name="ccpStusId" value="${ccpInfoMap.ccpStusId}">
    
    <!-- previous -->
    <input type="hidden" id="_isPreVal" >
</form>
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num5">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Sales Person</a></li>
    <li><a href="#">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a href="#">Mailing Info</a></li>
    <c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#">Payment Channel</a></li>
    </c:if>
    <li><a href="#">Relief Certificate</a></li>
    <li><a href="#" onClick="javascript:chgTab('docInfo');">Document Submission</a></li>
    <li><a href="#" onClick="javascript:chgTab('payInfo');">Payment Listing</a></li>
</ul>
<!------------------------------------------------------------------------------
    Basic Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/basicInfo.jsp" %>
<!------------------------------------------------------------------------------
    Sales Person
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/hpCody.jsp" %>
<!------------------------------------------------------------------------------
    Customer Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/custInfoExceptGrid.jsp" %>
<!------------------------------------------------------------------------------
    Installation Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/installInfo.jsp" %>
<!------------------------------------------------------------------------------
    Mailling Info
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/mailInfo.jsp" %>
<!------------------------------------------------------------------------------
    Payment Channel
------------------------------------------------------------------------------->
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
<%@ include file="/WEB-INF/jsp/sales/order/include/payChannel.jsp" %>
</c:if>
<!------------------------------------------------------------------------------
    Relief Certificate
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/rliefCrtfcat.jsp" %>
<!------------------------------------------------------------------------------
    Document Submission
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/docSubmission.jsp" %>
<!------------------------------------------------------------------------------
    Payment Listing
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/include/payList.jsp" %>

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>CCP Score Point</h3>
<ul class="right_btns">
    <li><p class="btn_blue2"><a href="#">FICO Report</a></p></li>
    <li><p class="btn_blue2"><a href="#">CTOS Report</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:210px" />
    <col style="width:*" />
    <col style="width:80px" />
    <col style="width:*" />
    <col style="width:80px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order Unit</th>
    <td>
        <select class="w100p" name="ordUnit" id="_ordUnit"></select>
    </td>
    <th scope="row">Count</th>
    <td><span><b>${fieldMap.ordUnitCount }</b></span></td>
    <th scope="row">Point</th>
    <td><span><b>${fieldMap.orderUnitPoint}</b></span></td>
</tr>
<tr>
    <th scope="row">Avg ROS Mth</th>
    <td> <select class="w100p" name="ordMth" id="_ordMth"></select></td>
    <th scope="row">Count</th>
    <td><span><b>${fieldMap.rosCount}</b></span></td>
    <th scope="row">Point</th>
    <td><span><b>${fieldMap.rosUnitPoint}</b></span></td> 
</tr>
<tr>
    <th scope="row">Suspension/Termination</th> 
    <td> <select class="w100p" name="ordSuspen" id="_ordSuspen"></select></td>
    <th scope="row">Count</th>
    <td><span><b>${fieldMap.susUnitCount}</b></span></td>
    <th scope="row">Point</th>
    <td><span><b>${fieldMap.susUnitPoint}</b></span></td>
</tr>
<tr>
    <th scope="row">Existing Customer</th>
    <td><select class="w100p" name="ordExistingCust" id="_ordExistingCust"></select></td>
    <th scope="row">Count</th>
    <td><span><b>${fieldMap.custUnitCount}</b></span></td>
    <th scope="row">Point</th>
    <td><span><b>${fieldMap.custUnitPoint}</b></span></td>
</tr>
<tr>
    <th scope="row">Total Point</th>
    <td colspan="5"><b>${fieldMap.totUnitPoint}</b></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>CCP Result</h3>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:190px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">CCP Status</th>
    <td><span><select class="w100p" name="statusEdit" id="_statusEdit"></select></span></td>
    <th scope="row">Income Range</th>
    <td><span><select class="w100p" name="incomeRangeEdit" id="_incomeRangeEdit"></select></span></td>
    <th scope="row">Reject Status</th>
    <td><span><select class="w100p" name="rejectStatusEdit" id="_rejectStatusEdit"></select></span></td>
</tr>
<tr>
    <th scope="row">FICO Score</th>
    <td colspan="5"><span>text</span></td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td colspan="5"><span><select class="w100p" name="reasonCodeEdit" id="_reasonCodeEdit"></select></span></td>  
</tr>
<tr>
    <th scope="row">Special Remark</th>
    <td colspan="5"><textarea cols="20" rows="5" id="_spcialRem" name="spcialRem"></textarea></td>
</tr>
<tr>
    <th scope="row">P &amp; C Remark</th>
    <td colspan="5"><textarea cols="20" rows="5" id="_pncRem" name="pncRem"></textarea></td>
</tr>
<tr>
    <th scope="row">Letter Of Undertaking</th>
    <td><span><input type="checkbox"  id="_letterOfUdt"  name="letterOfUdt"/></span></td>
    <th scope="row">Summon</th>
    <td><span><input type="checkbox"  id="_summon"  name="summon"/></span></td>
    <th scope="row">On Hold CCP</th>
    <td><span><input type="checkbox"  id="_onHoldCcp"  name="onHoldCcp"/></span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">List</a></p></li>
</ul>


</section>
</div>