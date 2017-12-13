<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var mainGrid;
var subGrid1;
var subGrid2;
var subGrid3;
var selectedGridValue;

$(document).ready(function(){
    
    mainGrid = GridCommon.createAUIGrid("#grid_wrap_main", columnLayout, null, gridPros);
    subGrid1 = GridCommon.createAUIGrid("#grid_wrap_sub1", columnLayoutForSub1, null, gridProsForSub);
    subGrid2 = GridCommon.createAUIGrid("#grid_wrap_sub2", columnLayoutForSub2, null, gridProsForSub);
    subGrid3 = GridCommon.createAUIGrid("#grid_wrap_sub3", columnLayoutForSub3, null, gridPros);
    
    Common.ajax("GET", "/payment/selectCommDeduction.do", {}, function(result){
        AUIGrid.setGridData(mainGrid, result);
    });
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(mainGrid, "cellClick", function( event ){ 
    	selectedGridValue = event.rowIndex;
    });  
    
    AUIGrid.bind(subGrid2, "cellClick", function(event){
    	$("#grid_wrap_sub3").show();
    	var payId = AUIGrid.getCellValue(subGrid2, event.rowIndex, "payId");
    	Common.ajax("GET", "/payment/selectDetailForPaymentResult.do", {"payId" : payId}, function(result){
            AUIGrid.setGridData(subGrid3, result);
            AUIGrid.resize(subGrid3);
        });
    });
    
    $("#grid_wrap_sub1").hide();
    $("#grid_wrap_sub2").hide();
    $("#grid_wrap_sub3").hide();
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 5,
        height:200
};

var gridProsForSub = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 10
};

var columnLayout=[
       {dataField:"fileId", headerText:"File No"},
       {dataField:"fileName", headerText:"File Name"},
       {dataField:"fileDt", headerText:"Upload date",dataType:"date",formatString:"dd-mm-yyyy"},
       {dataField:"fileRefNo", headerText:"File Type"},
       {dataField:"totRcord", headerText:"Total Records"},
       {dataField:"totAmt", headerText:"Total Amount", dataType:"numeric", formatString:"#,##0.00"},
       {dataField:"fileStus", headerText:"File Status"}
];

var columnLayoutForSub1=[
       {dataField:"fileId", headerText:"FileID"},
       {dataField:"itmId", headerText:"ItemID"},
       {dataField:"ordNo", headerText:"Order No"},
       {dataField:"memCode", headerText:"Member Code"},
       {dataField:"amt", headerText:"Amount"},
       {dataField:"syncCmplt", headerText:"Status"}
];

var columnLayoutForSub2=[
       {dataField:"trxId", headerText:"TrxNo"},
       {dataField:"trxDt", headerText:"TrxDate"},
       {dataField:"trxAmt", headerText:"TrxTotal"},
       {dataField:"payId", headerText:"PID"},
       {dataField:"orNo", headerText:"ORNo"},
       {dataField:"trNo", headerText:"TRNo"},
       {dataField:"orAmt", headerText:"ORTotal"},
       {dataField:"salesOrdNo", headerText:"OrderNo"},
       {dataField:"appTypeName", headerText:"AppType"},
       {dataField:"productDesc", headerText:"Product"},
       {dataField:"custName", headerText:"Customer"},
       {dataField:"custIc", headerText:"IC/CO No."},
       {dataField:"clcrtBrnchName", headerText:"Branch"},
       {dataField:"keyinUserName", headerText:"UserName"}
];

var columnLayoutForSub3=[
	   {dataField:"payId", headerText:"PayID", visible:false},
	   {dataField:"payItmId", headerText:"ItemID", visible:false},
       {dataField:"codeName", headerText:"Mode"},
       {dataField:"payItmRefNo", headerText:"RefNo"},
       {dataField:"payItmCCTypeId", headerText:"CCType"},
       {dataField:"payItmCcHolderName", headerText:"CCHolder"},
       {dataField:"payItmCcExprDt", headerText:"CCExpiryDate"},
       {dataField:"payItmChqNo", headerText:"ChequeNo"},
       {dataField:"bank", headerText:"IssueBank"},
       {dataField:"payItmAmt", headerText:"Amount"},
       {dataField:"payItmIsOnline", headerText:"On-Line"},
       {dataField:"accDesc", headerText:"BankAccount"},
       {dataField:"payItmRefDt", headerText:"RefDate", dataType:"date", formatString:"dd-mm-yyyy"},
       {dataField:"payItmAppvNo", headerText:"ApprNo"},
       {dataField:"payItmRem", headerText:"Remark"},
       {dataField:"name1", headerText:"Status"},
       {dataField:"payItmIsLok", headerText:"Locked"},
       {dataField:"payItmBankChrgAmt", headerText:"BankChange"}
];

function fn_uploadFile(){
	var formData = new FormData();
	
	formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
	
	Common.ajaxFile("/payment/csvUpload.do", formData, function(result){
		Common.alert(result.message);
	});
}

function fn_viewResult(){
	
    if(selectedGridValue != undefined){
    	$("#grid_wrap_sub1").show();
        $("#grid_wrap_sub2").show();
        $("#grid_wrap_sub3").hide();
        
    	var fileNo = AUIGrid.getCellValue(mainGrid, selectedGridValue, "fileId");
    	Common.ajax("GET", "/payment/loadPaymentResult.do", {"fileId" : fileNo}, function(result){
    		AUIGrid.setGridData(subGrid2, result);
    		AUIGrid.resize(subGrid2);
        });
    	
    	Common.ajax("GET", "/payment/loadRawItemsStatus.do", {"fileId" : fileNo}, function(result){
            AUIGrid.setGridData(subGrid1, result);
            AUIGrid.resize(subGrid1);
        });
    }else{
    	Common.alert("Select a file.");
    }
}

function fn_createPayment(){
	if(selectedGridValue != undefined){
		var fileNo = AUIGrid.getCellValue(mainGrid, selectedGridValue, "fileId");
		Common.ajax("GET", "/payment/createPayment.do", {"fileId" : fileNo}, function(result){
			Common.alert(result.message);
        });
	}else{
		return;
	}
}

function fn_clickArea1(){
	$("#grid_wrap_sub3").hide();
}

function fn_clickArea2(){
	AUIGrid.resize(subGrid2);
}
</script>

<section id="content"><!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Payment</li>
		<li>Commission Deduction</li>
	</ul>

	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Commission Deduction</h2>
	</aside><!-- title_line end -->

	<ul class="right_btns">
		<li><p class="btn_blue"><a href="javascript:fn_createPayment();">Create Payment</a></p></li>
		<li><p class="btn_blue"><a href="javascript:fn_viewResult();">View Result</a></p></li>
	</ul>         

	<ul class="left_btns mt20">
		<li>
			<div class="auto_file"><!-- auto_file start -->
				<input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
			</div><!-- auto_file end -->
		</li>
		<li><p class="btn_sky"><a href="javascript:fn_uploadFile();">Upload</a></p></li>
		<!-- <li><p class="btn_sky"><a href="#">Download CSV Format</a></p></li> -->
	</ul>

	<section class="search_result mt20"><!-- search_result start -->
		<article class="grid_wrap" id="grid_wrap_main"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->
	</section><!-- search_result end -->

	<section class="tap_wrap"><!-- tap_wrap start -->
		<ul class="tap_type1">
			<li><a href="javascript:fn_clickArea1();" class="on">Raw File Items Status</a></li>
			<li><a href="javascript:fn_clickArea2();" >Payment Results</a></li>
		</ul>

		<article class="tap_area" id="tap_area1"><!-- tap_area start -->
			<article class="grid_wrap" id="grid_wrap_sub1"><!-- grid_wrap start -->
			</article><!-- grid_wrap end -->
		</article><!-- tap_area end -->
		
		<article class="tap_area" id="tap_area2"><!-- tap_area start -->
			<article class="grid_wrap " id="grid_wrap_sub2"><!-- grid_wrap start -->
			</article><!-- grid_wrap end -->
			<article class="grid_wrap " id="grid_wrap_sub3"><!-- grid_wrap start -->
			</article><!-- grid_wrap end -->
		</article><!-- tap_area end -->
	</section><!-- tap_wrap end -->
</section><!-- content end -->
