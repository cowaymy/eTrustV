<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

	$(document).ready(function() {
		
		$("#search").click(function(){
			Common.ajax("GET", "/commission/calculation/commSHIMemSearch", $("#myForm").serializeJSON(), function(result) {
				if(result != null){
					$("#teamCode").val(result.DEPT_CODE);
					$("#level").val(result.MEM_LVL);
					
					
					Common.ajax("GET", "/commission/calculation/commSPCRgenrawSHIIndex", $("#myForm").serializeJSON(), function(result) {
						alert("들어옴");
					});
				}else{
					Common.alert("No member record found");
				}
			});
		});
		
		$('#memBtn').click(function() {
		    //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
		    Common.popupDiv("/common/memberPop.do", $("#myForm").serializeJSON(), null, true);
		});
	});
	
	function fn_loadOrderSalesman(memId, memCode) {
	    $("#memCode").val(memCode);
	    console.log(' memId:'+memId);
	    console.log(' memCd:'+memCode);
	}
</script>

<section id="content"><!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>SHI Index - Collection Target</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a href="#" id="search">Search</a></p></li>
			<li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
		</ul>
	</aside><!-- title_line end -->
	
	
	<section class="search_table"><!-- search_table start -->
		<form action="#" method="post" name="myForm" id="myForm">
			
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:140px" />
					<col style="width:*" />
					<col style="width:140px" />
					<col style="width:*" />
					<col style="width:170px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Member Type</th>
						<td>
							<select class="w100p" id="typeCode" name="typeCode">
							<c:forEach var="list" items="${memType }">
                                    <option value="${list.cdid}">${list.cdnm} (${list.cd})</option>
                                </c:forEach>
							</select>
						</td>
						<th scope="row">Member Code</th>
						<td>
						  <input type="text" title="" placeholder="" class="" id="memCode" name="memCode"/>
						  <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
						</td>
						<th scope="row">Commission Month</th>
						<td>
						  <input type="text" title="기준년월" class="j_date2 w100p" id="shiDate" name="shiDate" />
						</td>
					</tr>
					<tr>
						<th scope="row">* Team Code</th>
						<td>
						  <input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly"  id="teamCode" name="teamCode"/>
						</td>
						<th scope="row">* Level</th>
						<td colspan="3">
						  <input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly" readonly="readonly"  id="level" name="level"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="col_all">
						  <p><span>(*) Fields are depends on the commission month selected.</span></p>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="col_all al_center">
						
							<table class="type2" style="width:460px;"><!-- table start -->
								<caption>table</caption>
								<colgroup>
									<col style="width:340px" />
									<col style="width:120px" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col" class="al_center">RC Rate</th>
										<th scope="col" class="al_center">SHI Index</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="al_center"><span>90% ~ 100% Excellent</span></td>
										<td class="al_center"><span>10%</span></td>
									</tr>
									<tr>
									   <td class="al_center"><span>80% ~ 89% Very Good (target average)</span></td>
										<td class="al_center"><span>5%</span></td>
									</tr>
									<tr>
										<td class="al_center"><span>70% ~ 79% Good (above average)</span></td>
										<td class="al_center"><span>0%</span></td>
									</tr>
									<tr>
										<td class="al_center"><span>60% ~ 69% Poor (below average)</span></td>
										<td class="al_center"><span>-10%</span></td>
									</tr>
									<tr>
										<td class="al_center"><span>50% ~ 59% (serious)</span></td>
										<td class="al_center"><span>-20%</span></td>
									</tr>
									<tr>
										<td class="al_center"><span>0% ~ 49% (Worst)</span></td>
										<td class="al_center"><span>-30%</span></td>
									</tr>
								</tbody>
							</table><!-- table end -->
						
						</td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
	
	<ul class="right_btns">
		<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
	</ul>
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	그리드 영역
	</article><!-- grid_wrap end -->
	
	</section><!-- search_result end -->

</section><!-- content end -->

		
<hr />

</body>
</html>