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
var confirmGridID;
var detId = 0;
var batchIdList = null;
var selectedItem = null;
var selectedRowIndex = null;
var confirmColumnLayout = [ {
    dataField : "detId",
    visible : false
}, {
    dataField : "validStusId",
    headerText : "<spring:message code='pay.head.validStatus'/>"
}, {
    dataField : "validRem",
    headerText : "<spring:message code='pay.head.validRemark'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "ordNo",
    headerText : "<spring:message code='pay.head.orderNo'/>"
},{
    dataField : "worNo",
    headerText : "<spring:message code='pay.head.orNo'/>"
}, {
    dataField : "custName",
    headerText : "<spring:message code='pay.head.customerName'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "amt",
    headerText : "<spring:message code='pay.head.amoumt'/>",
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "appType",
    headerText : "<spring:message code='pay.head.appType'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "payMode",
    headerText : "<spring:message code='pay.head.payMode'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "issuebankPaytChannel",
    headerText : "<spring:message code='pay.head.issueBank'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "bankaccnoPaytChannel",
    headerText : "<spring:message code='pay.head.bankAccount'/>",
}, {
    dataField : "ccNo",
    headerText : "<spring:message code='pay.head.crcNo'/>"
}, {
    dataField : "bankReconStus",
    headerText : "<spring:message code='pay.head.bankReconStatus'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "canclDt",
    headerText : "<spring:message code='pay.head.cancelDate'/>",
    dataType : "date",
    formatString : "dd/mm/yyyy"
}, {
    dataField : "refAmt",
    headerText : "<spring:message code='pay.head.refundAmount'/>",
    style : "aui-grid-user-custom-right",
    dataType: "numeric",
    formatString : "#,##0.00"
}, {
    dataField : "refModeCode",
    visible : false
}, {
    dataField : "refModeName",
    headerText : "<spring:message code='pay.head.refundMode'/>",
    style : "aui-grid-user-custom-left"
}, {
    dataField : "bankAccCode",
    visible : false
}, {
    dataField : "bankAccName",
    headerText : "<spring:message code='pay.head.bankAccount'/>"
}, {
    dataField : "cardNo",
    headerText : "<spring:message code='pay.head.cardNo'/>"
}, {
    dataField : "cardHolder",
    headerText : "<spring:message code='pay.head.cardHolder'/>"
}, {
    dataField : "chqNo",
    headerText : "<spring:message code='pay.head.chequeNo'/>"
}, {
    dataField : "refDt",
    headerText : "<spring:message code='pay.head.refundDate'/>",
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
    headerHeight : 50,
    softRemoveRowMode : false,
    // 셀 선택모드 (기본값: singleCell)
    selectionMode : "multipleCells"
};

$(document).ready(function () {
	$("#close_btn1").click(fn_closePop1);
    $("#allItem_btn").click(function() {
        if(fn_validStusIdCheckForConfirm()) {
            setFilterByValues(0);
        }
    });
    $("#validItem_btn").click(function() {
        if(fn_validStusIdCheckForConfirm()) {
            setFilterByValues(4);
        }
    });
    $("#invalidItem_btn").click(function() {
        if(fn_validStusIdCheckForConfirm()) {
            setFilterByValues(21);
        }
    });
    
    $("#validCheck_btn").click(fn_checkRefundValid);
    $("#pConfirm_btn").click(fn_refundConfirm);
    $("#pClear_btn").click(fn_pClear);
    $("#remove_btn").click(fn_refundItemDisab);
});

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
    
    fn_setConfirmGridEvent();
}

function fn_setConfirmGridEvent() {
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
            selectedRowIndex = event.rowIndex;
            selectedItem = event.item;
            
            fn_refundInfoKeyInPop();
        } else {
            Common.alert("<spring:message code='pay.alert.eneterRefundInfo'/>");
        }
    });
}

// 그리드를 제거합니다.
function fn_destroyConfirmGrid() {
    AUIGrid.destroy("#refund_confirm_grid_wrap");
    confirmGridID = null;
}

function fn_isEmptyRefundInfo(data) {
    var result = true;
    for(var i = 0; i < data.length; i++) {
        if(FormUtil.isEmpty(data[i].refModeName)) {
            result = false;
            Common.alert("<spring:message code='pay.alert.enterRefundMode' arguments='"+(i+1)+"' htmlEscape='false'/>");
            break;
        }
        if(FormUtil.isEmpty(data[i].bankAccName)) {
            result = false;
            Common.alert("<spring:message code='pay.alert.enterBankAccount' arguments='"+(i+1)+"' htmlEscape='false'/>");
            break;
        }
    }
    return result;
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
    
    //$("#conf_popup_wrap").show();
    
    fn_createConfirmAUIGrid();
    
    AUIGrid.setGridData(confirmGridID, gridData);
    
    fn_setConfirmRefundHeader(result);
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

function fn_refundInfoKeyInPop() {
    Common.popupDiv("/payment/refundInfoKeyInPop.do", null, null, true, "refundInfoKeyInPop", fn_showKeyInPop);
}

function fn_showKeyInPop() {
    $("#rSalesOrdNo").val(selectedItem.ordNo);
    $("#rOrNo").val(selectedItem.worNo);
    $("#rCustName").val(selectedItem.custName);
    
    var str =""+ Number(selectedItem.amt).toFixed(2);
    
    var str2 = str.split(".");
   
    if(str2.length == 1){           
        str2[1] = "00";
    }
    
    str = str2[0].replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"."+str2[1];
    console.log(str);
    
    $("#rAmt").val(str);
    $("#rRefAmt").val(str);
    
    CommonCombo.make("rRefMode", "/payment/selectCodeList.do", null, "", {
        id: "code",
        name: "codeName",
        type:"S"
    });
    
    fn_setAccNo();
    
    selectedItem = null;
}

function fn_closePop1() {
    $("#refundConfirmPop").remove();
    //$("#conf_popup_wrap").hide();
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
    var result = true;
    var gridDataList = AUIGrid.getGridData(confirmGridID);
    for(var i = 0; i < gridDataList.length; i++) {
        if(FormUtil.isEmpty(gridDataList[i].validStusId)) {
            result = false;
            Common.alert("<spring:message code='pay.alert.validFirst'/>");
            break;
        }
    }
    return result;
}

function fn_refundConfirm() {
    console.log("fn_confirm Action start");
    if(fn_validStusIdCheckForConfirm()) {
        console.log("if Action");
        Common.confirm("<spring:message code='pay.alert.confirmRefund'/>", function (){
            console.log("confirmPop Action");
            if(Number($("#totInvalid").text()) > 0) {
                Common.alert("<spring:message code='pay.alert.invalidItemExist'/>");
            } else {
                if(Number($("#totValid").text()) > 0) {
                    Common.ajax("POST", "/payment/refundConfirm.do", {batchIdList:batchIdList}, function(result) {
                        console.log(result);
                        
                        //$('#btnConf').hide();
                        //$('#btnDeactivate').hide();
                        
                        fn_selectRefundList();
                        
                        Common.alert(result.message);
                        
                        fn_closePop1();
                        
                        batchIdList = null
                        
                    });
                } else {
                    Common.alert("<spring:message code='pay.alert.validItemFound'/>");
                }
            }
        });
    }
}

function fn_refundItemDisab() {
    console.log("remove Action");
    if(fn_validStusIdCheckForConfirm()) {
        if(detId > 0) {
            Common.ajax("POST", "/payment/refundItemDisab.do", {detId:detId,batchIdList:batchIdList}, function(result) {
                
                Common.alert(result.message);
                
                AUIGrid.removeRow(confirmGridID, AUIGrid.getRowIndexesByValue(confirmGridID, "detId", detId));
                
                fn_setConfirmRefundHeader(result.data);
                
                detId = 0;
            });
        } else {
            Common.alert("<spring:message code='pay.alert.noItem'/>");
        }
    }
}

function fn_setConfirmRefundHeader(result) {
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
</script>

<!-- <div id="conf_popup_wrap" class="popup_wrap" style="display: none;"> --><!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Refund Confirmation</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="close_btn1"><spring:message code='sys.btn.close'/></a></p></li>
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
    <li><p class="btn_grid"><a href="#" id="validCheck_btn"><spring:message code='pay.btn.validationCheck'/></a></p></li>
    <li id="remove_btn_area"><p class="btn_grid"><a href="#" id="remove_btn"><spring:message code='pay.btn.remove'/></a></p></li>
    <li><p class="btn_grid"><a href="#" id="allItem_btn"><spring:message code='pay.btn.allItems'/></a></p></li>
    <li><p class="btn_grid"><a href="#" id="validItem_btn"><spring:message code='pay.btn.validItems'/></a></p></li>
    <li><p class="btn_grid"><a href="#" id="invalidItem_btn"><spring:message code='pay.btn.invalidItems'/></a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="refund_confirm_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns" id="confirm_btn_area">
    <li><p class="btn_blue2 big"><a href="#" id="pConfirm_btn"><spring:message code='pay.btn.confirm'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="pClear_btn"><spring:message code='sys.btn.clear'/></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
