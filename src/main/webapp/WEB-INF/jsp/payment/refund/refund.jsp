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
},{
    dataField : "ordNo",
    headerText : 'Order<br>No.'
},{
    dataField : "worNo",
    headerText : 'OR No.'
}, {
    dataField : "custName",
    headerText : 'Customer Name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "amt",
    headerText : 'Amount',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appType",
    headerText : 'App Type',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "payMode",
    headerText : 'Pay<br>Mode',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "issuebankPaytChannel",
    headerText : 'Issue<br>Bank',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "bankaccnoPaytChannel",
    headerText : 'Bank<br>Account',
}, {
    dataField : "ccNo",
    headerText : 'CRC No.'
}, {
    dataField : "bankReconStus",
    headerText : 'Bank<br>Recon<br>Status',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "canclDt",
    headerText : 'Cancel<br>Date',
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
    headerHeight : 50
};

var refundGridID;

$(document).ready(function () {
	refundGridID = AUIGrid.create("#refund _grid_wrap", refundColumnLayout, refundGridPros);
	
	$("#refund_btn").click(fn_showConfirmPop);
	$('#excel_down_btn').click(function() {    
        GridCommon.exportTo("refund _grid_wrap", 'xlsx', 'Refund List');
    });
	
	/* $("#payMode").multipleSelect("checkAll");
    $("#confirmStatus").multipleSelect("setSelects", [44]);
    $("#batchStatus").multipleSelect("setSelects", [1]); */
	
	$("#cancelMode").multipleSelect("checkAll");
	$("#payMode").multipleSelect("checkAll");
	
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

function fn_showConfirmPop() {
	var checkList = AUIGrid.getItemsByValue(refundGridID, "isActive", "Active");
    if(checkList.length > 0) {
        $("#conf_popup_wrap").show();
        
        fn_createConfirmAUIGrid();
        
        AUIGrid.setGridData(confirmGridID, checkList);
        
        fn_setConfirmPopEvent();
        
        $("#totItem").text("-");
        $("#totValid").text("-");
        $("#totInvalid").text("-");
        $("#totRefAmt").text("-");
        $("#totValidAmt").text("-");
        $("#totInvalidAmt").text("-");
        
    } else {
        Common.alert('No item selected.');
    }
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
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Refund</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectRefundList()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_formClear()"><span class="clear"></span>Clear</a></p></li>
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
    <select class="multy_select w100p" multiple="multiple" id="payMode" name="payMode">
    <option value="105">Cash</option>
    <option value="106">Cheque (CHQ)</option>
    <option value="107">Credit Card (CRC)</option>
    <option value="108">Online Payment (ONL)</option>
    </select>
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
    <li><p class="btn_grid"><a href="#" id="excel_down_btn">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#" id="refund_btn">Refund</a></p></li>
</ul>

<article class="grid_wrap" id="refund _grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

<script type="text/javascript">
var confirmGridID;
var detId = 0;
var batchIdList = null;
var confirmColumnLayout = [ {
    dataField : "detId",
    visible : false
}, {
    dataField : "validStusId",
    headerText : 'Valid Status'
}, {
    dataField : "validRem",
    headerText : 'Valid Remark',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "ordNo",
    headerText : 'Order<br>No.'
},{
    dataField : "worNo",
    headerText : 'OR No.'
}, {
    dataField : "custName",
    headerText : 'Customer Name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "amt",
    headerText : 'Amount',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appType",
    headerText : 'App Type',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "payMode",
    headerText : 'Pay<br>Mode',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "issuebankPaytChannel",
    headerText : 'Issue<br>Bank',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "bankaccnoPaytChannel",
    headerText : 'Bank<br>Account',
}, {
    dataField : "ccNo",
    headerText : 'CRC No.'
}, {
    dataField : "bankReconStus",
    headerText : 'Bank<br>Recon<br>Status',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "canclDt",
    headerText : 'Cancel<br>Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "refAmt",
    headerText : 'Refund<br>Amount',
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "refModeCode",
    visible : false
}, {
    dataField : "refModeName",
    headerText : 'Refund<br>Mode',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "bankAccCode",
    visible : false
}, {
    dataField : "bankAccName",
    headerText : 'Bank<br>Account'
}, {
    dataField : "cardNo",
    headerText : 'Card No.'
}, {
    dataField : "cardHolder",
    headerText : 'Card<br>Holder'
}, {
    dataField : "chqNo",
    headerText : 'Cheque No.'
}, {
    dataField : "refDt",
    headerText : 'Refund<br>Date',
    dataType : "date",
    formatString : "dd/mm/yyyy"
}
];

//그리드 속성 설정
var confirmGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    headerHeight : 40,
    height : 240,
    enableFilter : true,
    // 헤더 높이 지정
    headerHeight : 50
};

//AUIGrid 를 생성합니다.
function fn_createConfirmAUIGrid() {
    // 이미 생성되어 있는 경우
    console.log("isCreated : " + AUIGrid.isCreated("#refund_confirm_grid_wrap"));
    if(AUIGrid.isCreated("#refund_confirm_grid_wrap")) {
    	fn_destroyConfirmGrid();
    }

    // 실제로 #grid_wrap 에 그리드 생성
    confirmGridID = AUIGrid.create("#refund_confirm_grid_wrap", confirmColumnLayout, confirmGridPros);
    // AUIGrid 에 데이터 삽입합니다.
    //AUIGrid.setGridData("#mileage_grid_wrap", gridData);
}

// 그리드를 제거합니다.
function fn_destroyConfirmGrid() {
    AUIGrid.destroy("#refund_confirm_grid_wrap");
    confirmGridID = null;
}

function fn_isEmptyRefundInfo(data) {
	for(var i = 0; i < data.length; i++) {
        if(FormUtil.isEmpty(data[i].refModeName)) {
        	Common.alert('Please enter Refund Mode of line ' + (i+1));
        	return false;
        }
        if(FormUtil.isEmpty(data[i].bankAccName)) {
        	Common.alert('Please enter Bank Account of line ' + (i+1));
            return false;
        }
    }
	return true;
}

function fn_gridDataGrouping(data) {
	var cash = new Array();
	var cheque = new Array();
	var creditCard = new Array();
	var online = new Array();
	var eCash = new Array();
	var autoDebit = new Array();
	
	for(var i = 0; i < data.length; i++) {
		if(data[i].refModeCode == "105"){
			cash.push(data[i]);
		}
		if(data[i].refModeCode == "106"){
			cheque.push(data[i]);
        }
		if(data[i].refModeCode == "107"){
			creditCard.push(data[i]);
        }
		if(data[i].refModeCode == "108"){
			online.push(data[i]);
        }
		if(data[i].refModeCode == "109"){
			eCash.push(data[i]);
        }
        if(data[i].refModeCode == "110"){
        	autoDebit.push(data[i]);
        }
	}
	
	var result = new Array();
	result.push(cash);
	result.push(cheque);
	result.push(creditCard);
	result.push(online);
	result.push(eCash);
	result.push(autoDebit);
	
	return result;
}

function fn_checkRefundValid() {
    var gridDataList = AUIGrid.getGridData(confirmGridID);
    if(fn_isEmptyRefundInfo(gridDataList)) {
    	var data = fn_gridDataGrouping(gridDataList);
        Common.ajax("POST", "/payment/checkRefundValid.do", {gridDataList:data}, function(result) {
        	console.log(result);
            fn_getConfirmRefund(result);
            
        });
        
    }
}

function fn_getConfirmRefund(result) {
    if(result.data) {
    	batchIdList = result.data
        Common.ajax("POST", "/payment/getConfirmRefund.do", {batchIdList:result.data}, function(result) {
        	console.log(result);
            fn_setConfirmRefund(result);
        });
    } else {
        Common.alert(result.message);
    }
}

function fn_setConfirmRefund(result) {
	var checkList = AUIGrid.getItemsByValue(refundGridID, "isActive", "Active");
	
	var gridData = fn_conversionForGridData(checkList, result.gridDataList);
	
	$("#conf_popup_wrap").show();
	
	fn_createConfirmAUIGrid();
	
	AUIGrid.setGridData(confirmGridID, gridData);
	
	fn_setConfirmPopEvent();
	
	$("#totItem").text(result.totalItem);
	$("#totValid").text(result.totalValid);
	$("#totInvalid").text(result.totalInvalid);
    
    var str =""+ Number(result.totalAmt).toFixed(2);
    var str2 = str.split(".");
    if(str2.length == 1){           
        str2[1] = "00";
    }
    str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"."+str2[1];
    $("#totRefAmt").text(str);
    
    str =""+ Number(result.totalValidAmt).toFixed(2);
    str2 = str.split(".");
    if(str2.length == 1){           
        str2[1] = "00";
    }
    str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"."+str2[1];
    $("#totValidAmt").text(str);
    
    str =""+ Number(result.totalInvalidAmt).toFixed(2);
    str2 = str.split(".");
    if(str2.length == 1){           
        str2[1] = "00";
    }
    str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"."+str2[1];
    $("#totInvalidAmt").text(str);
}

function fn_conversionForGridData(checkList, bRefundItem) {
	console.log("conversionForGridData Action");
	console.log(checkList);
	console.log(bRefundItem);
	for(var i = 0; i < checkList.length; i++) {
		for(var j = 0; j < bRefundItem.length; j++) {
			var item = bRefundItem[j];
			console.log("j : " + j);
			console.log(item);
			for(var k = 0; k < item.length; k++) {
				console.log("k : " + k);
	            console.log(item[k]);
				if(checkList[i].worNo == item[k].worNo) {
	                checkList[i].detId = item[k].detId;
	                checkList[i].validStusId = item[k].validStusId;
	                checkList[i].validRem = item[k].validRem;
	                checkList[i].refAmt = item[k].amt;
	                checkList[i].refModeCode = item[k].refModeCode;
	                checkList[i].refModeName = item[k].refModeName;
	                checkList[i].bankAccCode = item[k].accCode;
	                checkList[i].bankAccName = item[k].accDesc;
	                checkList[i].cardNo = item[k].ccNo;
	                checkList[i].cardHolder = item[k].ccHolderName;
	                checkList[i].chqNo = item[k].chqNo;
	                checkList[i].refDt = item[k].refDtDay + "/" + item[k].refDtMonth + "/" + item[k].refDtYear;
	            }
			}
		}
	}
	return checkList;
}

function fn_setConfirmPopEvent() {
	$("#close_btn1").click(fn_closePop1);
    $("#allItem_btn").click(function() {
        setFilterByValues(0);
    });
    $("#validItem_btn").click(function() {
        setFilterByValues(4);
    });
    $("#invalidItem_btn").click(function() {
        setFilterByValues(21);
    });
    
    $("#validCheck_btn").click(fn_checkRefundValid);
    $("#pConfirm_btn").click(fn_confirm);
    $("#pClear_btn").click(fn_pClear);
    $("#remove_btn").click(fn_refundItemDisab);
    
    AUIGrid.bind(confirmGridID, "cellClick", function( event ) {
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        console.log("CellClick detId : " + event.item.detId);
        // TODO pettyCash Expense Info GET
        detId = event.item.detId;
    });
    
    AUIGrid.bind(confirmGridID, "cellDoubleClick", function( event ) {
        console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        console.log("CellDoubleClick detId : " + event.item.detId);
        // TODO pettyCash Expense Info GET
        if(FormUtil.isEmpty(event.item.validStusId)) {
        	$("#selectedRowIndex").val(event.rowIndex);
            $("#ref_popup_wrap").show();
            fn_setRefundPopEvent();
            
            $("#rSalesOrdNo").val(event.item.ordNo);
            $("#rOrNo").val(event.item.worNo);
            $("#rCustName").val(event.item.custName);
            
            var str =""+ Number(event.item.amt).toFixed(2);
            
            var str2 = str.split(".");
           
            if(str2.length == 1){           
                str2[1] = "00";
            }
            
            str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"."+str2[1];
            console.log(str);
            
            $("#rAmt").val(str);
            $("#rRefAmt").val(str);
            
            fn_setAccNo();
        } else {
        	Common.alert('You have already entered refund information.');
        }
    });
}

function fn_closePop1() {
    //$("#refundConfirmPop").remove();
	$("#conf_popup_wrap").hide();
}

//값에 따라 필터링을 지정합니다.
function setFilterByValues(validStusId) {

    // 참고 : 단순 값에 따른 필터링이 아닌 복잡한 형태(예: 정규식등) 로 필터링 하려면
    // AUIGrid.setFiler() 메소드를 사용하십시오.
    
    // 이름이 "Anna", "Emma" 인 행으로 필터링합니다.
    // 4 : valid, 21 : invalid
    console.log("setFilterByValues");
    console.log(validStusId);
    if(validStusId == 4) {
        AUIGrid.setFilterByValues(confirmGridID, "validStusId", [4]);
    } else if(validStusId == 21) {
        AUIGrid.setFilterByValues(confirmGridID, "validStusId", [21]);
    } else {
        AUIGrid.clearFilterAll(confirmGridID);
    }
    
}

function fn_pClear() {
	var cnt = AUIGrid.getRowCount(confirmGridID);
	for(var i = 0; i < cnt; i++) {
		AUIGrid.restoreEditedRows(confirmGridID, i);
	}
}

function fn_validStusIdCheckForConfirm() {
	var gridDataList = AUIGrid.getGridData(confirmGridID);
	for(var i = 0; i < gridDataList.length; i++) {
        if(FormUtil.isEmpty(gridDataList[i].validStusId)) {
        	Common.alert('Please check the validation first.');
            return false;
        }
    }
    return true;
}

function fn_confirm() {
	if(fn_validStusIdCheckForConfirm()) {
		Common.confirm('Are you sure want to confirm this refund ?', function (){
	        if(Number($("#totInvalid").text()) > 0) {
	            Common.alert('There is some invalid item exist.<br />Confirm is disallowed.');
	        } else {
	            if(Number($("#totValid").text()) > 0) {
	                Common.ajax("POST", "/payment/refundConfirm.do", {batchIdList:batchIdList}, function(result) {
	                    console.log(result);
	                    
	                    //$('#btnConf').hide();
	                    //$('#btnDeactivate').hide();
	                    
	                    Common.alert(result.message);
	                    
	                    fn_closePop1();
	                    
	                    fn_selectRefundList();
	                    
	                    batchIdList = null
	                    
	                });
	            } else {
	                Common.alert('No valid item found.<br />Confirm is disallowed.');
	            }
	        }
	    });
	}
}

function fn_refundItemDisab() {
    console.log("remove Action");
    if(detId > 0) {
        Common.ajax("POST", "/payment/batchRefundItemDisab.do", {detId:detId,batchIdList:batchIdList}, function(result) {
            console.log(result);
            
            //$('#btnConf').hide();
            //$('#btnDeactivate').hide();
            
            Common.alert(result.message);
            
            fn_setConfirmRefund(result.data);
            
            detId = 0;
        });
    } else {
        Common.alert('No item selected.');
    }
}
</script>

<div id="conf_popup_wrap" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Refund Confirmation</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="close_btn1">Close</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" id="form_refundConfirm">
<input type="hidden" id="pBatchId" name="batchId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Total Item</th>
    <td id="totItem"></td>
    <th scope="row">Total Valid</th>
    <td id="totValid"></td>
    <th scope="row">Total Invalid</th>
    <td id="totInvalid"></td>
</tr>
<tr>
    <th scope="row">Total Refund Amount</th>
    <td id="totRefAmt"></td>
    <th scope="row">Valid Amount</th>
    <td id="totValidAmt"></td>
    <th scope="row">Invalid Amount</th>
    <td id="totInvalidAmt"></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="validCheck_btn">Validation Check</a></p></li>
    <li id="remove_btn_area"><p class="btn_grid"><a href="#" id="remove_btn">Remove</a></p></li>
    <li><p class="btn_grid"><a href="#" id="allItem_btn">All Items</a></p></li>
    <li><p class="btn_grid"><a href="#" id="validItem_btn">Valid Items</a></p></li>
    <li><p class="btn_grid"><a href="#" id="invalidItem_btn">Invalid Items</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="refund_confirm_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns" id="confirm_btn_area">
    <li><p class="btn_blue2 big"><a href="#" id="pConfirm_btn">Confirm</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="pClear_btn">Clear</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<script type="text/javascript">
function fn_setRefundPopEvent() {
    $("#close_btn2").click(fn_closePop2);
    
    $("#rRefAmt").keydown(function (event) { 
        
        var code = window.event.keyCode;
        
        if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) ||code==110 ||code==190 ||code == 8 || code == 9 || code == 13 || code == 46)
        {
         window.event.returnValue = true;
         return;
        }
        window.event.returnValue = false;

        return false;
   });
   
   $("#rRefAmt").click(function () { 
       var str = $("#rRefAmt").val().replace(/,/gi, "");
       $("#rRefAmt").val(str);      
  });
   
   $("#rRefAmt").blur(function () { 
       var str = $("#rRefAmt").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       $("#rRefAmt").val(str);  
  });
   
    $("#rRefAmt").change(function(){
       var str =""+ Math.floor($("#rRefAmt").val() * 100)/100;
              
       var str2 = str.split(".");
      
       if(str2.length == 1){           
           str2[1] = "00";
       }
       
       if(str2[0].length > 11){
           Common.alert("<spring:message code='budget.msg.inputAmount' />");
              str = $("#rAmt").val().replace(/,/gi, "");
       }else{               
           str = str2[0].substr(0, 11)+"."+str2[1] + "00".substring(str2[1].length, 2);   
       }
       
       if(Number($("#rRefAmt").val().replace(/,/gi, "")) > Number($("#rAmt").val().replace(/,/gi, ""))) {
           Common.alert('Refund Amount can not be greater than Amount.');
           str = $("#rAmt").val().replace(/,/gi, "");
       }
       
       str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
       
       $("#rRefAmt").val(str);
       
   }); 
}

function fn_closePop2() {
    //$("#refundConfirmPop").remove();
    $("#ref_popup_wrap").hide();
}

function fn_setAccNo() {
    CommonCombo.make("rAccNo", "/payment/selectAccNoList.do", {payMode:$("#rRefMode").val()}, "", {
        id: "codeId",
        name: "codeName",
        type:"S"
    });
}

function fn_rClear() {
	$("#rRefMode").val("106");
	$("#rRefAmt").val($("#rAmt").val());
	$("#rCcNo").val("");
	$("#rChqNo").val("");
	$("#rCcHolderName").val("");
}

function fn_updateGridData() {
	console.log("fn_updateGridData Action");
	AUIGrid.setCellValue(confirmGridID, $("#selectedRowIndex").val(), "refAmt", $("#rRefAmt").val().replace(/,/gi, ""));
	AUIGrid.setCellValue(confirmGridID, $("#selectedRowIndex").val(), "refModeCode", $("#rRefMode option:selected").val());
	AUIGrid.setCellValue(confirmGridID, $("#selectedRowIndex").val(), "refModeName", $("#rRefMode option:selected").text());
	AUIGrid.setCellValue(confirmGridID, $("#selectedRowIndex").val(), "bankAccCode", $("#rAccNo option:selected").val());
    AUIGrid.setCellValue(confirmGridID, $("#selectedRowIndex").val(), "bankAccName", $("#rAccNo option:selected").text());
    AUIGrid.setCellValue(confirmGridID, $("#selectedRowIndex").val(), "cardNo", $("#rCcNo").val());
    AUIGrid.setCellValue(confirmGridID, $("#selectedRowIndex").val(), "cardHolder", $("#rCcHolderName").val());
    AUIGrid.setCellValue(confirmGridID, $("#selectedRowIndex").val(), "chqNo", $("#rChqNo").val());
    
    fn_rClear();
    fn_closePop2();
}
</script>

<div id="ref_popup_wrap" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="close_btn2">Close</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<form action="#" id="form_refundInfo">
<input type="hidden" id="selectedRowIndex">

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
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rSalesOrdNo"/></td>
    <th scope="row">OR No.</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rOrNo"/></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rCustName"/></td>
</tr>
<tr>
    <th scope="row">Amount</th>
    <td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="rAmt"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Refund Mode</th>
    <td>
    <select class="" id="rRefMode" onchange="javascript:fn_setAccNo()">
    <option value="106" selected="selected">Cheque (CHQ)</option>
    <option value="107">Credit Card (CRC)</option>
    <option value="108">Online Payment (ONL)</option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Bank Account</th>
    <td>
    <select class="" id="rAccNo"></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Refund Amount</th>
    <td><input type="text" title="" placeholder="" class="" id="rRefAmt"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Credit Card No.</th>
    <td><input type="text" title="" placeholder="" class="" id="rCcNo" autocomplete="off"/></td>
    <th scope="row">Cheque No.</th>
    <td><input type="text" title="" placeholder="" class="" id="rChqNo" autocomplete="off"/></td>
</tr>
<tr>
    <th scope="row">Credit Card Holder Name</th>
    <td><input type="text" title="" placeholder="" class="" id="rCcHolderName"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

</section><!-- search_table end -->

<ul class="center_btns" id="confirm_btn_area">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_updateGridData()" >Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_rClear()">Clear</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
