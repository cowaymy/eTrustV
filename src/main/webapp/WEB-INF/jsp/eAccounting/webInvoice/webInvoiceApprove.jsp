<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 첨부파일 버튼 스타일 재정의*/
.aui-grid-button-renderer {
     width:100%;
     padding: 4px;
 }
</style>
<script type="text/javascript">
var excelGrid;
var appvPrcssNo;
var atchFileGrpId;
var clmType;
//그리드에 삽입된 데이터의 전체 길이 보관
var gridDataLength = 0;
var invoAprveGridColLayout = [ {
    dataField : "appvPrcssNo",
    visible : false // Color 칼럼은 숨긴채 출력시킴
},{
    dataField : "appvLineSeq",
    visible : false // Color 칼럼은 숨긴채 출력시킴
},{
    dataField : "clamUn",
    visible : false // Color 칼럼은 숨긴채 출력시킴
},{
    dataField : "isActive",
    headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
    width: 30,
    renderer : {
        type : "CheckBoxEditRenderer",
        showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
        checkValue : "Active", // true, false 인 경우가 기본
        unCheckValue : "Inactive",
        // 체크박스 disabled 함수
        disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
            if(item.appvPrcssStusCode == "A" || item.appvPrcssStusCode == "J")
                return true; // true 반환하면 disabled 시킴
            return false;
        }
    }
},{
    dataField : "clmNo",
    headerText : '<spring:message code="invoiceApprove.clmNo" />',
    width : 90
},{
    dataField : "reqstDt",
    headerText : '<spring:message code="invoiceApprove.reqstDt" />',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "codeName",
    headerText : '<spring:message code="invoiceApprove.clmType" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "costCentr",
    headerText : '<spring:message code="webInvoice.cc" />'
}, {
    dataField : "costCentrName",
    headerText : '<spring:message code="webInvoice.ccName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "invcType",
    headerText : '<spring:message code="invoiceApprove.invcType" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "memAccId",
    headerText : '<spring:message code="invoiceApprove.member" />',
}, {
    dataField : "memAccName",
    headerText : '<spring:message code="invoiceApprove.memberName" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "cur",
    headerText : '<spring:message code="newWebInvoice.cur" />'
}, {
    dataField : "appvAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appvPrcssStusCode",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "atchFileGrpId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "atchFileId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "atchFileName",
    headerText : '<spring:message code="newWebInvoice.attachment" />',
    width : 200,
    visible : false,
    labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
        var myString = value;
        // 로직 처리
        // 여기서 value 를 원하는 형태로 재가공 또는 포매팅하여 반환하십시오.
        if(FormUtil.isEmpty(myString)) {
        	myString = '<spring:message code="invoiceApprove.noAtch.msg" />';
        }
        return myString;
     }, 
    renderer : {
        type : "ButtonRenderer",
        onclick : function(rowIndex, columnIndex, value, item) {
        	console.log("view_btn click item.appvPrcssNo : " + item.appvPrcssNo);
        	console.log("view_btn click atchFileGrpId : " + item.atchFileGrpId + " atchFileId : " + item.atchFileId);
        	console.log("view_btn click item.fileCnt : " + item.fileCnt);
        	if(item.fileCnt > 1) {
        		//atchFileGrpId = item.atchFileGrpId;
        		appvPrcssNo = item.appvPrcssNo;
        		fn_fileListOfAppvPrcssNoPop();
        	} else {
        		if(item.fileCnt == 1) {
        			var data = {
                            atchFileGrpId : item.atchFileGrpId,
                            atchFileId : item.atchFileId
                    };
                    if(item.fileExtsn == "jpg" || item.fileExtsn == "png") {
                        // TODO View
                        console.log(data);
                        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                            console.log(result);
                            var fileSubPath = result.fileSubPath;
                            fileSubPath = fileSubPath.replace('\', '/'');
                            console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
                        });
                    } else {
                        Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
                            console.log(result);
                            var fileSubPath = result.fileSubPath;
                            fileSubPath = fileSubPath.replace('\', '/'');
                            console.log("/file/fileDown.do?subPath=" + fileSubPath
                                    + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                            window.open("/file/fileDown.do?subPath=" + fileSubPath
                                + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
                        });
                    }
        		} else {
        			Common.alert('<spring:message code="invoiceApprove.notFoundAtch.msg" />');
        		}
        	}
        }
    }
}, {
    dataField : "fileExtsn",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "fileCnt",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="invoiceApprove.appvBrDt" />'
}
];

//그리드 속성 설정
var invoAprveGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 체크박스 표시 설정
    showRowCheckColumn : false,
    showRowNumColumn : false,
    // 헤더 높이 지정
    headerHeight : 40,
    showEditedCellMarker : false,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var invoAprveGridID;

$(document).ready(function () {
	invoAprveGridID = AUIGrid.create("#approve_grid_wrap", invoAprveGridColLayout, invoAprveGridPros);
    
    $("#search_supplier_btn").click(fn_supplierSearchPop);
    $("#search_costCenter_btn").click(fn_costCenterSearchPop);
    $("#search_createUser_btn").click(fn_searchUserIdPop);
    $("#approve_btn").click(fn_approveRegistPop);
    $("#reject_btn").click(fn_rejectRegistPop);
    $("#excelDown_btn").click(fn_getAppvExcelInfo);
    
    AUIGrid.bind(invoAprveGridID, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick appvPrcssNo : " + event.item.appvPrcssNo);
                console.log("CellDoubleClick atchFileGrpId : " + event.item.atchFileGrpId);
                // TODO detail popup open
                appvPrcssNo = event.item.appvPrcssNo;
                atchFileGrpId = event.item.atchFileGrpId;
                var clmNo = event.item.clmNo;
                clmType = clmNo.substr(0, 2);
                
                fn_webInvoiceAppvViewPop();
            });
    
    // ready 이벤트 바인딩
    AUIGrid.bind(invoAprveGridID, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(invoAprveGridID).length; // 그리드 전체 행수 보관
    });
    
    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(invoAprveGridID, "headerClick", headerClickHandler);
    
    // 셀 수정 완료 이벤트 바인딩
    AUIGrid.bind(invoAprveGridID, "cellEditEnd", function(event) {
        
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "isActive") {
            
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(invoAprveGridID, "isActive", "Active");
            
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != gridDataLength) {
                document.getElementById("allCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("allCheckbox").checked = true;
            }
        }
    });
    
    CommonCombo.make("clmType", "/common/selectCodeList.do", {groupCode:'343', orderValue:'CODE'}, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });
    
    $("#appvPrcssStus").multipleSelect("checkAll");
    
    fn_setToDay()
});

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {
	
    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "isActive") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;
            checkAll(isChecked);
        }
        return false;
    }
}

// 전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) {
	
	 var idx = AUIGrid.getRowCount(invoAprveGridID); 
    
    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {
    	for(var i = 0; i < idx; i++){
    		if(AUIGrid.getCellValue(invoAprveGridID, i, "appvPrcssStusCode") == "R"){
                //AUIGrid.updateAllToValue(invoAprveGridID, "isActive", "Active");
                AUIGrid.setCellValue(invoAprveGridID, i, "isActive", "Active")
            }
        }
    } else {
        AUIGrid.updateAllToValue(invoAprveGridID, "isActive", "Inactive");
    }
    
    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
}

function fn_setToDay() {
    var today = new Date();
    
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    
    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm
    }
    
    today = dd + "/" + mm + "/" + yyyy;
    $("#startDt").val(today)
    $("#endDt").val(today)
}

function fn_supplierSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", null, null, true, "supplierSearchPop");
}

function fn_costCenterSearchPop() {
    Common.popupDiv("/eAccounting/webInvoice/costCenterSearchPop.do", null, null, true, "costCenterSearchPop");
}

function fn_setCostCenter() {
    $("#costCenter").val($("#search_costCentr").val());
    $("#costCenterText").val($("#search_costCentrName").val());
}

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", null, null, true);
}

// set 하는 function
function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
        	Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            console.log(memInfo);
            // TODO createUser set
            $("#createUser").val(memInfo.memCode);
        }
    });
}

function fn_setSupplier() {
    $("#memAccId").val($("#search_memAccId").val());
    $("#memAccName").val($("#search_memAccName").val());
}

function fn_selectApproveList() {
    Common.ajax("GET", "/eAccounting/webInvoice/selectApproveList.do?_cacheId=" + Math.random(), $("#form_approve").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(invoAprveGridID, result);
    });
}

function fn_fileListOfAppvPrcssNoPop() {
    var data = {
            appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/fileListOfAppvPrcssNoPop.do", data, null, true, "fileListPop");
}

function fn_fileListPop() {
    var data = {
    		atchFileGrpId : atchFileGrpId
    };
    Common.popupDiv("/eAccounting/webInvoice/fileListPop.do", data, null, true, "fileListPop");
}

function fn_webInvoiceAppvViewPop() {
    var data = {
    		clmType : clmType
            ,appvPrcssNo : appvPrcssNo
            ,pageAuthFuncChange : "${PAGE_AUTH.funcChange}"
    };
    Common.popupDiv("/eAccounting/webInvoice/webInvoiceAppvViewPop.do", data, null, true, "webInvoiceAppvViewPop");
}

function fn_approveRegistPop() {
	var data = {
            appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/approveRegistPop.do", null, null, true, "approveRegistPop");
}

function fn_rejectRegistPop() {
	var data = {
            appvPrcssNo : appvPrcssNo
    };
    Common.popupDiv("/eAccounting/webInvoice/rejectRegistPop.do", null, null, true, "rejectRegistPop");
}

function fn_setGridData(gridId, data) {
    console.log(data);
    AUIGrid.setGridData(gridId, data);
}

function fn_appvRejctSubmit(type, rejctResn) {
 // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
    var invoAppvGridList = AUIGrid.getItemsByValue(invoAprveGridID, "isActive", "Active");
    var url = "";
    console.log(invoAppvGridList);
    console.log(invoAppvGridList.length);
    if(invoAppvGridList.length == 0) {
        Common.alert("No data selected.");
    } else {
        var data = {
                invoAppvGridList : invoAppvGridList
                ,rejctResn : rejctResn
        };
        if(type == "appv") {
        	url = "/eAccounting/webInvoice/approvalSubmit.do";
        }else if(type == "rejct") {
        	url = "/eAccounting/webInvoice/rejectionSubmit.do";
        }
        console.log(data);
        console.log(type);
        console.log(url);
        Common.ajax("POST", url, data, function(result) {
            console.log(result);
            if(type == "appv") {
            	Common.popupDiv("/eAccounting/webInvoice/approveComplePop.do", null, null, true, "approveComplePop");
            }else if(type == 'rejct') {
            	Common.popupDiv("/eAccounting/webInvoice/rejectComplePop.do", null, null, true, "rejectComplePop");
            }
        });
    }
    
    // $("#webInvoiceAppvViewPop").length return 1 -> $("#webInvoiceAppvViewPop") exist
    if($("#webInvoiceAppvViewPop") > 0) {
        $("#webInvoiceAppvViewPop").remove();
    }
    //fn_closePop();
}

function fn_getAppvExcelInfo() {
	var list = AUIGrid.getColumnValues(invoAprveGridID, "appvPrcssNo", true);
	console.log(list);
    Common.ajax("POST", "/eAccounting/webInvoice/getAppvExcelInfo.do?_cacheId=" + Math.random(), {appvPrcssNo:list}, function(result) {
        console.log(result);
        
        //그리드 생성
        fn_makeGrid();
        
        AUIGrid.setGridData(excelGrid, result.data);
        
        if(result.data.length > 0) {
            var clmNo = result.data[0].appvReqKeyNo;
            var reqstDt = result.data[0].reqstDt;
            reqstDt = reqstDt.replace(/\//gi, "");
            GridCommon.exportTo("excel_grid_wrap", 'xlsx', clmNo + "_" + reqstDt);
        } else {
            Common.alert('There is no data to download.');
        }
    });
}

function fn_makeGrid(){

    var excelPop = [
        {
            dataField : "appvReqKeyNo",
            headerText : 'Claim No',
            width : 100,
            cellMerge : true
        },{
            dataField : "reqstDt",
            headerText : 'Request Date',
            width : 100,
            cellMerge : true 
        },{
            dataField : "reqstUserId",
            headerText : 'Request User Id',
            width : 100,
            cellMerge : true 
        },{
            dataField : "invcNo",
            headerText : 'Invoice No',
            width : 100
        },{
            dataField : "invcDt",
            headerText : 'Invoice Date',
            width : 100
        },{
            dataField : "invcType",
            headerText : 'Invoice Type',
            width : 100
        },{
            dataField : "memAccId",
            headerText : 'Member Account Id',
            width : 100
        },{
            dataField : "memAccName",
            headerText : 'Member Account Name',
            width : 100
        },{
            dataField : "supplir",
            headerText : 'Supplier Name',
            width : 100
        },{
            dataField : "payDueDt",
            headerText : 'Payment Due Date',
            width : 100
        },{
            dataField : "expType",
            headerText : 'Expense Type',
            width : 100
        },{
            dataField : "expTypeName",
            headerText : 'Expense Type Name',
            width : 100
        },{
            dataField : "costCentr",
            headerText : 'Cost Center',
            width : 100
        },{
            dataField : "costCentrName",
            headerText : 'Cost Center Name',
            width : 100
        },{
            dataField : "budgetCode",
            headerText : 'Budget Code',
            width : 100
        },{
            dataField : "budgetCodeName",
            headerText : 'Budget Code Name',
            width : 100
        },{
            dataField : "glAccCode",
            headerText : 'GL Account Code',
            width : 100
        },{
            dataField : "glAccCodeName",
            headerText : 'GL Account Code Name',
            width : 100
        },{
            dataField : "taxCode",
            headerText : 'Tax Code',
            width : 100
        },{
            dataField : "taxName",
            headerText : 'Tax Code Name',
            width : 100
        },{
            dataField : "netAmt",
            headerText : 'Net Amount',
            width : 100
        },{
            dataField : "taxAmt",
            headerText : 'Tax Amount',
            width : 100
        },{
            dataField : "taxNonClmAmt",
            headerText : 'Tax Non Claim Amount',
            width : 100
        },{
            dataField : "appvAmt",
            headerText : 'Approve Amount',
            width : 100
        },{
            dataField : "utilNo",
            headerText : 'Utilities Account No',
            width : 100
        },{
            dataField : "jPayNo",
            headerText : 'JomPAY No',
            width : 100
        },{
            dataField : "bilPeriodF",
            headerText : 'Billing Period From',
            width : 100
        },{
            dataField : "bilPeriodT",
            headerText : 'Billing Period To',
            width : 100
        }
    ];
        
     var excelOptions = {
            enableCellMerge : true,
            showStateColumn:false,
            fixedColumnCount    : 3,
            showRowNumColumn    : false,
            //headerHeight : 100,
            usePaging : false
      }; 
    
     excelGrid = GridCommon.createAUIGrid("#excel_grid_wrap", excelPop, "", excelOptions);
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code="webInvoice.fav" /></a></p>
<h2><spring:message code="invoiceApprove.title" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectApproveList()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
	</c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_approve">
<input type="hidden" id="memAccName" name="memAccName">
<input type="hidden" id="costCenterText" name="costCenterText">

<table class="type1"><!-- table start -->
<caption><spring:message code="webInvoice.table" /></caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.clmType" /></th>
	<td>
	<select class="w100p" id="clmType" name="clmType" multiple="multiple">
	</select>
	</td>
	<th scope="row"><spring:message code="invoiceApprove.createUser" /></th>
	<td><input type="text" title="" placeholder="" class="" id="createUser" name="createUser" /><a href="#" class="search_btn" id="search_createUser_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.member" /></th>
	<td><input type="text" title="" placeholder="" class="" id="memAccId" name="memAccId" /><a href="#" class="search_btn" id="search_supplier_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row"><spring:message code="webInvoice.costCenter" /></th>
	<td><input type="text" title="" placeholder="" class="" id="costCenter" name="costCenter" /><a href="#" class="search_btn" id="search_costCenter_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row"><spring:message code="invoiceApprove.reqstDt" /></th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
	<span><spring:message code="webInvoice.to" /></span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"><spring:message code="webInvoice.status" /></th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="appvPrcssStus" name="appvPrcssStus">
		<option value="A"><spring:message code="webInvoice.select.approved" /></option>
		<option value="R"><spring:message code="webInvoice.select.request" /></option>
		<option value="J"><spring:message code="pettyCashRqst.rejected" /></option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_grid"><a href="#" id="excelDown_btn">EXCEL DW</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	<li><p class="btn_grid"><a href="#" id="approve_btn"><spring:message code="invoiceApprove.title" /></a></p></li>
	<li><p class="btn_grid"><a href="#" id="reject_btn"><spring:message code="webInvoice.select.reject" /></a></p></li>
	</c:if>
</ul>

<article class="grid_wrap" id="approve_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<article class="grid_wrap" id="excel_grid_wrap" style="display: none;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->