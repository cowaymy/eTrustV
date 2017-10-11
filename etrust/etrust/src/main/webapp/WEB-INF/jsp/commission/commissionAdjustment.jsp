<!DOCTYPE html>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

	$(document).ready(function() {
		
		$("#save").click(function() {
			Common.ajax("GET", "/commission/calculation/memberInfoSearch", $("#searchForm").serialize(), function(result) {
				if(result != null){
					$("#memId").val(result.MEMID);
					Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveAdjustment);
				}else{
				    Common.alert("멤버코드없음");
				} 
			});
		});
	
	});
	
	function fn_saveAdjustment(){
		Common.ajax("GET", "/commission/calculation/saveAdjustment", $("#searchForm").serialize(), function(result) {
			Common.setMsg("<spring:message code='sys.msg.success'/>");
		});
	}
</script>

<div id="wrap"><!-- wrap start -->

<header id="header"><!-- header start -->
<ul class="left_opt">
	<li>Neo(Mega Deal): <span>2394</span></li> 
	<li>Sales(Key In): <span>9304</span></li> 
	<li>Net Qty: <span>310</span></li>
	<li>Outright : <span>138</span></li>
	<li>Installment: <span>4254</span></li>
	<li>Rental: <span>4702</span></li>
	<li>Total: <span>45080</span></li>
</ul>
<ul class="right_opt">
	<li>Login as <span>KRHQ9001-HQ</span></li>
	<li><a href="#" class="logout">Logout</a></li>
	<li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_home.gif" alt="Home" /></a></li>
	<li><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/top_btn_set.gif" alt="Setting" /></a></li>
</ul>
</header><!-- header end -->
<hr />
		
<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="검색" />
</p>

</form>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu">
	<li class="active">
	<a href="#" class="on">menu 1depth</a>

	<ul>
		<li class="active">
		<a href="#" class="on">menu 2depth</a>

		<ul>
			<li class="active">
			<a href="#" class="on">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
			<li>
			<a href="#">menu 3depth</a>
			</li>
		</ul>

		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
		<li>
		<a href="#">menu 2depth</a>
		</li>
	</ul>

	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
	<li>
	<a href="#">menu 1depth</a>
	</li>
</ul>
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
	<li>
	<a href="#">My menu 1depth</a>
	</li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Commission Adjustment</h2>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" name="searchForm" id="searchForm" method="post">
	<input type="hidden" name="memId" id="memId"/>
	<table class="type1"><!-- table start -->
	<caption>table</caption>
	<colgroup>
		<col style="width:160px" />
		<col style="width:*" />
	</colgroup>
	<tbody>
	<tr>
		<th scope="row">Adjustment Type</th>
		<td>
		<select name="adjustmentType" id="adjustmentType">
			<c:forEach var="list" items="${adjustList }">
	            <option value="${list.codeId}">${list.codeName}</option>
	        </c:forEach>
		</select>
		</td>
	</tr>
	<tr>
		<th scope="row">Member Code</th>
		<td>
		<input type="text" name="memCode" id="memCode" title="" placeholder="Member Code" class="" />
		</td>
	</tr>
	<tr>
		<th scope="row">Order No</th>
		<td>
		<input type="text" name="ordNo" id="ordNo" title="" placeholder="Order No" class="" />
		</td>
	</tr>
	<tr>
		<th scope="row">Adjustment Amt</th>
		<td>
		<input type="text" name="adjustmentAmt" id="adjustmentAmt"  title="" placeholder="Amont" class="" />
		</td>
	</tr>
	<tr>
		<th scope="row">Adjustment Desc</th>
		<td>
		<textarea cols="20" name="adjustmentDesc" id="adjustmentDesc" rows="5" placeholder="Remark"></textarea>
		</td>
	</tr>
	</tbody>
	</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id="save"><spring:message code='sys.btn.save'/></a></p></li>
	<li><p class="btn_blue2 big"><a href="#"><spring:message code='sys.btn.clear'/></a></p></li>
</ul>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn"><a href="#">menu1</a></p></li>
		<li><p class="link_btn"><a href="#">menu2</a></p></li>
		<li><p class="link_btn"><a href="#">menu3</a></p></li>
		<li><p class="link_btn"><a href="#">menu4</a></p></li>
		<li><p class="link_btn"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn"><a href="#">menu6</a></p></li>
		<li><p class="link_btn"><a href="#">menu7</a></p></li>
		<li><p class="link_btn"><a href="#">menu8</a></p></li>
	</ul>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="#">menu1</a></p></li>
		<li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu3</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu4</a></p></li>
		<li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu6</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu7</a></p></li>
		<li><p class="link_btn type2"><a href="#">menu8</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
		
</section><!-- container end -->
<hr />

</div><!-- wrap end -->
</body>
</html>