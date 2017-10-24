<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 
    각 화면에서 클릭함수를 구현해 주어야 함.
 -->
<c:if test="${auth.insert}">
	<input type="button" class="btn" onclick="javascript:fn_save();" value="저장" />
</c:if>
<c:if test="${auth.update}">
	<input type="button" class="btn" onclick="javascript:fn_modify();" value="수정" />
</c:if>
<c:if test="${auth.delete}">
	<input type="button" class="btn" onclick="javascript:fn_delete();" value="삭제" />
</c:if>
