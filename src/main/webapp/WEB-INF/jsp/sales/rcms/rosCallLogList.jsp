<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

//Create and Return Grid Id
var rosGridID;

var optionModule = {
        type: "M",
        isCheckAll: false,
        isShowChoose: false
};

var gridPros = {
        usePaging           : true,         //페이징 사용
        pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
        editable            : false,
        fixedColumnCount    : 0,
        showStateColumn     : true,
        displayTreeOpen     : false,
   //     selectionMode       : "singleRow",  //"multipleCells",
        headerHeight        : 30,
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
        noDataMessage       : "No order found.",
        groupingMessage     : "Here groupping"
    };

$(document).ready(function() {/////////////////////////////////////////////////////////////// Document Ready Func Start

	createRosCallGrid();

	CommonCombo.make("_appType", "/sales/rcms/getAppTypeList", {codeMasterId : '10'}, "66|!|1412", optionModule);
	doGetCombo('/common/selectCodeList.do', '95', '','cmbCorpTypeId', 'M' , 'f_multiCombo');     // Company Type Combo Box
	doGetComboAndGroup2('/common/selectProductCodeList.do', {selProdGubun: 'EXHC'}, '', 'listProductId', 'S', 'fn_setOptGrpClass');//product 생성
	CommonCombo.make("mainReason", "/sales/rcms/getReasonCodeList", {typeId : '1175' , stusCodeId : '1'},  '', {type: "S"});  //Reason Code
	CommonCombo.make("rosStatus", "/common/selectCodeList.do", {groupCode : '391'}, '', {type: "S"});  //Reason Code
	CommonCombo.make("rosCallerType", "/sales/rcms/selectAgentTypeList", {codeMasterId : '329'}, '',  { type: "S"});
	CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {stus:'1'} ,'',  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});


	//Search
	$("#_searchBtn").click(function() {

		Common.ajax("GET","/sales/rcms/selectRosCallLogList" , $("#_searchForm").serialize(),function(result){
			//set Grid Data
			AUIGrid.setGridData(rosGridID, result);
		});
	});

	/* $("#rosCallerType").change(function(){
		CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {stus:'1',agentType: this.value} ,'',  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});
	}); */

	AUIGrid.bind(rosGridID, "cellDoubleClick", function(event){
		if('${PAGE_AUTH.funcUserDefine1}' == 'Y'){
			fn_newROSCall();
		}else{
			Common.alert("Access Deny");
		}

	});

	$('#excelDown').click(function() {
	    GridCommon.exportTo("rosCall_grid_wrap", 'xlsx', "ROS Call Log");
	 });
});////////////////////////////////////////////////////////////////////////////////////////////////// Document Ready Func End

function f_multiCombo(){
    $(function() {
        $('#cmbCorpTypeId').change(function() {

        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '80%'
        });
    });
}

function chgGridTab(tabNm) {
    switch(tabNm) {
        case 'custInfo' :
            AUIGrid.resize(custInfoGridID, 920, 300);
            break;
        case 'memInfo' :
            AUIGrid.resize(memInfoGridID, 920, 300);
            break;
        case 'docInfo' :
            AUIGrid.resize(docGridID, 920, 300);
            if(AUIGrid.getRowCount(docGridID) <= 0) {
                fn_selectDocumentList();
            }
            break;
        case 'callLogInfo' :
            AUIGrid.resize(callLogGridID, 920, 300);
            if(AUIGrid.getRowCount(callLogGridID) <= 0) {
                fn_selectCallLogList();
            }
            break;
        case 'payInfo' :
            AUIGrid.resize(payGridID, 920, 300);
            if(AUIGrid.getRowCount(payGridID) <= 0) {
                fn_selectPaymentList();
            }
            break;
        case 'transInfo' :
            AUIGrid.resize(transGridID, 920, 300);
            if(AUIGrid.getRowCount(transGridID) <= 0) {
                fn_selectTransList();
            }
            break;
        case 'autoDebitInfo' :
            AUIGrid.resize(autoDebitGridID, 920, 300);
            if(AUIGrid.getRowCount(autoDebitGridID) <= 0) {
                fn_selectAutoDebitList();
            }
            break;
        case 'discountInfo' :
            AUIGrid.resize(discountGridID, 920, 300);
            if(AUIGrid.getRowCount(discountGridID) <= 0) {
                fn_selectDiscountList();
            }
            break;
        case 'afterList' :
            AUIGrid.resize(afterServceGridID, 940, 300);
            break;
        case 'beforeList' :
            AUIGrid.resize(beforeServceGridID, 940, 300);
            break;
        case 'rentalfulldetail' :
        	AUIGrid.resize(agmHistoryGridID, 940, 180);
            AUIGrid.resize(billingGroupLatestSummaryGridID, 940, 180);
            AUIGrid.resize(agreementGridID, 940, 180);
            break;
    };
}

function fn_underDevelop(){
	Common.alert("This Program is Under Development.");
}

function fn_orderUloadBatch(){
	Common.popupDiv("/sales/rcms/orderUploadBatchListPop.do", null ,  null , true, '_updLoadDiv');
}


function createRosCallGrid(){
	 var rosColumnLayout =  [
	                            {dataField : "ordNo", headerText : '<spring:message code="sal.text.ordNo" />', width : '10%' , editable : false},
	                            {dataField : "firstInstallDt", headerText : '<spring:message code="sal.text.insDate" />', width : '10%', editable : false},
	                            {dataField : "ordStusName", headerText : '<spring:message code="sal.text.orderStatus" />', width : '10%' , editable : false},
	                            {dataField : "appTypeCode", headerText : '<spring:message code="sal.title.text.appType" />', width : '10%' , editable : false},
	                            {dataField : "stockDesc", headerText : '<spring:message code="sal.title.text.product" />', width : '20%' , editable : false},
	                            {dataField : "custName", headerText : '<spring:message code="sal.text.custName" />', width : '20%' , editable : false},
	                            {dataField : "custId", headerText : '<spring:message code="sal.text.customerId" />', width : '15%' , editable : false},
	                            {dataField : "custType", headerText : '<spring:message code="sal.text.custType" />', width : '20%' , editable : false},
	                            {dataField : "rentalStus", headerText : '<spring:message code="sal.text.rentalStatus" />', width : '10%' , editable : false},
	                            {dataField : "currMthAging", headerText : '<spring:message code="sal.title.msg.currAgingMonth" />', width : '15%' , editable : false},
	                            {dataField : "currentOs", headerText : '<spring:message code="sal.text.currOutstnd" />', width : '15%' , editable : false},
	                            {dataField : "rosCaller", headerText : '<spring:message code="sal.title.text.rosCaller" />', width : '20%' , editable : false},
	                            {dataField : "rosMainReason", headerText : '<spring:message code="sal.title.text.mainReason"/>', width : '20%' , editable : false},
	                            {dataField : "paymode", headerText : '<spring:message code="sal.title.paymode" />', width : '15%' , editable : false},
	                            {dataField : "etr", headerText : '<spring:message code="sal.title.text.etr" />', width : '5%' , editable : false},
	                            {dataField : "ordId", visible : false},
	                            {dataField : "custBillId", visible : false}
	                           ];

	    //그리드 속성 설정
	    var gridPros = {

	            usePaging           : true,         //페이징 사용
	            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
	            fixedColumnCount    : 1,
	            showStateColumn     : true,
	            displayTreeOpen     : false,
	//            selectionMode       : "singleRow",  //"multipleCells",
	            headerHeight        : 30,
	            useGroupingPanel    : false,        //그룹핑 패널 사용
	            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
	            noDataMessage       : "No Ros Call found.",
	            groupingMessage     : "Here groupping"
	    };

	    rosGridID = GridCommon.createAUIGrid("#rosCall_grid_wrap", rosColumnLayout,'', gridPros);  // address list
}

function fn_newROSCall(){

	//Validation
	var selectedItem = AUIGrid.getSelectedItems(rosGridID);
    if(selectedItem.length <= 0){
        Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
        return;
    }
    //Popup
    Common.popupDiv("/sales/rcms/newRosCallPop.do", {salesOrderId : selectedItem[0].item.ordId , ordNo : selectedItem[0].item.ordNo, custId : selectedItem[0].item.custId, custBillId : selectedItem[0].item.custBillId}, null , true , '_newDiv');
}

function fn_chargeOrderBillingType(){

	//Validation
    var selectedItem = AUIGrid.getSelectedItems(rosGridID);
    if(selectedItem.length <= 0){
        Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
        return;
    }
    //Popup
	Common.popupDiv('/payment/initChangeBillingTypePop.do', {custBillId : selectedItem[0].item.custBillId , callPrgm : "BILLING_GROUP"}, null , true);

}

function searchList(){
	$("#_searchBtn").click();
}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};

function fn_feedbackList(){
	Common.popupDiv("/sales/rcms/feedbackPop.do", null ,  null , true, '_feedbackPop');
}

function fn_setOptGrpClass() {
    $("optgroup").attr("class" , "optgroup_text");
}

function fn_alert() {
	Common.alert("Under Development");
}

$(function() {
	$("#rosCallerType").change(function(){
		CommonCombo.make("rosCaller", "/sales/rcms/selectRosCaller", {stus:'1',agentType: this.value} ,'',  {id:'agentId', name:"agentName", isShowChoose: false,isCheckAll : false , type: "M"});
	});
});
</script>



<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.text.rosCallLog" /></h2>
<ul class="right_btns">
    <%-- <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a onclick="javascript:fn_newROSCall()"><span ></span><spring:message code="sal.title.text.newRosCall" /></a></p></li>
    </c:if> --%>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a onclick="javascript:fn_chargeOrderBillingType()"><span ></span><spring:message code="sal.title.text.chargeOrderBillingType" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue"><a onclick="javascript:fn_orderUloadBatch()"><span ></span><spring:message code="sal.title.text.orderRemUploadBatch" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a id="_searchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a onclick="javascript:$('#_searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="_searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>
        <input type="text" title="" placeholder="Order No" class="w100p" id="_ordNo" name="ordNo"/>
    </td>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="_appType" name="appType"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_rentalStatus" name="rentalStatus">
        <option value="ACT"><spring:message code="sal.btn.active" /></option>
        <option value="REG"><spring:message code="sal.combo.text.regular" /></option>
        <option value="INV"><spring:message code="sal.combo.text.investigate" /></option>
        <option value="SUS"><spring:message code="sal.combo.text.supend" /></option>
        <option value="RET"><spring:message code="sal.combo.text.returned" /></option>
        <option value="CAN"><spring:message code="sal.combo.text.cancelled" /></option>
        <option value="TER"><spring:message code="sal.combo.text.terminated" /></option>
        <option value="WOF"><spring:message code="sal.combo.text.writeOff" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td>
        <input type="text" title="" placeholder="Customer ID (Number Only)" class="w100p" id="_custId" name="custId" />
    </td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td>
        <input type="text" title="" placeholder="Customer Name" class="w100p" id="_custName" name="custName"/>
    </td>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
    <td>
        <input type="text" title="" placeholder="NRIC/Company Number" class="w100p" id="_custNric" name="custNric" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.poNum'/></th>
    <td>
        <input id="listPoNo" name="poNo" type="text" title="PO No" placeholder="<spring:message code='sales.poNum'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.companyType" /></th>
    <td>
        <select id="cmbCorpTypeId" name="cmbCorpTypeId" class="multy_select w100p" multiple="multiple"></select>
    </td>
    <th scope="row"><spring:message code='sales.ContactNo'/></th>
    <td>
    <input id="listContactNo" name="contactNo" type="text" title="Contact No" placeholder="<spring:message code='sales.ContactNo'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.prod'/></th>
    <td>
        <select id="listProductId" name="productId" class="w100p"></select>
    </td>
    <th scope="row"><spring:message code='sales.SeriacNo'/></th>
    <td>
        <input id="listSerialNo" name="serialNo" type="text" title="Serial Number" placeholder="<spring:message code='sales.SeriacNo'/>" class="w100p" />
    </td>
    <th scope="row"><spring:message code='sales.vaNum'/></th>
    <td>
        <input id="listVaNo" name="vaNo" type="text" title="VA Number" placeholder="<spring:message code='sales.vaNum'/>" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agentType" /></th>
        <td>
        <select class="w100p" id="rosCallerType" name="rosCallerType"></select>
        </td>
     <th scope="row"><spring:message code='sal.title.text.reCallDate'/></th>
        <td>
            <div class="date_set w100p"><!-- date_set start -->
                <p><input id="listRclStartDt" name="rclStartDt" type="text" value="" title="Recall start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
            <span>To</span>
                <p><input id="listRclEndDt" name="rclEndDt" type="text" value="" title="Recall end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
            </div><!-- date_set end -->
        </td>
     <th scope="row"><spring:message code="sal.title.text.mainReason" /></th>
        <td>
            <select class="w100p" id="mainReason" name="mainReason"></select>
        </td>
</tr>
<tr>
     <th scope="row"><spring:message code="sal.title.text.rosCaller" /></th>
         <td>
             <select id="rosCaller" name="rosCaller" class="multy_select w100p" multiple="multiple"></select>
         </td>
     <th scope="row"><spring:message code='sal.title.text.ptpDate'/></th>
         <td>
         <div class="date_set w100p"><!-- date_set start -->
             <p><input id="listPtpStartDt" name="ptpStartDt" type="text" value="" title="PTP start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                 <span>To</span>
             <p><input id="listPtpEndDt" name="ptpEndDt" type="text" value="" title="PTP end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
          </div><!-- date_set end -->
         </td>
     <th scope="row"><spring:message code="sal.title.text.rosStus" /></th>
         <td>
             <select class="w100p" id="rosStatus" name="rosStatus"></select>
         </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt><spring:message code="sal.title.text.link" /></dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a onclick="javascript:fn_feedbackList()"><spring:message code="sal.title.text.feedbackList" /></a></p></li>
        <li><p class="link_btn"><a onclick="javascript:fn_alert()">VVIP Customer Info</a></p></li>
        <li><p class="link_btn"><a onclick="javascript:fn_alert()">ROS Summary Report</a></p></li>
        <%-- <li><p class="link_btn"><a href="${pageContext.request.contextPath}/payment/initInvoiceIssue.do">Invoice</a></p></li>  --%>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<ul class="right_btns mt10">
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    </c:if>
        <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code="sal.title.text.download" /></a></p></li>

</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="rosCall_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->