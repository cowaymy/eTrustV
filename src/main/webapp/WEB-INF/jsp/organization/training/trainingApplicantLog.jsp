<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

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
var applicantColumnLayout = [ {
    dataField : "coursMemId",
    headerText : 'Member Code'
}, {
    dataField : "coursDMemName",
    headerText : 'Member Name',
    style : "aui-grid-user-custom-left",
}, {
    dataField : "coursDMemNric",
    headerText : 'NRIC',
}, {
    dataField : "brnchId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "code",
    headerText : 'Branch',
}
];

//그리드 속성 설정
var applicantGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20
};

var applicantGridID;

$(document).ready(function () {
	applicantGridID = AUIGrid.create("#applicant_grid_wrap", applicantColumnLayout, applicantGridPros);
});
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Applicant Log</h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
</c:if>	
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:80px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Member Code</th>
	<td>
	<input type="text" title="Member Code" placeholder="" class="w100p" />
	</td>
	<th scope="row">Member Name</th>
	<td>
	<input type="text" title="Member Name" placeholder="" class="w100p" />
	</td>
	<th scope="row">NRIC</th>
	<td>
	<input type="text" title="NRIC" placeholder="" class="w100p" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#" id="courseReport_pdf_btn">Course Report (PDF)</a></p></li>
        <li><p class="link_btn"><a href="#" id="courseReport_excel_btn">Course Report (Excel)</a></p></li>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	<li><p class="btn_grid"><a href="#">DEL</a></p></li>
	<li><p class="btn_grid"><a href="#">INS</a></p></li>
	<li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul> -->

<article class="grid_wrap" id="applicant_grid_wrap" style="margin-top: 30px"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->