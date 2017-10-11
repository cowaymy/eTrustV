<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">
var mainGrid;
var subGrid1;
var subGrid2;
var selectedGridValue;

$(document).ready(function(){
    
    mainGrid = GridCommon.createAUIGrid("#grid_wrap_main", columnLayout, null, gridPros);
    
    Common.ajax("GET", "/payment/selectCommDeduction.do", {}, function(result){
        AUIGrid.setGridData(mainGrid, result);
    });
    
    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(mainGrid, "cellClick", function( event ){ 
    	selectedGridValue = event.rowIndex;
    });  
});

var gridPros = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 5,
        height:200
};

var girdProsForSub = {
        editable: false,
        showStateColumn: false,
        pageRowCount : 10
};

var columnLayout=[
       {dataField:"fileId", headerText:"File No"},
       {dataField:"fileName", headerText:"File Name"},
       {dataField:"fileDt", headerText:"Upload date"},
       {dataField:"fileRefNo", headerText:"File Type"},
       {dataField:"totRcord", headerText:"Total Records"},
       {dataField:"totAmt", headerText:"Total Amount"},
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

function fn_uploadFile(){
	var formData = new FormData();
	
	formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
	
	Common.ajaxFile("/payment/csvUpload.do", formData, function(result){
		Common.alert("완료!");
	});
}

function fn_viewResult(){
    subGrid1 = GridCommon.createAUIGrid("#grid_wrap_sub1", columnLayoutForSub1, null, girdProsForSub);
    subGrid2 = GridCommon.createAUIGrid("#grid_wrap_sub2", columnLayoutForSub2, null, girdProsForSub);
    
    if(selectedGridValue != undefined){
    	var fileNo = AUIGrid.getCellValue(mainGrid, selectedGridValue, "fileId");
    	Common.ajax("GET", "/payment/loadPaymentResult.do", {"fileId" : fileNo}, function(result){
    		AUIGrid.setGridData(subGrid2, result);
        });
    	
    	Common.ajax("GET", "/payment/loadRawItemsStatus.do", {"fileId" : fileNo}, function(result){
            AUIGrid.setGridData(subGrid1, result);
        });
    }else{
    	Common.alert("Select a file.");
    }
}

</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="../images/common/path_home.gif" alt="Home" /></li>
    <li>Payment</li>
    <li>Commission Deduction</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Commission Deduction</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
     <li><p class="btn_blue"><a href="javascript:fn_generateStatement();">Create Payment</a></p></li>
     <li><p class="btn_blue"><a href="javascript:fn_viewResult();">View Result</a></p></li>
</ul>         
<ul class="left_btns mt20">
    <li>
    <div class="auto_file"><!-- auto_file start -->
    <input type="file" title="file add" id="uploadfile" name="uploadfile" />
    </div><!-- auto_file end -->
    </li>
    <li><p class="btn_sky"><a href="javascript:fn_uploadFile();">Upload</a></p></li>
    <li><p class="btn_sky"><a href="#">Download CSV Format</a></p></li>
</ul>

<section class="search_result mt20"><!-- search_result start -->

<article class="grid_wrap" id="grid_wrap_main"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Raw File Items Status</a></li>
    <li><a href="#">Payment Results</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
	<article class="grid_wrap" id="grid_wrap_sub1"><!-- grid_wrap start -->
	</article><!-- grid_wrap end -->
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
	<article class="grid_wrap " id="grid_wrap_sub2"><!-- grid_wrap start -->
	</article><!-- grid_wrap end -->
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- content end -->

