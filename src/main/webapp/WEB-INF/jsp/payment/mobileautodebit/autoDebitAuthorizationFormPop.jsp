<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style>
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var myGridID;

var option = {
        width : "1200px",   // 창 가로 크기
        height : "500px"    // 창 세로 크기
};

var basicAuth = false;

$(document).ready(function(){
	$('#orderNo').val('${params.salesOrdNo}');
	if($('#orderNo').val() != ""){
		selectList();
	}
	createAUIGrid();

	$('#status').change(function() {
    }).multipleSelect({
        selectAll: true,
        width: '100%'
    });

	//Search
	$("#_listSearchBtn").click(function() {
		if($('#orderNo').val() == "" && $("#padNo").val() == ""){
			Common.alert("Order Number or Pad Number is required");
			return false;
		}

	    //Validation start
	    selectList();
	});
});

function createAUIGrid() {
	var columnLayout = [ {
        	dataField : "padId",
	        headerText : 'PAD ID.',
	        width : 140,
	        editable : false,
	        visible: false
	    },{
        	dataField : "custCrcId",
	        headerText : 'Credit Card Id',
	        width : 140,
	        editable : false,
	        visible: false
	    },{
            dataField : "padNo",
            headerText : 'PAD No.',
            width : 140,
            editable : false
        }, {
            dataField : "keyInDate",
            headerText : 'PAD Key-in Date',
            width : 160,
            editable : false
        }, {
            dataField : "crcApplyDate",
            headerText : 'Apply Date',
            width : 160,
            editable : false
        }, {
            dataField : "statusDesc",
            headerText : 'PAD Status',
            width : 150,
            editable : false
        }, {
            dataField : "creator",
            headerText : 'Creator',
            width : 170,
            editable : false
        }, {
            dataField : "salesOrdNo",
            headerText : 'Order Number',
            width : 170,
            editable : false
        }, {
        	dataField: "",
        	headerText: "Generate File" ,
	        width : 160,
            renderer: {
            	type: "ButtonRenderer" ,labelText: "Download" ,onclick: function(rowIndex, columnIndex, value, item){
					console.log(item);
            		fileDownload(item);
                }
            },
            editable : false
        }
    ];


	var gridPros = {
	    usePaging : true,
	    pageRowCount : 20,
	    editable : true,
	    fixedColumnCount : 1,
	    showStateColumn : false,
	    displayTreeOpen : true,
	    headerHeight : 30,
	    useGroupingPanel : false,
	    skipReadonlyColumns : true,
	    wrapSelectionMove : true,
	    showRowNumColumn : true
	};
	myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
}

function fileDownload(item){
    var whereSQL = "";
    $("#reportFileName").val("");
    $("#reportDownFileName").val("");
    $("#viewType").val("");



    $("#reportDownFileName").val("AutoDebitAuthorization_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

    $("#searchForm #viewType").val("PDF");
    $("#searchForm #reportFileName").val("/payment/AutoDebitAuthorization.rpt");
    $("#searchForm #V_WHERESQL").val(whereSQL);
    //Common.report("form", option);
}

//ajax list 조회.
function selectList(){
    Common.ajax("GET","/payment/mobileautodebit/selectAutoDebitEnrollmentList",$("#searchForm").serialize(), function(result){
        console.log(result);
        AUIGrid.setGridData(myGridID, result);
    });
}
</script>
<!-- html content -->
<body>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1 id="hTitle">
	Credit/Debit Card AUto Debit Authorization (Customer Sign)
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a id="btnCloseModify" href="#"><spring:message
       code="sal.btn.close" /></a>
    </p></li>
  </ul>
 </header>
<section class="pop_body">
    <!-- title_line start -->
    <aside class="title_line">
        <h2>Auto Debit Enroll List</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a id="_listSearchBtn" href="#"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="#" onclick="fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->
    <!-- search_table start -->
    <section class="search_table">
		<form id="searchForm" action="#" method="post">
			<input type="hidden" id="reportFileName" name="reportFileName" value="" />
			<input type="hidden" id="viewType" name="viewType" value="" />
			<input type="hidden" id="reportDownloadFileName" name="reportDownloadFileName" value="" />
			<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
			<table class="type1">
				<caption>table</caption>
				<colgroup>
                    <col style="width:100px" />
                    <col style="width:*" />
                    <col style="width:200px" />
                    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">PAD Number</th>
						<td>
							 <input type="text" title="PAD No" id="padNo" name="padNo" placeholder="PAD No" class="w100p" />
						</td>
						<th scope="row">PAD Key-In Date</th>
						<td>
							<!-- date_set start -->
							<div class="date_set w100p">
						    <p><input id="requestDateFrom" name="requestDateFrom" type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
						    <span>~</span>
						    <p><input id="requestDateTo" name="requestDateTo"  type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
						    </div>
						    <!-- date_set end -->
						</td>
					</tr>
					<tr>
						<th scope="row">Order Number</th>
						<td>
							 <input type="text" title="Order No" id="orderNo" name="orderNo" placeholder="Order No" class="w100p" />
						</td>
						<th scope="row">Creator</th>
						<td>
							<p><input id="memCode" name="memCode" type="text" title="" placeholder="Member Code" class="w100p" /></p>
						</td>
					</tr>
					<tr>
						<th scope="row">Apply Date</th>
						<td>
							<!-- date_set start -->
							<div class="date_set w100p">
						    <p><input id="crcRequestDateFrom" name="crcRequestDateFrom" type="text" title="Apply Start Date" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
						    <span>~</span>
						    <p><input id="crcRequestDateTo" name="crcRequestDateTo"  type="text" title="Apply End Date" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
						    </div>
						    <!-- date_set end -->
						</td>
						<th scope="row">PAD Status</th>
						<td>
							<select id="status" name="status" class="w100p multy_select" multiple="multiple">
                                <option value="1">Active</option>
                                <option value="5">Approved</option>
                                <option value="6">Rejected</option>
                            </select>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
    </section>
    <!-- search_table end -->
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section>
<!-- html content -->
</div>
</body>