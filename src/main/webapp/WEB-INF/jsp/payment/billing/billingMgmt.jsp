<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

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
    {dataField:"taskId", headerText:"Task ID"},
    {dataField:"taskType", headerText:"TaskType"},
    {dataField:"billingYear", headerText:"Year"},
    {dataField:"billingMonth", headerText:"Month"},
    {dataField:"totCnt", headerText:"Bills"},
    {dataField:"totAmt", headerText:"Amount"},
    {dataField:"startDt", headerText:"Started", dataType : "date", formatString : "yyyy-mm-dd HH:MM:ss"}, 
    {dataField:"endDt", headerText:"Ended", dataType : "date", formatString : "yyyy-mm-dd HH:MM:ss"},
    {dataField:"stus", headerText:"Status"},
    {dataField:"isCnfm", headerText:"Confirmed",
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
        Common.alert("No Task ID Selected.");
    }
}

function fn_createBills(){
    var inputYear = $("#year").val();
    var inputMonth = $("#month").val();
    var curDate = new Date();
    
    if(inputYear == null ){
        Common.alert("Selecte year for bill generations.");
    }
    else if(inputMonth == null){
        Common.alert("Selecte month for bill generations.");
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
                             Common.alert("Failed to save request. Selected Task Monthly Bill Was Generated.");
                       }else{
                             var taskType = AUIGrid.getCellValue(myGridID , selectedGridValue , "taskType");
                             var success = -1;
                             console.log("taskType : " + taskType);
                             Common.ajax("GET", "/payment/confirmAlltBill.do", {"taskId" : taskId, "type" : taskType}, function(returnValue) {
                                 success = returnValue;
                                 
                                 console.log("success : " + success);
                                 if(success == 1){
                                     fn_getBillingList();
                                     Common.alert("Bill Task Confirmed.");
                                 }else{
                                     Common.alert("Failed to save  request. Please try again later.");
                                 }
                             });
                             
                       }
                });
            }else{
                Common.alert("Failed to save request. Selected Task ID should be Success Status.");
            }
        }else{
            Common.alert("Failed to save request. Selected Task ID Was Generated.");
        }
    }else{
        Common.alert("No Task ID Selected.");
    }
}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Monthly Batch Billing</li>
        <li>Rental</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Rental</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_createBills()">Create Bills</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_createBills()">Create Early Bills</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_complete()">Confirm Bills</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_getBillingList();"><span class="search"></span>Search</a></p></li>
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
                        <li><p class="link_btn"><a href="javascript:fn_view()">View Details</a></p></li>
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