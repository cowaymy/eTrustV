<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 
    각 화면에서 클릭함수를 구현해 주어야 함.
    
    - button_id : 차후에 권한 관련 처리를 위해 버튼 id를 DB에 등록할 예정입니다.
    
    1) onclick javascript 형식 
        : onclick="fn_{button_id}();"
        
    2) SYS0052M 다국어 메세지 테이블 id.
        : sys.btn.{button_id}
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



