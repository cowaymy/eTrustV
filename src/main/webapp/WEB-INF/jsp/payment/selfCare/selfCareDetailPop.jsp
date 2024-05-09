<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	var selfCareGridDetailID;
	$(document).ready(function() {
		console.log("selfCareDetailPop.jsp");
		createAUIGrid();
		fn_getSelfCareTransactionDetails(null);

	    $("#btnAllTrx").click(function() {
	    	fn_getSelfCareTransactionDetails(null);
		});

	    $("#btnCompleteTrx").click(function() {
	    	fn_getSelfCareTransactionDetails("4"); //Complete
		});

	    $("#btnFailedTrx").click(function() {
	    	fn_getSelfCareTransactionDetails("21"); //Failed
		});

	    $("#btnDownload").click(function() {
	        GridCommon.exportTo("grid_wrap_detail", "xlsx", "SelfCareDetail");
		});

	    $('#btnSelfCareDetClose').click(function() {
	    	fn_close();
	    });
	});

	function fn_close() {
		    $("#popup_wrap").remove();
	}

	function createAUIGrid() {
		var columnLayout = [ {
			dataField : "id",
			headerText : 'ID',
			visible : false,
			editable : false
		}, {
			dataField : "fileId",
			headerText : 'File ID.',
			editable : false
		}, {
			dataField : "payDate",
			headerText : 'Pay Date',
			editable : false
		}, {
			dataField : "transId",
			headerText : 'Ref No.',
			editable : false
		}, {
			dataField : "authCode",
			headerText : 'Auth Code',
			editable : false
		},{
			dataField : "ccNo",
			headerText : 'CRC No.',
			editable : false
		},{
			dataField : "payMethod",
			headerText : 'Payment Method',
			editable : false
		},{
			dataField : "payTypeDesc",
			headerText : 'Payment Type',
			editable : false
		}, {
			dataField : "salesOrdNo",
			headerText : 'Sales Order No.',
			editable : false
		},{
			dataField : "amount",
			headerText : 'Amount',
			editable : false
		}, {
			dataField : "remarks",
			headerText : 'Remark',
			editable : false
		}, {
			dataField : "payStusDesc",
			headerText : 'Pay Status',
			editable : false
		},  {
			dataField : "crtDt",
			headerText : 'Created Date',
			editable : false
		}, {
			dataField : "batchId",
			headerText : 'Batch ID',
			editable : false
		}, {
			dataField : "prcssStusDesc",
			headerText : 'Process Status',
			editable : false
		}, {
			dataField : "prcssStusRemark",
			headerText : 'Process Status Remark',
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
		selfCareGridDetailID = AUIGrid.create("#grid_wrap_detail",
				columnLayout, gridPros);
	}

	function fn_getSelfCareTransactionDetails(status){
		var data = {
				fileId: '${detail.fileId}',
				prcssStatusId: status
		};
	      Common.ajax("GET", "/payment/selfCareHostToHost/getSelfCareTransactionDetails.do", data, function(result) {
	    	  console.log(result);
	          AUIGrid.setGridData(selfCareGridDetailID, result);
	      });
	}
</script>
<body>
	<div id="popup_wrap" class="popup_wrap size_big1">
		<header class="pop_header">
			<!-- pop_header start -->
			<h1>Selfcare Transaction Details</h1>
			<ul class="right_opt">
				<li><p class="btn_blue2">
						<a id="btnDownload" href="#">Download</a>
					</p></li>
				<li><p class="btn_blue2">
						<a id="btnAllTrx" href="#">All Transactions</a>
					</p></li>
				<li><p class="btn_blue2">
						<a id="btnCompleteTrx" href="#">Completed Transactions</a>
					</p></li>
				<li><p class="btn_blue2">
						<a id="btnFailedTrx" href="#">Failed Transactions</a>
					</p></li>
					<li><p class="btn_blue2"><a id="btnSelfCareDetClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
			</ul>
		</header>
		<!-- pop_header end -->
		<section class="pop_body">
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap_detail"></div>
			</article>
		</section>
	</div>
</body>