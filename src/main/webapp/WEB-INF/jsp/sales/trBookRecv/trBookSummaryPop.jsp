<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
//Grid ID
var rcvBookGridID;

$(document).ready(function() {
	
	CreateGrid();
	
	CommonCombo.make("_trBranch", "/sales/trBookRecv/getbrnchList", '', '', {isShowChoose: true, chooseMessage: "Select the Branch"});
});

function CreateGrid(){
	 var rcvBookColLayout = [ 
	                      {dataField : "trBookNo", headerText : "TR Book", width : '15%'}, 
	                      {dataField : "trReciptNoStr", headerText : "Receipt Start", width : '15%'},
	                      {dataField : "trReciptNoEnd", headerText : "Receipt End", width : '15%'},
	                      {dataField : "trClosDt", headerText : "Receive Date", width : '25%'}, 
	                      {dataField : "trTrnsitFrom", headerText : "Location From", width : '15%'},
	                      {dataField : "trTrnsitTo", headerText : "Location To", width : '15%'}
	                      ];

       var rcvBookOptions = {
                  showStateColumn:false,
                  showRowNumColumn    : false,
                  usePaging : true,
                  editable : false//,
                  //selectionMode : "singleRow"
            }; 
       
       rcvBookGridID = GridCommon.createAUIGrid("#_rcv_book_grid", rcvBookColLayout, "", rcvBookOptions);
}

function fn_getTransitNoByBranch(brnchVal){
	//Setting
	if(brnchVal == null || brnchVal == ''){
		$("#_transitNo").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
		 $("#_transitNo").val('');
	}else{
		$("#_transitNo").attr({"disabled" : false , "class" : "w100p"});
		CommonCombo.make("_transitNo", "/sales/trBookRecv/getTransitListByTransitNo", {trTrnsitTo : brnchVal}, '', {isShowChoose: false});
	}
}

//SetGrid
function fn_bookList(){
	//Validation
	if($("#_trBranch").val() == null || $("#_trBranch").val() == ''){
		Common.alert("* Please key in the branch.<br />");
		return;
	}
	
	if($("#_transitNo").val() == null || $("#_transitNo").val() == ''){
        Common.alert("* Please key in the Transit No.<br /> ");
        return;
    }
	
	//Validation Pass
	Common.ajax("GET", "/sales/trBookRecv/trBookSummaryListing", {trnsitTo : $("#_trBranch").val(), trTrnsitId : $("#_transitNo").val()}, function(result){
		AUIGrid.setGridData(rcvBookGridID, result);
	});
}

function fn_getReport(){
	
	//validation
	if($("#_trBranch").val() == null || $("#_trBranch").val() == ''){
		Common.alert("* Please key in the branch.<br />");
		return;
	}
	
	if($("#_transitNo").val() == null || $("#_transitNo").val() == ''){
        Common.alert("* Please key in the Transit No.<br />");
        return;
    }
	
	//Generate Report
	$("#reportFileName").val('/sales/TRbookSummaryListing_PDF.rpt');
	$("#viewType").val('PDF');
	
	//title
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }
    var title = "RentalBadAccountRaw_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
    $("#reportDownFileName").val(title); //Download File Name
    
    //Params
    $("#Branchcode").val($("#_trBranch").val());
    $("#TransitID").val($("#_transitNo").val());
    
    //Gen Report
    var option = {
            isProcedure : false // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
    Common.report("summForm", option);
}
</script>

<form id="summForm">
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType"/>
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <!-- Params -->
    <input type="hidden" id="Branchcode" name="Branchcode">
    <input type="hidden" id="TransitID" name="TransitID">
</form>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>TR Book Summary</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_itmSrchPopClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<ul class="right_btns">
    <li><p class="btn_blue"><a onclick="javascript:fn_getReport()"><span ></span>Generate</a></p></li>
    <li><p class="btn_blue"><a onclick="javascript:fn_bookList()"><span class="search"></span>Search</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Branch</th>
    <td>
    <select class="w100p" id="_trBranch" onchange="javascript: fn_getTransitNoByBranch(this.value)"></select>
    </td>
    <th scope="row">Transit No.</th>
    <td>
    <select disabled="disabled" class="w100p disabled" id="_transitNo"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->


<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="_rcv_book_grid" style="width:100%; height:400px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section>
</div>