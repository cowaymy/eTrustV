<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script>
	document.write('<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js?v='
					+ new Date().getTime() + '"><\/script>');
</script>
<script type="text/javaScript">
	var option = {
		width : "1200px",
		height : "500px"
	};

	var myGridID;
	var gridPros = {
		usePaging : true,
		pageRowCount : 20,
		editable : true,
		fixedColumnCount : 1,
		showStateColumn : true,
		displayTreeOpen : true,
		selectionMode : "singleRow",
		headerHeight : 30,
		useGroupingPanel : true,
		skipReadonlyColumns : true,
		wrapSelectionMove : true,
		showRowNumColumn : false,
	};

	$(document).ready(
		function() {
			asManagementGrid();
			doGetCombo('/services/holiday/selectBranchWithNM', 43, '','cmbbranchId', 'M', 'f_multiCombo'); // DSC BRANCH
			CommonCombo.make('cmbCategory', '/common/selectCodeList.do', {groupCode : 11,codeIn : 'WP,AP,BT,BB,MAT,FRM,POE'}, '', {type : 'M'});

			AUIGrid.bind(myGridID, "cellDoubleClick", function(event) { // AS ENTRY VIEW DOUBLE CLICK

				var asid = AUIGrid.getCellValue(myGridID, event.rowIndex,"asId");
				var asNo = AUIGrid.getCellValue(myGridID, event.rowIndex,"asNo");
				var asStusId = AUIGrid.getCellValue(myGridID,event.rowIndex, "asStusId");
				var salesOrdNo = AUIGrid.getCellValue(myGridID,event.rowIndex, "salesOrdNo");
				var salesOrdId = AUIGrid.getCellValue(myGridID,event.rowIndex, "asSoId");

				var param = "?salesOrderId=" + salesOrdId + "&ord_Id=" + salesOrdId + "&ord_No="
						+ salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asid + "&IND= 1";

				Common.popupDiv("TestResultViewPop.do" + param, null, null, true, '_newASResultDiv1');
			});
		});

	function asManagementGrid() {
		var columnLayout = [
				{
					dataField : "code",
					headerText : "<spring:message code='service.grid.ASTyp'/>",
					editable : false,
					width : 100
				},
				{
					dataField : "code2",
					headerText : "<spring:message code='service.title.ApplicationType'/>",
					width : 100
				},
				{
					dataField : "stkDesc",
					headerText : "<spring:message code='service.grid.Product'/>",
					width : 200
				},
				{
					dataField : "asNo",
					headerText : "<spring:message code='service.grid.ASNo'/>",
					editable : false,
					width : 100
				},
				{
					dataField : "code1",
					headerText : "<spring:message code='service.grid.Status'/>",
					editable : false,
					width : 80
				},
				{
					dataField : "asCrtDt",
					headerText : "<spring:message code='service.grid.registerDt'/>",
					editable : false,
					width : 150,
					dataType : "date",
					formatString : "dd/mm/yyyy"
				},
				{
					dataField : "salesOrdNo",
					headerText : "<spring:message code='service.title.SalesOrder'/>",
					editable : false,
					width : 100
				},
				{
					dataField : "name",
					headerText : "<spring:message code='service.title.CustomerName'/>",
					width : 200
				},
				{
					dataField : "asReqstDt",
					headerText : "<spring:message code='service.grid.ReqstDt'/>",
					editable : false,
					width : 110,
					dataType : "date",
					formatString : "dd/mm/yyyy"
				},
				{
					dataField : "asAppntDt",
					headerText : "<spring:message code='service.grid.AppntDt'/>",
					editable : false,
					width : 110,
					dataType : "date",
					formatString : "dd/mm/yyyy"
				},
				{
					dataField : "asSetlDt",
					headerText : "<spring:message code='service.grid.SettleData'/>",
					editable : false,
					width : 110,
					dataType : "date",
					formatString : "dd/mm/yyyy"
				},
				{
					dataField : "asResultCrtDt",
					headerText : "<spring:message code='pay.head.lastUpdate'/>",
					editable : false,
					width : 110,
					dataType : "date",
					formatString : "dd/mm/yyyy"
				},
				{
					dataField : "c3",
					headerText : "<spring:message code='service.grid.ResultNo'/>",
					editable : false,
					style : "my-column",
					width : 100
				},
				{
					dataField : "asResultCrtUserId",
					headerText : "<spring:message code='service.grid.asRsltEntCreator'/>",
					editable : false,
					width : 100
				},
				{
					dataField : "memCode",
					headerText : "<spring:message code='service.grid.CTCode'/>",
					editable : false,
					width : 100
				},
				{
					dataField : "brnchCode",
					headerText : "<spring:message code='service.title.ASBrch'/>",
					width : 100
				},
				{
					dataField : "cms",
					headerText : "<spring:message code='service.title.AllowComm'/>",
					width : 80
				},
				{
					dataField : "c4",
					headerText : "<spring:message code='service.grid.asEntCreator'/>",
					editable : false,
					width : 100
				},
				{
					dataField : "totalAs",
					headerText : "<spring:message code='service.grid.asTotalLdg'/>",
					editable : false,
					dataType : "numeric",
					width : 100
				},
				{
					dataField : "bsNo",
					headerText : "<spring:message code='service.grid.HSNo'/>",
					editable : false,
					width : 100
				},
				{
					dataField : "undefined",
					headerText : "<spring:message code='sys.btn.edit'/>",
					width : 100,
					renderer : {
						type : "ButtonRenderer",
						labelText : "<spring:message code='sys.btn.edit'/>",
						onclick : function(rowIndex, columnIndex, value, item) {

							var AS_ID = AUIGrid.getCellValue(myGridID,rowIndex, "asId");
							var AS_NO = AUIGrid.getCellValue(myGridID,rowIndex, "asNo");
							var asStusId = AUIGrid.getCellValue(myGridID,rowIndex, "code1");
							var ordno = AUIGrid.getCellValue(myGridID,rowIndex, "salesOrdNo");
							var ordId = AUIGrid.getCellValue(myGridID,rowIndex, "asSoId");

							if (asStusId != "ACT" && asStusId != "RCL") {
							    Common.alert("<spring:message code='service.msg.asEdtChk' arguments='<b>"
												+ AS_NO + "</b>' htmlEscape='false' argumentSeparator=';' />");
								return;
							}

							Common.popupDiv(
									"/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId=" + ordId + "&ordNo="
											+ ordno	+ "&AS_NO=" + AS_NO + "&IND= 1", null, null, true, '_viewEntryPopDiv1');
						}
					}
				},
				{
					dataField : "nric",
					headerText : "<spring:message code='service.title.NRIC_CompanyNo'/>",
					width : 100,
					visible : false
				},

				{
					dataField : "asIfFlag",
					headerText : "<spring:message code='service.title.ASFlg'/>",
					width : 80,
					visible : false
				},

				{
					dataField : "asBrnchId",
					headerText : "<spring:message code='service.title.ASBrchId'/>",
					width : 100,
					visible : false
				},
				{
					dataField : "c5",
					headerText : "<spring:message code='service.title.ASAmt'/>",
					width : 100,
					visible : false
				},
				{
					dataField : "asResultId",
					headerText : "<spring:message code='service.title.ASRstId'/>",
					width : 100,
					visible : false
				}, {
					dataField : "refReqst",
					headerText : "",
					width : 100,
					visible : false
				}, {
					dataField : "rcdTms",
					headerText : "",
					width : 100,
					visible : false
				} ];

		var gridPros = {
			showRowCheckColumn : true,
			usePaging : true,
			pageRowCount : 20,
			showRowAllCheckBox : true,
			editable : false,
			selectionMode : "multipleCells"
		};

		myGridID = AUIGrid.create("#grid_wrap_asList", columnLayout, gridPros);
	}

	function fn_searchASManagement() { // SEARCH AS

		var valid = true;
		var msg = "";
/*
		console.log($("#asNum").val()); */

		if ($("#asNum").val() == '' && $("#resultNum").val() == ''
				&& $("#orderNum").val() == '') {
			if (startDate == '' && endDate == '') {
				msg = "Request Date is required when AS No.,  Result No. and Order No. are empty.";
				valid = false;
			} else if (startDate != '' && endDate == '') {
				msg = "Request End Date is required.";
				valid = false;
			} else if (startDate == '' && endDate != '') {
				msg = "Request Start Date is required.";
				valid = false;
			} else if (startDate != '' && endDate != '') {
				console.log("here");
				if (!js.date.checkDateRange(startDate, endDate, "Request", "3"))
					valid = false;
			}
		}

		if (valid) {
			Common.ajax("GET", "/ResearchDevelopment/searchASManagementList.do", $(
					"#ASForm").serialize(), function(result) {
				AUIGrid.setGridData(myGridID, result);
			});
		} else {
			Common.alert(msg);
		}
	}

	function fn_viewASResultPop() { // VIEW RESULT
		var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

		if (selectedItems.length <= 0) {
			Common.alert("<spring:message code='service.msg.NoRcd'/>");
			return;
		}

		if (selectedItems.length > 1) {
			Common.alert("<spring:message code='service.msg.onlyPlz'/>");
			return;
		}

		var AS_ID = selectedItems[0].item.asId;
		var AS_NO = selectedItems[0].item.asNo;
		var asStusId = selectedItems[0].item.code1;
		var ordno = selectedItems[0].item.salesOrdNo;
		var ordId = selectedItems[0].item.asSoId;

		if (asStusId != "ACT") {
			Common.alert("AS Info Edit Restrict</br>" + DEFAULT_DELIMITER + "<b>[" + AS_NO +
				    "]  is not in active status.</br> AS information edit is disallowed.</b>");
			return;
		}

		Common.popupDiv(
				"/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId=" + ordId + "&ordNo=" + ordno + "&AS_NO=" + AS_NO
				+ '&AS_ID=' + AS_ID, null, null, true, '_viewEntryPopDiv1');
	}

	function fn_newASResultPop() {
	    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

	    if (selectedItems.length <= 0) {
	      Common.alert("<spring:message code='service.msg.NoRcd'/>");
	      return;
	    }

	    if (selectedItems.length > 1) {
	      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
	      return;
	    }

	    var asId = selectedItems[0].item.asId;
	    var asNo = selectedItems[0].item.asNo;
	    var asStusId = selectedItems[0].item.code1;
	    var salesOrdNo = selectedItems[0].item.salesOrdNo;
	    var salesOrdId = selectedItems[0].item.asSoId;
	    //var refReqst = selectedItems[0].item.refReqst;
	    var rcdTms = selectedItems[0].item.rcdTms;
	    //var asRst = selectedItems[0].item.c3;


	    //if (asRst != '-') {
	      //Common.alert("<spring:message code='service.msg.asAddHvRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
	      //return;
	    //}

	     if (asStusId != "ACT") {
	      Common.alert("<spring:message code='service.msg.asAddHvRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
	      return;
	    }

	    Common.ajax("POST", "/services/as/selRcdTms.do", {
	        asNo : asNo,
	        asId : asId,
	        salesOrdNo : salesOrdNo,
	        salesOrderId : salesOrdId,
	        rcdTms : rcdTms
	    }, function(result) {
	      if (result.code == "99") {
	        Common.alert(result.message);
	        return;
	      } else {
	        var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asId + /* "&refReqst=" + refReqst +  "&as_Rst=" + asRst +*/ "&rcdTms=" + rcdTms;
	        Common.popupDiv("/ResearchDevelopment/TestResultNewResultPop.do" + param, null, null, true, '_newASResultDiv1');
	      }
	    });
	  }

	function fn_TestResultViewPop() {
		var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

		if (selectedItems.length <= 0) {
			Common.alert("<spring:message code='service.msg.NoRcd'/>");
			return;
		}

		if (selectedItems.length > 1) {
			Common.alert("<spring:message code='service.msg.onlyPlz'/>");
			return;
		}

		var asid = selectedItems[0].item.asId;
		var asNo = selectedItems[0].item.asNo;
		var asStusId = selectedItems[0].item.code1;
		var salesOrdNo = selectedItems[0].item.salesOrdNo;
		var salesOrdId = selectedItems[0].item.asSoId;
		var asResultNo = selectedItems[0].item.c3;

		if (asStusId == "ACT") {
			Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>"
							+ asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
			return;
		}

		if (asResultNo == "") {
			Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>"
							+ asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
			return;
		}

		var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asid
				+ "&mod=RESULTVIEW&as_Result_No=" + asResultNo;

		Common.popupDiv("/ResearchDevelopment/TestResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
	}

	function fn_asResultEditPop(ind) {
		var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

		if (selectedItems.length <= 0) {
			Common.alert("<spring:message code='service.msg.NoRcd'/>");
			return;
		}

		if (selectedItems.length > 1) {
			Common.alert("<spring:message code='service.msg.onlyPlz'/>");
			return;
		}

		var asId = selectedItems[0].item.asId;
		var asNo = selectedItems[0].item.asNo;
		var asStusId = selectedItems[0].item.code1;
		var salesOrdNo = selectedItems[0].item.salesOrdNo;
		var salesOrdId = selectedItems[0].item.asSoId;
		var asResultNo = selectedItems[0].item.c3;
		var asResultId = selectedItems[0].item.asResultId;
		var rcdTms = selectedItems[0].item.rcdTms;
		var updDt = selectedItems[0].item.asSetlDt;
		var lstUpdDt = selectedItems[0].item.asResultCrtDt;

		if (asResultNo == "-") {
			Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>"	+ asNo +
					"</b>' htmlEscape='false' argumentSeparator=';' />");
			return;
		}

		if (ind == 0) {
			if (asStusId != "RCL") {
				if (updDt != "" && updDt != null) {
					var stat = true;
					var sDate = new Date(updDt);
					var tDate = new Date();
					tDate.setDate(tDate.getDate() - 7);

					var tMth = tDate.getMonth();
					var tYear = tDate.getFullYear();
					var tDay = tDate.getDate();
					var sMth = sDate.getMonth();
					var sYear = sDate.getFullYear();
					var sDay = sDate.getDate();

					if (sYear > tYear) {
						stat = true;
					} else {
						if (sMth > tMth) {
							stat = true;
						} else {
							if (sDay > tDay) {
								stat = true;
							} else {
								stat = false;
							}
						}
					}

					if (!stat) {
						Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk'/></b>");
						return;
					}
				} else if (lstUpdDt != "" && lstUpdDt != null) {
					var stat = true;
					var sDate = new Date(lstUpdDt);
					var tDate = new Date();
					tDate.setDate(tDate.getDate() - 7);

					var tMth = tDate.getMonth();
					var tYear = tDate.getFullYear();
					var tDay = tDate.getDate();
					var sMth = sDate.getMonth();
					var sYear = sDate.getFullYear();
					var sDay = sDate.getDate();

					if (sYear > tYear) {
						stat = true;
					} else {
						if (sMth > tMth) {
							stat = true;
						} else {
							if (sDay > tDay) {
								stat = true;
							} else {
								stat = false;
							}
						}
					}

					if (!stat) {
						Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk2'/></b>");
						return;
					}
				}
			}
		}

		if (asResultNo == "") {
			Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>" + asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
			return;
		}

		Common.ajax("POST", "/services/as/selRcdTms.do", {
			asNo : asNo,
			asId : asId,
			salesOrdNo : salesOrdNo,
			salesOrderId : salesOrdId,
			rcdTms : rcdTms
		}, function(result) {
			if (result.code == "99") {
				Common.alert(result.message);
				return;
			} else {
				var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asId
					+ "&mod=RESULTEDIT&as_Result_No=" + asResultNo + "&as_Result_Id=" + asResultId;

				Common.popupDiv("/ResearchDevelopment/TestResultEditViewPop.do" + param, null, null, true, '_newASResultDiv1');
			}
		});
	}


	function fn_asResultEditBasicPop(ind) {
		var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

		if (selectedItems.length <= 0) {
			Common.alert("<spring:message code='service.msg.NoRcd'/>");
			return;
		}

		if (selectedItems.length > 1) {
			Common.alert("<spring:message code='service.msg.onlyPlz'/>");
			return;
		}

		var asId = selectedItems[0].item.asId;
		var asNo = selectedItems[0].item.asNo;
		var asStusId = selectedItems[0].item.code1;
		var salesOrdNo = selectedItems[0].item.salesOrdNo;
		var salesOrdId = selectedItems[0].item.asSoId;
		var asResultNo = selectedItems[0].item.c3;
		var asResultId = selectedItems[0].item.asResultId;
		var refReqst = selectedItems[0].item.refReqst;
		var rcdTms = selectedItems[0].item.rcdTms;
		var updDt = selectedItems[0].item.asSetlDt;
		var lstUpdDt = selectedItems[0].item.asResultCrtDt;

		// ONLY APPLICABLE TO COMPLETE AND CANCEL AS
		if (asStusId != "CAN" && asStusId != "COM") {
			Common.alert("<spring:message code='service.msg.asEdtBscChk' arguments='<b>"
							+ asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
			return;
		}

		if (asStusId == "ACT") { // STILL ACTIVE
			if (refReqst == "") {
				Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>"
								+ asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
				return;
			}
		}

		if (asResultNo == "") { // NO RESULT
			Common.alert("<spring:message code='service.msg.asEdtNoRst' arguments='<b>"
							+ asNo + "</b>' htmlEscape='false' argumentSeparator=';' />");
			return;
		}

		// CHECKING 7 DAYS ONLY MOD LEVEL CAN HELP EDIT
		if (ind == 0) {
			if (asStusId != "RCL") {
				if (updDt != "" && updDt != null) {
					var stat = true;
					var sDate = new Date(updDt);
					var tDate = new Date();
					tDate.setDate(tDate.getDate() - 7);

					var tMth = tDate.getMonth();
					var tYear = tDate.getFullYear();
					var tDay = tDate.getDate();
					var sMth = sDate.getMonth();
					var sYear = sDate.getFullYear();
					var sDay = sDate.getDate();

					if (sYear > tYear) {
						stat = true;
					} else {
						if (sMth > tMth) {
							stat = true;
						} else {
							if (sDay > tDay) {
								stat = true;
							} else {
								stat = false;
							}
						}
					}

					if (!stat) {
						Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk'/></b>");
						return;
					}
				} else if (lstUpdDt != "" && lstUpdDt != null) {
					var stat = true;
					var sDate = new Date(lstUpdDt);
					var tDate = new Date();
					tDate.setDate(tDate.getDate() - 7);

					var tMth = tDate.getMonth();
					var tYear = tDate.getFullYear();
					var tDay = tDate.getDate();
					var sMth = sDate.getMonth();
					var sYear = sDate.getFullYear();
					var sDay = sDate.getDate();

					if (tYear > sYear) {
						stat = false;
					} else {
						if (tMth > sMth) {
							stat = false;
						} else {
							if (tDay > sDay) {
								stat = false;
							} else {
								stat = true;
							}
						}
					}

					if (!stat) {
						Common.alert("<b><spring:message code='service.alert.msg.AsEditPrdChk2'/></b>");
						return;
					}
				}
			}
		}

		Common.ajax("POST", "/services/as/selRcdTms.do", { // CHECK TIMESTAMP
			asNo : asNo,
			asId : asId,
			salesOrdNo : salesOrdNo,
			salesOrderId : salesOrdId,
			rcdTms : rcdTms
		}, function(result) {
			if (result.code == "99") {
				Common.alert(result.message);
				return;
			} else {
				var param = "?ord_Id=" + salesOrdId + "&ord_No=" + salesOrdNo + "&as_No=" + asNo + "&as_Id=" + asId
						+ "&mod=edit&as_Result_No=" + asResultNo + "&as_Result_Id=" + asResultId;

				Common.popupDiv("/ResearchDevelopment/TestResultEditBasicPop.do" + param, null, null, true, '_newASResultBasicDiv1');
			}
		});
	}

	function fn_excelDown() {
		// type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
		GridCommon.exportTo("grid_wrap_asList", "xlsx", "AS Management");
	}

	function f_multiCombo() {
		$(function() {
			$('#cmbbranchId').change(function() {

			}).multipleSelect({
				selectAll : true, // 전체선택
				width : '80%'
			});
		});
	}
</script>
<section id="content">
	<!-- content start -->
	<ul class="path">
		<!-- <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>Sales</li>
  <li>Order list</li> -->
	</ul>
	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>After PEX Test Result</h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
				<li><p class="btn_blue">
				    <a href="#" onclick="fn_newASResultPop()">
				    <spring:message code='service.btn.addtAs' /></a>
				</p></li>
			</c:if>
			<!-- FUNCTION WHICH ALLOW EDIT RECORD WHICH MORE THAN 7 DAYS -->
			<c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
				<li><p class="btn_blue">
				    <a href="#" onclick="fn_asResultEditBasicPop(0)">
				    <spring:message code='service.btn.edtBsAs' /></a>
				</p></li>
			</c:if>
			<c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">
				<li><p class="btn_blue">
				    <a href="#" onclick="fn_asResultEditPop(0)">
					<spring:message code='service.btn.edtAs' /></a>
				</p></li>
			</c:if>
			<!-- FUNCTION WHICH ALLOW EDIT RECORD WITHIN 7 DAYS -->
			<%-- <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" onclick="fn_asResultEditBasicPop(1)"><spring:message
								code='service.btn.edtBsAs' /></a>
					</p></li>
			</c:if>
			<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" onclick="fn_asResultEditPop(1)"><spring:message
								code='service.btn.edtAs' /></a>
					</p></li>
			</c:if> --%>
			<c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
				<li><p class="btn_blue">
				    <a href="#" onclick="fn_TestResultViewPop()">
				    <spring:message code='service.btn.viewAS' /></a>
				</p></li>
			</c:if>
			<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li><p class="btn_blue">
				    <a href="#" onClick="fn_searchASManagement()">
					<span class="search"></span> <spring:message code='sys.btn.search' /></a>
				</p></li>
			</c:if>
			<li><p class="btn_blue">
			    <a href="#"><span class="clear"></span>
			    <spring:message code='service.btn.Clear' /></a>
			</p></li>
		</ul>
	</aside>
	<!-- title_line end -->
	<section class="search_table">
		<!-- search_table start -->
		<form action="#" method="post" id="ASForm">
			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 150px" />
					<col style="width: *" />
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 170px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message
								code='service.title.OrderNumber' /></th>
						<td><input type="text" title=""
							placeholder="<spring:message code='service.title.OrderNumber'/>"
							class="w100p" id="orderNum" name="orderNum" /></td>
						<th scope="row"><spring:message code='service.title.ASBrch' /></th>
						<td><select class="multy_select w100p" multiple="multiple"
							id="cmbbranchId" name="cmbbranchId"></select></td>
						<th scope="row"><spring:message code='service.title.Status' /></th>
						<td><select class="multy_select w100p" multiple="multiple" id="asStatus" name="asStatus">
								<c:forEach var="list" items="${asStat}" varStatus="status">
									<c:choose>
										<c:when test="${list.codeId=='4'}">
											<option value="${list.codeId}" selected>${list.codeName}</option>
										</c:when>
										<c:otherwise>
											<option value="${list.codeId}">${list.codeName}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select></td>
					</tr>
					<tr>
						<th scope="row">Product Category</th>
						<td><select class="w100p" id="cmbCategory" name="cmbCategory" >
							</select></td>
						<th scope="row"><spring:message code='service.grid.Product' /></th>
						<td><select class="multy_select w100p" multiple="multiple" id="asProduct" name="asProduct">
						  <c:forEach var="list" items="${asProduct}" varStatus="status">
						      <option value="${list.stkId}">${list.stkDesc}</option>
						  </c:forEach>
						</select></td>
						<th scope="row">Test Result Number</th>
						<td>
						<input type="text" title="" placeholder="Test Result Number" class="w100p" id="TestResultNo" name="TestResultNo" /></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code='service.grid.SettleDate' /></th>
						<td><div class="date_set w100p"><p>
						  <input type="text" title="Create start Date"
							 placeholder="DD/MM/YYYY" class="j_date" id="settleDtFrm" name="settleDtFrm" /></p>
						  <span><spring:message code='pay.text.to' /></span>
						  <p><input type="text" title="Create end Date"
							 placeholder="DD/MM/YYYY" class="j_date" id="settleDtTo" name="settleDtTo" /></p>
						</div></td>
						<th scope="row"></th>
						<td></td>
						<th scope="row"></th>
						<td></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->
			<ul class="right_btns">
				<c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
					<li><p class="btn_grid">
							<a href="#" onClick="fn_excelDown()"><spring:message
									code='service.btn.Generate' /></a>
						</p></li>
				</c:if>
			</ul>
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap_asList"
					style="width: 100%; height: 500px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->
		</form>
		<form action="#" id="reportForm" method="post">
			<!--  <input type="hidden" id="V_RESULTID" name="V_RESULTID" /> -->
			<input type="hidden" id="v_serviceNo" name="v_serviceNo" /> <input
				type="hidden" id="v_invoiceType" name="v_invoiceType" /> <input
				type="hidden" id="reportFileName" name="reportFileName" /> <input
				type="hidden" id="viewType" name="viewType" /> <input type="hidden"
				id="reportDownFileName" name="reportDownFileName"
				value="DOWN_FILE_NAME" />
		</form>
		<form id='reportFormASLst' method="post" name='reportFormASLst'
			action="#">
			<input type='hidden' id='reportFileName' name='reportFileName' /> <input
				type='hidden' id='viewType' name='viewType' /> <input type='hidden'
				id='reportDownFileName' name='reportDownFileName' /> <input
				type='hidden' id='V_TEMP' name='V_TEMP' />
		</form>
	</section>
	<!-- search_table end -->
</section>
<!-- content end -->
