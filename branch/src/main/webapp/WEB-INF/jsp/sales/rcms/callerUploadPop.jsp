<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

//var myGridID;

$(document).ready(function() {
      //InputFile Enable
      setInputFile2();
    //Upload
    $("#_ordUploadBtn").click(function() {
        
        if(null == $("#fileSelector").val() || '' == $("#fileSelector").val().trim()){
            Common.alert('<spring:message code="sal.title.text.plzSelYourCsvFileBr" />');
            return;
        }
        
        var formData = new FormData();
        formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
        Common.ajaxFile("/sales/rcms/uploadCaller.do", formData, function(result){
            if(result == null){
                Common.alert('<spring:message code="sal.title.text.failToUpdateRosCall" />');
            }else{
                var msg = "";
                msg += '<spring:message code="sal.title.text.rosCallerSuccUpdated" />';
                msg += '<spring:message code="sal.title.text.batchIdCol" />' + result.batchId + "<br />";
                msg += '<spring:message code="sal.title.text.totRows" />' + result.totUpDt + "<br />";
                msg += '<spring:message code="sal.title.text.totSuccess" />' + result.totCmplt + "<br />";
                msg += '<spring:message code="sal.title.text.totFailed" />' + result.totFail + "<br />";
            	
            	Common.alert(msg , fn_popClose);
            }
        }, function(jqXHR, textStatus, errorThrown){
            Common.alert('<spring:message code="sal.title.text.failToUpdateRosCall" />');
            console.log("jqXHR : " + jqXHR + " , textStatus : " + textStatus + " ,errorThrown " + errorThrown);
        });
        
    });
    
    //file Delete
    $("#_fileDel").click(function() {
        $("#fileSelector").val('');
        $(".input_text").val('');
        console.log("fileDel complete.");
    });
});///Doc Ready End //////////////////////////////


function setInputFile2(){//인풋파일 세팅하기
    $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a id='_fileDel'>Delete</a></span>");
}

function fn_popClose(){
    $("#_popClose").click();
    $("#_searchBtn").click();
}


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.OrdUpload" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_popClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="_searchForm_" >

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.uploadFile" /></th>
    <td>
    <div class="auto_file2"><!-- auto_file start -->
    <input type="file" title="file add"  id="fileSelector" accept=".csv"  name="uploadfile"/>
    </div>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="_ordUploadBtn"><spring:message code="sal.title.text.upload" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/sales/ROSCallerUpdate.csv"><spring:message code="sal.title.text.download" /></a></p></li>
</ul>
</section><!-- search_table end -->
</section><!-- content end -->
<hr />
</div><!-- popup_wrap end -->