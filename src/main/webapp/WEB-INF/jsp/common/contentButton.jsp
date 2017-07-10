<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 
    각 화면에서 클릭함수를 구현해 주어야 함.
 -->
<c:if test="${auth == null || auth.insert}">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_save();">Save</a></p></li>
</c:if>
<c:if test="${auth == null || auth.update}">
	<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_update();">Update</a></p></li>
</c:if>
<c:if test="${auth == null || auth.delete}">
	<li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript:fn_delete();">Delete</a></p></li>
</c:if>
