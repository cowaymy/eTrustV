<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

	$(document).ready(function() {
		
		$("#save").click(function() {
			Common.ajax("GET", "/commission/calculation/memberInfoSearch", $("#searchForm").serialize(), function(result) {
				if(result != null){
					$("#memId").val(result.MEMID);
					if(validation()){
						   Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveAdjustment);
					}
				}else{
				    Common.alert("non member");
				} 
			});
		});
	
	});
	
	function validation(){
		if( $("#memCode").val() == null || $("#memCode").val() == "" ){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='memCode' htmlEscape='false'/>"); return false;
		}else	 if( $("#ordNo").val() == null || $("#ordNo").val() == "" ){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='ordNo' htmlEscape='false'/>"); return false;
        }else if( $("#adjustmentAmt").val() == null || $("#adjustmentAmt").val() == "" ){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='adjustmentAmt' htmlEscape='false'/>"); return false;
        }else if( $("#adjustmentDesc").val() == null || $("#adjustmentDesc").val() == "" ){
			Common.alert("<spring:message code='sys.common.alert.validation' arguments='adjustmentDesc' htmlEscape='false'/>"); return false;
        }else{
			return true;
        }
	}
	
	function fn_saveAdjustment(){
		Common.ajax("GET", "/commission/calculation/saveAdjustment", $("#searchForm").serialize(), function(result) {
           Common.setMsg("<spring:message code='sys.msg.success'/>");
       });
	}
	
	function clearForm(){
		$("#memCode").val("");
		$("#ordNo").val("");
		$("#adjustmentAmt").val("");
		$("#adjustmentDesc").val("");
	}
</script>

<section id="content">
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
		<li><p class="btn_blue2 big"><a href="javascript:clearForm();"><spring:message code='sys.btn.clear'/></a></p></li>
	</ul>


</section><!-- content end -->

<hr />

</body>
</html>