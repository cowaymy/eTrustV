<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	var selfCareGridReportDetailID;
	$(document).ready(function() {
		console.log("selfCareReportDetailPop.jsp");

		console.log('${detail.fileId}');
		var fileId=  '${detail.fileId}';
		$('#reportFileId').val(fileId);
		$('#readFileId').val(fileId);
		createAUIGrid();
	    $("#btnDownload").click(function() {
	        GridCommon.exportTo("grid_wrap_report_detail", "xlsx", "SelfCareReportDetail");
		});

	    $('#btnSelfCareDetReportClose').click(function() {
	    	fn_close();
	    });

	    $("#_searchBtn").click(function() {
		    fn_getSelfCareTransactionReportDetails();
		});

	    f_multiCombo();
	    fn_getSelfCareTransactionReportDetails();
	});

	function fn_close() {
		    $("#popup_wrap").remove();
	}

	function createAUIGrid() {
		var columnLayout = [
        {
      		dataField : "id",
      		headerText : 'ID',
      		editable : false
        },
        {
      		dataField : "batchId",
      		headerText : 'Batch ID',
      		editable : false
        },
		{
			dataField : "payDate",
			headerText : 'Payment Date',
			editable : false
		}, {
			dataField : "userIssBank",
			headerText : 'Bank',
			editable : false
		}, {
			dataField : "payItmModeDesc",
			headerText : 'Payment Mode',
			editable : false
		}, {
			dataField : "payMethod",
			headerText : 'Payment Method',
			editable : false
		},{
			dataField : "cardNo",
			headerText : 'Card Num.',
			editable : false
		},{
			dataField : "approvalCode",
			headerText : 'Appv Code',
			editable : false
		},{
			dataField : "userRefNo",
			headerText : 'Ref No',
			editable : false
		}, {
			dataField : "remarks",
			headerText : 'Remark',
			editable : false
		},{
			dataField : "userAmt",
			headerText : 'Key-in Amount',
			editable : false
		},{
			dataField : "totalAmt",
			headerText : 'Total Amount',
			editable : false
		}, {
			dataField : "salesOrdNo",
			headerText : 'Order Num.',
			editable : false
		}, {
			dataField : "receiptNo",
			headerText : 'Receipt No.',
			editable : false
		},  {
			dataField : "keyInDt",
			headerText : 'Key-In Date',
			editable : false
		},  {
      		dataField : "fileId",
      		headerText : 'File ID',
      		editable : false
        }];

		var gridPros = {
			usePaging : true,
			pageRowCount : 20,
			fixedColumnCount : 3,
			showStateColumn : false,
			displayTreeOpen : true,
			headerHeight : 30,
			useGroupingPanel : false,
			skipReadonlyColumns : true,
			wrapSelectionMove : true,
			wordWrap : true
		};
		selfCareGridReportDetailID = AUIGrid.create("#grid_wrap_report_detail",
				columnLayout, gridPros);
	}

	function f_multiCombo() {
	    $('#payModeStus').change(function() {
	    }).multipleSelect({
	      selectAll : true,
	      width : '100%'
	    });
	  }

	function fn_getSelfCareTransactionReportDetails(payModeStus){
	      Common.ajax("GET", "/payment/selfCareHostToHost/getSelfcareBatchDetailReport.do", $("#searchFormReport").serialize(), function(result) {
	    	  console.log(result);
	          AUIGrid.setGridData(selfCareGridReportDetailID, result);
	      });
	}
</script>
<body>
	<div id="popup_wrap" class="popup_wrap size_big1">
		<header class="pop_header">
			<!-- pop_header start -->
			<h1>Selfcare Transaction Details</h1>
			<ul class="right_opt">
        		<li><p class="btn_blue2"><a id="_searchBtn" href="#"><span class="search"></span>
            	<spring:message code='sys.btn.search' /></a></p></li>
				<li><p class="btn_blue2">
						<a id="btnDownload" href="#">Download</a>
					</p></li>
					<li><p class="btn_blue2"><a id="btnSelfCareDetReportClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
			</ul>
		</header>
		<!-- pop_header end -->
		<section class="pop_body">
			<section class="search_table">
				<form id="searchFormReport" action="#" method="post">
					<input type="hidden" id="reportFileId" name="reportFileId"' value=""/>
				   	<table class="type1">
		        		<caption>table</caption>
				        <colgroup>
				          <col style="width: 170px" />
				          <col style="width: *" />
				          <col style="width: 230px" />
				          <col style="width: *" />
				        </colgroup>
				        <tbody>
				        	<tr>
				        		<th>Key-In Date</th>
				        		<td>
									<div class="date_set w100p">
										<p><input id="dateFrom" name="dateFrom" type="text" title="Date From" placeholder="DD/MM/YYYY" class="j_date" autocomplete="off" /></p> <span>~</span>
										<p><input id="dateTo" name="dateTo" type="text" title="Date To" placeholder="DD/MM/YYYY" class="j_date" autocomplete="off" /></p>
									</div>
				        		</td>
				        		<th>Payment Mode</th>
								<td>
									<select id="payModeStus" name="payModeStus" class="w100p multy_select" multiple="multiple">
									    <option value="107">Credit Card</option>
									    <option value="108">Online Payment</option>
									</select>
								</td>
				        	</tr>
				        	<tr>
				        		<th>ID</th>
				        		<td>
				        			<input type="text" title="ID" id="detailId" name="detailId" placeholder="ID" class="w100p" />
				        		</td>
				        		<th>Batch ID</th>
				        		<td>
				        			<input type="text" title="Batch ID" id="batchId" name="batchId" placeholder="Batch ID" class="w100p" />
				        		</td>
				        	</tr>
				        	<tr>
				        		<th>File ID</th>
				        		<td>
				        			<input type="text" title="File ID" id="readFileId" name="readFileId" placeholder="File ID" class="w100p" disabled/>
				        		</td>
				        	</tr>
				        </tbody>
				   	</table>
			   </form>
			</section>
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap_report_detail"></div>
			</article>
		</section>
	</div>
</body>