<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>



    <script type="text/javaScript" language="javascript">
    
    $(function() {

    });

    function fn_openDivPop(){

    	var jsonObj = {
    	    	param01 : "param01",
    	    	param02 : "param02",
    	    	param03 : "param03",
    	};

    	// 또는 
    	
    	jsonObj = $("#dataForm").serializeJSON();
        
        var divObj = Common.popupDiv("/sample/sampleSchedulePop.do", jsonObj, function(params){
            alert("callback....");
            //alert("params01 : " + params.param01);
        });
//        }, null, "testId");
    }

    function fn_openWinPop(){
       Common.popupWin("dataForm", "/sample/publishSample.do");
    }
    </script>


	<form id="dataForm">
		param02 : <input type="text" id="param02" name="param02" value="param02" /><br /> 
		param02 : <input type="text" id="param02" name="param02" value="param02" /><br /> 
		<input type="button" class="btn" onclick="javascript:fn_openWinPop();" value="새창 팝업 예" />
	</form>

	<div id="testId">
		<input type="button" onclick="javascript:fn_openDivPop();"
			value="DIV 팝업 예" />
	</div>

<div id="_popupDiv"></div>