<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

$(document).ready(function(){
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    AUIGrid.setSelectionMode(myGridID, "singleRow");  
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){ 
        selectedGridValue = event.rowIndex;
    });
    
    //fn_getBillingList();
    
    var curDate = new Date();   
    
    fn_setYearList(curDate.getFullYear()-10, curDate.getFullYear());
    fn_setMonthList();
    
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 10
};

var columnLayout=[
    {dataField:"taskId", headerText:"<spring:message code='pay.head.taskId'/>"},
    {dataField:"taskType", headerText:"<spring:message code='pay.head.taskType'/>"},
    {dataField:"billingYear", headerText:"<spring:message code='pay.head.year'/>"},
    {dataField:"billingMonth", headerText:"<spring:message code='pay.head.month'/>"},
    {dataField:"totCnt", headerText:"<spring:message code='pay.head.bills'/>"},
    {dataField:"totAmt", headerText:"<spring:message code='pay.head.amount'/>"},
    {dataField:"startDt", headerText:"<spring:message code='pay.head.started'/>", dataType : "date", formatString : "yyyy-mm-dd HH:MM:ss"}, 
    {dataField:"endDt", headerText:"<spring:message code='pay.head.ended'/>", dataType : "date", formatString : "yyyy-mm-dd HH:MM:ss"},
    {dataField:"stus", headerText:"<spring:message code='pay.head.status'/>"},
    {dataField:"isCnfm", headerText:"<spring:message code='pay.head.confirmed'/>",
        renderer:{
            type : "CheckBoxEditRenderer",
            showLabel : false,
            editable : false,
            checkValue : "1",
            unCheckValue : "0"
        }   
    }
];

function fn_setYearList(startYear, endYear){
    //console.log("startYear : " + startYear +", endYear : " + endYear);
    //$("#year option").remove();
    $("#year").append("<option value='' disabled selected hidden>issueYear</option>");
    for(var i=startYear; i<=endYear+1; i++){
        $("#year").append("<option value="+i +">"+i+"</option>");
    }
}

function fn_setMonthList(){
    $("#month").append("<option value='' disabled selected hidden>issueMonth</option>");
    for(var i=1; i<13; i++){
        $("#month").append("<option value="+i +">"+i+"</option>");
    }
}

function fn_getBillingList(){
    if($("#year").val() != null && $("#month").val() != null){
        Common.ajax("GET", "/payment/selectBillingMgmtList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
}

function fn_view(){
    if(selectedGridValue != undefined){
        var value = AUIGrid.getCellValue(myGridID , selectedGridValue , "taskId");
        Common.popupDiv('/payment/initBillingResultPop.do', {taskId:value}, null , true ,'_billingDetailViewPop');      
        
    }else{
        Common.alert("<spring:message code='pay.alert.noTaskId'/>");
    }
}

function fn_createBills(){
    var inputYear = $("#year").val();
    var inputMonth = $("#month").val();
    var curDate = new Date();
    
    if(inputYear == null ){
        Common.alert("<spring:message code='pay.alert.selectYear'/>");
    }
    else if(inputMonth == null){
        Common.alert("<spring:message code='pay.alert.selectMonth'/>");
    }
    
    if(inputYear != null && inputMonth != null){
           console.log("year : " + inputYear + ", month : " + inputMonth);
           
           Common.ajax("GET", "/payment/createBills.do", {"year" : inputYear, "month" : inputMonth}, function(result) {
               Common.alert(result.message);
               fn_getBillingList();
           });
    }
}

function fn_complete(){
    if(selectedGridValue != undefined){
        var taskConfirmed = AUIGrid.getCellValue(myGridID , selectedGridValue , "isCnfm");
        var taskId = AUIGrid.getCellValue(myGridID , selectedGridValue , "taskId");
        console.log(taskConfirmed);
        if(taskConfirmed == 0){
            var taskStatus = AUIGrid.getCellValue(myGridID , selectedGridValue , "stus");
            console.log(taskStatus);
            if(taskStatus == 'SUCCESS'){
                var existBillMonthYear = 0;
                Common.ajax("GET", "/payment/getExistBill.do", {"year" : $("#year").val(), "month" : $("#month").val(), "taskId" : taskId}, function(result) {
                       existBillMonthYear = result;
                       if(existBillMonthYear > 0){
                             Common.alert("<spring:message code='pay.alert.failSaveReqBillGen'/>");
                       }else{
                             var taskType = AUIGrid.getCellValue(myGridID , selectedGridValue , "taskType");
                             var success = -1;
                             console.log("taskType : " + taskType);
                             Common.ajax("GET", "/payment/confirmAlltBill.do", {"taskId" : taskId, "type" : taskType}, function(returnValue) {
                                 success = returnValue;
                                 
                                 console.log("success : " + success);
                                 if(success == 1){
                                     fn_getBillingList();
                                     Common.alert("<spring:message code='pay.alert.billTaskConf'/>");
                                 }else{
                                     Common.alert("<spring:message code='pay.alert.failSaveReqAgain'/>");
                                 }
                             });
                             
                       }
                });
            }else{
                Common.alert("<spring:message code='pay.alert.failSaveSuccessStatus'/>");
            }
        }else{
            Common.alert("<spring:message code='pay.alert.failSaveReqTaskGen'/>");
        }
    }else{
        Common.alert("<spring:message code='pay.alert.noTaskId'/>");
    }
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Rental</h2>   
        <ul class="right_btns">
         <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_createBills()"><spring:message code='pay.btn.createBills'/></a></p></li>
          </c:if> 
           <c:if test="${PAGE_AUTH.funcChange == 'Y'}">  
             <li><p class="btn_blue"><a href="javascript:fn_createBills()"><spring:message code='pay.btn.createEarlyBills'/></a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}"> 
             <li><p class="btn_blue"><a href="javascript:fn_complete()"><spring:message code='pay.btn.confirmBills'/></a></p></li>
            </c:if>
             <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a href="javascript:fn_getBillingList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </c:if>
        </ul>    
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:200px" />
                    <col style="width:144px" />
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Year</th>
                        <td>
                            <select id="year" name="year" class="w100p"></select>
                        </td>
                        <th scope="row">Month</th>
                        <td>
                            <select id="month" name="month" class="w100p"></select>
                        </td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
        </form>
        <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                         <li><p class="link_btn"><a href="javascript:fn_view()"><spring:message code='pay.btn.link.viewDetails'/></a></p></li>
                        </c:if>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
    </section>

    <!-- search_result start -->
    <section class="search_result">     
         <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap mt10"></article>
        <!-- grid_wrap end -->
        
    </section>
</section>
<!-- popup_wrap end -->