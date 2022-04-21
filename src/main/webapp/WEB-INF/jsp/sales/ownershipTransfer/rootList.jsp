<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	var rotID, rotNo, rotOrdId, rotOrdNo, ccpID;
	var search_rootGridID;
	var ownershipTransferColumn = [ {
		dataField : "rotId",
		visible : false,
	}, {
		dataField : "rotOrdId",
		visible : false
	}, {
		dataField : "ccpId",
		visible : false
	}, {
		dataField : "rotNo",
		headerText : "ROT<Br> No",
		width : 90
	}, {
		dataField : "rotOrdNo",
		headerText : "Order<Br> No",
		width : 90
	}, {
		dataField : "rotAppType",
		headerText : "Application<br> Type",
		width : 90
	}, {
		dataField : "rotOldCustId",
		headerText : "Original CID",
		width : 110
	}, {
		dataField : "oldCustName",
		headerText : "Original<Br> Customer Name",
		width: 180
	}, {
		dataField : "rotNewCustId",
		headerText : "New CID",
		width : 90
	}, {
		dataField : "newCustName",
		headerText : "New<Br> Customer Name",
		width :150
	}, {
		dataField : "rotStus",
		headerText : "Status",
		width : 70
	}, {
		dataField : "rotReqDt",
		headerText : "Request Date<Br> (ROOT Key In <Br>User)",
		width : 140
	}, {
		dataField : "rotFeedbackCode",
		headerText : "ROT<Br> FB Code",
		width : 140
	}, {
		dataField : "ccpRem",
		headerText : "ROT<Br> Remark",
		width : 140
	}, {
		dataField : "rotUpdDt",
		headerText : "Last Update<Br> At (By)",
		width : 140
	} ];

	var ownershipTransferGridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
//            selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 60,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            wordWrap :  true
        };

	$(document).ready(
			function() {
				console.log("ready :: rotList");
				//rootGridID = GridCommon.createAUIGrid("grid_wrap", ownershipTransferColumn, '', ownershipTransferGridPros);
				search_rootGridID = AUIGrid.create("#search_grid_wrap",
						ownershipTransferColumn, ownershipTransferGridPros);


				doGetComboSepa('/common/selectBranchCodeList.do', '1', ' - ',
						'', 'rotReqBrnch', 'M', 'fn_multiCombo'); //Branch Code
				doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',
						'', 'rotAppType', 'M', 'fn_multiCombo'); //Common Code
				doGetComboOrder('/sales/ownershipTransfer/selectStatusCode.do',
						'', '', '', 'rotStus', 'M', 'fn_multiCombo'); //Status Code
				doGetComboCodeId('/common/selectReasonCodeList.do',
						{typeId : '6242', separator : ' - ', inputId : ''}, '', 'rotFeedbackCode', 'M', 'fn_multiCombo'); //Feedback Code

				$("#search").click(fn_searchROT);
				$("#requestROT").click(fn_requestROTSearchOrder);
				$("#updateROT").click(fn_updateROT);
				//$("#search_requestor_btn").click(fn_supplierSearchPop);
				$("#newAS").click(fn_newAS);
				$("#rootRawData").click(fn_rootRawData);
			    $('#search_requestor_btn').click(function() {
			        //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
			        Common.popupDiv("/common/memberPop.do", $("#root_searchForm").serializeJSON(), null, true);
			    });
				fn_setGridEvent();
			});



	function fn_setGridEvent() {
		AUIGrid.bind(search_rootGridID, "cellDoubleClick", function(e) {
	        if (rotId != "" && rotId != null) {
	            var data = {
	                rotId : rotId,
	                rotNo : rotNo,
	                salesOrdId : rotOrdId,
	                salesOrdNo : rotOrdNo,
	                ccpId : ccpID
	            };

	            Common.popupDiv("/sales/ownershipTransfer/updateROT.do", data,
	                    null, true, "fn_updateROT");
	        }
		});
        AUIGrid.bind(search_rootGridID, "cellClick", function(e) {
            console.log("rootList :: cellClick :: rowIndex :: " + e.rowIndex);
            console.log("rootList :: cellClick :: rotId :: " + e.item.rotId);
            console.log("rootList :: cellClick :: rotNo :: " + e.item.rotNo);
            rotId = e.item.rotId;
            rotNo = e.item.rotNo;
            rotOrdId = e.item.rotOrdId;
            rotOrdNo = e.item.rotOrdNo;
            ccpID = e.item.ccpId;
        });
	}

	function fn_multiCombo() {
		$('#rotReqBrnch').change(function() {
			//console.log($(this).val());
		}).multipleSelect({
            selectAll : true, // 전체선택
            width : '100%'});

		$('#rotAppType').change(function() {
			//console.log($(this).val());
		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});
		$('#rotAppType').multipleSelect("checkAll");

		$('#rotStus').change(function() {
			//console.log($(this).val());
		}).multipleSelect({
			selectAll : true, // 전체선택
			width : '100%'
		});

	    $('#rotFeedbackCode').change(function() {
	        //console.log($(this).val());
	    }).multipleSelect({
	        selectAll : true, // 전체선택
	        width : '100%'
	    });
	}

// 	function fn_supplierSearchPop() {
// 		Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {
// 			accGrp : "VM10"
// 		}, null, true, "supplierSearchPop");
// 	}

// 	function fn_setSupplier() {
// 		$("#requestorID").val($("#search_memAccId").val());
// 		$("#requestorName").val($("#search_memAccName").val());
// 		$("#requestorInfo").val(
// 				$("#search_memAccId").val() + " - "
// 						+ $("#search_memAccName").val());
// 	}

	// Button functions - Start
	function fn_searchROT() {
 		console.log($("#root_searchForm").serialize());
		Common.ajax("GET", "/sales/ownershipTransfer/selectRootList.do", $(
				"#root_searchForm").serialize(), function(result) {
			AUIGrid.setGridData(search_rootGridID, result);

		});
	}

	function fn_requestROT(salesOrderId) {
		console.log("fn_requestROT");
		Common.popupDiv("/sales/ownershipTransfer/requestROT.do", {
			salesOrderId : salesOrderId
		}, null, true, "requestROTPop");
	}

	function fn_requestROTSearchOrder() {
		console.log("fn_requestROTSearchOrder");
		Common.popupDiv("/sales/ownershipTransfer/requestROTSearchOrder.do",
				null, null, true, "rotOrdNoSearchPop");

	}

	function fn_requestROT_d(salesOrderId) {
		Common.popupDiv("/sales/ownershipTransfer/requestROT_d.do", {
			salesOrderId : salesOrderId
		}, null, true, "requestROT");
	}

	function fn_updateROT() {
		console.log("fn_updateROT");
		console.log(rotId);
		if (rotId != "" && rotId != null) {
			var data = {
				rotId : rotId,
				rotNo : rotNo,
				salesOrdId : rotOrdId,
				salesOrdNo : rotOrdNo,
				ccpId : ccpID
			};

			Common.popupDiv("/sales/ownershipTransfer/updateROT.do", data,
					null, true, "fn_updateROT");
		}
	}

	function fn_newAS() {
		console.log("fn_newAS");
		if (FormUtil.isNotEmpty(rotId)) {
			console.log("fn_newAS :: rotNo :: " + rotNo);
			console.log("fn_newAS :: rotOrdNo :: " + rotOrdNo);

			// Common.popupDiv("/services/as/ASReceiveEntryPop.do", {in_ordNo : rotOrdNo}, null, true, '_NewEntryPopDiv1');

			Common
					.ajax(
							"GET",
							"/services/as/searchOrderNo",
							{
								orderNo : rotOrdNo
							},
							function(result) {
								if (result == null) {
									Common
											.alert("<spring:message code='service.msg.asOrdNtFound' />");
									$("#Panel_AS")
											.attr("style", "display:none");
									return;
								} else {
									var msg = fn_checkASReceiveEntry();

									if (msg == "") {
										fn_resultASPop(result.ordId,
												result.ordNo);
									} else {
										msg += "<br/> <spring:message code='service.msg.doPrc' /> <br/>";

										Common.confirm(
												"<spring:message code='service.title.asRecvEntConf' />"
														+ DEFAULT_DELIMITER
														+ "<b>" + msg + "</b>",
												fn_resultASPop(result.ordId,
														result.ordNo));
									}
								}
							});

		} else {
			Common.alert("No record selected!");
			return false;
		}
	}

	function fn_checkASReceiveEntry() {
		Common.ajaxSync("GET", "/services/as/checkASReceiveEntry.do", {
			salesOrderNo : $("#entry_orderNo").val()
		}, function(result) {
			msg = result.message;
		});
		return msg;
	}

	// Callback function for new AS
	function fn_resultASPop(ordId, ordNo) {
		var selectedItems = AUIGrid.getCheckedRowItems(search_rootGridID);
		var mafuncId = "";
		var mafuncResnId = "";
		var asId = "";

		if (selectedItems.length > 0) {
			mafuncId = selectedItems[0].item.asMalfuncId;
			mafuncResnId = selectedItems[0].item.asMalfuncResnId;
			asId = selectedItems[0].item.asId;
		}

		var pram = "?salesOrderId=" + ordId + "&ordNo=" + ordNo + "&mafuncId="
				+ mafuncId + "&mafuncResnId=" + mafuncResnId + "&AS_ID=" + asId
				+ "&IND= 1";

		Common.popupDiv("/services/as/resultASReceiveEntryPop.do" + pram, null,
				null, true, '_resultNewEntryPopDiv1');
	}

	function fn_rootRawData() {
		Common.popupDiv("/sales/ownershipTransfer/rootRawDataPop.do", $("#root_searchForm").serializeJSON(), null, true);
		//set date portion for report download filename - start
        /* var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        if (month < 10) {
          month = "0" + month;
        }
        //set date portion for report download filename - end

        var $reportForm = $("#reportForm")[0];

        $($reportForm).empty(); //remove children

        var reportDownFileName = "ROOTRawData_" + day + month + date.getFullYear(); //report name
        var reportFileName = "/sales/ROOTRawData_Excel.rpt"; //reportFileName
        var reportViewType = "EXCEL"; //viewType

        //default input setting
        $($reportForm).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
        $($reportForm).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
        $($reportForm).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type

        //default setting
        $("#reportForm #reportFileName").val(reportFileName);
        $("#reportForm #reportDownFileName").val(reportDownFileName);
        $("#reportForm #viewType").val(reportViewType);

        //report 호출
        var option = {
            isProcedure : false, // procedure 로 구성된 리포트 인경우 필수.
        };
        Common.report("reportForm", option); */
	}



    function fn_loadOrderSalesman(memId, memCode) {
        console.log($('#btnReqOwnTrans'))
        console.log('fn_loadOrderSalesman memId:'+memId);
        console.log('fn_loadOrderSalesman memCd:'+memCode);

        fn_clearOrderSalesman();

            Common.ajax("GET", "/sales/ownershipTransfer/selectMemberByMemberIDCode1.do", {memId : memId, memCode : memCode, stus : 1, salesMen : 1}, function(memInfo) {
                console.log("print meminfo")
                console.log(memInfo.memCode)
                if(memInfo == null) {
                    Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
                    //Common.alert('<spring:message code="sal.alert.msg.memNotFoundInput" arguments="'+memCode+'"/>');
                }
                else {
                	if (typeof($('#btnReqOwnTrans').val()) == "undefined"){
                		$('#search_requestorInfo').val(memInfo.memCode);
                	}else{
	                     $('#Request_requestorInfo').val(memInfo.memCode);
	                     $('#salesmanType').val(memInfo.codeName);
	                     $('#salesmanTypeId').val(memInfo.memType);
	                     $('#salesmanNm').val(memInfo.name);
	                     $('#salesmanNric').val(memInfo.nric);
	                     $('#departCd').val(memInfo.deptCode);
	                     $('#departMemId').val(memInfo.lvl3UpId);
	                     $('#grpCd').val(memInfo.grpCode);
	                     $('#grpMemId').val(memInfo.lvl2UpId);
	                     $('#orgCd').val(memInfo.orgCode);
	                     $('#orgMemId').val(memInfo.lvl1UpId);
	                     $('#Requestor_Brnch').val(memInfo.branchName);
                	}
                }
            });
        };

    function fn_clearOrderSalesman() {
        if (typeof($('#btnReqOwnTrans').val()) == "undefined"){
            $('#search_requestorInfo').val("");
        }else{
             $('#Request_requestorInfo').val("");
             $('#salesmanType').val("");
             $('#salesmanTypeId').val("");
             $('#salesmanNm').val("");
             $('#salesmanNric').val("");
             $('#departCd').val("");
             $('#departMemId').val("");
             $('#grpCd').val("");
             $('#grpMemId').val("");
             $('#orgCd').val("");
             $('#orgMemId').val("");
             $('#Requestor_Brnch').val("");
        }
    }

    function fn_clear() {
    	document.getElementById("root_searchForm").reset();
    }

	// Button functions - End

	/*
	function fn_resetRotGrid() {
	    console.log("fn_resetRotGrid");
	    if(AUIGrid.isCreated("#grid_wrap")) {
	        AUIGrid.destroy("#grid_wrap");
	        rootGridID = null;
	        rootGridID = AUIGrid.create("#grid_wrap", ownershipTransferColumn, ownershipTransferGridPros);
	        fn_setEvent();
	    }
	}

	function fn_back(popup) {
	    console.log("fn_back");

	    if(popup == "req" || popup == "reqc") {
	        $("#reqPopup").remove();
	    } else if(popup == "ordNoSearch") {
	        $("#ordSearch_popup").remove();
	    }

	    fn_resetRotGrid();
	    fn_searchROT();
	}
	 */
</script>

<section id="content">
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>Sales</li>
		<li>CCP</li>
		<li>ROOT Request</li>
	</ul>

	<!-- title_line start -->
	<aside class="title_line">
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>Rental Outright Ownership Transfer</h2>
		<ul class="right_btns">
			<li><p class="btn_blue">
					<a href="#" id="search"><span class="search"></span>
					<spring:message code="sal.btn.search" /></a>
				</p></li>
			<li><p class="btn_blue">
					<a href="#" id="requestROT">Request</a>
				</p></li>
			<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" id="updateROT">Update</a>
					</p></li>
			</c:if>
			<li><p class="btn_blue type2">
					<a href="#" onclick="fn_clear();"><span
						class="clear"></span>
					<spring:message code="sal.btn.clear" /></a>
				</p></li>
		</ul>
	</aside>
	<!-- title_line end -->

	<!-- search_table start -->
	<section class="search_table">
		<form id="root_searchForm" name="root_searchForm" action="#" method="post">
			<input type="hidden" id="requestorName" name="requestorName">
			<input type="hidden" id="requestorID" name="requestorID">

			<!-- table start -->
			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 140px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Order Number</th>
						<td><input type="text" title="Order Number" id="rotOrdNo"
							name="rotOrdNo" placeholder="Order Number" class="w100p" /></td>
						<th scope="row">Application Type</th>
						<td><select id="rotAppType" name="rotAppType" class="w100p"></select>
						</td>
						<th scope="row">Status</th>
						<td><select id="rotStus" name="rotStus" class="w100p"></select>
							<!--
                        <select class="multy_select w100p" multiple="multiple" id="rotStus" name="rotStus">
                            <option value="1" selected="selected">Active</option>
                            <option value="5" selected="selected">Approved</option>
                            <option value="6" selected="selected">Rejected</option>
                        </select>
                         --></td>
					</tr>
					<tr>
						<th scope="row">Original Customer ID</th>
						<td><input type="text" title="Existing Customer ID"
							id="oriCustID" name="oriCustID"
							placeholder="Existing Customer ID" class="w100p" /></td>
						<th scope="row">Transfer Customer ID</th>
						<td><input type="text" title="New Customer ID" id="newCustID"
							name="newCustID" placeholder="New Customer ID" class="w100p" />
						</td>
						<th scope="row">Request Date</th>
						<td>
							<!-- date_set start -->
							<div class="date_set w100p">
								<p>
									<input type="text" title="Request Start Date"
										placeholder="DD/MM/YYYY" class="j_date" id="reqStartDt"
										name="reqStartDt" />
								</p>
								<span>To</span>
								<p>
									<input type="text" title="Request End Date"
										placeholder="DD/MM/YYYY" class="j_date" id="reqEndDt"
										name="reqEndDt" />
								</p>
							</div> <!-- date_set end -->
						</td>
					</tr>
					<tr>
						<th scope="row">ROT No</th>
						<td><input type="text" title="ROT No" id="rotNo" name="rotNo"
							placeholder="ROT No" class="w100p" /></td>
						<th scope="row">ROT Requestor</th>
						<td><input type="text" title="" placeholder="Requestor ID"
							class="" style="width: 93%" id="search_requestorInfo" name="reqInfo"
							readonly /> <a href="#" class="search_btn"
							id="search_requestor_btn"><img
								src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
								alt="search" /></a></td>
						<th scope="row">Requestor Branch</th>
						<td><select id="rotReqBrnch" name="rotReqBrnch" class="w100p"></select>
						</td>
					</tr>
					<tr>
					   <th scope="row">ROT Feedback Code</th>
					   <td><select id="rotFeedbackCode" name="rotFeedbackCode" class="w100p"></select></td>
					   <th scope="row">Last Update User</th>
					   <td><input type="text" title="Last Update User" id="lastUpdateUser" name="lastUpdateUser"
					               placeholder="Last Update User" class="w100p" /></td>
                       <th scope="row">Root Key In User</th>
                       <td><input type="text" title="Root Key In User" id="rootKeyInUser" name="rootKeyInUser"
                                   placeholder="Root Key In User" class="w100p" /></td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->
		</form>
	</section>
	<!-- search_table end -->

	<!-- Link Wrap Start -->
	<article class="link_btns_wrap">
		<p class="show_btn">
			<a href="#"><img
				src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif"
				alt="link show" /></a>
		</p>
		<dl class="link_list">
			<dt>
				<spring:message code="sal.title.text.link" />
			</dt>
			<dd>
				<ul class="btns">
					<li><p class="link_btn">
							<a href="#" id="newAS">New AS</a>
						</p></li>
				    <li><p class="link_btn">
                            <a href="#" id="rootRawData">ROOT Raw Data</a>
                        </p></li>
				</ul>
				<p class="hide_btn">
					<a href="#"><img
						src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
						alt="hide" /></a>
				</p>
			</dd>
		</dl>
	</article>
	<!-- Link Wrap End -->

	<!-- search_result start -->
	<section class="search_result">
		<!-- grid_wrap start -->
		<article class="grid_wrap">
			<div id="search_grid_wrap"
				style="width: 100%; height: 480px; margin: 0 auto;"></div>
		</article>
		<!-- grid_wrap end -->
	</section>
	<!-- search_result end -->
</section>

<!-- crystal report -->
<form name="reportForm" id="reportForm" method="post"></form>

<!-- content end -->