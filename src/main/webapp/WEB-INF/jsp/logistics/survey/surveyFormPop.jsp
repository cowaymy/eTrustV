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

function fn_close(){
	$("#survey_popup_wrap").hide();
}
function btnSubmit(){

	var valid = true, formMaster = [];

    $('#form :input').each(function() {
    	var form = {};

    	if( (!FormUtil.isEmpty($(this).val()) && this.type != 'radio') || (this.type == 'radio' && this.checked != false) ){
    		if((this.type == 'radio' || this.type == 'text' || this.tagName.toLowerCase() == 'select' || this.type == 'textarea' )
    		|| (this.type == 'radio' && this.checked == true) ){
            form = {
                        id     : $(this).attr("name") ,
                        val   :  $(this).val(),
                        type : this.tagName.toLowerCase() == 'select' ? this.tagName.toLowerCase() : this.type
                      }
            formMaster.push(form);
            console.log(form);
            }

    	}else{
    		if(this.name != 'comment' && !$('input:radio[name='+this.name+']').is(':checked')){
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
		    		if('${inWeb}' == '0'){
			    		Common.alert('<spring:message code="sys.title.surveySaved" />' + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", function(){fn_goMain(); });
			    		setTimeout(function(){fn_goMain();},3000);
		    		}else{
		    			Common.alert('<spring:message code="sys.title.surveySaved" />' + DEFAULT_DELIMITER + "<b>"+"Thank you for completing our survey!"+"</b>", function(){fn_close();});
		    		}
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
.login_pop{position:fixed; top:20px; left:50%; z-index:1001; margin-left:-500px; width:1000px; background:#fff; border:1px solid #ccc;}
.login_pop:after{content:""; display:block; position:fixed; top:0; left:0; z-index:-1; width:100%; height:100%; background:rgba(0,0,0,0.6);}
.login_pop.size_small{width:500px!important; margin-left:-250px!important;}
.login_pop.size_mid{width:700px!important; margin-left:-350px!important;}
.login_pop.size_mid2{width:600px!important; margin-left:-300px!important;}
.login_pop.size_big{width:1240px!important; margin-left:-620px!important;}
.login_pop.size_all{width:100%!important; margin-left:0!important; left:0!important; top:0!important; box-sizing:border-box;}
.login_header{padding:10px; background:#e5e5e5; border-bottom:2px solid #25527c;cursor: move}
.login_header:after{content:""; display:block; clear:both;}
.login_header h1{position:relative; float:left; height:28px; line-height:28px; padding-left:14px; font-size:20px; color:#111; font-weight:normal;}
.login_header h1:before{content:""; display:block; position:absolute; top:5px; left:0; width:3px; height:18px; background:#25527c;}
.login_header .right_opt{float:right;}
.login_header .right_opt:after{content:""; display:block; clear:both;}
.login_header .right_opt li{float:left; margin-left:5px;}
.login_body{max-height:100%; padding:10px; background:#fff; overflow-y:scroll;}
.login_body.win_popup{max-height:100%;overflow-y:auto;}
.login_pop.no_scroll .login_body{max-height:100%;}
.login_pop.size_small .login_body{max-height:350px;}
.login_body:after{content:""; display:block; height:10px; background:#fff;}
.login_body > *:first-child{margin-top:0!important;}
.login_body form > *:first-child{margin-top:0!important;}
.login_body h2{padding:10px 0 0 0; font-size:12px; color:#25527c;}
.login_body .title_line:first-child h2{padding-top:0;}
.login_body h3{margin:0; line-height:22px; font-size:11px; color:#333;}
.login_pop.msg_box{width:400px; height:auto!important; top:50%; margin:-100px 0 0 -200px; border:1px solid #0c3a65;}
.login_pop.msg_box.msg_big{width:500px; height:300px; margin:-150px 0 0 -250px;}
.login_pop.msg_box .login_header{padding:10px 20px; background:#0c3a65; border-bottom:0 none;cursor: default;}
.login_pop.msg_box .login_header h1{height:auto; font-size:13px; color:#fff; padding-left:0;}
.login_pop.msg_box .login_header h1:before{display:none;}
.login_pop.msg_box .login_header .pop_close{position:absolute; top:9px; right:21px;}
.login_pop.msg_box .login_header .pop_close a{display:block; text-indent:-1000em; overflow:hidden; width:17px; height:17px; background:url(../images/common/btn_pop_close.gif) no-repeat 0 0;}
.login_pop.msg_box .login_body {height:auto; min-height:60px;}
.login_pop.msg_box .msg_txt{display:table-cell; width:360px; height:50px; vertical-align:middle; text-align:center; line-height:1.5;}
.login_pop.msg_box.msg_big .msg_txt{width:460px; height:186px;}
.login_pop.msg_box .msg_txt .input_area{display:inline-block; margin:5px 0; padding:5px 10px 7px 10px; background:#e5e5e5; border-radius:15px;}
.login_pop.msg_box .msg_txt label input[type=checkbox],
.login_pop.msg_box .msg_txt label input[type=radio]{position:relative; top:2px; margin:0 5px 0 0; padding:0; border:1px solid #d2d2d2;}
.login_pop.msg_box .center_btns {margin-top:15px;}
.login_pop.msg_box.msg_big .center_btns {margin-top:0;}
.login_pop .ms-drop ul {max-height:275px !important;}

/* Popup Window*/
.login_pop.pop_win{position:relative;left: 0;top: 0; margin-left:0!important; width:100%!important; border:0 none!important;}
.login_pop.pop_win:after{display:none;}
.login_pop.pop_win .login_header{cursor: default;position: fixed;width:100%;z-index:10}
.login_pop.pop_win .login_header .right_opt{margin-right:20px;}
.login_pop.pop_win .login_body{max-height:none; padding:10px; background:#fff; overflow-y:hidden;padding-top: 60px}
</style>

<div id="survey_popup_wrap" class="login_pop" ><!-- popup_wrap start -->

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
    <col style="width:59%" />
    <col style="width:36%" />
</colgroup>
<tbody>
<c:forEach items="${title}" var="title">
<tr>
        <th scope="row" colspan="3"><br><b>${title.surveyMessage}</b><br/></th>

        <!-- <th scope="row" colspan="3"><b>Score : 5 - Very Satisfied | 4 - Satisfied | 3 - Average | 2 - Dissatisfied | 1 - Very Dissatisfied </b></th> -->
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
                <td><c:forEach var="score" begin="1" end = "5" step="1">
                <label><input type="radio" name="${ques.quesId}" value="${6-score}"/><span> ${6-score} </span></label>
                </c:forEach></td>
             </c:when>

             <c:when test = "${ques.inputType eq 'DROPDOWN'}">
                <script>
                doGetComboData('/logistics/survey/getSurveyAns.do', {quesId : '${ques.quesId}' },'', '${ques.quesId}','S', '');
                </script>
                <td><select id="${ques.quesId}" name="${ques.quesId}" class="w50p" ></select></td>
             </c:when>

             <c:when test = "${ques.inputType eq 'TEXT'}">
                <%-- <td><input class="w100p"type="text" title="" id="${ques.quesId}" name="${ques.quesId}" /></td> --%>
                <td><textarea  id="${ques.quesId}" name="${ques.quesId}" cols="20" rows="5" ></textarea></td>
             </c:when>

             <c:when test = "${ques.inputType eq 'DROPTEXT'}">
                <script>
                doGetComboData('/logistics/survey/getSurveyAns.do', {quesId : '${ques.quesId}' },'', '${ques.quesId}','S', '');
                </script>
                <td>
                    <label><select id="${ques.quesId}" name="${ques.quesId}" class="w50p" ></select></label>
                    <br/>
                    <label><input type="text" title="" id="${ques.quesId}" name="${ques.quesId}" /></label>
                </td>
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