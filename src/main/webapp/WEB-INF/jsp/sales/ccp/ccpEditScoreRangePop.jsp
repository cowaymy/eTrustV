<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

$(document).ready(function(){

	   $('#cancelBtn').click(function() {
           $('#closeBtn').trigger("click");
       });

	   $('#saveBtn').click(function() {
           fn_submitScoreRangeForm();
       });
});

function fn_validation(){
    if($("#chgRemark").val() == null || $("#chgRemark").val() == ''){
        Common.alert("Please enter reason of edit.");
        return false;
    }

    return true;
}

function fn_submitScoreRangeForm(){
	if(!fn_validation()){
        return false;

    }else {

    	var homeCat = '${editScoreRange.homeCat}';

    	var selectedData = {
    		scoreRangeId : '${editScoreRange.scoreRangeId}',
    		scoreProv : '${editScoreRange.scoreProv}',
    		scoreGrp : '${editScoreRange.scoreGrp}',
    		homeCat : homeCat,
    		startScore : $("#startScore").val(),
    		endScore : $("#endScore").val(),
    		reason : $("#chgRemark").val()
    	};

		Common.ajax("POST", "/sales/ccp/submitScoreRange.do", selectedData, function(result) {

		    if(result.code == "00"){
		        Common.alert("Configuration saved.", searchScoreRangeCtrlAjax(homeCat));
		    }else {
		        Common.alert(result.message, searchScoreRangeCtrlAjax(homeCat));
		    }
		       $("#popup_wrap_scoreRange").remove();

		       searchScoreRangeCtrlAjax(homeCat);
		});
    }
}

</script>

<div id="popup_wrap_scoreRange" class="popup_wrap"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
    <h1>Edit ${editScoreRange.homeCat} Score Range</h1>
    <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#" id="closeBtn"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form id="scoreRangeform">

            <table class="type1" id="">
                <caption><spring:message code="webInvoice.table" /></caption>
                <colgroup>
                    <col style="width:75px" />
                    <col style="width:130px" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>Start Score</th>
                        <td>
                            <input id="startScore" name="startScore" value="${editScoreRange.startScore}" type="number" min="0" oninput="validity.valid||(value='');" placeholder="" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th>End Score</th>
                        <td>
                            <input id="endScore" name="endScore" value="${editScoreRange.endScore}" type="number" min="0" oninput="validity.valid||(value='');" placeholder="" class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th>Remark</th>
                        <td>
                            <textarea type="text" title="" placeholder="" class="w100p" id="chgRemark" name="chgRemark" maxlength="100"></textarea>
                            <span id="characterCount">0 of 100 max characters</span>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->

            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a href="#" id="saveBtn">SAVE</a></p></li>
                <li><p class="btn_blue2 big"><a href="#" id="cancelBtn">CANCEL</a></p></li>
            </ul>
       </form>
    </section><!-- pop_body end -->
</div><!-- popup_wrap end -->
