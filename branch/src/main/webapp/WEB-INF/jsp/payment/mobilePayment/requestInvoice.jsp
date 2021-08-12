<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>



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
var gridDataLength = 0;
var myGridID;
var myExcelID;
var refundColumnLayout =
[
        { dataField : "mobTicketNo", cellMerge : true , width:80, headerText : "<spring:message code='pay.title.ticketNo'/>" }
    ,   { dataField : "reqDt", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:100, headerText : "<spring:message code='sal.text.requestDate'/>" }
    ,   { dataField : "reqStusIdNm", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:100, headerText : "<spring:message code='pay.head.satatus'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "invcTypeNm", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:140, headerText : "<spring:message code='invoiceApprove.invcType'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "invcItmOrdNo", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:100, headerText : "<spring:message code='pay.head.order No'/>" }
    ,   { dataField : "taxInvcId", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:100, headerText : "<spring:message code='pay.head.invcId'/>" }
    ,   { dataField : "taxInvcRefNo", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:140, headerText : "<spring:message code='pay.head.brNo'/>" }
    ,   { dataField : "email", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:200, headerText : "<spring:message code='pay.head.email'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "email2", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:200, headerText : "<spring:message code='pay.head.addEmail'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "invcAdvPrd", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:80, headerText : "<spring:message code='pay.head.period'/>" }
    ,   { dataField : "reqInvcMonthYear", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:120, headerText : "<spring:message code='pay.head.startOfPeriod'/>" }
    ,   { dataField : "invcItmDiscRate", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:120, headerText : "<spring:message code='pay.head.discountRate'/>", dataType : "numeric", style : "aui-grid-user-custom-right" }
    ,   { dataField : "invcItmExgAmt", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:140, headerText : "<spring:message code='pay.head.existingAmount'/>", dataType : "numeric", formatString : "#,##0.00", style : "aui-grid-user-custom-right" }
    ,   { dataField : "invcItmTotAmt", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:100, headerText : "<spring:message code='pay.head.amoumt'/>",         dataType : "numeric", formatString : "#,##0.00", style : "aui-grid-user-custom-right" }
    ,   { dataField : "invcCntcPerson", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:140, headerText : "<spring:message code='pay.head.contactPerson'/>" }
    ,   { dataField : "invcItmPoNo", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:160, headerText : "<spring:message code='pay.head.pOno'/>", style : "aui-grid-user-custom-left" }
    ,   {
                dataField : "invcItmPoImgUrl"
            ,   cellMerge : true
            ,   mergeRef : "mobTicketNo"
            ,   mergePolicy : "restrict"
            ,   width : 100
            ,   headerText : "<spring:message code='pay.head.pOAttach'/>"
            ,   renderer : {
                               type : "ImageRenderer",
                               width : 20,
                               height : 20,
                               imgTableRef :
                               {
                            	   "DOWN": "${pageContext.request.contextPath}/resources/AUIGrid/images/arrow-down-black-icon.png"
                               }
                            }
        }
    ,   { dataField : "rem", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:100, headerText : "<spring:message code='pay.head.remark'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "branchCode", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:100, headerText : "<spring:message code='log.head.branchcode'/>" }
    ,   { dataField : "memberCode", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:100, headerText : "<spring:message code='pay.head.memberCode'/>" }
    ,   { dataField : "updDt", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:160, headerText : "<spring:message code='pay.head.updateDate'/>" }
    ,   { dataField : "updUserId", cellMerge : true, mergeRef : "mobTicketNo", mergePolicy : "restrict", width:140, headerText : "<spring:message code='pay.head.updateUser'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "reqStusId", visible : false }
    ,   { dataField : "invcType", visible : false }
    ,   { dataField : "reqInvcNo", visible : false }
    ,   { dataField : "reqIndex", visible : false }
    ,   { dataField : "invcItmRentalFee", visible : false }
    ,   { dataField : "atchFileName", visible : false }
    ,   { dataField : "physiclFileName", visible : false }
];













$(document).ready(function () {
    fn_setToDay();



    CommonCombo.make("ticketStusId", "/payment/requestInvoice/selectTicketStatusCode.do", null, "", { id: "code", name: "codeName",  type:"S" });



    CommonCombo.make("invcType", "/payment/requestInvoice/selectInvoiceType.do", null, "", { id: "code", name: "codeName", type:"S" });



    var refundGridPros = {
              selectionMode : "multipleRows"//셀 선택모드를 지정합니다. 유효 속성값은 다음과 같습니다.
        ,     enableCellMerge : true
        ,     rowSelectionWithMerge : true
        ,     cellMergePolicy : "withNull"
    };

    myGridID = AUIGrid.create("#grid_wrap", refundColumnLayout, refundGridPros);//List

    /* myExcelID = AUIGrid.create("#grid_excel_wrap", refundColumnLayout, refundGridPros);//Excel */

    AUIGrid.bind(myGridID, "pageChange", function(event) {
        fn_searchPage(event.currentPage);
    });



    AUIGrid.bind(myGridID, "cellClick", function( event ) {
        if( event.dataField == "invcItmPoImgUrl" ){
            if( FormUtil.isEmpty(event.value) == false){
                var rowVal = AUIGrid.getItemByRowIndex(myGridID, event.rowIndex);
                if( FormUtil.isEmpty(rowVal.atchFileName) == false && FormUtil.isEmpty(rowVal.physiclFileName) == false){
                    window.open("/file/fileDownWasMobile.do?subPath=" + rowVal.fileSubPath + "&fileName=" + rowVal.physiclFileName + "&orignlFileNm=" + rowVal.atchFileName);
                }
            }
        }
    });
});



function fn_setToDay() {
    var today = new Date();

    today.setMonth(today.getMonth() - 1);
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm;
    }
    var fromReqDt = dd + "/" + mm + "/" + yyyy;
    $("#fromReqDt").val(fromReqDt);

    today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm;
    }
    var toReqDt = dd + "/" + mm + "/" + yyyy;
    $("#toReqDt").val(toReqDt);
}



function fn_search(){
    fn_searchPage(1);
}



function fn_searchPage(pageNo){
    Common.ajax("POST", "/payment/requestInvoice/selectRequestInvoiceList.do",  $.extend($("#searchForm").serializeObject(), {"pageNo":pageNo, "pageSize":20, "gu" : "ALL"}), function(result) {
        //GridCommon.createExtPagingNavigator(pageNo, result.total, {funcName:'fn_searchPage'});
        AUIGrid.setGridData(myGridID, result.dataList);
    });
}



function fn_clear(){
    $("#searchForm").each(function() {
        this.reset();
    });
    fn_setToDay();
}



function fn_excel(){
    GridCommon.exportTo("grid_wrap", 'xlsx', 'Request Invoice');
/*
    Common.ajax("POST", "/payment/requestInvoice/selectRequestInvoiceList.do",  $.extend($("#searchForm").serializeObject(), {"gu" : "EXCEL"}), function(result) {
        AUIGrid.setGridData(myExcelID, result.dataList);
        GridCommon.exportTo("grid_excel_wrap", 'xlsx', 'Request Invoice');
    })
*/
}



function fn_approve(){
    var selectGrd = AUIGrid.getSelectedItems(myGridID);
    if( selectGrd.length <= 0 ){
        Common.alert("<spring:message code='pay.check.noRowsSelected'/>");

    }else{
        var reqStusId = AUIGrid.getCellValue(myGridID, selectGrd[0].rowIndex, "reqStusId");
        if( reqStusId != 1 ){
            Common.alert("<spring:message code='pay.check.reqStusId'/>");
            return false;
        }

        Common.confirm("<spring:message code='pay.confirm.approve'/>", function(){
            Common.ajaxSync("POST", "/payment/requestInvoice/saveRequestInvoiceArrpove.do", selectGrd[0].item, function(result) {
            	console.log("fn_approve "+result);
                if(result !=""  && null !=result ){
                    Common.alert("<spring:message code='pay.alert.approve'/>", function(){
                        fn_search(1);
                    });
                }
            });

        });
    }
}



function fn_rejcet(){
    var selectGrd = AUIGrid.getSelectedItems(myGridID);
    if( selectGrd.length <= 0 ){
        Common.alert("<spring:message code='pay.check.noRowsSelected'/>");

    }else{
        var reqStusId = AUIGrid.getCellValue(myGridID, AUIGrid.getSelectedItems(myGridID)[0].rowIndex, "reqStusId");
        if( reqStusId != 1 ){
            Common.alert("<spring:message code='pay.check.reqStusId'/>");
            return false;
        }

        Common.prompt("<spring:message code='pay.prompt.reject'/>", "", function(){
            if( FormUtil.isEmpty($("#promptText").val()) ){
                Common.alert("<spring:message code='pay.check.rejectReason'/>");

            }else{
                var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;
                rejectData.rem = $("#promptText").val();
                Common.ajaxSync("POST", "/payment/requestInvoice/saveRequestInvoiceReject.do", rejectData, function(result) {
                    if(result !=""  && null !=result ){
                        Common.alert("<spring:message code='pay.alert.reject'/>", function(){
                            fn_search(1);
                        });
                    }
                });

            }
        });
    }
}
</script>






<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>



    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Request Invoice</h2>
        <ul class="right_btns">
            <li>
                <p class="btn_blue">
                    <a href="#" onclick="javascript:fn_search()">
                        <span class="search"></span>
                        <spring:message code='sys.btn.search'/>
                    </a>
                </p>
            </li>
            <li>
                <p class="btn_blue">
                    <a href="#" onclick="javascript:fn_clear()">
                        <span class="clear"></span>
                        <spring:message code='sys.btn.clear'/>
                    </a>
                </p>
            </li>
        </ul>
    </aside>



    <section class="search_table">
        <form id="searchForm" method="post" onsubmit="return false;">
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
<!--[1.Start]  -->
                    <tr>
                        <th scope="row">Ticket No.</th>
                        <td><input type="text" title="Ticket No." placeholder="Ticket No." class="w100p" id="mobTicketNo" name="mobTicketNo"/></td>

                        <th scope="row">Ticket Request Date</th>
                        <td>
                            <div class="date_set w100p">
                                <p>
                                    <input type="text" title="Ticket Request Date" placeholder="DD/MM/YYYY" class="j_date" id="fromReqDt" name="fromReqDt"/>
                                </p>
                                <span>To</span>
                                <p>
                                    <input type="text" title="Ticket Request Date" placeholder="DD/MM/YYYY" class="j_date" id="toReqDt" name="toReqDt"/>
                                </p>
                            </div>
                        </td>
                    </tr>
<!--[1.End]  -->
<!--[2.Start]  -->
                    <tr>
                        <th scope="row">Order No.</th>
                        <td>
                            <input type="text" title="Order No." placeholder="Order No." class="w100p" id="salesOrdNo" name="salesOrdNo"/>
                        </td>

                        <th scope="row">Ticket Status</th>
                        <td>
                            <select class="w100p" id="ticketStusId" name="ticketStusId"></select>
                        </td>
                    </tr>
<!--[2.End]  -->
<!--[3.Start]  -->
                    <tr>
                        <th scope="row">Branch Code</th>
                        <td>
                            <input type="text" title="Branch Code" placeholder="Branch Code" class="w100p" id="brnchCode" name="brnchCode"/>
                        </td>

                        <th scope="row">Member Code</th>
                        <td>
                            <input type="text" title="Member Code" placeholder="Member Code" class="w100p" id="memCode" name="memCode"/>
                        </td>
                    </tr>
<!--[3.End]  -->
<!--[4.Start]  -->
                    <tr>
                        <th scope="row">Invoce Type</th>
                        <td>
                            <select class="w100p" id="invcType" name="invcType"></select>
                        </td>

                        <th scope="row"></th>
                        <td></td>
                    </tr>
<!--[4.End]  -->
                </tbody>
            </table>
        </form>
    </section>



    <ul class="right_btns">
        <li>
            <p class="btn_grid">
                <a href="#" onclick="javascript:fn_excel()">
                    <spring:message code='pay.btn.exceldw'/>
                </a>
            </p>
        </li>
        <li>
            <p class="btn_grid">
                <a href="#" onclick="javascript:fn_approve()">
                    <spring:message code='pay.btn.approve'/>
                </a>
            </p>
        </li>
        <li>
            <p class="btn_grid">
                <a href="#" onclick="javascript:fn_rejcet()">
                    <spring:message code='budget.Reject'/>
                </a>
            </p>
        </li>
    </ul>



    <section class="grid_wrap">
        <article class="grid_wrap">
            <div class="autoGridHeight" style="width:100%; margin:0 auto;" id="grid_wrap"></div>
        </article>
        <!-- <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div> -->
        <!-- <article class="grid_wrap" id="grid_excel_wrap" style="display: none;"></article> -->
    </section>
</section>