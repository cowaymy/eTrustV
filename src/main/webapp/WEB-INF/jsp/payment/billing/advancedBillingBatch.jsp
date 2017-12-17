<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
var myGridID;
var popGridID;
var selectedItem;

$(document).ready(function(){
	myGridID = GridCommon.createAUIGrid("billing_batch_grid", columnLayout,null,gridPros);
	popGridID = GridCommon.createAUIGrid("pop_batch_grid", columnLayoutForPop,null,gridPros);
	
	// Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedItem = event.rowIndex;
    });
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 10
};

var columnLayout=[
                  {dataField:"advBillBatchId", headerText:"Batch ID"},
                  {dataField:"advBillBatchRefNo", headerText:"RefNo"},
                  {dataField:"advBillBatchTot", headerText:"Total Amount", dataType : "numeric", formatString : "#,##0.00"},
                  {dataField:"advBillBatchTotDscnt", headerText:"Total Discount", dataType : "numeric", formatString : "#,##0.00"},
                  {dataField:"code", headerText:"Status"},
                  {dataField:"advBillBatchRem", headerText:"Remark"},
                  {dataField:"advBillBatchCrtDt", headerText:"Update Date", dataType:"date", formatString:"dd-mm-yyyy"}, 
                  {dataField:"userName", headerText:"Updator"}
              ];
              
var columnLayoutForPop=[
                  {dataField:"accBatchItmOrdNo", headerText:"Order No."},
                  {dataField:"accBatchItmBillStart", headerText:"Bill Start"},
                  {dataField:"accBatchItmBillEnd", headerText:"Bill End"},
                  {dataField:"accBatchItmBillAmt", headerText:"Bill Amount"},
                  {dataField:"accBatchItmBillDscnt", headerText:"Bill Discount"},
                  {dataField:"code", headerText:"Status"},
                  {dataField:"accBatchItmRem", headerText:"Remark"}, 
                  {dataField:"userName", headerText:"Updator"},
                  {dataField:"accBatchItmUpdDt", headerText:"Update Date"}
              ];
              
function fn_searchBillingBatch(){
	Common.ajax("GET", "/payment/selectBillingBatch.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_newBillingBatch(){
	$("#new_batch_pop").show();
	$("#link1").unbind('click', false);
	$("#popRem").val('');
	$("#popRem").attr("disabled", false);
	$('#uploadfile').val("");
	$("#uploadfile").attr("disabled", false);
}

function fn_uploadFile(){
	var formData = new FormData();
	
	formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
	formData.append("remark", $("#popRem").val());
	
	console.log(formData);
	
	Common.ajaxFile("/payment/batchCsvUpload.do", formData, function(result){
		Common.alert(result.message);
		
		$('#uploadfile').val("");
		$("#popRem").val('');
		
		$("#link1").bind('click', false);
		$("#popRem").attr("disabled", true);
		$("#uploadfile").attr("disabled", true);
	});
}

function fn_viewBillingBatch(){
	if(selectedItem != undefined){
		   
		   var batchId = AUIGrid.getCellValue(myGridID, selectedItem, "advBillBatchId");
		    $("#itemText").text("Batch Item");
		    Common.ajax("GET", "/payment/selectBatchMasterInfo.do", {"batchId" : batchId}, function(result){
		    	$("#view_batch_pop").show();
		        $("#popBatchNo").text(result.master.advBillBatchRefNo);
		        $("#popCreated").text(result.master.advBillBatchCrtDt);
		        $("#popCreator").text(result.master.userName);
		        
		        $("#popStatus").text(result.master.advBillBatchStusId);
		        $("#popAmount").text(result.master.advBillBatchTot.toFixed(2));
		        $("#popDiscount").text(result.master.advBillBatchTotDscnt.toFixed(2));
		        
		        if(result.master.advBillBatchStusId == 1){
		        	$("#popDeactive").show();
		        	$("#popApprove").show();
		        }else{
		        	$("#popDeactive").hide();
		        	$("#popApprove").hide();
		        }
		        
		        $("#popTotalItem").text(result.master.totalItem);
		        $("#popTotalSucces").text(result.master.totalSuccess);
		        $("#popTotalFailed").text(result.master.totalFail);
		        
		        $("#popRemark").text(result.master.advBillBatchRem);
		        
		        AUIGrid.setGridData(popGridID, result.detail);
		        AUIGrid.resize(popGridID, 1200, 280);
		    });
	}
}

function fn_selectDetail(statusId){
	var batchId = AUIGrid.getCellValue(myGridID, selectedItem, "advBillBatchId");
	
	 Common.ajax("GET", "/payment/selectBatchDetailByStatus.do", {"batchId" : batchId, "statusId" : statusId}, function(result){
		 if(statusId == 0){
			 $("#itemText").text("All Item");
		 }else if(statusId == 4){
		     $("#itemText").text("Success Item");
		 }else if(statusId == 21){
		      $("#itemText").text("Fail Item");
		 }
		 AUIGrid.setGridData(popGridID, result);
		 AUIGrid.resize(popGridID, 1200, 280);
	 });
	
}

function fn_clickDeactivate(){
	Common.confirm("Are you sure to deactivate this batch conversion.", function(){
		
		var batchId = AUIGrid.getCellValue(myGridID, selectedItem, "advBillBatchId");
		
		Common.ajax("GET", "/payment/doDeactivateAdvanceBillBatach.do", {"batchId" : batchId}, function(result){
			console.log(result);
			Common.alert(result.message);
			$("#popDeactive").hide();
			
			Common.ajax("GET", "/payment/selectBatchMasterInfo.do", {"batchId" : batchId}, function(re){
				$("#popBatchNo").text(re.master.advBillBatchRefNo);
                $("#popCreated").text(re.master.advBillBatchCrtDt);
                $("#popCreator").text(re.master.userName);
                
                $("#popStatus").text(re.master.advBillBatchStusId);
                $("#popAmount").text(re.master.advBillBatchTot.toFixed(2));
                $("#popDiscount").text(re.master.advBillBatchTotDscnt.toFixed(2));
                
                if(re.master.advBillBatchStusId == 1){
                    $("#popDeactive").show();
                    $("#popApprove").show();
                }else{
                    $("#popDeactive").hide();
                    $("#popApprove").hide();
                }
			});
	     });
	});
}

function fn_clickApprove(){
    Common.confirm("<b>Are you sure to approve this batch conversion. </b>", function(){
    	
        var batchId = AUIGrid.getCellValue(myGridID, selectedItem, "advBillBatchId");
        
        Common.ajax("GET", "/payment/updBillBatchUpload.do", {"batchId" : batchId}, function(result){
            console.log(result);
            Common.alert(result.message);
            $("#popDeactive").hide();
            $("#popApprove").hide();
            fn_viewBillingBatch();
         });
    });
}

function fn_Clear(){
	$("#searchForm")[0].reset();
}

</script>
<section id="content"><!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Payment</li>
		<li>Advanced Billing Batch</li>
	</ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Advanced Billing Batch</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a href="javascript:fn_searchBillingBatch();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
			<li><p class="btn_blue"><a href="javascript:fn_Clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
		</ul>
	</aside><!-- title_line end -->

	
	<section class="search_table"><!-- search_table start -->
		<form id="searchForm" name="searchForm" action="#" method="post">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:180px" />
					<col style="width:*" />
					<col style="width:180px" />
                    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Bill Batch ID</th>
						<td>
						   <input type="text" id="batchId" name="batchId" title="" placeholder="Bill Batch ID" class="w100p" />
						</td>
						<th scope="row">Creator</th>
                        <td colspan="">
                          <input type="text" id="creator" name="creator" title="" placeholder="Updator" class="w100p" />
                        </td>
					</tr>
					<tr>
						<th scope="row">Upload Date From</th>
                        <td>
                           <input type="text" id="uploadDtFr" name="uploadDtFr" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                        </td>
                        <th scope="row">Upload Date To</th>
                        <td>
                           <input type="text" id="uploadDtTo" name="uploadDtTo" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
                        </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- search_table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="javascript:fn_viewBillingBatch();">View Billing Batch</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="javascript:fn_newBillingBatch();">New Billing Batch</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->	

	<section class="search_result"><!-- search_result start -->
		<article id="billing_batch_grid" class="grid_wrap"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->
	</section><!-- search_result end -->

</section><!-- content end -->

<div id="new_batch_pop" class="popup_wrap size_big" style="display:none;">
    <header class="pop_header">
        <h1> NEW BATCH ADVANCE BILLING </h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
         <table class="type1 mt10"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:130px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
              <tr>
                  <th>Remark</th>
                  <td><textarea rows="3" id="popRem" name="popRem" title="Remark"></textarea></td>
              </tr>
              <tr>
                  <th>Select CSV File *</th>
                  <td>
                    <div class="auto_file"><!-- auto_file start -->
                          <input type="file" title="file add"  id="uploadfile" name="uploadfile"  accept=".csv"/>
                     </div><!-- auto_file end -->
                     <ul class="right_btns">
                        <li><p class="btn_grid"><a href="${pageContext.request.contextPath}/resources/download/payment/BillingBatchUploadFormat.csv">Download CSV Format</a></p></li>
                     </ul>
                  </td>
              </tr>
              <tr>
                <td colspan="2">
                    <ul class="right_btns">
                        <li><p class="btn_grid"><a id="link1" href="javascript:fn_uploadFile();">
                            Read CSV
                        </a></p></li>
                     </ul>
                </td>
              </tr>
            </tbody>
        </table>
    </section>
    <!-- pop_body end -->
</div>

<div id="view_batch_pop" class="popup_wrap size_big" style="display:none;">
    <header class="pop_header">
        <h1> VIEW BATCH ADVANCE BILLING </h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">
        <p>Advance Billing Batch Info</p>
         <table class="type1 mt10"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
              <tr>
                  <th>Batch No</th>
                  <td><span id="popBatchNo"></span></td>
                  <th>Created At</th>
                  <td><span id="popCreated"></span></td>
                  <th>Create By</th>
                  <td><span id="popCreator"></span></td>
              </tr>
              <tr>
                  <th>Batch Status</th>
                  <td><span id="popStatus"></span></td>
                  <th>Total Billing Amount</th>
                  <td><span id="popAmount"></span></td>
                  <th>Total Billing Discount</th>
                  <td><span id="popDiscount"></span></td>
              </tr>
              <tr>
                  <th>Total Item</th>
                  <td><span id="popTotalItem"></span></td>
                  <th>Total Success Item</th>
                  <td><span class="green_text"  id="popTotalSucces"></span></td>
                  <th>Total Failed Item</th>
                  <td><span class="red_text" id="popTotalFailed"></span></td>
              </tr>
              <tr>
                  <th>Remark</th>
                  <td colspan="5" id="popRemark"></td>
              </tr>
            </tbody>
        </table>
         <p id="itemText">Batch Item</p>
         <ul class="right_btns">
            <li><p class="btn_grid"><a href="javascript:fn_selectDetail(0);"><spring:message code='pay.btn.allItem'/></a></p></li>
            <li><p class="btn_grid"><a href="javascript:fn_selectDetail(4);"><spring:message code='pay.btn.successItem'/></a></p></li>
            <li><p class="btn_grid"><a href="javascript:fn_selectDetail(21);"><spring:message code='pay.btn.failItem'/></a></p></li>
         </ul>
         <article id="pop_batch_grid" class="grid_wrap"><!-- grid_wrap start -->
         </article><!-- grid_wrap end -->
         <ul class="center_btns">
            <li><p class="btn_grid" id="popDeactive" style="display: none"><a href="javascript:fn_clickDeactivate();"><spring:message code='pay.btn.deactivate'/></a></p></li>
            <li><p class="btn_grid" id="popApprove" style="display: none"><a href="javascript:fn_clickApprove();"><spring:message code='pay.btn.approve'/></a></p></li>
         </ul>
    </section>
    <!-- pop_body end -->
</div>
