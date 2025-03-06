<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
	var callStusCode;
	var callStusId;
	var salesOrdId;
	var callEntryId;
	var salesOrdNo;
	var rcdTms;
	  var waStusCodeId;
	  var waStusDesc;
	  var callCrtDt;

	// Empty Set
	var emptyData = [];
	var myGridID;

	//Start AUIGrid
	$(document)
			.ready(
					function() {
						// SET COMBO DATA
						// APPLICATION CODE
						doGetComboOrder('/common/selectCodeList.do', '10',
								'CODE_ID', '', 'listAppType', 'M',
								'fn_multiCombo'); //Common Code
						// HDC CODE
						doGetComboSepa('/common/selectBranchCodeList.do',
                                '6672', ' - ', '', 'listDSCCode', 'M',
                                'fn_multiCombo'); //Branch Code
						// DSC CODE
						doGetComboSepa('/common/selectBranchCodeList.do',
                                '11', ' - ', '', 'listDSCCode2', 'M',
                                'fn_multiCombo');
						/* doGetComboSepa('/homecare/selectHomecareAndDscBranchList.do',
								'', ' - ', '', 'listDSCCode', 'M',
								'fn_multiCombo'); */  //Branch Code
						// STATE CODE
						doGetCombo('/callCenter/getstateList.do', '', '',
								'ordStatus', 'S', '');
						// AREA CODE
						doDefCombo(emptyData, '', 'ordArea', 'S', '');
						// Product Code
						doGetComboAndGroup2('/common/selectProductCodeList.do',
								{
									selProdGubun : 'HC'
								}, '', 'product', 'M', 'fn_setOptGrpClass');//product 생성 - Only Homecare
						// PROMOTION
						doGetComboOrder('/callCenter/selectPromotionList.do',
								'', 'CODE_ID', '', 'callLogPromotionList', 'M',
								'fn_multiCombo'); //Common Code
						$("#ordStatus")
								.change(
										function() {
											$("#ordArea").find('option').each(
													function() {
														$(this).remove();
													});

											if ($(this).val().trim() == "") {
												doDefCombo(emptyData, '',
														'ordArea', 'S', '');
												return;
											}
											doGetCombo(
													'/callCenter/getAreaList.do',
													$(this).val(), '',
													'ordArea', 'S', '');
										});

						// AUIGrid 그리드를 생성합니다.
						orderCallListGrid();

						AUIGrid
								.bind(
										myGridID,
										"rowAllChkClick",
										function(event) {
											if (event.checked) {
												var uniqueValues = AUIGrid
														.getColumnDistinctValues(
																event.pid,
																"appTypeId");
												if (uniqueValues
														.indexOf("5764") != -1) {
													uniqueValues
															.splice(
																	uniqueValues
																			.indexOf("5764"),
																	1);
												}
												AUIGrid.setCheckedRowsByValue(
														event.pid, "appTypeId",
														uniqueValues);
											} else {
												AUIGrid.setCheckedRowsByValue(
														event.pid, "appTypeId",
														[]);
											}
										});

						AUIGrid
								.bind(
										myGridID,
										"cellDoubleClick",
										function(event) {
											callStusCode = AUIGrid
													.getCellValue(myGridID,
															event.rowIndex,
															"callStusCode");
											callStusId = AUIGrid.getCellValue(
													myGridID, event.rowIndex,
													"callStusId");
											salesOrdId = AUIGrid.getCellValue(
													myGridID, event.rowIndex,
													"salesOrdId");
											callEntryId = AUIGrid.getCellValue(
													myGridID, event.rowIndex,
													"callEntryId");
											salesOrdNo = AUIGrid.getCellValue(
													myGridID, event.rowIndex,
													"salesOrdNo");
											rcdTms = AUIGrid.getCellValue(
													myGridID, event.rowIndex,
													"rcdTms");

											waStusCodeId = AUIGrid.getCellValue(
											        myGridID, event.rowIndex,
											        "waStusCodeId");

											waStusDesc = AUIGrid.getCellValue(
											    myGridID, event.rowIndex,
											    "waStusDesc");

											callCrtDt = AUIGrid.getCellValue(
											        myGridID, event.rowIndex,
											        "crtDt");

											Common
													.popupDiv("/callCenter/viewCallResultPop.do?isPop=true&callStusCode="
															+ callStusCode
															+ "&callStusId="
															+ callStusId
															+ "&salesOrdId="
															+ salesOrdId
															+ "&callEntryId="
															+ callEntryId
															+ "&salesOrdNo="
															+ salesOrdNo
															+ "&ordNo="
															+ salesOrdNo
															+ "&salesOrderId="
															+ salesOrdId
															+ "&rcdTms="
															+ rcdTms
															+ "&branchTypeId="
															+ "${branchTypeId}");
										});

						/* AUIGrid.bind(myGridID, "cellClick", function(event) {
						    callStusCode = AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusCode");
						    callStusId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusId");
						    salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
						    callEntryId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callEntryId");
						    salesOrdNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
						    rcdTms = AUIGrid.getCellValue(myGridID, event.rowIndex, "rcdTms");
						}); */
					});

	function fn_setOptGrpClass() {
	    $("optgroup").attr("class" , "optgroup_text");
		fn_multiCombo();
	}

	function fn_disableGroupOption(){
	    $('.optgroup').children('input').attr("disabled","disabled");
	}

	function fn_multiCombo() {
		$('#listAppType').change(function() {

		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});

		$('#listDSCCode').change(function() {

        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '100%'
        });

		$('#listDSCCode2').change(function() { // Added by Hui Ding

        }).multipleSelect({
            selectAll : true, // 전체선택
            width : '100%'
        });

		$('#callLogPromotionList').change(function() {//Added by Keyi
		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});

		$('#searchFeedBackCode').change(function() { //Added by Keyi
		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});

		$('#waStusCodeId').change(function() { //Added by Frango
		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});

		$('#product').change(function(event) { //Added by Frango
			event.preventDefault();
			fn_disableGroupOption();
			$('#product').next().find('.placeholder').text('');
			$('#product').next().find('.placeholder').text($("#product option:selected").text());
		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});
	}

	function fn_orderCallList() {
		if ($("#orderNo").val() == "") {
			if ($("#createDate").val() == "" || $("#endDate").val() == "") {
				Common.alert("<spring:message code='service.msg.ordNoDtReq'/>");
				return;
			}
		}

		Common.ajax("GET",
				"/homecare/services/install/searchHcOrderCallList.do", $(
						"#orderCallSearchForm").serialize(), function(result) {
					AUIGrid.setGridData(myGridID, result);
				});
	}

	function fn_openAddCall() {
		var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
		if (selectedItems.length == 0) {
			// NO DATA SELECTED.
			Common.alert("<spring:message code='service.msg.NoRcd'/> ");
			return;
		}

		if (selectedItems.length > 1) {
			// ONLY SELECT ONE ROW PLEASE
			Common.alert("<b><spring:message code='service.msg.onlyPlz'/><b>");
			return;
		}

		if ('${SESSION_INFO.userTypeId}' == '5758'
				&& selectedItems.item.vrifyFlg != 1) {
			Common.alert("Not allowed");
			return;
		}

		callStusCode = selectedItems[0].item.callStusCode;
		callStusId = selectedItems[0].item.callStusId;
		salesOrdId = selectedItems[0].item.salesOrdId;
		callEntryId = selectedItems[0].item.callEntryId;
		salesOrdNo = selectedItems[0].item.salesOrdNo;
		rcdTms = selectedItems[0].item.rcdTms;

        waStusCodeId = selectedItems[0].item.waStusCodeId;
        waStusDesc = selectedItems[0].item.waStusDesc;
        callCrtDt = selectedItems[0].item.crtDt;

//   	  if(waStusCodeId == "44" && callStusId == "1"){
//           var todayDate = new Date();
//           var crtDateExpiry = new Date(callCrtDt);
//           crtDateExpiry.setDate(crtDateExpiry.getDate() + 1);

// 			if(todayDate <= crtDateExpiry) {
// 			      Common.alert("Pending Whatsapp Appointment Confirmation.");
// 		          return;
// 			}
// 	  }

		if (callStusId == "1" || callStusId == "19" || callStusId == "30") {
			Common
					.ajax(
							"POST",
							"/callCenter/selRcdTms.do",
							{
								callStusCode : callStusCode,
								callStusId : callStusId,
								salesOrdId : salesOrdId,
								callEntryId : callEntryId,
								salesOrdNo : salesOrdNo,
								salesOrderId : salesOrdId,
								rcdTms : rcdTms
							},
							function(result) {
								if (result.code == "99") { // fail
									Common.alert(result.message);
									return;
								} else { // success
									Common
											.popupDiv(
													"/homecare/services/install/hcAddCallLogResultPop.do",
													{
														callStusCode : callStusCode,
														callStusId : callStusId,
														salesOrdId : salesOrdId,
														callEntryId : callEntryId,
														salesOrdNo : salesOrdNo,
														salesOrderId : salesOrdId,
														ordNo : salesOrdNo,
														rcdTms : rcdTms,
														branchTypeId : "${branchTypeId}"
													});
								}
							});
		} else if (callStusId == "10") {
			Common.alert("<spring:message code='service.msg.callLogCan'/> ");
		} else if (callStusId == "20") {
			Common.alert("<spring:message code='service.msg.callLogRDY'/> ");
		} else {
			Common.alert("<spring:message code='service.msg.selectRcd'/> ");
		}
	}

	function orderCallListGrid() {
		var columnLayout = [ {
			dataField : "callTypeCode",
			headerText : '<spring:message code="service.grid.Type" />',
			editable : false,
			width : 90
		}, {
			dataField : "callStusCode",
			headerText : '<spring:message code="service.grid.Status" />',
			editable : false,
			width : 90
		},{
		       dataField : "waStusDesc",
		       headerText : 'WA Status',
		       editable : false,
		       width : 100
		    },{
		      dataField : "waStusCode",
		      headerText : "",
		      width : 0
		    },{
		      dataField : "waStusCodeId",
		      headerText : "",
		      width : 0
		    },{
		        dataField : "waRemarks",
		        headerText : 'WA Remarks',
		        editable : false,
		        width : 100
		    },{
            dataField : "c3",
            headerText : 'Order key in date',
            dataType: "date",
            formatString: "dd/mm/yyyy",
            editable : false,
            width : 120
        },
        {
            dataField : "callLogEntryDate",
            headerText : 'Call Log Entry Date',
            /* dataType: "date",
            formatString: "dd/mm/yyyy", */
            editable : false,
            width : 120
        },{
			dataField : "callLogDt",
			headerText : '<spring:message code="service.grid.Date" />',
			dataType: "date",
            formatString: "dd/mm/yyyy",
			editable : false,
			width : 130
		}, {
			dataField : "bndlNo",
			headerText : 'BNDL No.',
			editable : false,
			width : 120
		}, {
			dataField : "salesOrdNo",
			headerText : '<spring:message code="service.grid.OrderNo" />',
			editable : false,
			width : 120
		},{
            dataField : "feedBack",
            headerText : '<spring:message code="service.title.FeedbackCode" />',
            editable : false,
            width : 150
        }, {
			dataField : "appTypeName",
			headerText : '<spring:message code="service.grid.AppType" />',
			editable : false,
			style : "my-column",
			width : 100
		}, {
			dataField : "productCode",
			headerText : '<spring:message code="service.grid.Product" />',
			editable : false,
			width : 280
		}, {
			dataField : "custName",
			headerText : '<spring:message code="service.grid.Customer" />',
			editable : false,
			width : 180
		}, {
			dataField : "state",
			headerText : '<spring:message code="service.grid.State" />',
			editable : false,
			width : 180
		}, {
			dataField : "area",
			headerText : '<spring:message code="service.grid.Area" />',
			editable : false,
			width : 180
		}, {
			dataField : "postcode",
			headerText : '<spring:message code="service.grid.PostCode" />',
			editable : false,
			width : 100
		}, {
			dataField : "dscCode",
			headerText : '<spring:message code="service.grid.Branch" />',
			editable : false,
			width : 150
		},{ // added for HA & HC branch code enhancement - Hui Ding, 5/3/2024
            dataField : "dscCode2",
            headerText : '<spring:message code="service.title.DSCBranch" />',
            editable : false,
            width : 150
        }, {
			dataField : "isWaitCancl",
			headerText : '<spring:message code="service.grid.WaitCancel" />',
			editable : false,
			width : 100
		}, {
			dataField : "vrifyFlg",
			headerText : 'vrify_Flg',
			editable : false,
			width : 100
		}, {
			dataField : "callStusId",
			width : 0
		}, {
			dataField : "salesOrdId",
			width : 0
		}, {
			dataField : "callEntryId",
			width : 0
		}, {
			dataField : "rcdTms",
			width : 0
		}, {
			dataField : "appTypeId",
			width : 0
		}, {
            dataField : "ordStusCodeId",
            width : 0
        },{
            dataField : "crtDt",
            headerText : "",
            width : 0
        }];

		var gridPros = {
			usePaging : true,
			pageRowCount : 20,
			showRowCheckColumn : true,
			independentAllCheckBox : true,
			showRowAllCheckBox : true,
			editable : false,
			showStateColumn : false,
			displayTreeOpen : true,
			headerHeight : 30,
			skipReadonlyColumns : true,
			wrapSelectionMove : true,
			showRowNumColumn : true,
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if (item.appTypeId == "5764" && !(item.ordStusCodeId == "25" && item.callTypeCode == "EXC")) { // AUX가  아닌 경우 체크박스 disabeld 처리함
					return false; // false 반환하면 disabled 처리됨
				}
				return true;
			}
		};

		myGridID = AUIGrid
				.create("#grid_wrap_callList", columnLayout, gridPros);
	}

	function fn_excelDown() {
		// type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
		GridCommon.exportTo("grid_wrap_callList", "xlsx",
				"Order Call Log Search");
	}

	function fn_clear() {
		$("#orderCallSearchForm").find("input, select").val("");
		// 		$("#searchFeedBackCode").val("");
		// 		$("#callLogPromotionList").val("");
	}
</script>
<section id="content">
	<spring:message code="service.placeHolder.ordNo" var="ordNo" />
	<spring:message code="service.placeHolder.dtFmt" var="dtFmt" />
	<spring:message code="service.placeHolder.custId" var="custId" />
	<spring:message code="service.placeHolder.custNm" var="custNm" />
	<spring:message code="service.placeHolder.unqNo" var="unqNo" />
	<spring:message code="service.placeHolder.contcNo" var="contcNo" />
	<spring:message code="service.placeHolder.poNo" var="poNo" />
	<spring:message code="service.title.strDt" var="crtDt" />
	<spring:message code="service.title.endDt" var="endDt" />

	<!-- content start -->
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>
	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#none" class="click_add_on">My menu</a>
		</p>
		<h2>
			<spring:message code='service.title.OrderCallLogSearch' />
		</h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
				<li>
					<p class="btn_blue">
						<a href="#none" onClick="fn_openAddCall()"><spring:message
								code='service.btn.addCallLogResult' /></a>
					</p>
				</li>
			</c:if>
			<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li>
					<p class="btn_blue">
						<a href="#none" onClick="javascript:fn_orderCallList()"><span
							class="search"></span> <spring:message code='sys.btn.search' /></a>
					</p>
				</li>
			</c:if>
			<li>
				<p class="btn_blue">
					<a href="#none" onClick="javascript:fn_clear()"><span
						class="clear"></span> <spring:message code='sys.btn.clear' /></a>
				</p>
			</li>
		</ul>
	</aside>
	<!-- title_line end -->
	<section class="search_table">
		<!-- search_table start -->
		<form action="#" method="post" id="orderCallSearchForm"
			autocomplete=off>
			<input type="hidden" name="branchTypeId" value="${branchTypeId}" />
			<!-- table start -->
			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 150px" />
					<col style="width: *" />
					<col style="width: 150px" />
					<col style="width: *" />
					<col style="width: 150px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message code='service.title.OrderNo' /><span
							name="m1" id="m1" class="must">*</span></th>
						<td><input type="text" title="" placeholder="${ordNo}"
							class="w100p" id="orderNo" name="orderNo" /></td>
						<th scope="row"><spring:message
								code='service.title.ApplicationType' /></th>
						<td><select class="multy_select w100p" multiple="multiple"
							id="listAppType" name="appType"></select></td>
						<th scope="row"><spring:message
								code='service.title.OrderDate' /><span name="m1" id="m1"
							class="must">*</span></th>
						<td>
							<div class="date_set">
								<!-- date_set start -->
								<p>
									<input type="text" title="${crtDt}" placeholder="${dtFmt}"
										class="j_dateHc" id="createDate" name="createDate" />
								</p>
								<span>To</span>
								<p>
									<input type="text" title="${endDt}" placeholder="${dtFmt}"
										class="j_dateHc" id="endDate" name="endDate" />
								</p>
							</div> <!-- date_set end -->
						</td>
					</tr>
					<tr>
						<th scope="row"><spring:message code='service.title.State' /></th>
						<td><select class="w100p" id="ordStatus" name="ordStatus"></select></td>
						<th scope="row"><spring:message code='service.title.Area' /></th>
						<td><select class="w100p" id="ordArea" name="ordArea"></select></td>
						<th scope="row"><spring:message code='service.title.Product' /></th>
						<td><select class="w100p" id="product" name="product"></select>
						</td>
					</tr>
					<tr>
						<th scope="row"><spring:message
								code='service.title.CallLogType' /></th>
						<td><select class="multy_select w100p" multiple="multiple"
							id="callLogType" name="callLogType">
								<c:forEach var="list" items="${callLogTyp}" varStatus="status">
									<c:choose>
										<c:when test="${list.code=='257'}">
											<option value="${list.code}" selected>${list.codeName}</option>
										</c:when>
										<c:otherwise>
											<option value="${list.code}">${list.codeName}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select></td>
						<th scope="row"><spring:message
								code='service.title.CallLogStatus' /></th>
						<td><select class="multy_select w100p" multiple="multiple"
							id="callLogStatus" name="callLogStatus">
								<c:forEach var="list" items="${callLogSta}" varStatus="status">
									<c:choose>
										<c:when test="${list.code=='1' || list.code=='19'}">
											<option value="${list.code}" selected>${list.codeName}</option>
										</c:when>
										<c:otherwise>
											<option value="${list.code}">${list.codeName}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select></td>
						<th scope="row"><spring:message
								code='service.title.CallLogDate' /></th>
						<td>
							<div class="date_set">
								<!-- date_set start -->
								<p>
									<input type="text" title="${crtDt}" placeholder="${dtFmt}"
										class="j_dateHc" id="callStrDate" name="callStrDate" />
								</p>
								<span>To</span>
								<p>
									<input type="text" title="${endDt}" placeholder="${dtFmt}"
										class="j_dateHc" id="callEndDate" name="callEndDate" />
								</p>
							</div> <!-- date_set end -->
						</td>
					</tr>
					<tr>
						<th scope="row"><spring:message
								code='service.title.CustomerID' /></th>
						<td><input type="text" title="" placeholder="${custId}"
							class="w100p" id="custId" name="custId" /></td>
						<th scope="row"><spring:message
								code='service.title.CustomerName' /></th>
						<td><input type="text" title="" placeholder="${custNm}"
							class="w100p" id="custName" name="custName" /></td>
						<th scope="row"><spring:message
								code='service.title.NRIC_CompanyNo' /></th>
						<td><input type="text" title="" placeholder="${unqNo}"
							class="w100p" id="nricNo" name="nricNo" /></td>
					</tr>
					<tr>
						<th scope="row"><spring:message
								code='service.title.ContactNo' /></th>
						<td><input type="text" title="" placeholder="${contcNo}"
							class="w100p" id="contactNo" name="contactNo" /></td>
						<th scope="row">HCD Code</th>
						<td><select class="select w100p" id="listDSCCode"
							name="DSCCode"></select></td>
						<th scope="row"><spring:message code='service.title.PONumber' /></th>
						<td><input type="text" title="" placeholder="${poNo}"
							class="w100p" id="PONum" name="PONum" /></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code='service.title.SortBy' /></th>
						<td><select class="w100p" id="sortBy" name="sortBy">
								<c:forEach var="list" items="${callLogSrt}" varStatus="status">
									<c:choose>
										<c:when test="${list.code=='4'}">
											<option value="${list.code}" selected>${list.codeName}</option>
										</c:when>
										<c:otherwise>
											<option value="${list.code}">${list.codeName}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
						</select></td>
						<th scope="row">DSC Code</th>
                        <td><select class="select w100p" id="listDSCCode2"
                            name="DSCCode2"></select></td>
						<th scope="row">Bundle Number</th>
						<td><input type="text" title="bndlNo" id="bndlNo"
							name="bndlNo" placeholder="Bundle Number" class="w100p" /></td>

					</tr>
					<tr>
						<th scope="row">Promotion Code</th> <!-- Added by Keyi  -->
						<td><select class="multy_select w100p" multiple="multiple"
							id="callLogPromotionList" name="promotion">

								<%--    <c:forEach var="list" items="${promotionList}" varStatus="status">
         <option value="${list.promoId}">${list.c1}</option>
        </c:forEach> --%>
						</select></td>
						<th scope="row">Feedback Code</th><!-- Added by Keyi  -->
						<td><select class="w100p" id="searchFeedBackCode"
							name="searchFeedBackCode" multiple>
								<option value=""><spring:message
										code='service.title.FeedbackCode' /></option>
								<c:forEach var="list" items="${callStatus}" varStatus="status">
									<option value="${list.resnId}">${list.c1}</option>
								</c:forEach>
						</select></td>
						<th scope="row">is e-Commerce</th> <!-- Added by Keyi  -->
						<td><input id="isECommerce" name="isECommerce"
							type="checkbox" /></td>
					</tr>
				     <tr>
				     	<th scope="row">WA Status</th>
						<td>
					    <select id="waStusCodeId" name="waStusCodeId" class="multy_select w100p" multiple="multiple">
				               <option value="44">Pending</option>
				               <option value="134">Follow-up</option>
				               <option value="4">Confirm</option>
				               <option value="21">Failed</option>
				        </select>
						</td>
						<th></th>
						<td></td>
						<th></th>
						<td></td>
				     </tr>
				</tbody>
			</table>
			<!-- table end -->
		</form>
	</section>
	<!-- search_table end -->

	<section class="search_result">
		<!-- search_result start -->
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
				<li>
					<p class="btn_grid">
						<a href="#none" onClick="fn_excelDown()"><spring:message
								code='service.btn.Generate' /></a>
					</p>
				</li>
			</c:if>
		</ul>
		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="grid_wrap_callList"
				style="width: 100%; height: 500px; margin: 0 auto;"></div>
		</article>
		<!-- grid_wrap end -->
	</section>
	<!-- search_result end -->
</section>
<!-- content end -->
