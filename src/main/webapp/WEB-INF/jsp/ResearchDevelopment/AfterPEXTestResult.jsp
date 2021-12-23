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
	var myGridIDExcel;
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
			PEXTestResultGrid();
			PEXTestResultExcelGrid();
			doGetCombo('/services/holiday/selectBranchWithNM', 43, '','cmbbranchId', 'M', 'f_multiCombo'); // DSC BRANCH
			CommonCombo.make('cmbCategory', '/common/selectCodeList.do', {groupCode : 11,codeIn : 'WP,AP,BT,BB,MAT,FRM,POE'}, '', {type : 'M'});
		});

	function PEXTestResultGrid() {

		var columnLayout =[
		        {
					dataField : "productCategory",
					headerText : "Product Category",
					width : 110
				},
				{
                    dataField : "productCode",
                    headerText : "Product Code",
                    width : 100
                },
                {
                    dataField : "productName",
                    headerText : "Product Name",
                    width : 180
                },
				{
					dataField : "prodSerialNo",
					headerText : "Product Serial Number",
					width : 150
				},
				{
					dataField : "pexTestResultStus",
					headerText : "<spring:message code='service.grid.Status'/>",
					width : 100
				},
				{
					dataField : "pexDate",
					headerText : "PEX Date",
					width : 100,
					dataType : "date",
					formatString : "dd/mm/yyyy"
				},
				{
                    dataField : "asAging",
                    headerText : "AS Aging",
                    width : 100
                },
				{
					dataField : "orderNo",
					headerText : "<spring:message code='service.title.SalesOrder'/>",
					width : 100
				},
				{
                    dataField : "ctCode",
                    headerText : "<spring:message code='service.grid.CTCode'/>",
                    width : 100
                },
                {
                    dataField : "dscCode",
                    headerText : "CT Branch",
                    width : 100
                },
                {
                    dataField : "problemSymptomLarge",
                    headerText : "Problem Symptom Large",
                    width : 100
                },
                {
                    dataField : "problemSymptomSmall",
                    headerText : "Problem Symptom Small",
                    width : 100
                },
                {
                    dataField : "defectPartLarge",
                    headerText : "Defect Part Large",
                    width : 100
                },
                {
                    dataField : "defectPartSmall",
                    headerText : "Defect Part Small",
                    width : 100
                },
                {
                    dataField : "pexReasonCode",
                    headerText : "PEX Code",
                    width : 100
                },
                {
                    dataField : "pexReasonDesc",
                    headerText : "PEX Desc",
                    width : 150
                },
                {
                    dataField : "retNo",
                    headerText : "RET No",
                    width : 100
                },
                {
                    dataField : "pexInsNo",
                    headerText : "PEX Installation No",
                    width : 100
                },
                {
                    dataField : "testResultNo",
                    headerText : "Test Result No",
                    width : 100
                },
                {
                    dataField : "custName",
                    headerText : "Customer Name",
                    width : 200
                },
                {
                    dataField : "testResultRem",
                    headerText : "Test Result Remark",
                    width : 400
                },
				{
					dataField : "testSettleDt",
					headerText : "Test Settle Date",
					width : 100,
					dataType : "date",
					formatString : "dd/mm/yyyy"
				},
				{
                    dataField : "amp",
                    headerText : "AMP",
                    width : 100
                },
                {
                    dataField : "voltage",
                    headerText : "Voltage",
                    width : 100
                },
                {
                    dataField : "instState",
                    headerText : "State",
                    width : 100
                },
                {
                    dataField : "instCity",
                    headerText : "City",
                    width : 100
                },
                {
                    dataField : "instArea",
                    headerText : "Area",
                    width : 100
                },
                {
                    dataField : "prodGenuine",
                    headerText : "G/NG",
                    width : 100
                },
                {
		                         dataField : "soExchgId",
		                         headerText : "SO Exchange ID",
		                         width : 110,
		                         visible : false
		       },
		       {
		                         dataField : "soId",
		                         headerText : "Sales Order ID",
		                         width : 110,
		                         visible : false
		        },
		       {
		                         dataField : "testResultStus",
		                         headerText : "PEX Test Result Status ID",
		                         width : 110,
		                         visible : false
		       },
		       {
		                         dataField : "testResultId",
		                         headerText : "PEX Test Result ID",
		                         width : 110,
		                         visible : false
		       },
		       {
		                         dataField : "rcdTms",
		                         headerText : "rcdTms",
		                         width : 100,
		                         visible : false
		       }
		 ];

		var gridPros = {
			showRowCheckColumn : true,
			usePaging : true,
			pageRowCount : 20,
			showRowAllCheckBox : true,
			editable : false,
			selectionMode : "multipleCells",
			wordWrap : true
		};

		myGridID = AUIGrid.create("#grid_wrap_PEXTestResult", columnLayout, gridPros);
	}

	function PEXTestResultExcelGrid() {

        var columnLayout =[
                {
                    dataField : "productCategory",
                    headerText : "Product Category",
                    width : 110
                },
                {
                    dataField : "productCode",
                    headerText : "Product Code",
                    width : 100
                },
                {
                    dataField : "productName",
                    headerText : "Product Name",
                    width : 180
                },
                {
                    dataField : "prodSerialNo",
                    headerText : "Product Serial Number",
                    width : 150
                },
                {
                    dataField : "pexTestResultStus",
                    headerText : "<spring:message code='service.grid.Status'/>",
                    width : 100
                },
                {
                    dataField : "pexDate",
                    headerText : "PEX Date",
                    width : 100,
                    dataType : "date",
                    formatString : "dd/mm/yyyy"
                },
                {
                    dataField : "asAging",
                    headerText : "AS Aging",
                    width : 100
                },
                {
                    dataField : "orderNo",
                    headerText : "<spring:message code='service.title.SalesOrder'/>",
                    width : 100
                },
                {
                    dataField : "ctCode",
                    headerText : "<spring:message code='service.grid.CTCode'/>",
                    width : 100
                },
                {
                    dataField : "dscCode",
                    headerText : "CT Branch",
                    width : 100
                },
                {
                    dataField : "problemSymptomLarge",
                    headerText : "Problem Symptom Large",
                    width : 100
                },
                {
                    dataField : "problemSymptomSmall",
                    headerText : "Problem Symptom Small",
                    width : 100
                },
                {
                    dataField : "defectPartLarge",
                    headerText : "Defect Part Large",
                    width : 100
                },
                {
                    dataField : "defectPartSmall",
                    headerText : "Defect Part Small",
                    width : 100
                },
                {
                    dataField : "pexReasonCode",
                    headerText : "PEX Code",
                    width : 100
                },
                {
                    dataField : "pexReasonDesc",
                    headerText : "PEX Desc",
                    width : 150
                },
                {
                    dataField : "retNo",
                    headerText : "RET No",
                    width : 100
                },
                {
                    dataField : "pexInsNo",
                    headerText : "PEX Installation No",
                    width : 100
                },
                {
                    dataField : "testResultNo",
                    headerText : "Test Result No",
                    width : 100
                },
                {
                    dataField : "custName",
                    headerText : "Customer Name",
                    width : 200
                },
                {
                    dataField : "testResultRem",
                    headerText : "Test Result Remark",
                    width : 400
                },
                {
                    dataField : "testSettleDt",
                    headerText : "Test Settle Date",
                    width : 100,
                    dataType : "date",
                    formatString : "dd/mm/yyyy"
                },
                {
                    dataField : "amp",
                    headerText : "AMP",
                    width : 100
                },
                {
                    dataField : "voltage",
                    headerText : "Voltage",
                    width : 100
                },
                {
                    dataField : "instState",
                    headerText : "State",
                    width : 100
                },
                {
                    dataField : "instCity",
                    headerText : "City",
                    width : 100
                },
                {
                    dataField : "instArea",
                    headerText : "Area",
                    width : 100
                },
                {
                    dataField : "prodGenuine",
                    headerText : "G/NG",
                    width : 100
                }
         ];

        var gridPros = {
            showRowCheckColumn : true,
            usePaging : true,
            pageRowCount : 20,
            showRowAllCheckBox : true,
            editable : false,
            selectionMode : "multipleCells",
            wordWrap : true
        };

        myGridIDExcel = AUIGrid.create("#grid_wrap2", columnLayout, gridPros);
    }

	function fn_searchPEXTestResult() { // SEARCH PEX TEST RESULT

		var valid = true;
		var msg = "";

		 if ($("#settleDtFrm").val() != '' && $("#settleDtTo").val() == '') {
             msg = "Settle End Date is required.";
             valid = false;
         } else if ($("#settleDtFrm").val() == '' && $("#settleDtTo").val() != '') {
             msg = "Settle Start Date is required.";
             valid = false;
         }
		/* if ($("#TestResultNo").val() == '' && $("#orderNum").val() == '') {

			if ($("#settleDtFrm").val() == '' && $("#settleDtTo").val() == '') {
				msg = "Settle Date is required when Test Result No. and Order No. are empty.";
				valid = false;
			} else if ($("#settleDtFrm").val() != '' && $("#settleDtTo").val() == '') {
				msg = "Settle End Date is required.";
				valid = false;
			} else if ($("#settleDtFrm").val() == '' && $("#settleDtTo").val() != '') {
				msg = "Settle Start Date is required.";
				valid = false;
			} /* else if (startDate != '' && endDate != '') {
				if (!js.date.checkDateRange(startDate, endDate, "Request", "3"))
					valid = false;
			} */

		if (valid) {
			Common.ajax("GET", "/ResearchDevelopment/searchPEXTestResultList.do", $(
					"#PEXTestForm").serialize(), function(result) {
				AUIGrid.setGridData(myGridID, result);
				AUIGrid.setGridData(myGridIDExcel, result);
			});
		} else {
			Common.alert(msg);
		}
	}

	function fn_newPEXTestResultPop() {
	    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

	    if (selectedItems.length <= 0) {
	      Common.alert("<spring:message code='service.msg.NoRcd'/>");
	      return;
	    }

	    if (selectedItems.length > 1) {
	      Common.alert("<spring:message code='service.msg.onlyPlz'/>");
	      return;
	    }

	    var soExchgId = selectedItems[0].item.soExchgId;
        var pexTestResultStus = selectedItems[0].item.pexTestResultStus;
	    var testResultId = selectedItems[0].item.testResultId;
	    var testResultNo = selectedItems[0].item.testResultNo;
	    var rcdTms = selectedItems[0].item.rcdTms;

	     if (pexTestResultStus != "ACT") {
	      Common.alert("Fail to add due to selected PEX Test <b>" + testResultNo + "</b> have result.");
	      return;
	    }

	    Common.ajax("POST", "/ResearchDevelopment/selRcdTms.do", {
	    	testResultNo : testResultNo,
	        testResultId : testResultId,
	        soExchgId : soExchgId,
	        rcdTms : rcdTms
	    }, function(result) {
	      if (result.code == "99") {
	        Common.alert(result.message);
	        return;
	      } else {
	        var param = "?testResultNo=" + testResultNo + "&testResultId=" + testResultId + "&soExchgId=" + soExchgId + "&rcdTms=" + rcdTms;
	        Common.popupDiv("/ResearchDevelopment/TestResultNewResultPop.do" + param, null, null, true, '_newPEXTestResultDiv1');
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

		var soExchgId = selectedItems[0].item.soExchgId;
	    var pexTestResultStus = selectedItems[0].item.pexTestResultStus;
	    var testResultId = selectedItems[0].item.testResultId;
	    var testResultNo = selectedItems[0].item.testResultNo;
	    var rcdTms = selectedItems[0].item.rcdTms;

		if (pexTestResultStus == "ACT") {
			 Common.alert("Fail to view due to selected PEX Test <b>" + testResultNo + "</b> does not have any result.");
			return;
		}

		if (testResultNo == "") {
			Common.alert("Fail to view due to selected PEX Test <b>" + testResultNo + "</b> does not have any result.");
	        return;
		}

		var param = "?testResultNo=" + testResultNo + "&testResultId=" + testResultId + "&soExchgId=" + soExchgId
				+  "&mod=RESULTVIEW";

		Common.popupDiv("/ResearchDevelopment/TestResultEditViewPop.do" + param, null, null, true, '_newPEXTestResultDiv1');
	}

	function fn_PEXTestResultEditBasicPop(ind) {
		var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

		if (selectedItems.length <= 0) {
			Common.alert("<spring:message code='service.msg.NoRcd'/>");
			return;
		}

		if (selectedItems.length > 1) {
			Common.alert("<spring:message code='service.msg.onlyPlz'/>");
			return;
		}

		var testResultId = selectedItems[0].item.testResultId;
		var testResultNo = selectedItems[0].item.testResultNo;
		var testResultStusId = selectedItems[0].item.testResultStus;
		var pexTestResultStusCode = selectedItems[0].item.pexTestResultStus
		var orderNo = selectedItems[0].item.orderNo;
		var soExchgId = selectedItems[0].item.soExchgId;
		var rcdTms = selectedItems[0].item.rcdTms;
		var updDt = selectedItems[0].item.updDt;
		var crtDt = selectedItems[0].item.crtDt;

		// ONLY APPLICABLE TO COMPLETE
		if (pexTestResultStusCode != "COM") {
			Common.alert("Fail to edit due to selected PEX <b>" + testResultNo + "</b> are not in Complete status.");
			return;
		}

		if (pexTestResultStusCode == "ACT") { // STILL ACTIVE
			  Common.alert("Fail to edit due to selected PEX <b>" + testResultNo + "</b> does not have any result.");
				return;
		}

		if (testResultNo == "") { // NO RESULT
			Common.alert("Fail to edit due to selected PEX <b>"
							+ testResultNo + "</b> does not have any result.");
			return;
		}

		Common.ajax("POST", "/ResearchDevelopment/selRcdTms.do", { // CHECK TIMESTAMP
			testResultNo : testResultNo,
            testResultId : testResultId,
            soExchgId : soExchgId,
            rcdTms : rcdTms
		}, function(result) {
			if (result.code == "99") {
				Common.alert(result.message);
				return;
			} else {
				var param = "?testResultNo=" + testResultNo + "&testResultId=" + testResultId + "&soExchgId=" + soExchgId + "&rcdTms=" + rcdTms;
				Common.popupDiv("/ResearchDevelopment/TestResultEditBasicPop.do" + param, null, null, true, '_newPEXResultBasicDiv1');
			}
		});
	}

	 function fn_excelDown() {
		// type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("#grid_wrap2", "xlsx", "After PEX Test Result");

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

	 function fn_PEXTestRawData() {
		    Common.popupDiv("/ResearchDevelopment/PEXTestRawDataPop.do", null, null, true, '');
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
				    <a href="#" onclick="fn_newPEXTestResultPop()">
				    Add PEX Test Result</a>
				</p></li>
			</c:if>
			<!-- FUNCTION WHICH ALLOW EDIT RECORD WHICH MORE THAN 7 DAYS -->
			<li><p class="btn_blue">
		      <a href="#" onclick="fn_PEXTestResultEditBasicPop(0)">
				    Edit PEX Test Result</a>
			</p></li>
			<c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
				<li><p class="btn_blue">
				    <a href="#" onclick="fn_TestResultViewPop()">
				    View PEX Test Result</a>
				</p></li>
			</c:if>
			<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li><p class="btn_blue">
				    <a href="#" onClick="fn_searchPEXTestResult()">
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
		<form action="#" method="post" id="PEXTestForm">
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
						<th scope="row">
						<spring:message code='service.title.OrderNumber' />
						</th>
						<td>
						<input type="text" title="" placeholder="<spring:message code='service.title.OrderNumber'/>"
							class="w100p" id="orderNum" name="orderNum" />
						</td>
						<th scope="row">Branch</th>
						<td>
						<select class="multy_select w100p" multiple="multiple" id="cmbbranchId" name="cmbbranchId"></select>
						</td>
						<th scope="row">
						<spring:message code='service.title.Status' />
						</th>
						<td>
						  <select class="multy_select w100p" multiple="multiple" id="PEXTRStatus" name="PEXTRStatus">
						      <c:forEach var="list" items="${PEXTRStatus}" varStatus="status">
						          <option value="${list.codeId}">${list.codeName}</option>
						      </c:forEach>
						  </select>
						</td>
					</tr>
					<tr>
						<th scope="row">Product Category</th>
						<td>
						  <select class="w100p" id="cmbCategory" name="cmbCategory" ></select>
						</td>
						<th scope="row">
						  <spring:message code='service.grid.Product' />
						</th>
						<td>
							<select class="multy_select w100p" multiple="multiple" id="Product" name="Product">
							  <c:forEach var="list" items="${Product}" varStatus="status">
							      <option value="${list.stkId}">${list.stkDesc}</option>
							  </c:forEach>
							</select>
						</td>
						<th scope="row">Test Result Number</th>
						<td>
						  <input type="text" title="" placeholder="Test Result Number" class="w100p" id="TestResultNo" name="TestResultNo" />
						</td>
					</tr>
					<tr>
						<th scope="row">
						  <spring:message code='service.grid.SettleDate' />
						</th>
						<td>
							<div class="date_set w100p">
							<p>
							  <input type="text" title="Create start Date"
								 placeholder="DD/MM/YYYY" class="j_date" id="settleDtFrm" name="settleDtFrm" />
							</p>
							  <span><spring:message code='pay.text.to' /></span>
							  <p>
							  <input type="text" title="Create end Date"
								 placeholder="DD/MM/YYYY" class="j_date" id="settleDtTo" name="settleDtTo" />
							  </p>
							</div>
						</td>
						<th scope="row"></th>
						<td></td>
						<th scope="row"></th>
						<td></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->

			<aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn">
     <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
    </p>
    <dl class="link_list">
     <dt><spring:message code='sales.Link'/></dt>
     <dd>
      <ul class="btns">
      </ul>
      <ul class="btns">
         <li>
          <p class="link_btn type2">
           <a href="#" onclick="fn_PEXTestRawData()">PEX Test Result Raw Data</a>
          </p>
         </li>
      </ul>
      <p class="hide_btn">
       <a href="#"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
        alt="hide" /></a>
      </p>
     </dd>
    </dl>
   </aside>

			<ul class="right_btns">
				<c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
					<li><p class="btn_grid">
							<a href="#" onclick="fn_excelDown()">
							<spring:message code='service.btn.Generate' /></a>
					</p></li>
				</c:if>
			</ul>
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap_PEXTestResult" style="width: 100%; height: 500px; margin: 0 auto;"></div>
				<div id="grid_wrap2"></div>
			</article>
			<!-- grid_wrap end -->
		</form>
	</section>
	<!-- search_table end -->
</section>
<!-- content end -->
