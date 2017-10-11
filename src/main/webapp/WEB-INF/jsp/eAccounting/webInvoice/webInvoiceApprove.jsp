<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
var myGridColumnLayout = [ {
    dataField : "clmNo",
    headerText : 'Claim No',
    width : 140
},{
    dataField : "reqstDt",
    headerText : 'Request Date',
    dataType : "date",
    formatString : "dd/mm/yyyy",

}, {
    dataField : "clmType",
    headerText : 'Claim Type'
}, {
    dataField : "costCentr",
    headerText : 'Cost Center'
}, {
    dataField : "costCentrName",
    headerText : 'C/C Name'
}, {
    dataField : "invcType",
    headerText : 'Type'
}, {
    dataField : "memAccId",
    headerText : 'Suppliers / Employee'
}, {
    dataField : "memAccName",
    headerText : 'Name'
}, {
    dataField : "totAmt",
    headerText : '<spring:message code="webInvoice.amount" />',
    dataType: "numeric",
    formatString : "#,##0"
}, {
    dataField : "appvPrcssStus",
    headerText : '<spring:message code="webInvoice.status" />'
}, {
    dataField : "reqstDt",
    headerText : 'Attachment'
}, {
    dataField : "appvPrcssDt",
    headerText : '<spring:message code="webInvoice.approvedDate" />'
}
];

//그리드 속성 설정
var myGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    // 체크박스 표시 설정
    showRowCheckColumn : true,
    showRowNumColumn : false
};

var myGridId;

$(document).ready(function () {
    myGridId = AUIGrid.create("#approve_grid_wrap", myGridColumnLayout, myGridPros);
    
    AUIGrid.bind(myGridId, "cellDoubleClick", function( event ) 
            {
                console.log("CellDoubleClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellDoubleClick clmNo : " + event.item.clmNo);
                // TODO detail popup open
                //fn_viewEditWebInvoicePop(event.item.clmNo);
            });
});
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="../images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Web Invoice - Approve</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:140px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Claim Type</th>
	<td>
	<select class="w100p">
		<option value="1">111</option>
		<option value="2">222</option>
		<option value="3">333</option>
	</select>
	</td>
	<th scope="row">Create User</th>
	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row">Supplier / Employee</th>
	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a></td>
	<th scope="row">Cost Center</th>
	<td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="../images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
	<th scope="row">Posting Date</th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row">Status</th>
	<td>
	<select class="multy_select w100p" multiple="multiple">
		<option value="1">Approved</option>
		<option value="2">Request</option>
		<option value="3">Reject</option>
	</select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#">Approve</a></p></li>
	<li><p class="btn_grid"><a href="#">Reject</a></p></li>
</ul>

<article class="grid_wrap" id="approve_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->