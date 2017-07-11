<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 
    각 화면에서 클릭함수를 구현해 주어야 함.
 -->
<c:if test="${auth == null || auth.insert}">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_save();"><spring:message code='sys.btn.save' /></a></p></li>
</c:if>
<c:if test="${auth == null || auth.update}">
	<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_update();"><spring:message code='sys.btn.update' /></a></p></li>
</c:if>
<c:if test="${auth == null || auth.delete}">
	<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_delete();"><spring:message code='sys.btn.delete' /></a></p></li>
</c:if>
