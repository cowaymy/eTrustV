<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<style>
</style>
<script type="text/javaScript">
var myGridID;
var option = {
	width: "1200px", // 창 가로 크기
	height: "500px" // 창 세로 크기
};
var basicAuth = false;
$(document).ready(function() {

	var memLevel = "${memLevel}";

    if (memLevel == 4) {
      $("#searchForm #memberCode").val("${memCode}");
      $("#searchForm #memberCode").prop("readonly", true);
    } else {
      $("#searchForm #memberCode").val("");
      $("#searchForm #memberCode").prop("readonly", false);
    }

    createAUIGrid();

    $('#_listSearchBtn').click(function(){
		selectList();
    })
});

function selectList(){
    Common.ajax("GET","/payment/mobileLumpSumPayment/getlumpSumEnrollmentList.do",$("#searchForm").serialize(), function(result){
        AUIGrid.setGridData(myGridID, result);
    });
}

function createAUIGrid() {
	var columnLayout = [{
        dataField : "checkId",
        headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
        cellMerge : true ,
        mergeRef : "mobPayGroupNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
        mergePolicy : "restrict",
        width : 50,
        renderer : {
        	type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N",
            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                return false;
            }
      }
    },{
		dataField: "mobPayGroupNo",
		headerText: '<spring:message code="pay.title.ticketNo" />',
		width: 100,
		cellMerge: true
	}, {
		dataField: "crtDt",
		headerText: '<spring:message code="pay.grid.requestDate" />',
		width: 140,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "payStusName",
		width: 100,
		headerText: '<spring:message code="pay.grid.status" />',
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "crtUserName",
		headerText: '<spring:message code="pay.head.memberCode" />',
		width: 160,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "payModeName",
		width: 160,
		headerText: '<spring:message code="sal.text.payMode" />',
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "salesOrdNo",
		headerText: '<spring:message code="pay.title.orderNo" />',
		width: 120,
		editable: false
	}, {
		dataField: "payType",
		headerText: 'Pay Type',
		width: 130,
		editable: false
	}, {
		dataField: "oriOutAmt",
		headerText: '<spring:message code="pay.head.outstandingAmount" />',
		width: 130,
		editable: false
	}, {
		dataField: "payAmt",
		headerText: '<spring:message code="pay.head.paymentAmount" />',
		width: 130,
		editable: false
	}, {
		dataField: "custName",
		headerText: '<spring:message code="pay.head.customerName" />',
		width: 200,
		editable: false,
		style: "aui-grid-user-custom-left",
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "totOriOutAmt",
		headerText: 'Total Outstanding Amt',
		width: 100,
		editable: false,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "totPayAmt",
		headerText: 'Total Payment Amt',
		width: 100,
		dataType: "numeric",
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	}, {
		dataField: "slipNo",
		headerText: 'Slip No',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict"
	},{
		dataField: "attchImgUrl1",
		headerText: 'Transaction Slip',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict",
		 renderer : {
	            type : "ImageRenderer",
	            width : 20,
	            height : 20,
	            imgTableRef : {
	              "DOWN" : "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
	            }
	          }
	},{
		dataField: "attchImgUrl2",
		headerText: 'Submission Checklist',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict",
		 renderer : {
	            type : "ImageRenderer",
	            width : 20,
	            height : 20,
	            imgTableRef : {
	              "DOWN" : "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
	            }
	          }
	},{
		dataField: "attchImgUrl3",
		headerText: 'Cheque Image',
		width: 100,
		cellMerge: true,
		mergeRef: "mobPayGroupNo",
		mergePolicy: "restrict",
		 renderer : {
	            type : "ImageRenderer",
	            width : 20,
	            height : 20,
	            imgTableRef : {
	              "DOWN" : "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
	            }
	          }
	}, {
		dataField: "payStusId",
		visible: false
	}, {
		dataField: "mobPayDetailId",
		visible: false
	}, {
		dataField: "ordId",
		visible: false
	}, {
		dataField: "payMode",
		visible: false
	}];
	var gridPros = {
		enableCellMerge : true,
		cellMergePolicy: "withNull",
        usePaging : false,
        editable :false,
   		headerHeight: 30,
		wordWrap:true
	};
	myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    AUIGrid.bind(myGridID, "headerClick", headerClickHandler);

    AUIGrid.bind(myGridID, "cellClick", function(event) {
        if (event.dataField == "attchImgUrl1") {
          if (FormUtil.isEmpty(event.value) == false) {
            var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
            if (FormUtil.isEmpty(rowVal.atchFileName1) == false && FormUtil.isEmpty(rowVal.physiclFileName1) == false) {
              window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath1 + "&fileName=" + rowVal.physiclFileName1 + "&orignlFileNm=" + rowVal.atchFileName1);
            }
          }
        } else if (event.dataField == "attchImgUrl2") {
          if (FormUtil.isEmpty(event.value) == false) {
            var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
            if (FormUtil.isEmpty(rowVal.atchFileName2) == false && FormUtil.isEmpty(rowVal.physiclFileName2) == false) {
              window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath2 + "&fileName=" + rowVal.physiclFileName2 + "&orignlFileNm=" + rowVal.atchFileName2);
            }
          }
        } else if (event.dataField == "attchImgUrl3") {
          if (FormUtil.isEmpty(event.value) == false) {
            var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
            if (FormUtil.isEmpty(rowVal.atchFileName3) == false && FormUtil.isEmpty(rowVal.physiclFileName3) == false) {
              window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath3 + "&fileName=" + rowVal.physiclFileName3 + "&orignlFileNm=" + rowVal.atchFileName3);
            }
          }
        }

        if(event.dataField == "checkId"){
    		var isChecked = AUIGrid.getCellValue(myGridID, event.rowIndex, "checkId");
    		var mobPayGroupNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "mobPayGroupNo");
    		var rows = AUIGrid.getRowsByValue(myGridID, "mobPayGroupNo", mobPayGroupNo);
    		var items = [];
    		for(var i = 0 ; i < rows.length; i++){
        		var rowIndex = AUIGrid.getRowIndexesByValue(myGridID, "mobPayDetailId", rows[i].mobPayDetailId);
    			AUIGrid.setCellValue(myGridID, rowIndex, "checkId",isChecked);
    		}
		}
      });
}

function loadComboBox() {
	doGetCombo('/common/selectCodeList.do', '439', '', 'payMode', 'L', ''); // Pay Mode
	doGetCombo('/common/selectCodeList.do', '49', '', 'cmbRegion', 'L', 'f_multiCombo'); //region
}

function f_multiCombo() {
	$(function() {
		$('#cmbRegion').change(function() {}).multipleSelect({
			selectAll: true,
			width: '80%'
		});
		$('#ticketStatus').change(function() {}).multipleSelect({
			selectAll: true,
			width: '80%'
		});
	});
}

function fn_clear() {
	$('#grpTicketNo').val('');
	$('#requestStartDate').val('');
	$('#requestEndDate').val('');
	$('#orderNo').val('');
	$('#ticketStatus').val('');
	$('#branchCode').val('');
	$('#cmbRegion').val('');
	$('#payMode').val('');
	$('#serialNo').val('');
	$('#memberCode').val('');
	$('#cardNoA').val('');
	$('#cardNoB').val('');
	$('#orgCode').val('');
	$('#grpCode').val('');
	$('#deptCode').val('');
}

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {
    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "checkId") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;

            checkAll(isChecked);
        }
        return false;
    }
}

//전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) {
	 var idx = AUIGrid.getRowCount(myGridID);

    if(isChecked) {
    	for(var i = 0; i < idx; i++){
            if(AUIGrid.getCellValue(myGridID, i, "payStusName") == 'Active'){
                AUIGrid.setCellValue(myGridID, i, "checkId", "Y")
            }
        }
    } else {
        AUIGrid.updateAllToValue(myGridID, "checkId", "N");
    }

    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
}
</script>
<!-- html content -->
<section id="content">
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
	</ul>
	<!-- title_line start -->
	<aside class="title_line">
		<p class="fav">
			<a href="#" class="click_add_on"> <spring:message
					code='pay.text.myMenu' />
			</a>
		</p>
		<h2>Lump Sum Payment Enroll List</h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li>
					<p class="btn_blue">
						<a id="_listSearchBtn" href="#"><span class="search"></span> <spring:message
								code='sys.btn.search' /> </a>
					</p>
				</li>
			</c:if>
			<li>
				<p class="btn_blue">
					<a href="#" onclick="fn_clear();"><span class="clear"></span> <spring:message
							code='sys.btn.clear' /> </a>
				</p>
			</li>
		</ul>
	</aside>
	<!-- title_line end -->
	<!-- search_table start -->
	<section class="search_table">
		<form id="searchForm" action="#" method="post">
			<table class="type1">
				<caption>table</caption>
				<colgroup>
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 130px" />
					<col style="width: *" />
					<col style="width: 170px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><span>Group Ticket No.</span></th>
						<td><input type="text" title="Group Ticket No"
							id="grpTicketNo" name="grpTicketNo" placeholder="Group Ticket No"
							class="w100p" /></td>
						<th scope="row"><spring:message code="pay.grid.requestDate" />
						</th>
						<td>
							<div class="date_set w100p">
								<!-- date_set start -->
								<p>
									<input id="requestStartDate" name="requestStartDate"
										type="text" title="Create start Date" placeholder="DD/MM/YYYY"
										class="j_date" value="" />
								</p>
								<span>To</span>
								<p>
									<input id="requestEndDate" name="requestEndDate" type="text"
										title="Create end Date" placeholder="DD/MM/YYYY"
										class="j_date" value="" />
								</p>
							</div> <!-- date_set end -->
						</td>
						<th scope="row"><spring:message code="pay.title.orderNo" />
						</th>
						<td><input type="text" title="Order No" id="orderNo"
							name="orderNo" placeholder="Order No" class="w100p" /></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="pay.title.ticketStatus" /></th>
						<td><select id="ticketStatus" name="ticketStatus"
							class="multy_select w100p" multiple="multiple">
								<option value="1">Active</option>
								<option value="104">Processing</option>
								<option value="5">Approved</option>
								<option value="6">Rejected</option>
								<option value="21">Failed</option>
								<option value="10">Cancelled</option>
						</select></td>
						<th scope="row"><spring:message code="pay.title.branchCode" /></th>
						<td><select class="multy_select w100p" id="branchCode"
							name="branchCode" multiple="multiple">
								<c:forEach var="list" items="${userBranch}" varStatus="status">
									<option value="${list.branchid}">${list.c1}</option>
								</c:forEach>
						</select></td>
						<th scope="row">Region</th>
						<td><select id="cmbRegion" name="cmbRegion"
							class="multy_select w100p" multiple="multiple">
						</select></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.text.payMode" /></th>
						<td><select id="payMode" name="payMode" class="w100p"></select>
						</td>
						<th scope="row"><spring:message code="pay.head.slipNo" /> /
							<spring:message code="pay.title.chequeNo" /></th>
						<td><input type="text" title="Slip No / Cheque No"
							id=serialNo name="serialNo" class="w100p" /></td>
						<th scope="row"><spring:message code="pay.title.memberCode" /></th>
						<td><input type="text"
							title="<spring:message code="pay.title.memberCode" />"
							id="memberCode" name="memberCode" class="w100p" value="" /></td>
					</tr>
					<tr>
						<th scope="row"><spring:message code="sal.title.text.apprvNo" /></th>
						<td><input type="text" title="Apprv No" id="apprvNo"
							name="apprvNo" class="w100p" /></td>
						<th scope="row"><spring:message code="pay.head.crc.cardNo" /></th>
						<td>
							<p class="short">
								<input type="text" title="First 6 Card No." id="cardNoA"
									name="cardNoA" size="10" maxlength="6" class="wAuto"
									placeholder="First 6 no." />
							</p> <span>**-****-</span>
							<p class="short">
								<input type="text" title="Last 4 Card No." id="cardNoB"
									name="cardNoB" size="10" maxlength="4" class="wAuto"
									placeholder="Last 4 no." />
							</p>

						</td>
						<th></th>
						<td></td>
					</tr>

					<tr>
						<th scope="row"><spring:message code="sal.text.orgCode" /></th>
						<td><input type="text"
							title="<spring:message code="sal.text.orgCode" />" id="orgCode"
							name="orgCode" class="w100p" disabled value="${memDetail.orgcde}" />
							<input type="hidden" title="" id="hidOrgCode" name="hidOrgCode"
							class="w100p" value="${memDetail.orgcde}" /></td>
						<th scope="row"><spring:message code="sal.text.grpCode" /></th>
						<td><input type="text"
							title="<spring:message code="sal.text.orgCode" />" id="grpCode"
							name="grpCode" class="w100p" disabled value="${memDetail.grpcde}" />
							<input type="hidden" title="" id="hidGrpCode" name="hidGrpCode"
							class="w100p" value="${memDetail.grpcde}" /></td>
						<th scope="row"><spring:message code="sal.text.detpCode" /></th>
						<td><input type="text"
							title="<spring:message code="sal.text.detpCode" />" id="deptCode"
							name="deptCode" class="w100p" disabled
							value="${memDetail.deptcde}" /> <input type="hidden" title=""
							id="hidDeptCode" name="hidDeptCode" class="w100p"
							value="${memDetail.deptcde}" /></td>
					</tr>
				</tbody>
			</table>
		</form>
	</section>
	<ul class="right_btns">
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
			<li><p class="btn_grid">
					<a href="#" onClick="fn_viewLdg()"><spring:message
							code="sal.btn.ledger" /> </a>
				</p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
			<li><p class="btn_grid">
					<a href="#" onClick="fn_validateLdg()"><spring:message
							code="pay.btn.approve" /> </a>
				</p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
			<li><p class="btn_grid">
					<a href="#" onClick="fn_reject()"><spring:message
							code="pay.btn.failreject" /> </a>
				</p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
			<li><p class="btn_grid">
					<a href="#" onClick="fn_excelDown()"><spring:message
							code="pay.btn.exceldw" /></a>
				</p></li>
		</c:if>
	</ul>
	<!-- search_table end -->

	<!-- search_result start -->
	<section class="search_result">
		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="grid_wrap" style="width: 100%; margin: 0 auto;"
				class="autoGridHeight"></div>
			<!-- grid_wrap end -->
		</article>
	</section>
	<!-- search_result end -->
</section>
<!-- html content -->