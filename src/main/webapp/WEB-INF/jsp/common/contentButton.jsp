<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 
    각 화면에서 클릭함수를 구현해 주어야 함.
    
    1) onclick javascript 형식 
        : onclick="fn_{button id}();"
        
    2) sys_i18n 다국어 메세지 테이블 id.
        : sys.btn.{button id}
    
 -->

<c:forEach items="${auth}" var="authMap">
    <c:if test="${authMap.value}">
		<li>
            <p class="btn_blue">
                <a href="javascript:void(0);" id="${authMap.key}" onclick="javascript:fn_${authMap.key}();"><spring:message code='sys.btn.${authMap.key}' /></a>
            </p>
		</li>
	</c:if>
</c:forEach>



