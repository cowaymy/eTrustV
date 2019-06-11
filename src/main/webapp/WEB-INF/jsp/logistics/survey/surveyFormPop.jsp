<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script src ="${pageContext.request.contextPath}/resources/js/pdfobject.js" type="text/javascript"></script>
<script type="text/javaScript">
var verCnt = 0;
var userType = "";
var surveyTypeId = 0;

$(document).ready(function() {
	surveyTypeId = '${surveyTypeId}';
});

function btnSubmit(){

	var valid = true, formMaster = [];

    $('#form :input').each(function() {
    	var form = {};

    	if( (!FormUtil.isEmpty($(this).val()) && this.type != 'radio') || (this.type == 'radio' && this.checked != false) ){
    		if((this.type == 'radio' || this.type == 'text' || this.tagName.toLowerCase() == 'select' ) || (this.type == 'radio' && this.checked == true) ){
            form = {
                        id     : $(this).attr("name") ,
                        val   :  $(this).val(),
                        type : this.tagName.toLowerCase() == 'select' ? this.tagName.toLowerCase() : this.type
                      }
            formMaster.push(form);
            }

    	}else{
    		if(this.type != 'textarea' && !$('input:radio[name='+this.name+']').is(':checked')){
    			console.log(this.name);
    			valid = false;
    		}
    	}
    });

    if(valid){
    	var data = {};
        data.form = formMaster;
        data.etc = [{"rem":$("#comment").val()},{"surveyTypeId":surveyTypeId}];

        console.log(data);

        Common.ajax("GET", "/logistics/survey/verifyStatus.do", {surveyTypeId:surveyTypeId}, function(result) {
        	if(result.code != '1'){
		    	Common.ajax("POST", "/logistics/survey/surveySave.do", data, function(result) {
		    		setTimeout(function(){ fn_goMain(),3000 });//Login after 3 sec
		    		Common.alert('<spring:message code="sys.title.surveySaved" />' + DEFAULT_DELIMITER + "<b>"+result.message+"</b>",fn_goMain());
		        });
        	}else{
        		Common.alert('<spring:message code="sys.title.surveySaved" />' + DEFAULT_DELIMITER + "<b>"+result.message+"</b>");
        	}
        });
    }else{
    	Common.alert("Please fill up all survey questions.");
    }
}

</script>

<style>
table.type1 tbody th{height:20px; color:#333; font-weight:normal; line-height:15px; background:#e9f0f4; border-bottom:1px solid #d3d9dd; border-left:1px solid #d3d9dd; border-right:1px solid #d3d9dd;}
table.type1 tbody td{height:20px; padding:2px 6px; border-bottom:1px solid #d3d9dd; border-left:1px solid #d3d9dd; border-right:1px solid #d3d9dd;}
</style>

<div id="popup_wrap" class="popup_wrap size_big"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>${title[0].surveyTitle}</h1>
<%-- <ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul> --%>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form" name="form">

<table class="type1 question"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:5%" />
    <col style="width:67%" />
    <col style="width:27%" />
</colgroup>
<tbody>
<c:forEach items="${title}" var="title">
<tr>
        <th scope="row" colspan="3"><br><b>${title.surveyMessage}</b><br/></th>
        <tr>
    <th scope="row" colspan="3"><b>Score : 1 - Strongly Disagree | 2 - Disagree | 3 - Neutral | 4 - Agree | 5 - Strongly Agree</b></th>
</tr>
    <tr>

        <th scope="row">No.</th>
        <th scope="row">Question</th>
        <th scope="row">Answer</th>
    </tr>

    <c:forEach items="${title.ques}" var="ques">
    <tr>
        <td>${ques.seq}</td>
        <td>${ques.ques}</td>
        <c:choose>
            <c:when test = "${ques.inputType eq 'CHECKBOX'}">
                <td><c:forEach var="score" begin="1" end = "5">
                <label><input type="radio" name="${ques.quesId}" value="${score}"/><span> ${score} </span></label>
                </c:forEach></td>
             </c:when>

             <c:when test = "${ques.inputType eq 'DROPDOWN'}">
                <script>
                doGetComboData('/logistics/survey/getSurveyAns.do', {quesId : '${ques.quesId}' },'', '${ques.quesId}','S', '');
                </script>
                <td><select id="${ques.quesId}" name="${ques.quesId}" class="w50p" ></select></td>
             </c:when>

             <c:when test = "${ques.inputType eq 'TEXT'}">
                <td><label><input type="text" title="" id="${ques.quesId}" name="${ques.quesId}" /></label></td>
             </c:when>

             <c:otherwise>
             <td><c:forEach var="score" begin="1" end = "5">
                <label><input type="radio" name="${ques.quesId}" value="${score}" /><span> ${score} </span></label>
                </c:forEach></td>
             </c:otherwise>
         </c:choose>
    </tr>
</c:forEach>
</tr>
</c:forEach>

<tr>
    <th scope="row" colspan="3"><spring:message code="sys.text.comment" /></th>
</tr>
<tr>
    <td colspan="3"><textarea  id="comment" name="comment" cols="20" rows="5" ></textarea></td>
</tr>

</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:btnSubmit();"><spring:message code="sys.btn.submit" /></a></p></li>
</ul>

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->