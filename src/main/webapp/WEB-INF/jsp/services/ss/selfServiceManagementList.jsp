<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

	var gSelMainRowIdx = 0;
	var gSelMainColIdx = 0;

	// Grid ID
	var selfServiceGridID;
	var selfServiceItmGridID;
	var excelListGridID;

	// Warehouse - CJ KL_A
	var whLocId = '1532';

	// Params
	var salesOrdId;
	var schdulId;
	var hsNo;
	var salesOrdNo;
	var stkId;
	var custId;
	var ssResultId;
	var ssDelvryStus;
	var ssStuscd;
	var ssRtnNo;
	var custAddId
	var custCntId;

	var StatusTypeData = [ {
		"codeId" : "1",
		"codeName" : "Active"
	}, {
		"codeId" : "4",
		"codeName" : "Completed"
	}, {
		"codeId" : "21",
		"codeName" : "Failed"
	}, {
		"codeId" : "10",
		"codeName" : "Cancelled"
	} ];

	$(document).ready(
			function() {
				createAUIGrid();
				createSelfServiceItmGrid();
				createExcelAUIGrid();
				$("#_itmDetailGridDiv").css("display", "none");
				$("#btnSave").hide();

				$('#mySSMonth').val(
						$.datepicker.formatDate('mm/yy', new Date()));
				doDefCombo(StatusTypeData, '', 'cmbSsStatus', 'S', '');

				AUIGrid.bind(selfServiceGridID, "cellClick", function(event) {
					ssStuscd = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "ssStus");
					hsNo = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "hsNo");
					schdulId = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "schdulId");
					salesOrdId = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "salesOrdId");
					salesOrdNo = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "salesOrdNo");
					stkId = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "stkId");
					custId = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "custId");
					ssResultId = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "ssResultId");
					ssDelvryStus = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "delvyStus");
					ssRtnNo = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "ssRtnNo");
					custAddId = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "custAddId");
					custCntId = AUIGrid.getCellValue(selfServiceGridID,
							event.rowIndex, "custCntId");

					AUIGrid.clearGridData(selfServiceItmGridID);
					if (ssStuscd == 'ACT') {
						$("#btnSave").show();
					} else {
						$("#btnSave").hide();
					}

					$("#_itmDetailGridDiv").css("display", "");
					$("#_resultItmDetailGridDiv").css("display", "none");

					var detailParam = {
						salesOrdId : event.item.salesOrdId,
						schdulId : event.item.schdulId
					};

					Common.ajax("GET",
							"/services/ss/selectSelfServiceFilterItmList",
							detailParam, function(result) {
								AUIGrid.setGridData(selfServiceItmGridID,
										result);
								AUIGrid.resize(selfServiceItmGridID);
							});

				});
			});

	$(function() {
		$('#_btnSearch').click(function() {
			if (fn_validSearchList())
				fn_getSelfServiceList();
		});

		$('#excelDown').click(
				function() {
					var excelProps = {
						fileName : "Self Service Management List",
						exceptColumnFields : AUIGrid
								.getHiddenColumnDataFields(excelListGridID)
					};
					AUIGrid.exportToXlsx(excelListGridID, excelProps);
				});

		$('#btnSave').click(function() {
			var ssGridDataList = AUIGrid.getGridData(selfServiceItmGridID);
	        for (var i = 0; i < ssGridDataList.length; i++) {
	        	if(ssGridDataList[i]["serialChk"] == "Y" && (ssGridDataList[i]["serialNo"] == null || ssGridDataList[i]["serialNo"] == "")){
	        		Common.alert('<spring:message code="sal.alert.msg.selSerialNum" />' + " - " + ssGridDataList[i]["stkDesc"]);
	        		return false;
	        	}
	        }

			fn_SaveSelfServiceResult();
		});

		$("#selfServiceDetailView").click(
			       function() {
			         var rowIdx = AUIGrid.getSelectedIndex(selfServiceGridID)[0];
			         if (rowIdx > -1) {
			           Common.popupDiv("/services/ss/selfServiceManagementViewDetailPop", {
			        	   salesOrderId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "salesOrdId") ,
			        	   ssResultId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "ssResultId") ,
			        	   schdulId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "schdulId") ,
			        	   custId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "custId") ,
			        	   hsNo : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "hsNo")
			        	   }, null, true, '_insDiv');
			         } else {
			           Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
			           return false;
			         }
			       }
			    );

		$("#statusUpd").click(
			       function() {
			         var rowIdx = AUIGrid.getSelectedIndex(selfServiceGridID)[0];
			         if (rowIdx > -1) {
			        	 if (ssStuscd != 'COM') {
			                 Common.alert('<spring:message code="service.ss.alert.updateStatusDisallow" arguments="'+ssStuscd+'"/>');
			                 return false;
			             }else{
			            	 Common.popupDiv("/services/ss/selfServiceStatusUpdatePop", {
					        	   salesOrderId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "salesOrdId") ,
					        	   ssResultId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "ssResultId") ,
					        	   schdulId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "schdulId") ,
					        	   custId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "custId") ,
					        	   hsNo : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "hsNo")
					        	   }, null, true, '_insDiv');
			             }

			         } else {
			           Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
			           return false;
			         }
			       }
			    );

		$("#returnQtyUpd").click(
			       function() {
			         var rowIdx = AUIGrid.getSelectedIndex(selfServiceGridID)[0];
			         if (rowIdx > -1) {
			        	 if (ssStuscd != 'FAL') {
			                 Common.alert('<spring:message code="service.ss.alert.updateRtnQtyDisallow" arguments="'+ssStuscd+'"/>');
			                 return false;
			             }else{
			            	 if(ssRtnNo != '-'){
			            		 Common.alert('<spring:message code="service.ss.alert.updateRtnQtyDisallow2" arguments="'+ssRtnNo+'"/>');
				                 return false;
			            	 }else{
			           Common.popupDiv("/services/ss/selfServiceReturnQtyUpdatePop", {
			        	   salesOrderId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "salesOrdId") ,
			        	   ssResultId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "ssResultId") ,
			        	   schdulId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "schdulId") ,
			        	   custId : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "custId") ,
			        	   hsNo : AUIGrid.getCellValue( selfServiceGridID, rowIdx, "hsNo")
			        	   }, null, true, '_insDiv');
			             }
			            }
			         } else {
			           Common.alert('<spring:message code="sal.alert.msg.noRecordSelected" />');
			           return false;
			         }
			       }
			    );
	});

	function fn_getSelfServiceList() {
		Common.ajax("GET", "/services/ss/selectSelfServiceJsonList.do", $(
				"#searchForm").serialize(), function(result) {
			AUIGrid.setGridData(selfServiceGridID, result);
			AUIGrid.setGridData(excelListGridID, result);

			AUIGrid.clearGridData(selfServiceItmGridID);
			$("#_itmDetailGridDiv").css("display", "none");
			$("#btnSave").hide();
		});
	}

	function fn_cMySSMonth(field) {
		$("#" + field + "").val("");
	}

	function createAUIGrid() {
		var selfServiceColumnLayout = [
				{
					dataField : "custId",
					headerText : '<spring:message code="service.title.CustomerID" />',
					width : '8%',
					editable : false
				},
				{
					dataField : "custName",
					headerText : '<spring:message code="service.title.CustomerName" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "salesOrdNo",
					headerText : '<spring:message code="sal.title.text.salesOrder" />',
					width : '8%',
					editable : false
				},
				{
					dataField : "hsNo",
					headerText : '<spring:message code="service.title.HSOrder" />',
					width : '8%',
					editable : false
				},
				{
					dataField : "stkDesc",
					headerText : '<spring:message code="service.title.Product" />',
					width : '15%',
					editable : false
				},
				{
					dataField : "ssStus",
					headerText : '<spring:message code="service.ss.title.ssStatus" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "completeDt",
					headerText : '<spring:message code="service.ss.title.completedDate" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "delvyStus",
					headerText : '<spring:message code="service.ss.title.deliveryStatus" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "delivryDt",
					headerText : '<spring:message code="log.head.deliverydate" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "ssRtnNo",
					headerText : '<spring:message code="sal.title.text.returnNo" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "ssRtnDt",
					headerText : '<spring:message code="sal.text.returnDate" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "area",
					headerText : '<spring:message code="sal.text.area" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "postcode",
					headerText : '<spring:message code="sal.text.postCode" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "crtUsr",
					headerText : '<spring:message code="sal.text.createBy" />',
					width : '8%',
					editable : false
				},
				{
					dataField : "crtDt",
					headerText : '<spring:message code="sal.text.createDate" />',
					width : '8%',
					editable : false
				},
				{
					dataField : "updUsr",
					headerText : '<spring:message code="sal.text.updateBy" />',
					width : '8%',
					editable : false
				},
				{
					dataField : "updDt",
					headerText : '<spring:message code="sal.text.updateDate" />',
					width : '8%',
					editable : false
				}, {
					dataField : "schdulId",
					headerText : "schdulId",
					width : 120,
					visible : false
				}, {
					dataField : "salesOrdId",
					headerText : "salesOrdId",
					width : 120,
					visible : false
				}, {
					dataField : "stkId",
					headerText : "Stock ID",
					visible : false
				}, {
					dataField : "ssResultId",
					headerText : "Self Service Result ID",
					visible : false
				}, {
					dataField : "custAddId",
					headerText : "Customer Address ID",
					visible : false
				}, {
					dataField : "custCntId",
					headerText : "Customer Contact ID",
					visible : false
				} ];

		var gridPros = {
			usePaging : true,
			pageRowCount : 10,
			fixedColumnCount : 4,
			showStateColumn : true,
			displayTreeOpen : false,
			headerHeight : 30,
			useGroupingPanel : false,
			skipReadonlyColumns : true,
			wrapSelectionMove : true,
			showRowNumColumn : true
		};

		selfServiceGridID = GridCommon.createAUIGrid("#selfService_grid_wrap",
				selfServiceColumnLayout, '', gridPros);
	}

	function createExcelAUIGrid() {
		var excelColumnLayout = [
				{
					dataField : "custId",
					headerText : '<spring:message code="service.title.CustomerID" />',
					width : 200,
					editable : false
				},
				{
					dataField : "custName",
					headerText : '<spring:message code="service.title.CustomerName" />',
					width : 200,
					editable : false,
					visible : false
				},
				{
					dataField : "salesOrdNo",
					headerText : '<spring:message code="sal.title.text.salesOrder" />',
					width : 200,
					editable : false
				},
				{
					dataField : "hsNo",
					headerText : '<spring:message code="service.title.HSOrder" />',
					width : 200,
					editable : false
				},
				{
					dataField : "completeDt",
					headerText : '<spring:message code="service.ss.title.completedDate" />',
					width : 200,
					editable : false
				},
				{
					dataField : "ssStus",
					headerText : '<spring:message code="service.ss.title.ssStatus" />',
					width : 200,
					editable : false
				},
				{
					dataField : "delvyStus",
					headerText : '<spring:message code="service.ss.title.deliveryStatus" />',
					width : 200,
					editable : false
				},
				{
					dataField : "area",
					headerText : '<spring:message code="sal.text.area" />',
					width : 200,
					editable : false
				},
				{
					dataField : "postcode",
					headerText : '<spring:message code="sal.text.postCode" />',
					width : 200,
					editable : false
				},
				{
					dataField : "crtUsr",
					headerText : '<spring:message code="sal.text.createBy" />',
					width : 200,
					editable : false
				},
				{
					dataField : "crtDt",
					headerText : '<spring:message code="sal.text.createDate" />',
					width : 200,
					editable : false
				},
				{
					dataField : "updUsr",
					headerText : '<spring:message code="sal.text.updateBy" />',
					width : 200,
					editable : false
				},
				{
					dataField : "updDt",
					headerText : '<spring:message code="sal.text.updateDate" />',
					width : 200,
					editable : false
				} ];

		var excelGridPros = {
			enterKeyColumnBase : true,
			useContextMenu : true,
			enableFilter : true,
			showStateColumn : true,
			displayTreeOpen : true,
			noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
			groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
			exportURL : "/common/exportGrid.do"
		};

		excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap",
				excelColumnLayout, "", excelGridPros);
	}

	function createSelfServiceItmGrid() {
		var selfServiceItmColumnLayout = [
				{
					dataField : "stkCode",
					headerText : '<spring:message code="service.title.FilterCode" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "stkDesc",
					headerText : '<spring:message code="sal.title.filterName" />',
					width : '30%',
					editable : false
				},
				{
					dataField : "srvFilterPrvChgDt",
					headerText : '<spring:message code="sal.title.lastChangeDate" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "srvFilterPriod",
					headerText : '<spring:message code="sal.title.frequent" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "serialChk",
					headerText : '<spring:message code="log.head.serialcheck" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "c1",
					headerText : '<spring:message code="sal.title.qty" />',
					width : '10%',
					editable : false
				},
				{
					dataField : "serialNo",
					headerText : '<spring:message code="service.title.SerialNo" />',
					width : '20%',
					renderer : {
						type : "IconRenderer",
						iconWidth : 24, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
						iconHeight : 24,
						iconPosition : "aisleRight",
						iconTableRef : { // icon 값 참조할 테이블 레퍼런스
							"default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png" //
						},
						onclick : function(rowIndex, columnIndex, value, item) {
							gSelMainRowIdx = rowIndex;
							gSelMainColIdx = columnIndex;

							fn_serialSearchPop(item);
						}
					}
				}, {
					dataField : "schdulId",
					visible : false
				}, {
					dataField : "stkId",
					visible : false
				}, {
					dataField : "ssResultId",
					visible : false
				}, {
					dataField : "ssResultItmId",
					visible : false
				}, {
					dataField : "oldSerialNo",
					visible : false
				}];

		var itmGridPros = {
			showFooter : true,
			usePaging : true,
			pageRowCount : 10,
			fixedColumnCount : 1,
			showStateColumn : true,
			displayTreeOpen : false,
			headerHeight : 30,
			useGroupingPanel : false,
			skipReadonlyColumns : true,
			wrapSelectionMove : true,
			showRowNumColumn : true
		};

		selfServiceItmGridID = GridCommon.createAUIGrid(
				"#selfService_itm_grid_wrap", selfServiceItmColumnLayout, '',
				itmGridPros);
		AUIGrid.resize(selfServiceItmGridID, 960, 300);
	}

	function fn_validSearchList() {
		var isValid = true, msg = "";

		if ($("#mySSMonth").val() == "") {
			if ($("#txtSalesOrder").val() == "" && $("#txtHsOrder").val() == "") {
				isValid = false;
				msg += "* Please fill in HS Order or Sales Order.<br>";
			}
		}

		if (!isValid)
			Common
					.alert('<spring:message code="service.ss.text.selfServiceMgmtSrch" />'
							+ DEFAULT_DELIMITER + "<b>" + msg + "</b>");

		return isValid;
	}

	function fn_serialSearchPop(item) {
		$("#pLocationType").val('01'); //
		$('#pLocationCode').val(whLocId); // CJ KL_A
		$("#pItemCodeOrName").val(item.stkCode);

		if (FormUtil.isEmpty(item.stkCode)) {
			var text = "<spring:message code='service.grid.FilterCode'/>";
			var rtnMsg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
			Common.alert(rtnMsg);
			return false;
		}

		Common.popupWin("frmSearchSerial",
				"/logistics/SerialMgmt/serialSearchPop.do", {
					width : "1000px",
					height : "580",
					resizable : "no",
					scrollbars : "no"
				});
	}

	function fnSerialSearchResult(data) {
		data.forEach(function(dataRow) {
			AUIGrid.setCellValue(selfServiceItmGridID, gSelMainRowIdx,
					gSelMainColIdx, dataRow.serialNo);
		});
	}

	function fn_parentReload() {
		fn_getSelfServiceList(); //parent Method (Reload)
	}

	function fn_SaveSelfServiceResult() {

		// Construct the base JSON object
		var jsonObj = {
			serviceNo : hsNo,
			custId : custId,
			salesOrdNo : salesOrdNo,
			schdulId : schdulId,
			stkId : stkId,
			salesOrdId : salesOrdId,
			ssResultId : ssResultId,
			custAddId : custAddId,
			custCntcId : custCntId
		};

		// Function to make an AJAX POST request with error handling
		function makeAjaxPost(url, data, successMessage) {
			Common
					.ajax(
							"POST",
							url,
							data,
							function(result) {
								Common.alert(
										'<spring:message code="service.ss.text.saveSelfServiceSummary" />'
												+ DEFAULT_DELIMITER + "<b>"
												+ result.message + "</b>",
										fn_parentReload);
							},
							function(jqXHR, textStatus, errorThrown) {
								try {
									Common
											.alert('<spring:message code="service.ss.text.saveSelfServiceSummary" />'
													+ DEFAULT_DELIMITER
													+ "<b>Failed to save Self Service. "
													+ jqXHR.responseJSON.message
													+ "</b>");
									Common.removeLoader();
								} catch (e) {
									console.log("Error:", e);
								}
							});
		}

		// If ssResultId is not zero, update the service result
		if (ssResultId !== 0) {
			var gridDataList = AUIGrid.getGridData(selfServiceItmGridID);
			jsonObj.edit = gridDataList;
			jsonObj.form = $("#addSSForm").serializeJSON();

			makeAjaxPost('/services/ss/saveSelfServiceResult.do', jsonObj);
		} else {
			// If ssResultId is zero, validate before saving
			Common
					.ajax(
							"POST",
							"/services/ss/saveValidation.do",
							jsonObj,
							function(result) {
								if (result === 0) {
									var gridDataList = AUIGrid
											.getGridData(selfServiceItmGridID);
									jsonObj.add = gridDataList;
									jsonObj.form = $("#addSSForm")
											.serializeJSON();

									makeAjaxPost(
											'/services/ss/saveSelfServiceResult.do',
											jsonObj);
								} else {
									Common
											.alert('<spring:message code="service.ss.text.saveSelfServiceSummary" />'
													+ DEFAULT_DELIMITER
													+ '<spring:message code="service.ss.alert.updateResultDisallow" arguments="'+hsNo+'"/>',
													fn_parentReload);
									return false;
								}
							});
		}
	}

	function fn_ssFilterForecastList() {
        Common.popupDiv("/services/ss/report/ssFilterForecastListingPop.do",null, null, true, '');
    }
</script>
<form id="frmSearchSerial" name="frmSearchSerial" method="post">
     <input id="pGubun" name="pGubun" type="hidden" value="RADIO" />
     <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
     <input id="pLocationType" name="pLocationType" type="hidden" value="" />
     <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
     <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
     <input id="pStatus" name="pStatus" type="hidden" value="" />
     <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
</form>
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li><spring:message code="service.ss.title.selfServiceExecution" /></li>
    <li><spring:message code="service.ss.title.selfServiceManagement" /></li>
  </ul>
  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>
      <spring:message code="service.ss.title.selfServiceManagement" />
    </h2>
    <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="returnQtyUpd"><spring:message code="supplement.btn.supplementRtnQtyUpd" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="statusUpd"><spring:message code="service.ss.btn.selfServiceStatusUpdate" /></a>
          </p>
        </li>
      </c:if>
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
      <li>
          <p class="btn_blue">
            <a href="#" id="selfServiceDetailView"><spring:message code="sys.scm.inventory.ViewDetail" /></a>
          </p>
        </li>
        <li>
          <p class="btn_blue">
            <a href="#" id="_btnSearch"><span class="search"></span>
            <spring:message code="sal.btn.search" /></a>
          </p>
        </li>
      </c:if>
      <li>
        <p class="btn_blue">
          <a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>
          <spring:message code="sal.btn.clear" /></a>
        </p>
      </li>
    </ul>
  </aside>
  <section class="search_table">
    <form id="searchForm">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
		<col style="width: 110px" />
		<col style="width: *" />
		<col style="width: 110px" />
		<col style="width: *" />
		<col style="width: 100px" />
		<col style="width: *" />
		<col style="width: 120px" />
		<col style="width: *" />
		</colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code="service.title.HSOrder" /></th>
            <td>
              <input type="text" title="hsOrder" id="txtHsOrder" name="txtHsOrder" placeholder="HS Order" class="w100p" />
            </td>
            <th scope="row"><spring:message code="service.ss.title.ssPeriod" /></th>
            <td>
            <p style="width: 70%;">
				<input id="mySSMonth" name="mySSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" />
			</p>
			<p class="btn_gray"><a href='#' onclick="fn_cMySSMonth('mySSMonth')">Clear</a></p>
			</td>
            <th scope="row"><spring:message code="service.ss.title.ssStatus" /></th>
            <td>
           		<select class="w100p" id="cmbSsStatus" name="cmbSsStatus">
				<option value=""><spring:message code="sal.combo.text.chooseOne" /></option></select>
		   </td>
		   <th scope="row"><spring:message code="service.title.CustomerID" /></th>
		   <td>
		   		<input id="txtCustomerId" name="txtCustomerId" type="text" title="" placeholder="Customer ID" class="w100p" />
		   </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="service.title.SalesOrder" /></th>
            <td>
              <input type="text" title="txtSalesOrder" id="txtSalesOrder" name="txtSalesOrder" placeholder="Sales Order" class="w100p" />
            </td>
            <th scope="row"><spring:message code="service.title.InstallMonth" /></th>
            <td>
            <p style="width: 70%">
			<input id="myInstallMonth" name="myInstallMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" />
			</p>
			<p class="btn_gray">
			<a href="#" onclick="fn_cMySSMonth('myInstallMonth')">Clear</a>
			</p>
			</td>
            <th scope="row"><spring:message code="service.ss.title.deliveryStatus" /></th>
            <td><select class="multy_select w100p" multiple="multiple" id="ssDelStus" name="ssDelStus">
                <c:forEach var="list" items="${ssDelStus}" varStatus="ssDelStus">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
		   <th scope="row"><spring:message code="service.ss.title.completedDate" /></th>
		 <td>
              <div class="date_set w100p">
                <p>
                  <input id="completeStartDt" name="completeStartDt" type="text" value="" title="Complete Start Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
                <span>To</span>
                <p>
                  <input id="completeEndDt" name="completeEndDt" type="text" value="" title="Complete End Date" placeholder="DD/MM/YYYY" class="j_date" />
                </p>
              </div>
            </td>
          </tr>
          <tr>
          <th scope="row"><spring:message code="sal.text.postCode" /></th>
          <td>
              <input type="text" title="postCode" id="postCode" name="postCode" placeholder="postCode" class="w100p" />
            </td>
		 <th></th>
		 <td></td>
		 <th></th>
		 <td></td>
		 <th></th>
		 <td></td>
          </tr>
        </tbody>
      </table>
      <aside class="link_btns_wrap">
        <p class="show_btn">
          <a href="#">
            <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
        </p>
        <dl class="link_list">
          <dt>
            <spring:message code="sal.title.text.link" />
          </dt>
          <dd>
            <ul class="btns">
             <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
               <!-- test temprarily: SS Filter Forecast Listing -->
                 <li>
                   <p class="link_btn type2">
                        <a href="#" onclick="javascript:fn_ssFilterForecastList()"><spring:message code='service.title.ssFilterForecastListing'/></a>
                   </p>
                </li>
             </c:if>
            </ul>
            <p class="hide_btn">
              <a href="#">
                <img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
            </p>
          </dd>
        </dl>
      </aside>
    </form>
  </section>
  <section class="search_result">
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
      <ul class="right_btns">
        <li>
          <p class="btn_grid">
            <a href="#" id="excelDown"><spring:message code="sal.btn.generate" /></a>
          </p>
        </li>
      </ul>
    </c:if>
    <aside class="title_line">
    </aside>
    <article class="grid_wrap">
		<div id="selfService_grid_wrap" style="width: 100%; height: 300px; margin: 0 auto;"></div>
      	<div id="excel_list_grid_wrap" style="display: none;"></div>
    </article>
<form action="#" id="addSSForm" method="post">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
      <ul class="right_btns">
        <li>
          <p class="btn_grid">
            <a href="#" id="btnSave"><spring:message code="sal.btn.save" /></a>
          </p>
        </li>
      </ul>
    </c:if>
     <div id="_itmDetailGridDiv">
      <aside class="title_line">
        <h3>
          <spring:message code="sal.page.subTitle.filterInfo" />
        </h3>
      </aside>
      <article class="grid_wrap">
        <div id="selfService_itm_grid_wrap" style="width: 100%; height: 300px; margin: 0 auto;"></div>
      </article>
    </div>
</form>
  </section>
</section>
<hr />
