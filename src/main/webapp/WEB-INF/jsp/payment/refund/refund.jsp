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
</style>
<script type="text/javascript">
//그리드에 삽입된 데이터의 전체 길이 보관
var gridDataLength = 0;
var refundColumnLayout = [ {
    dataField : "isActive",
    headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
    width: 30,
    renderer : {
        type : "CheckBoxEditRenderer",
        showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
        checkValue : "Active", // true, false 인 경우가 기본
        unCheckValue : "Inactive"
    }
}, {
    dataField : "ordId",
    headerText : "<spring:message code='pay.head.orderId'/>"
}, {
    dataField : "ordNo",
    headerText : "<spring:message code='pay.head.orderNo'/>"
}, {
    dataField : "worNo",
    headerText : "<spring:message code='pay.head.orNo'/>"
}, {
    dataField : "custName",
    headerText : "<spring:message code='pay.head.customerName'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "amt",
    headerText : "<spring:message code='pay.head.amount'/>",
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appType",
    headerText : "<spring:message code='pay.head.appType'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "payModeCode",
    visible : false
}, {
    dataField : "payMode",
    headerText : "<spring:message code='pay.head.payMode'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "issueBankCode",
    headerText : "IssueBank Code",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "issueBank",
    headerText : "<spring:message code='pay.head.issueBank'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "bankAccId",
    visible : false
}, {
    dataField : "bankAccName",
    visible : false
}, {
    dataField : "bankAccNo",
    headerText : "Bank Account No",
}, {
    dataField : "ccNo",
    headerText : "<spring:message code='pay.head.crcNo'/>"
}, {
    dataField : "ccHolderName",
    headerText : "<spring:message code='pay.head.crcHolder'/>"
}, {
    dataField : "approveNo",
    headerText : "APProve No"
}, {
    dataField : "requestStage",
    headerText : "Request Stage"
}, {
    dataField : "cancelReason",
    headerText : "Cancel Reason"
}, {
    dataField : "cancelReasonDesc",
    headerText : "Cancel Reason<br>Description"
}, {
    dataField : "rejectId",
    headerText : "Reject ID"
}, {
    dataField : "payType",
    headerText : "Pay Type"
}, {
    dataField : "payBranchCode",
    headerText : "Pay Branch Code"
}, {
    dataField : "installStus",
    headerText : "Install Status"
}, {
    dataField : "ocrRemark",
    headerText : "OCR Remark"
}, {
    dataField : "instAddress",
    headerText : "Install Address"
}, {
    dataField : "mobileNo",
    headerText : "Mobile No"
}, {
    dataField : "mobileNo",
    headerText : "Mobile No"
}, {
    dataField : "officeNo",
    headerText : "Office No"
}, {
    dataField : "houseNo",
    headerText : "House No"
}, {
    dataField : "ordRem",
    headerText : "ORD Remark",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "bankReconStus",
    headerText : "<spring:message code='pay.head.bankReconStatus'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "canclDt",
    headerText : "<spring:message code='pay.head.cancelDate'/>",
    dataType : "date",
    formatString : "dd/mm/yyyy"
}
];

//그리드 속성 설정
var refundGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 체크박스 표시 설정
    showRowCheckColumn : false,
    showRowNumColumn : false,
    // 헤더 높이 지정
    headerHeight : 50,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

var refundGridID;

$(document).ready(function () {
	refundGridID = AUIGrid.create("#refund _grid_wrap", refundColumnLayout, refundGridPros);
	
	$("#refund_btn").click(fn_refundConfirmPop);
	//$("#refund_btn").click(fn_showConfirmPop);
	$('#excel_down_btn').click(function() {    
        GridCommon.exportTo("refund _grid_wrap", 'xlsx', 'Refund List');
    });
	
    CommonCombo.make("payMode", "/payment/selectCodeList.do", null, "", {
        id: "code",
        name: "codeName",
        type:"M"
    });
    
	$("#cancelMode").multipleSelect("checkAll");
	
	fn_setToDay();
	
	// ready 이벤트 바인딩
    AUIGrid.bind(refundGridID, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(refundGridID).length; // 그리드 전체 행수 보관
    });
    
    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(refundGridID, "headerClick", headerClickHandler);
    
    // 셀 수정 완료 이벤트 바인딩
    AUIGrid.bind(refundGridID, "cellEditEnd", function(event) {
        
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "isActive") {
            
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(refundGridID, "isActive", "Active");
            
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != gridDataLength) {
                document.getElementById("allCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("allCheckbox").checked = true;
            }
        }
    });
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
    
     var idx = AUIGrid.getRowCount(refundGridID); 
    
    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {
    	AUIGrid.updateAllToValue(refundGridID, "isActive", "Active");
    } else {
        AUIGrid.updateAllToValue(refundGridID, "isActive", "Inactive");
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

function fn_refundConfirmPop() {
	var checkList = AUIGrid.getItemsByValue(refundGridID, "isActive", "Active");
	if(checkList.length > 0) {
		Common.popupDiv("/payment/refundConfirmPop.do", null, null, true, "refundConfirmPop", fn_showConfirmPop);
	} else {
        Common.alert('<spring:message code="pay.alert.noItem"/>');
    }
}

function fn_showConfirmPop() {
    var checkList = AUIGrid.getItemsByValue(refundGridID, "isActive", "Active");
    //$("#conf_popup_wrap").show();
    console.log(checkList);
    
    for(var i = 0; i < checkList.length; i++) {
    	checkList[i].refAmt = checkList[i].amt;
    	checkList[i].refModeCode = checkList[i].payModeCode;
    	checkList[i].refModeName = checkList[i].payMode;
    	checkList[i].bankAccCode = checkList[i].bankAccId;
    	checkList[i].bankAccName = checkList[i].bankAccName;
    	checkList[i].cardNo = checkList[i].ccNo;
    	checkList[i].cardHolder = checkList[i].ccHolderName;
    	
    	if(checkList[i].payModeCode == "105") {
            checkList[i].refModeCode = "108";
            checkList[i].refModeName = "Online";
        }
    	if(checkList[i].payModeCode == "105" || checkList[i].payModeCode == "106" || checkList[i].payModeCode == "108") {
            checkList[i].bankAccCode = "523";
            checkList[i].bankAccName = "2710/010F - CIMB BHD (FINANCE)";
        }
    }
    
    fn_createConfirmAUIGrid();
    
    AUIGrid.setGridData(confirmGridID, checkList);
    
    $("#totItem").text("-");
    $("#totValid").text("-");
    $("#totInvalid").text("-");
    $("#totRefAmt").text("-");
    $("#totValidAmt").text("-");
    $("#totInvalidAmt").text("-");
    
 // 검색(search) Not Found 이벤트 바인딩
    AUIGrid.bind(confirmGridID, "notFound", function(event) {

    var term = event.term; // 찾는 문자열
    var wrapFound = event.wrapFound; // wrapSearch 한 경우 만족하는 term 이 그리드에 1개 있는 경우.
    
    console.log("notFound");
    console.log(term);
    console.log(wrapFound);
    
    if(wrapFound) {
        //Common.alert('Please enter the order number you would like to find.');
        Common.alert('The grid passed the last row, but the following string could not be found - ' + term );
    } else {
        //Common.alert('Please enter the order number you would like to find.');
        Common.alert('The following string is missing. - "' + term + '"');
    }

   });
}

function fn_selectRefundList() {
	Common.ajax("GET", "/payment/selectRefundList.do?_cacheId=" + Math.random(), $("#form_refund").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(refundGridID, result);
    });
}

function fn_formClear() {
	$("#form_refund").each(function() {
        this.reset();
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
<h2>Refund</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectRefundList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_formClear()"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" id="form_refund">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Sales Order No.</th>
    <td><input type="text" title="Sales Order No." placeholder="Sales Order No. (Number Only)" class="w100p" id="salesOrdNo" name="salesOrdNo"/></td>
    <th scope="row">Cancellation Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDt" name="startDt"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDt" name="endDt"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="Customer Name" placeholder="Customer Name" class="w100p" id="custName" name="custName"/>
    </td>
    <th scope="row">Cancel Mode</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cancelMode" name="cancelMode">
    <option value="1798">Auto Cancel</option>
    <option value="1996">CCP Reject/Cancel</option>
    <option value="1997">CCP Auto Cancel</option>
    <option value="1998">Cancel & Refund (S/O only)</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Paymode</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="payMode" name="payMode"></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excel_down_btn"><spring:message code='pay.btn.exceldw'/></a></p></li>
    <li><p class="btn_grid"><a href="#" id="refund_btn"><spring:message code='pay.btn.refund'/></a></p></li>
</ul>

<article class="grid_wrap" id="refund _grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->