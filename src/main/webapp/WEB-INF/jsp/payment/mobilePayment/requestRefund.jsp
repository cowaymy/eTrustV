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
        { dataField : "mobTicketNo", width:80, headerText : "<spring:message code='pay.title.ticketNo'/>" }
    ,   { dataField : "reqDt", width:100, headerText : "<spring:message code='pay.head.requestDate'/>" }
    ,   { dataField : "ticketStusNm", width:100, headerText : "<spring:message code='pay.head.Status'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "ordNo", width:140, headerText : "<spring:message code='pay.head.orderNO'/>" }
    ,   { dataField : "custName", width:200, headerText : "<spring:message code='pay.head.custName'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "worNo", width:120, headerText : "<spring:message code='pay.head.worNo'/>" }
    ,   { dataField : "amt", width:100, headerText : "<spring:message code='pay.head.amount'/>", dataType : "numeric", formatString : "#,##0.00", style : "aui-grid-user-custom-right" }
    ,   { dataField : "issuBankName", width:200, headerText : "<spring:message code='pay.head.customerIssueBank'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "custAccNo", width:200, headerText : "<spring:message code='pay.head.customerBankAccount'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "refResnName", width:120, headerText : "<spring:message code='pay.head.reason'/>", style : "aui-grid-user-custom-left" }
    ,   {
                dataField : "refAttchImgUrl"
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
    ,   { dataField : "rem", width:100, headerText : "<spring:message code='pay.head.remark'/>", style : "aui-grid-user-custom-left"}
    ,   { dataField : "brnchCode", width:100, headerText : "<spring:message code='log.head.branchcode'/>" }
    ,   { dataField : "memCode", width:100, headerText : "<spring:message code='pay.head.memberCode'/>" }
    ,   { dataField : "updDt", width:160, headerText : "<spring:message code='pay.head.updateDate'/>" }
    ,   { dataField : "updUserId", width:140, headerText : "<spring:message code='pay.head.updateUser'/>", style : "aui-grid-user-custom-left" }
    ,   { dataField : "refReqId", visible : false }
    ,   { dataField : "ticketStusId", visible : false }
    ,   { dataField : "refResn", visible : false }
    ,   { dataField : "issuBankId", visible : false }
    ,   { dataField : "refAttchImg", visible : false }
    ,   { dataField : "atchFileName", visible : false }
    ,   { dataField : "physiclFileName", visible : false }
];













$(document).ready(function () {
	fn_setToDay();

    CommonCombo.make("ticketStusId", "/payment/requestRefund/selectTicketStatusCode.do", null, "", { id: "code", name: "codeName",  type:"S" });

	var refundGridPros = {
		selectionMode : "singleRow"//셀 선택모드를 지정합니다. 유효 속성값은 다음과 같습니다.
	};

    myGridID = AUIGrid.create("#grid_wrap", refundColumnLayout, refundGridPros);//List

    myExcelID = AUIGrid.create("#grid_excel_wrap", refundColumnLayout, refundGridPros);//Excel

    AUIGrid.bind(myGridID, "pageChange", function(event) {
        fn_searchPage(event.currentPage);
    });

    AUIGrid.bind(myGridID, "cellClick", function( event ) {
        if( event.dataField == "refAttchImgUrl" ){
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
    Common.ajax("POST", "/payment/requestRefund/selectRequestRefundList.do",  $.extend($("#searchForm").serializeObject(), {"pageNo":pageNo, "pageSize":20, "gu" : "LIST"}), function(result) {
        GridCommon.createExtPagingNavigator(pageNo, result.total, {funcName:'fn_searchPage'});
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
    Common.ajax("POST", "/payment/requestRefund/selectRequestRefundList.do",  $.extend($("#searchForm").serializeObject(), {"gu" : "EXCEL"}), function(result) {
        AUIGrid.setGridData(myExcelID, result.dataList);
        GridCommon.exportTo("#grid_excel_wrap", 'xlsx', 'Request Fund Transfer');
    })
}



function fn_approve(){
    var indexArr = AUIGrid.getSelectedIndex(myGridID);
    if( indexArr[0] == -1 ){
    	Common.alert("<spring:message code='pay.check.noRowsSelected'/>");

    }else{
    	var ticketStusId = AUIGrid.getCellValue(myGridID, indexArr[0], "ticketStusId");
    	if( ticketStusId != 1 ){
    		Common.alert("<spring:message code='pay.check.ticketStusId'/>");

    	}else{
    		Common.confirm("<spring:message code='pay.confirm.approve'/>", function(){

    		    Common.ajaxSync("POST", "/payment/requestRefund/saveRequestRefundArrpove.do", AUIGrid.getSelectedItems(myGridID)[0].item , function(result) {
    		        if(result !=""  && null !=result ){
    		            Common.alert("<spring:message code='pay.alert.approve'/>", function(){
    		                fn_search(1);
    		            });
    		        }
    		    });

    		});
    	}
    }
}



function fn_rejcet(){
    var indexArr = AUIGrid.getSelectedIndex(myGridID);
    if( indexArr[0] == -1 ){
    	Common.alert("<spring:message code='pay.check.noRowsSelected'/>");

    }else{
        var ticketStusId = AUIGrid.getCellValue(myGridID, indexArr[0], "ticketStusId");
        if( ticketStusId != 1 ){
        	Common.alert("<spring:message code='pay.check.ticketStusId'/>");

        }else{
            Common.prompt("<spring:message code='pay.prompt.reject'/>", "", function(){
            	if( FormUtil.isEmpty($("#promptText").val()) ){
            		Common.alert("<spring:message code='pay.check.rejectReason'/>");

            	}else{
                    var rejectData = AUIGrid.getSelectedItems(myGridID)[0].item;
                    rejectData.rem = $("#promptText").val();
                    Common.ajaxSync("POST", "/payment/requestRefund/saveRequestRefundReject.do", rejectData, function(result) {
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
}
</script>






<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>



    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Request Refund</h2>
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
                            <input type="text" title="Order No." placeholder="Order No." class="w100p" id="ordNo" name="ordNo"/>
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
        <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
        <article class="grid_wrap" id="grid_excel_wrap" style="display: none;"></article>
    </section>
</section>