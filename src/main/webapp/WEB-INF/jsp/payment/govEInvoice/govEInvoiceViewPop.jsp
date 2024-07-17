<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var fileItemID;
var detailsColumnLayout=
[
{dataField : "invRefNo", headerText : "Invoice Reference No", width : 180},
{dataField : "uniqueId", headerText : "Unique Id", width : 280},
{dataField : "status", visible : false},
{dataField : "statusName", headerText : "status", width : 120},
{dataField : "lglTaxInclAmt", headerText : "Total Amount", width : 120},
{dataField : "lglTaxExclAmt", headerText : "Amount Exclude Tax", width : 120},
{dataField : "lglChargTotAmt", headerText : "Amount Tax Charge", width : 120},
{dataField : "respMsg", headerText : "Remarks", width : 120}
];

var gridPros = {
editable : false,
showStateColumn : false,
softRemoveRowMode:false
};

$(document).ready(function() {

	if ($("#hiddenStatus").val() == 5 ){
		$("#btnConf").hide();
		$("#btnDeactivate").hide();
	}

	fileItemID = GridCommon.createAUIGrid("fileItem_grid_wrap", detailsColumnLayout,null,gridPros);
	fn_search();
});

function fn_search(){
	Common.ajax("GET","/payment/einv/selectEInvoiceDetail.do",{"batchId":$("#hiddenBatchId").val()}, function(result){
        AUIGrid.setGridData(fileItemID, result);
        AUIGrid.resize(fileItemID,906, 280);
	});
}

function validFailedRequiredField(){
    var valid = true;
    var message = "";

    if(!($("#hiddenStatus").val() == '1'  || $("#hiddenStatus").val() == '104')){
         valid = false;
         message += 'This batch not in active/processing status. Unable to deactivate.';
    }

    if(valid == false){
        Common.alert(message);
    }

    return valid;
}

function fn_deactivateBatch(){
	if(validFailedRequiredField() == true){
		Common.confirm("<spring:message code='pay.alert.deactivatePayBatch'/>",function (){
	        var batchId = $("#hiddenBatchId").val();
	        Common.ajax("GET","/payment/einv/saveEInvDeactivateBatch.do", {"batchId" : batchId}, function(result){
	            console.log(result);
	            $("#viewEInvPop").remove();
	            fn_getEInvListAjax();
	            Common.alert(result.message);
	        });
	    });
	}
}

function validRequiredField(){
    var valid = true;
    var message = "";

    if($("#hiddenStatus").val() != '1' ){
         valid = false;
         message += 'This batch not in active status. Unable to confirm.';
    }

    if(valid == false){
        Common.alert(message);
    }

    return valid;
}

function fn_confirmBatch(){
	if(validRequiredField() == true){
	    Common.confirm("<spring:message code='pay.alert.confPayBatch'/>",function (){
	        var batchId = $("#hiddenBatchId").val();
	        Common.ajax("GET","/payment/einv/saveEInvBatch.do", {"batchId" : batchId}, function(result){
	            console.log(result);
	            /* $('#btnConf').hide();
	            $('#btnDeactivate').hide(); */
	            $("#viewEInvPop").remove();
	            fn_getEInvListAjax();
	            Common.alert(result.message);
	        });
	    });
    }
}

function myCustomFilter(vstatus) {
console.log('myCustomFilter' + vstatus);
    // 사용자 필터링 설정
    AUIGrid.setFilter(fileItemID, "status", function (dataField, value, item) {
        if (item.status == vstatus) {
            return true;
        }
        return false;
    });
};

function clearMyFilter() {
    // name 필터링 해제
    AUIGrid.clearFilter(fileItemID, "status");
};

function fn_batchPayItemList(validStatusId, gubun) {
	var batchId = $("#hiddenBatchId").val();

    Common.ajax("GET", "/supplement/payment/selectBatchPayItemList.do", {
      "batchId" : batchId,
      "validStatusId" : validStatusId
    }, function(result) {
      if (gubun == "V") {//VIEW
        if (validStatusId == "4") {
          $('#itemGubun').text("Valid Items");
        } else if (validStatusId == "21") {
          $('#itemGubun').text("Invalid Items");
        } else {
          $('#itemGubun').text("All Items");
        }

        AUIGrid.destroy(batchInfoGridID);
        batchInfoGridID = GridCommon.createAUIGrid("view_grid_wrap", batchInfoLayout, null, gridPros2);
        AUIGrid.setGridData(batchInfoGridID, result.batchPaymentDetList);
        AUIGrid.resize(batchInfoGridID, 1140, 280);

      } else if (gubun == "C") {//CONFIRM
        if (validStatusId == "4") {
          $('#itemGubun_conf').text("Valid Items");
        } else if (validStatusId == "21") {
          $('#itemGubun_conf').text("Invalid Items");
        } else {
          $('#itemGubun_conf').text("All Items");
        }

        AUIGrid.destroy(batchConfGridID);
        batchConfGridID = GridCommon.createAUIGrid("conf_grid_wrap", batchListLayout, null, gridPros2);
        AUIGrid.setGridData(batchConfGridID, result.batchPaymentDetList);
        AUIGrid.resize(batchConfGridID, 1140, 280);
      }
    });
  }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New E-invoice </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<!-- <section class="pop_body"> -->
    <!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
        <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on" id="paymentInfo_conf">Batch Payment Info</a></li>
            <li><a href="#">Batch Payment Item</a></li>
        </ul>
        <article class="tap_area"><!-- tap_area start -->
         <input type="hidden" value="<c:out value="${data.batchId}"/>" id="hiddenBatchId"/>
         <input type="hidden" value="<c:out value="${data.stsCode}"/>" id="hiddenStatus"/>

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Batch ID</th>
                            <td id="txt_batchId"><span><c:out value="${data.batchId}"/></span></td>
                        <th scope="row">Batch Status</th>
                            <td id="txt_batchStatus"><span><c:out value="${data.sts}"/></span></td>
                        <th scope="row">Confirm Status</th>
                            <td id="txt_confirmStatus"><span><c:out value="${data.confirmSts}"/></span></td>
                    </tr>
                    <tr>
                        <th scope="row">E-Invoice Type</th>
                            <td id="txt_einvType"><span><c:out value="${data.invTypeName}"/></span></td>
                        <th scope="row">Created By</th>
                            <td id="txt_createdBy"><span><c:out value="${data.crtUserName}"/></span></td>
                        <th scope="row">Created At</th>
                            <td id="txt_createdAt"><span><c:out value="${data.crtDt}"/></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Confirm By</th>
                            <td id="txt_confirmBy"><span><c:out value="${data.confUserName}"/></span></td>
                        <th scope="row">Confirm At</th>
                            <td id="txt_confirmAt"><span><c:out value="${data.confDt}"/></span></td>
                        <th scope="row">Total Records</th>
                           <td id="txt_totalRecords"><span><c:out value="${data.totalRecords}"/></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Total Amount</th>
                        <td id="txt_totalAmt"><span><c:out value="${data.totalAmt}"/></span></td>
                        <th scope="row"></th>
                        <td></td>
                        <th scope="row"></th>
                        <td></td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </article><!-- tap_area end -->
        <!-- tap_area start -->
        <article class="tap_area">
            <!-- title_line start -->
            <aside class="title_line">
            <h2 id="itemGubun_conf">All Items</h2>
            <ul class="right_btns">
                <li><p class="btn_grid"><a href="javascript:clearMyFilter();"><spring:message code='pay.btn.allItems'/></a></p></li>
                <li><p class="btn_grid"><a href="javascript:myCustomFilter('121');">Submitted Items</a></p></li>
                <li><p class="btn_grid"><a href="javascript:myCustomFilter('4');"><spring:message code='pay.btn.validItems'/></a></p></li>
                <li><p class="btn_grid"><a href="javascript:myCustomFilter('8');"><spring:message code='pay.btn.invalidItems'/></a></p></li>
            </ul>
            </aside>
            <!-- title_line end -->
            <!-- grid_wrap start -->
            <!-- <article id="fileItem_grid_wrap" class="grid_wrap">
            </article> -->
            <div id="fileItem_grid_wrap" style="width: 100%;margin: 0 auto;"></div>
            <!-- grid_wrap end -->
        </article><!-- tap_area end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="javascript:fn_confirmBatch();" id="btnConf"><spring:message code='pay.btn.confirm'/></a></p></li>
                <li><p class="btn_blue2 big"><a href="javascript:fn_deactivateBatch();" id="btnDeactivate"><spring:message code='pay.btn.deactivate'/></a></p></li>
            </ul>
        </section><!-- tap_wrap end -->
    </section><!-- pop_body end -->
<!-- </section> -->

</div><!-- popup_wrap end -->