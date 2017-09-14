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
    {dataField:"startDt", headerText:"Started", dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"}, 
    {dataField:"endDt", headerText:"Ended", dataType : "date", formatString : "yyyy-mm-dd hh:MM:ss"},
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
	$("#year").append("<option value=''>issueYear</option>");
	for(var i=startYear; i<=endYear; i++){
		$("#year").append("<option value="+i +">"+i+"</option>");
	}
}

function fn_setMonthList(){
	$("#month").append("<option value=''>issueMonth</option>");
	for(var i=1; i<13; i++){
		$("#month").append("<option value="+i +">"+i+"</option>");
	}
}

function fn_getBillingList(){
	Common.ajax("GET", "/payment/selectBillingMgntList.do", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_view(){
	if(selectedGridValue != undefined){
		var value = AUIGrid.getCellValue(myGridID , selectedGridValue , "taskId");
		
		location.href="/payment/initBillingResult.do?taskId="+value;
	}else{
		Common.alert("No Task ID Selected.");
	}
}

function fn_createBills(){
	var inputYear = $("#year").val();
	var inputMonth = $("#month").val();
	var curDate = new Date();
	
	if(inputYear == '' ){
		Common.alert("Selecte year for bill generations.");
	}
	else if(inputMonth == ''){
		Common.alert("Selecte month for bill generations.");
	}
	
	if(inputYear != '' && inputMonth != ''){
		   console.log("year : " + inputYear + ", month : " + inputMonth);
		   
		   Common.ajax("GET", "/payment/createBills.do", {"year" : inputYear, "month" : inputMonth}, function(result) {
			   Common.alert(result.message);
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
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing</li>
        <li>Billing Management</li>
    </ul>
    
    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="javascript:;" class="click_add_on">My menu</a></p>
        <h2>Billing Management</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getBillingList();"><span class="search"></span>Search</a></p></li>
        </ul>    
    </aside>
    <!-- title_line end -->


 <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">

            <table class="type1"><!-- table start -->
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
        </section>

 <!-- search_result start -->
<section class="search_result">     

    <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="/payment/initMonthlyRawData.do">Monthly Bill Raw Data</a></p></li>
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="javascript:fn_createBills()">Create Bills</a></p></li>
                        <li><p class="link_btn type2"><a href="javascript:fn_createBills()">Create Early Bills</a></p></li>
                        <li><p class="link_btn type2"><a href="javascript:fn_view()">View Details</a></p></li>
                        <li><p class="link_btn type2"><a href="javascript:fn_complete()">Complete Selected Billing</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
    <!-- grid_wrap start -->
    <article id="grid_wrap" class="grid_wrap"></article>
    <!-- grid_wrap end -->
</section>
</section>

<!-- popup_wrap end -->