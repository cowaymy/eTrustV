<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javaScript">

var reqId = '${reqId}';

//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){

	loadEStatementConfirm(reqId);
    
});

function loadEStatementConfirm(reqId){
	Common.ajax("GET","/payment/updEStatementConfirm.do", {"reqId":reqId}, function(result){
        $("#resultMessage").html(result.message);
    });
}

</script>
<html>
	<head>
	    <title>Coway E-Statement Confirmation</title>
	</head>
	<body>
	    <div>
	        <span id="resultMessage" style="color:red; font-size: 15px;"></span>
	    </div>
	</body>
</html>
