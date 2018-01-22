<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

function fn_save(){
	var msg = "";

	if($("#description").val() == ""){		
		msg += "* Please key-in the description.<br />";
	}
	if($("#feedback").val() == ""){
        msg += "* Please select the reason.<br />";
	}
	
	if(msg != ""){
	    Common.alert(msg);
	    return;
	}
	
    $("#saveDescription").val($("#description").val() );
    $("#saveFeedback").val($("#feedback").val() );
	
    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax("POST", "/sales/trBook/saveReportLost", $("#saveForm").serializeJSON(), function(result) { // Common.alert(result.message);
        
        	 if(result.dcfInfo != null){
        		 Common.alert("This TR Book is under request [" + result.dcfInfo.defReqNo + "]");
             }else{
            	 if(result.success){
            		 $("#saveDocNo").val(result.docNo);
            		 $("#saveDcfReqEntryId").val(result.dcfReqEntryId);
            		 
            	        console.log("성공." + JSON.stringify(result));
            	        
            		 Common.confirm("Report Summary "+DEFAULT_DELIMITER + "TR book lost result successfully saved.<br /><br />Are you want to add in attachment file ?</b>", go_uploadPage , null);
            		 
            		 $("#savebt").hide();
            	 }else{
            		 Common.alert(result.massage);
            	 }
             }
            
        }, function(jqXHR, textStatus, errorThrown) {
            console.log("실패하였습니다.");
            console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
            console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
            
            Common.alert("<spring:message code="sal.alert.title.saveFail" />"+DEFAULT_DELIMITER + "<b><spring:message code="sal.alert.msg.saveFail" /></b>");
            
            
        });
      
    });
       
}


function go_uploadPage(){
	alert("docNo " +$("#saveDocNo").val() );
	alert("dcfReqEntryId" +$("#saveDcfReqEntryId").val() );
	
    Common.popupDiv("/sales/trBook/reportLostUploadPop.do", {"docNo" : $("#saveDocNo").val(), "dcfReqEntryId" : $("#saveDcfReqEntryId").val()}, null, true, "fileUploadPop");
}

</script>


<!-- get param Form  -->
<form id="saveForm" method="get">
<input type="hidden" id="saveTrHolderType" name="trHolderType"  >
<input type="hidden" id="saveMemCode" name="memCode"  >
<input type="hidden" id="saveTrBookNo" name="trBookNo"  >

<input type="hidden" id="saveDocNo" name="docNo"  >
<input type="hidden" id="saveDcfReqEntryId" name="dcfReqEntryId"  >
<input type="hidden" id="saveDescription" name="description"  >
<input type="hidden" id="saveFeedback" name="feedback"  >

</form>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>TR BOOK - REPORT LOST</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">DCF Info</a></li>
    <li><a href="#">Lost Info</a></li>
</ul>


 
<!-- inc_dcfInfo  tab  start...-->
     <jsp:include page ='${pageContext.request.contextPath}/sales/trBook/inc_dcfInfoPop.do'/>   
<!-- inc_dcfInfo  tab  start...-->


<!-- inc_lostInfo tab  start...-->
   <jsp:include page ='${pageContext.request.contextPath}/sales/trBook/inc_lostInfoPop.do'/>   
<!-- inc_lostInfo tab  start...-->


</section><!-- tap_wrap end -->

</br>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id='savebt'   onclick="javascript:fn_save()"><spring:message code="sal.btn.save" /></a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
