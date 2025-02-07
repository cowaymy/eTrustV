<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  //AUIGrid 생성 후 반환 ID
    var myGridID;
    var basicAuth = false;
    var rcdTms;

    var productList = [];
    <c:forEach var="obj" items="${productList_1}">
    productList.push({codeId:"${obj.code}", codeName:"${obj.codeName}", code:"${obj.code}"});
    </c:forEach>

    $(document).ready(function() {
	    // AUIGrid 그리드를 생성합니다.
	    createAUIGrid();

	    // DT Branch CodeList 조회
 	    //doGetComboSepa('/homecare/selectHomecareBranchList.do',  '', ' - ', '', 'listDscBranchId', 'M', 'fn_multiCombo'); //Branch Code

        //doGetComboSepa('/homecare/selectHomecareAndDscBranchList.do',  '', ' - ', '',   'listDscBranchId', 'M', 'fn_multiCombo');

        doGetComboSepa('/common/selectBranchCodeList.do',  '6672', ' - ', '',   'listDscBranchId', 'M', 'fn_multiCombo');
 	    doGetComboSepa('/common/selectBranchCodeList.do',  '11', ' - ', '',   'listDscBranchId2', 'M', 'fn_multiCombo');
	    // f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
	    doGetCombo('/common/selectCodeList.do', '10', '', 'cmbAppTypeId', 'M', 'f_multiCombo'); // Application Type Combo Box

        doDefCombo(productList, '' ,'listProductId', 'M', 'fn_multiCombo');

	    // 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
		    $("#reqId").val(event.item.reqId);
		    $("#callEntryId").val(event.item.callEntryId);
		    $("#salesOrdId").val(event.item.ordId);
		    $("#typeId").val(event.item.typeId);
		    $("#docId").val(event.item.docId);
		    $("#refId").val(event.item.refId);
		    $("#paramReqStageId").val(event.item.paramReqStageId);

		    Common.popupDiv("/sales/order/cancelReqInfoPop.do", $("#detailForm").serializeJSON());
	    });

	    // 셀 클릭 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellClick", function(event) {
	    	 if( event.dataField != "attchmentDownload" ){
	        $("#reqId").val(event.item.reqId);
	        $("#callEntryId").val(event.item.callEntryId);
	        $("#salesOrdId").val(event.item.ordId);
	        $("#typeId").val(event.item.typeId);
	        $("#docId").val(event.item.docId);
	        $("#refId").val(event.item.refId);
	        $("#paramCallStusId").val(event.item.callStusId);
	        $("#paramCallStusCode").val(event.item.callStusCode);
	        $("#paramReqNo").val(event.item.reqNo);
	        $("#paramReqStusId").val(event.item.reqStusId);
	        $("#paramReqStusCode").val(event.item.reqStusCode);
	        $("#paramReqStusName").val(event.item.reqStusName);
	        $("#paramReqStageId").val(event.item.reqStageId);
	        $("#paramRsoStusId").val(event.item.rsoStus);
	        $("#paramSalesOrdNo").val(event.item.ordNo);
	        $("#appTypeId").val(event.item.appTypeId);

	        rcdTms = AUIGrid.getCellValue(myGridID, event.rowIndex, "rcdTms");
	        $("#rcdTms").val(rcdTms);
	        //gridValue = AUIGrid.getCellValue(myGridID, event.rowIndex, $("#detailForm").serializeJSON());
	    	 }
             else if( event.dataField == "attchmentDownload" ){
                     if( FormUtil.isEmpty(event.value) == false){
                       var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);

                       console.log("helloooo");
                       console.log(rowVal);
                       if( FormUtil.isEmpty(rowVal.atchFileName) == false && FormUtil.isEmpty(rowVal.physiclFileName) == false){
                         window.open("/file/fileDownWeb.do?subPath=" + rowVal.fileSubPath + "&fileName=" + rowVal.physiclFileName + "&orignlFileNm=" + rowVal.atchFileName);
                       }
                     }
                   }
	    });
	});

    function fn_multiCombo(){
        $('#listDscBranchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });

        $('#listDscBranchId2').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });

        $('#listProductId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $("#listProductId").multipleSelect("checkAll");
    }

    function createAUIGrid() {
	    // AUIGrid 칼럼 설정

	    // 데이터 형태는 다음과 같은 형태임,
	    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	    var columnLayout = [
	        {
	          dataField : "reqNo",
	          headerText : "<spring:message code='sal.title.text.reqNo' />",
	          width : 140,
	          editable : false
	        },
	        {
	            dataField : "crtDt",
	            headerText : "Request Date",
	            dataType:"date",
	            formatString:"dd/mm/yyyy",
	            width : 140,
	            editable : false
	          },
	        {
	          dataField : "reqStusCode",
	          headerText : "<spring:message code='sal.title.status' />",
	          width : 100,
	          editable : false
	        },
	        {headerText : "BNDL No.",                                              dataField : "bndlNo",               editable : false, width : 130},
	        {
	          dataField : "ordNo",
	          headerText : "<spring:message code='sal.title.ordNo' />.",
	          width : 120,
	          editable : false
	        },
	        {
	          dataField : "appTypeName",
	          headerText : "<spring:message code='sal.title.text.appType' />",
	          width : 120,
	          editable : false
	        },
	        {
	            dataField : "stockName",
	            headerText : "Product",
	            width : 120,
	            editable : false
	          },
	        {
	          dataField : "custName",
	          headerText : "<spring:message code='sal.title.text.customer' />",
	          editable : false
	        },
	        {
	          dataField : "custIc",
	          headerText : "<spring:message code='sal.title.text.nricCompNo' />",
	          width : 170,
	          editable : false
	        },
	        {
	            dataField : "reqResnDesc",
	            headerText : "Product Return Reason",
	            width : 170,
	            editable : false
	          },
	        {
	          dataField : "reqStage",
	          headerText : "<spring:message code='sal.title.text.requestStage' />",
	          editable : false
	        },
	        {
	          dataField : "callStusName",
	          headerText : "<spring:message code='sal.title.text.callStatus' />",
	          editable : false
	        },
	        {
	          dataField : "callRecallDt",
	          headerText : "<spring:message code='sal.title.text.reCallDate' />",
	          dataType : "date",
	          formatString : "dd/mm/yyyy",
	          editable : false
	        },
	        {
	          dataField : "appDt",
	          headerText : "<spring:message code='service.grid.AppntDt' />",
	          dataType : "date",
	          formatString : "dd/mm/yyyy",
	          editable : false
	        },
	        {
	          dataField : 'rsoStus',
	          headerText : 'RSO Status',
	          width : 100,
	          editable : false
	        },
	        {
	            dataField : 'assignCt',
	            headerText : 'Technician Code',
	            width : 100,
	            editable : false
	        },
	        {
	            dataField : "partnerCode",
	            headerText : "Pairing Code",
	            editable : false,
	            width : 100
	          },
	        {
	            dataField : 'hdc',
	            headerText : 'HDC',
	            width : 100,
	            editable : false
	        },
	        {
                dataField : 'dsc',
                headerText : 'DSC',
                width : 100,
                editable : false
            },
	        {
	          dataField : 'prdRtnLstUpd',
	          headerText : 'Update By',
	          width : 100,
	          editable : false
	        },
	        {dataField : "callEntryId",                    visible : false},
	        {dataField : "docId",                          visible : false},
	        {dataField : "typeId",                         visible : false},
	        {dataField : "refId",                           visible : false},
	        {dataField : "reqStusId",                     visible : false},
	        {dataField : "callStusId",                     visible : false},
	        {dataField : "callStusCode",                 visible : false},
	        {dataField : "callStusName",                visible : false},
	        {dataField : "reqStageId",                   visible : false},
	        {dataField : "rcdTms",                        visible : false},
	        {dataField : "appTypeId",                    visible : false},
	        {
	            dataField : "attchmentDownload",
	            width:100,
	            headerText : "<spring:message code='pay.head.attachment'/>",
	            renderer : { type : "ImageRenderer",
	                             width : 20,
	                             height : 20,
	                             imgTableRef : {
	                               "DOWN": "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
	                             }
	            }
	          }
        ];

	    // 그리드 속성 설정
	    var gridPros = {
            usePaging                 : true,         //페이징 사용
            pageRowCount          : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable                    : false,
            fixedColumnCount      : 1,
            showStateColumn       : false,
            displayTreeOpen        : false,
            headerHeight             : 30,
            useGroupingPanel       : false,        //그룹핑 패널 사용
            skipReadonlyColumns  : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove     : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn  : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage          : "No order found.",
            //wordWrap                  : true,
            groupingMessage       : "Here groupping"
		};

        myGridID = GridCommon.createAUIGrid("#list_grid_wrap", columnLayout, "", gridPros);
    }

    // 조회조건 combo box
    function f_multiCombo() {
        $(function() {
            $('#cmbAppTypeId').change(function() {

            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            });
            $('#cmbAppTypeId').multipleSelect("checkAll");
        });
    }

    // 리스트 조회.
    function fn_orderCancelListAjax() {
    	// 그리드 초기화.
    	// AUIGrid.setGridData(myGridID, []);

        Common.ajax("GET", "/homecare/sales/order/hcOrderCancellationList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }

    // New Log Result 버튼 Click Event
    function fn_newLogResult() {
        if (detailForm.reqId.value == "") {
            Common.alert("No cancellation request selected.");
        	return false;
        }
        if (detailForm.paramReqStusCode.value == 'CC') {
            Common.alert("Not available to use this function when Call Log Status in ‘CC’");
            return false;
        }
        if (detailForm.paramReqStusCode.value == 'REV') {
            Common.alert("Not available to use this function when Call Log Status in ‘REV’");
            return false;
        }
        if (detailForm.paramReqStusCode.value == 'CONTR') {
            Common.alert("Not available to use this function when Call Log Status in ‘CONTR’");
            return false;
        }

        // AUX skip
        if(detailForm.appTypeId.value !=5764) {
        	Common.ajax("POST", "/sales/order/selRcdTms.do", {orderId :   $("#salesOrdId").val(), callEntryId :  $("#callEntryId").val(), rcdTms : rcdTms}, function(result) {
                if (result.code == "99") {
                    Common.alert(result.message);
                    return;
                } else {
                    Common.popupDiv("/homecare/sales/order/hcCancelNewLogResultPop.do", $("#detailForm").serializeJSON(), null, true, '_newDiv');
                }
            });
        }else{
            Common.alert('Auxiliary products are not allowed to view');
        }
    }

    // Button Click - Add PR
    function fn_newRsoResult() {
        if (detailForm.reqId.value == "") {
            Common.alert("No cancellation request selected.");
            return false;
        }
        if (detailForm.paramRsoStusId.value != 'ACT') {
            Common.alert("Only available to use this function  in case of Return Service Order Status in ‘ACT’");
            return false;
        }

        // AUX skip
        if(detailForm.appTypeId.value !=5764) {
        	var salesOrdId1 = detailForm.salesOrdId.value;
            var salesOrdNo1 = detailForm.paramSalesOrdNo.value;

            Common.ajax("POST", "/sales/order/selRcdTms2.do", {orderId : $("#salesOrdId").val(), callEntryId :  $("#callEntryId").val(), rcdTms : rcdTms}, function(result) {
                if (result.code == "99") {
                    Common.alert(result.message);
                    return;
                } else {
                    Common.popupDiv("/homecare/sales/order/hcAddProductReturnPop.do?isPop=true&homecareYn=Y&salesOrderId=" + salesOrdId1 + "&salesOrderNO=" + salesOrdNo1,
                        $("#detailForm").serializeJSON(), null, "false", "addInstallationPopupId");
                }
            });
        }else{
            Common.alert('Auxiliary products are not allowed to view');
        }
    }

    $.fn.clearForm = function() {
        return this.each(function() {
        	  var type = this.type, tag = this.tagName.toLowerCase();
        	  if (tag === 'form') {
        	      return $(':input', this).clearForm();
        	  }
        	  if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea') {
                  this.value = '';
                  this.text = '';
              } else if (type === 'checkbox' || type === 'radio') {
                  this.checked = false;
                  this.text = '';
              } else if (tag === 'select') {
                  this.selectedIndex = -1;
                  this.text = '';
              }
        });
    };

    function fn_ctAssignment() {
        if (detailForm.reqId.value == "") {
            Common.alert("<spring:message code='sal.alert.msg.noCancelRequestSelected' />.");
            return false;
        } else {
            if (detailForm.paramReqStageId.value == '24') {
                Common.alert("["
                      + detailForm.paramReqNo.value
                      + "<spring:message code='sal.alert.msg.onlyRequestAfterInstallIsAllow' />.");
                return false;
            }
            if (detailForm.paramCallStusId.value == '1' || detailForm.paramCallStusId.value == '19') {
                Common.alert("["
                      + detailForm.paramReqNo.value
                      + "] is under status ["
                      + detailForm.paramReqStusName.value
                      + "] </br> <spring:message code='sal.alert.msg.reassignCtIsDisallowed' />.");
                return false;
            }

            Common.popupDiv("/homecare/sales/order/orderCancelDTAssignmentPop.do", $("#detailForm").serializeJSON(), null, true, '_newCTDiv');
        }
    }

    function fn_CTBulk() {
        Common.popupDiv("/sales/order/ctAssignBulkPop.do", $("#detailForm").serializeJSON(), null, true, '_bulkDiv');
    }

    function fn_rawData() {
        Common.popupDiv("/sales/order/orderCancelRequestRawDataPop.do", null, null, true);
    }

    function fn_productReturnRaw(a) {
        Common.popupDiv("/sales/order/orderCancelProductReturnRawPop.do", {"type" : "HC","ind": a}, null, true);
    }

    function fn_productReturnLogBookList() {
        Common.popupDiv("/sales/order/orderCancelProductReturnLogBookListingPop.do", null, null, true);
    }

    function fn_productReturnYSList() {
        Common.popupDiv("/sales/order/orderCancelProductReturnYellowSheetPop.do", null, null, true);
    }

    function fn_productReturnNoteList() {
        Common.popupDiv("/sales/order/orderCancelProductReturnNoteListingPop.do", null, null, true);
    }

    function fn_excelDown() {
        GridCommon.exportTo("list_grid_wrap", "xlsx", "Order Cancellation Listing");
    }
</script>

<section id="content">
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
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>
			<spring:message code="sal.page.title.orderCancellation" />
		</h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:fn_newLogResult()"><spring:message
								code="sal.btn.newLogResult" /></a>
					</p></li>
			</c:if>
			<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:fn_newRsoResult()">Add PR
							Result</a>
					</p></li>
			</c:if>
			<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:fn_ctAssignment()">DT Assignment</a>
					</p></li>
			</c:if>
			<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
<!-- 				<li><p class="btn_blue"> -->
<!-- 						<a href="#" onclick="javascript:fn_CTBulk()">Change Assign DT(Bulk)</a> -->
<!-- 					</p></li> -->
			</c:if>
			<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:fn_orderCancelListAjax()"><span class="search"></span> <spring:message code="sal.btn.search" /></a>
					</p></li>
			</c:if>
			<li><p class="btn_blue">
					<a href="#" onclick="javascript:$('#searchForm').clearForm();"><span
						class="clear"></span> <spring:message code="sal.btn.clear" /></a>
				</p></li>
		</ul>
	</aside>
	<!-- title_line end -->
	<section class="search_table">
		<!-- search_table start -->
		<form id="detailForm" name="detailForm" method="post">
			<input type="hidden" id="reqId" name="reqId">
			<input type="hidden" id="callEntryId" name="callEntryId">
			<input type="hidden" id="salesOrdId" name="salesOrdId">
            <input type="hidden" id="paramSalesOrdNo" name="paramSalesOrdNo">
            <input type="hidden" id="typeId" name="typeId">
            <input type="hidden" id="docId" name="docId">
            <input type="hidden" id="refId" name="refId">
            <input type="hidden" id="paramCallStusId" name="paramCallStusId">
            <input type="hidden" id="paramCallStusCode" name="paramCallStusCode">
			<input type="hidden" id="paramReqNo" name="paramReqNo">
			<input type="hidden" id="paramReqStusId" name="paramReqStusId">
			<input type="hidden" id="paramReqStusCode" name="paramReqStusCode">
			<input type="hidden" id="paramReqStusName" name="paramReqStusName">
			<input type="hidden" id="paramReqStageId" name="paramReqStageId">
			<input type="hidden" id="paramRsoStusId" name="paramRsoStusId">
			<input type="hidden" id="rcdTms" name="rcdTms">
			<input type="hidden" id="appTypeId" name="appTypeId">
		</form>
		<form id="searchForm" name="searchForm" method="post" autocomplete=off>
			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 150px" />
					<col style="width: *" />
					<col style="width: 160px" />
					<col style="width: *" />
					<col style="width: 170px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message code="sal.text.ordNo" /></th>
						<td><input type="text" title="" id="ordNo" name="ordNo" placeholder="Order Number" class="w100p" /></td>
						<th scope="row"><spring:message code="sal.text.appType" /></th>
						<td>
						    <select id="cmbAppTypeId" name="cmbAppTypeId" class="multy_select w100p" multiple="multiple"></select>
						</td>
						<th scope="row"><spring:message code="sal.title.text.callLogStus" /></th>
						<td>
						    <select id="callStusId" name="callStusId" class="multy_select w100p" multiple="multiple">
							    <option value="1" selected><spring:message code="sal.combo.text.active" /></option>
								<option value="19" selected><spring:message code="sal.combo.text.recall" /></option>
								<option value="32"><spring:message code="sal.combo.text.confirmToCancel" /></option>
								<option value="31"><spring:message code="sal.combo.text.reversalOfCancellation" /></option>
								<option value="105"><spring:message code="sal.combo.text.continueRental" /></option>
						    </select>
						</td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.text.requestDate" /></th>
						<td>
							<div class="date_set w100p">
								<!-- date_set start -->
								<p>
									<input type="text" id="startCrtDt" name="startCrtDt" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date" />
								</p>
								<span><spring:message code="sal.text.to" /></span>
								<p>
									<input type="text" id="endCrtDt" name="endCrtDt" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" />
								</p>
							</div> <!-- date_set end -->
						</td>
						<th scope="row"><spring:message code="service.grid.AppntDt" /></th>
						<td>
							<div class="date_set w100p">
								<!-- date_set start -->
								<p>
									<input type="text" id="startAppDt" name="startAppDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
								</p>
								<span><spring:message code="sal.text.to" /></span>
								<p>
									<input type="text" id="endAppDt" name="endAppDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" />
								</p>
							</div> <!-- date_set end -->
						</td>
						<th scope="row"><spring:message code="sal.text.callLogDate" /></th>
						<td>
							<div class="date_set w100p">
								<!-- date_set start -->
								<p>
									<input type="text" id="startRecallDt" name="startRecallDt" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
								</p>
								<span><spring:message code="sal.text.to" /></span>
								<p>
									<input type="text" id="endRecallDt" name="endRecallDt" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" />
								</p>
							</div> <!-- date_set end -->
						</td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.text.requestNo" /></th>
						<td><input type="text" title="" id="reqNo" name="reqNo" placeholder="Request Number" class="w100p" /></td>
						<th scope="row"><spring:message code="sal.title.text.requestStage" /></th>
						<td>
						    <select id="reqStageId" name="reqStageId" class="multy_select w100p" multiple="multiple">
						        <option value="24" selected><spring:message code="sal.text.beforeInstall" /></option>
								<option value="25" selected><spring:message code="sal.text.afterInstall" /></option>
						    </select>
						</td>
						<th scope="row">DT Branch</th>
						<td>
						    <select id="listDscBranchId" name="cmbDscBranchId" class="multy_select w100p" multiple="multiple"></select>
					    </td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.text.customerId" /></th>
						<td><input type="text" title="" id="custId" name="custId" placeholder="Customer ID(Number Only)" class="w100p" /></td>
						<th scope="row"><spring:message code="sal.text.custName" /></th>
						<td><input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" /></td>
						<th scope="row">DSC Branch</th>
                        <td>
                            <select id="listDscBranchId2" name="cmbDscBranchId2" class="multy_select w100p" multiple="multiple"></select>
                        </td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.text.creator" /></th>
						<td><input type="text" title="" id="crtUserId" name="crtUserId" placeholder="Creator(UserName)" class="w100p" /></td>
                        <th scope="row">Bundle Number</th>
                        <td><input type="text" title="bndlNo" id="bndlNo" name="bndlNo" placeholder="Bundle Number" class="w100p" /></td>
                        <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
                        <td><input type="text" title="" id="custIc" name="custIc" placeholder="NRIC/Company Number" class="w100p" /></td>
					</tr>
					<tr>
                    <th scope="row">RSO Status</th>
                    <td><select id="cmbrsoStatusId" name="cmbrsoStatusId" class="multy_select w100p" multiple="multiple">
                    <c:forEach var="list" items="${rsoStatusList }">
                    <option value="${list.stusCodeId }">${list.name }</option>
                    </c:forEach>
                    </select></td>
                    <th scope="row"><spring:message code='sales.prod' /></th>
                        <td><select id="listProductId" name="productId" class="w100p"></select></td>
                     <th scope="row">Product Return Reason</th>
                        <td><select id="cmbproductRetReasonId" name="cmbproductRetReasonId" class="multy_select w100p" multiple="multiple">
                        <c:forEach var="list" items="${productRetReasonList }">
                        <option value="${list.resnId }">${list.resnDesc }</option>
                        </c:forEach>
                        </select></td>
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
					<dt>Link</dt>
					<dd>
						<ul class="btns">
							<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
								<li>
								    <p class="link_btn type2">
										<a href="#" onClick="fn_rawData()"><spring:message code="sal.btn.requestRawData" /></a>
									</p>
								</li>
							</c:if>
							<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
								<li>
								    <p class="link_btn type2">
										<a href="#" onClick="fn_productReturnRaw(0)">Product Return Raw</a>
									</p>
								</li>
							</c:if>
							 <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
						        <li><p class="link_btn type2">
						          <a href="#" onClick="fn_productReturnRaw(1)">Product Return Raw (4 Months)</a>
						         </p></li>
					         </c:if>
							<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
								<li>
								    <p class="link_btn type2">
										<a href="#" onClick="fn_productReturnLogBookList()">Product Return Log Book Listing</a>
									</p>
								</li>
							</c:if>
							<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
								<li>
								    <p class="link_btn type2">
										<a href="#" onClick="fn_productReturnYSList()">Product Return YS Listing</a>
									</p>
								</li>
							</c:if>
							<c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
								<li>
								    <p class="link_btn type2">
										<a href="#" onClick="fn_productReturnNoteList()">Product Return Note</a>
									</p>
								</li>
							</c:if>
						</ul>
						<p class="hide_btn">
							<a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
						</p>
					</dd>
				</dl>
			</aside>
			<ul class="right_btns">
				<li>
				    <p class="btn_grid">
						<a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate' /></a>
					</p>
				</li>
			</ul>
			<!-- link_btns_wrap end -->
		</form>
	</section>
	<!-- search_table end -->
	<section class="search_result">
		<!-- search_result start -->
		<article class="grid_wrap">
			<!-- grid_wrap start -->
<!-- 			<div id="grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div> -->
			<div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
		</article>
		<!-- grid_wrap end -->
	</section>
	<!-- search_result end -->
</section>
<!-- content end -->