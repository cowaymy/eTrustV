<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javaScript">
var mainGrid;
var subGrid1;
var subGrid2;
var subGrid3;
var selectedGridValue;
//Combo Data
var memberTypeData = [{"codeId": "1","codeName": "Health Planner"},{"codeId": "2","codeName": "Coway Lady"}, {"codeId": "7","codeName": "Homecare Technician"}/* ,{"codeId": "3","codeName": "Coway Technician"},{"codeId": "7","codeName": "Homecare Technician"} */];

$(document).ready(function(){

	doDefCombo(memberTypeData, '' ,'cmbMemberType', 'S', '');
	doDefCombo(memberTypeData, '' ,'cmbMemberTypeNew', 'S', '');

    mainGrid = GridCommon.createAUIGrid("#grid_wrap_main", columnLayout, null, gridPros);
    subGrid1 = GridCommon.createAUIGrid("#grid_wrap_sub1", columnLayoutForSub1, null, gridProsForSub);
    subGrid2 = GridCommon.createAUIGrid("#grid_wrap_sub2", columnLayoutForSub2, null, gridProsForSub);

    fn_searchAjax();

    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(mainGrid, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });

    AUIGrid.bind(subGrid2, "cellClick", function(event){
    	AUIGrid.destroy(subGrid3);
        $("#grid_wrap_sub3").show();
        subGrid3 = GridCommon.createAUIGrid("#grid_wrap_sub3", columnLayoutForSub3, null, gridPros);
        var payId = AUIGrid.getCellValue(subGrid2, event.rowIndex, "payId");
        Common.ajax("GET", "/payment/selectDetailForPaymentResult.do", {"payId" : payId}, function(result){
            AUIGrid.setGridData(subGrid3, result);
            AUIGrid.resize(subGrid3);
        });
    });

    $("#grid_wrap_sub1").hide();
    $("#grid_wrap_sub2").hide();
    $("#grid_wrap_sub3").hide();

});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 5,
        height:200
};

var gridProsForSub = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 10
};

var columnLayout=[
       {dataField:"fileId", headerText:"<spring:message code='pay.head.fileNo'/>"},
       {dataField:"fileName", headerText:"<spring:message code='pay.head.fileName'/>"},
       {dataField:"fileDt", headerText:"<spring:message code='pay.head.uploaddate'/>",dataType:"date",formatString:"dd-mm-yyyy"},
       {dataField:"actnDt", headerText:"<spring:message code='pay.head.month'/>",dataType:"date",formatString:"dd-mm-yyyy"},
       {dataField:"memType", headerText:"<spring:message code='commission.text.search.orgType'/>"},
       {dataField:"fileRefNo", headerText:"<spring:message code='pay.head.fileType'/>"},
       {dataField:"totRcord", headerText:"<spring:message code='pay.head.totalRecords'/>"},
       {dataField:"totAmt", headerText:"<spring:message code='pay.head.totalAmount'/>", dataType:"numeric", formatString:"#,##0.00"},
       {dataField:"fileStus", headerText:"<spring:message code='pay.head.fileStatus'/>",visible:false},
       {dataField:"fileStusName", headerText:"<spring:message code='pay.head.fileStatus'/>"}
];

var columnLayoutForSub1=[
       {dataField:"fileId", headerText:"<spring:message code='pay.head.fileID'/>"},
       {dataField:"itmId", headerText:"<spring:message code='pay.head.itemId'/>"},
       {dataField:"ordNo", headerText:"<spring:message code='pay.head.orderNo'/>"},
       {dataField:"deductCode", headerText:"<spring:message code='pay.head.deductCode'/>"},
       {dataField:"payType", headerText:"<spring:message code='pay.head.payType'/>"},
       {dataField:"memCode", headerText:"<spring:message code='pay.head.memberCode'/>"},
       {dataField:"amt", headerText:"<spring:message code='pay.head.amount'/>"},
       {dataField:"syncCmplt", headerText:"<spring:message code='pay.head.status'/>"}
];

var columnLayoutForSub2=[
       {dataField:"trxId", headerText:"<spring:message code='pay.head.trxNo'/>"},
       {dataField:"trxDt", headerText:"<spring:message code='pay.head.trxDate'/>"},
       {dataField:"trxAmt", headerText:"<spring:message code='pay.head.trxTotal'/>"},
       {dataField:"payId", headerText:"<spring:message code='pay.head.pid'/>"},
       {dataField:"orNo", headerText:"<spring:message code='pay.head.orNo'/>"},
       {dataField:"trNo", headerText:"<spring:message code='pay.head.trNo'/>"},
       {dataField:"orAmt", headerText:"<spring:message code='pay.head.orTotal'/>"},
       {dataField:"salesOrdNo", headerText:"<spring:message code='pay.head.orderNo'/>"},
       {dataField:"appTypeName", headerText:"<spring:message code='pay.head.appType'/>"},
       {dataField:"productDesc", headerText:"<spring:message code='pay.head.product'/>"},
       {dataField:"custName", headerText:"<spring:message code='pay.head.customer'/>"},
       {dataField:"custIc", headerText:"<spring:message code='pay.head.iccoNo'/>"},
       {dataField:"clcrtBrnchName", headerText: "<spring:message code='pay.head.brach'/>"},
       {dataField:"keyinUserName", headerText:"<spring:message code='pay.head.userName'/>"}
];

var columnLayoutForSub3=[
       {dataField:"payId", headerText:"<spring:message code='pay.head.payId'/>", visible:false},
       {dataField:"payItmId", headerText:"<spring:message code='pay.head.itemId'/>", visible:false},
       {dataField:"codeName", headerText:"<spring:message code='pay.head.mode'/>"},
       {dataField:"payItmRefNo", headerText:"<spring:message code='pay.head.refNo'/>"},
       {dataField:"payItmCCTypeId", headerText:"<spring:message code='pay.head.ccType'/>"},
       {dataField:"payItmCcHolderName", headerText:"<spring:message code='pay.head.ccHolder'/>"},
       {dataField:"payItmCcExprDt", headerText:"<spring:message code='pay.head.ccExpiryDate'/>"},
       {dataField:"payItmChqNo", headerText:"<spring:message code='pay.head.chequeNo'/>"},
       {dataField:"bank", headerText:"<spring:message code='pay.head.issueBank'/>"},
       {dataField:"payItmAmt", headerText:"<spring:message code='pay.head.amount'/>"},
       {dataField:"payItmIsOnline", headerText:"<spring:message code='pay.head.online'/>"},
       {dataField:"accDesc", headerText:"<spring:message code='pay.head.bankAccount'/>"},
       {dataField:"payItmRefDt", headerText:"<spring:message code='pay.head.refDate'/>", dataType:"date", formatString:"dd-mm-yyyy"},
       {dataField:"payItmAppvNo", headerText:"<spring:message code='pay.head.apprNo'/>"},
       {dataField:"payItmRem", headerText:"<spring:message code='pay.head.remark'/>"},
       {dataField:"name1", headerText:"<spring:message code='pay.head.status'/>"},
       {dataField:"payItmIsLok", headerText:"<spring:message code='pay.head.locked'/>"},
       {dataField:"payItmBankChrgAmt", headerText:"<spring:message code='pay.head.bankChange'/>"}
];

function fn_uploadFile(){
    var formData = new FormData();

    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("cmbMemberType", $("#cmbMemberTypeNew").val());
    console.log($("#cmbMemberTypeNew").val());
    if($("#cmbMemberTypeNew").val() != ""){
    	Common.ajaxFile("/payment/csvUpload.do", formData, function(result){
    		Common.alert(result.message);
    	});
    }else{
    	Common.alert("Please select member type");
    }
}

function fn_viewResult(){
    $("#grid_wrap_sub1").show();
    $("#grid_wrap_sub2").show();
    $("#grid_wrap_sub3").hide();
    var fileNo = AUIGrid.getCellValue(mainGrid, selectedGridValue, "fileId");
    Common.ajax("GET", "/payment/loadRawItemsStatus.do", {"fileId" : fileNo}, function(result){
        AUIGrid.setGridData(subGrid1, result);
        AUIGrid.resize(subGrid1);
    });

}

function fn_createPayment(){
    if(selectedGridValue != undefined){
        var fileNo = AUIGrid.getCellValue(mainGrid, selectedGridValue, "fileId");
        Common.ajax("GET", "/payment/createPayment.do", {"fileId" : fileNo}, function(result){
            Common.alert(result.message);
        });
    }else{
        return;
    }
}

function fn_new(){
    $("#new_wrap").show();
}

function fn_deactivate(){

	if(selectedGridValue != undefined){
		var fileId = AUIGrid.getCellValue(mainGrid, selectedGridValue, "fileId");
		var stus = AUIGrid.getCellValue(mainGrid, selectedGridValue, "fileStus");
console.log(stus);
		if(stus == 1){
			Common.confirm("<spring:message code='pay.alert.deactivateBatch'/>",function (){
		        Common.ajax("GET", "/payment/deactivateCommissionDeduction.do", {"fileId":fileId}, function(result) {
		            Common.alert("<b>This batch has been deactivated.</b>",function(){fn_searchAjax()});
		        },function(result) {
		            Common.alert("<b>Failed to deactivate this batch.<br />Please try again later.</b>");
		        });
	        });
		}else{
			Common.alert("Only [Active] batch can be deactivated");
		}
	}else{
		Common.alert("<spring:message code='pay.alert.selectBatchId'/>");
	}
}

function fn_searchAjax(){
	Common.ajax("GET", "/payment/selectCommDeduction.do", $("#myForm").serializeJSON(), function(result) {
        AUIGrid.setGridData(mainGrid, result);
    });
}

function fn_clickArea1(){
    $("#grid_wrap_sub3").hide();
}

function fn_clickArea2(){

    if(selectedGridValue != undefined){
        AUIGrid.destroy(subGrid3);
        var fileNo = AUIGrid.getCellValue(mainGrid, selectedGridValue, "fileId");
        Common.ajax("GET", "/payment/loadPaymentResult.do", {"fileId" : fileNo}, function(result){
            AUIGrid.setGridData(subGrid2, result);
            AUIGrid.resize(subGrid2);
        });

    }else{
        Common.alert("<spring:message code='pay.alert.selectFile'/>");
    }
}
</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Commission Deduction</h2>

        <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="btn_blue"><a href="javascript:fn_new();">New</a></p></li>
        <li><p class="btn_blue"><a href="javascript:fn_createPayment();"><spring:message code='pay.btn.createPayment'/></a></p></li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue"><a href="javascript:fn_viewResult();"><spring:message code='pay.btn.viewResult'/></a></p></li>
        <li><p class="btn_blue"><a href="javascript:fn_searchAjax();"><spring:message code='sys.btn.search'/></a></p></li>
      </c:if>
    </ul>
    </aside><!-- title_line end -->

    <section class="search_table">
        <!-- search_table start -->
        <form action="#" method="post" name="myForm" id="myForm">

            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 120px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.orgType'/></th>
                        <td>
                            <select class="" name="cmbMemberType" id="cmbMemberType">
                            <option value=""></option>
                                <c:forEach var="list" items="${memType }">
                                    <option value="${list.cdid}">${list.cdnm}(${list.cd})</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='commission.text.search.targetMonth'/></th>
                        <td><input type="text" title="기준년월" placeholder="MM/YY" class="j_date2 w25p" name="actionDate" id="actionDate" /></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

<!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="javascript:fn_deactivate();"><spring:message code='pay.btn.deactivate'/></a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </c:if>
            </aside><!-- link_btns_wrap end -->

<%--     <ul class="left_btns mt20">

        <li>
            <div class="auto_file"><!-- auto_file start -->
                <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
            </div><!-- auto_file end -->
        </li>
         <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
             <li><p class="btn_sky"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.upload'/></a></p></li>
         </c:if>
        <li><p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/payment/CommDeduction.csv"><spring:message code="commission.button.dwCsvFormat" /></a></p></li>
    </ul> --%>

    <section class="search_result mt20"><!-- search_result start -->
        <article class="grid_wrap" id="grid_wrap_main"><!-- grid_wrap start -->
        </article><!-- grid_wrap end -->
    </section><!-- search_result end -->

    <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="javascript:fn_clickArea1();" class="on"><spring:message code='pay.btn.rawFileItemsStatus'/></a></li>
            <li><a href="#" onclick="fn_clickArea2();"><spring:message code='pay.btn.paymentResults'/></a></li>
        </ul>

        <article class="tap_area" id="tap_area1"><!-- tap_area start -->
            <article class="grid_wrap" id="grid_wrap_sub1"><!-- grid_wrap start -->
            </article><!-- grid_wrap end -->
        </article><!-- tap_area end -->

        <article class="tap_area" id="tap_area2"><!-- tap_area start -->
            <article class="grid_wrap " id="grid_wrap_sub2"><!-- grid_wrap start -->
            </article><!-- grid_wrap end -->
            <article class="grid_wrap " id="grid_wrap_sub3"><!-- grid_wrap start -->
            </article><!-- grid_wrap end -->
        </article><!-- tap_area end -->
    </section><!-- tap_wrap end -->
</section><!-- content end -->

<!---------------------------------------------------------------
    POP-UP (NEW COMMUSSION DEDUCTION)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="new_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="new_pop_header">
        <h1>NEW COMMISSION DEDUCTION</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#new_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="newForm" id="newForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.orgType'/></th>
                        <td>
                           <select class="" name="cmbMemberTypeNew" id="cmbMemberTypeNew">
                           <option value=""></option>
                            <c:forEach var="list" items="${memType }">
                                <option value="${list.cdid}">${list.cdnm}(${list.cd})</option>
                            </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sales.SelectCSVFile" /></th>

                        <td>
            <div class="auto_file"><!-- auto_file start -->
                <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
            </div><!-- auto_file end -->
                            <p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/payment/CommDeduction.csv"><spring:message code="commission.button.dwCsvFormat" /></a></p>
                        </td>
                    </tr>
                   </tbody>
            </table>
        </section>
        <!-- search_table end -->

        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.upload'/></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->