<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>



    <script type="text/javaScript" language="javascript">
    
    $(function() {

    });

    function fn_sendEmail(){
        Common.ajax("POST", "/sample/sendEmail.do", $("#dataForm").serializeJSON(), function(result) {
            alert(result.message);
        });
    }

    function fn_genSuiteSendSMS(){
        Common.ajax("POST", "/sample/genSuite/sendSMS.do", $("#dataForm").serializeJSON(), function(result) {
            alert(result.message);
        });
    }

    function fn_mvgateSendSMS(){
        Common.ajax("POST", "/sample/mvgate/sendSMS.do", $("#dataForm").serializeJSON(), function(result) {
            alert(result.message);
        });
    }
    </script>


	<form id="dataForm">
		phone : <input  id="phone" name="phone">
		<input type="button" class="btn" onclick="javascript:fn_sendEmail();" value="email 전송 테스트" />
		<input type="button" class="btn" onclick="javascript:fn_genSuiteSendSMS();" value="genSuiteSendSMS - 단건용(다건도 가능하나 좀 느림.)" />
		<input type="button" class="btn" onclick="javascript:fn_mvgateSendSMS();" value="mvgateSendSMS - 다건용(속도 빠름. 비쌈.)" />
	</form>
