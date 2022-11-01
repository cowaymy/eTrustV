
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<style>

/* 커스텀 행 스타일 */
.my-row-style {
    background:#FFB2D9;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javaScript" language="javascript">

var msg = "";

$(document).ready(function(){
    doGetCombo('/sales/promotion/selectProductCategoryList.do', '', '', 'productCtgry', 'S','fn_viewType'); //Category
    doGetCombo('/common/selectCodeList.do', '15', '', 'matType', 'S','fn_viewType');

    fn_viewType("${viewType}");
});

function  fn_viewType(type){
	type = "${viewType}";
	console.log(type);
	console.log('${asDefectPartInfo}');

    $("#productCtgry").val('${asDefectPartInfo.prodCatId}');
    $("#matType").val('${asDefectPartInfo.prodTypeId}');
    $("#matCode").val('${asDefectPartInfo.matCode}');
    $("#matName").val('${asDefectPartInfo.matName}');
    $("#defPartCode").val('${asDefectPartInfo.defPartCode}');
    $("#defPartName").val('${asDefectPartInfo.defPartName}');

    if (type == 2 || type == 1){ //Edit and New
    	$('#btn_save').show();
    }

    if (type == 3){ //View

         $("#productCtgry").prop("disabled", true);
		 $("#matType").prop("disabled", true);
		 $("#matCode").prop("disabled", true);
		 $("#matName").prop("disabled", true);
		 $("#defPartCode").prop("disabled", true);
		 $("#defPartName").prop("disabled", true);
		 $("#listStatus").prop("disabled", true);

    	 $('#btn_save').hide();
    }
}

function fn_save(){
    if(fn_validate()){
    	if(msg != "") {
            Common.alert(msg);
        }
    }
    else{
    	//save

    	var asDefPartResultM = {
            defPartId : '${asDefectPartInfo.defPartId}',
            viewType : '${viewType}',

            productCtgry : $("#productCtgry").val(),
            matType : $("#matType").val(),
            matCode : $("#matCode").val(),
            matName : $("#matName").val(),
            defPartCode : $("#defPartCode").val(),
            defPartName : $("#defPartName").val()

        }

        var saveForm = {
            "asDefPartResultM" : asDefPartResultM
        }

    	Common.ajax("POST", "/logistics/asDefectPart/saveDefPart.do", saveForm,
    		      function(result) {
    		        Common.alert(result.message, fn_saveclose);
    		        $("#popup_wrap").remove();
    		        fn_selectListAjax();
    	});
    }
}

function fn_saveclose() {
	addDefPartPopupId.remove();
  }

function fn_validate(){

	msg = "";

	//checkReges
    var checkRegexResult = true;
    var regExpSpecChar = /^[^*|\":<>[\]{}`\\';@&$]+$/;

	if($("#productCtgry").val() == ""){
		msg += "* Please select a product category <br>"
	}

	if($("#matType").val() == ""){
        msg += "* Please select a product type <br>"
    }

	if($("#matCode").val() == ""){
        msg += "* Please enter a material code <br>"
    }else if( regExpSpecChar.test($("#matCode").val()) == false ){
            msg += "* Material code contains special character <br>";
    }

	if($("#matName").val() == ""){
        msg += "* Please enter a material name <br>"
    } else if( regExpSpecChar.test($("#matName").val()) == false ){
        msg += "* Material name contains special character <br>";
    }

	if($("#defPartCode").val() == ""){
        msg += "* Please enter a defect part code <br>"
    }else if( regExpSpecChar.test($("#defPartCode").val()) == false ){
        msg += "* Defect part code contains special character <br>";
    }

	if($("#defPartName").val() == ""){
        msg += "* Please enter a defect part name <br>"
    }else if( regExpSpecChar.test($("#defPartName").val()) == false ){
        msg += "* Defect part name contains special character <br>";
    }

	if($("#defPartCode").val() != ""){
		Common.ajax("GET", "/logistics/asDefectPart/checkDefPart.do?dpCode=" + $("#defPartCode").val(), "", function(result) {
	        if (result.message == "fail") {
	        	$("#hidDefPartVal").val('F');
	          }
	        if(result.message == "duplicate") {
	        	$("#hidDefPartVal").val('D');
            }
	    });
	}

	if($("#hidDefPartVal").val() == "F"){
		msg += "* This Defect Part Code is not available <br>";
    }

	if($("#hidDefPartVal").val() == "D") {
	    msg += "* This Defect Part Code has duplicate code in system <br>";
	}
    return msg;
}
</script>


<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>
    <c:if test="${viewType eq  '1' }"> Add AS Defect Part Filter Code</c:if>
    <c:if test="${viewType eq  '2' }"> Edit AS Defect Part Filter Details</c:if>
    <c:if test="${viewType eq  '3' }"> View AS Defect Part Filter Details</c:if>
</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="nc_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="height:450px"><!-- pop_body start -->

<form action="#"   id="sForm"  name="saveForm" method="post"   onsubmit="return false;">

<section class="search_table"><!-- search_table start -->
<form action="#" method="post"  id='collForm' name ='collForm'>
<div style="display: none">
<input type="text" name="hidDefPartVal" id="hidDefPartVal"/>
</div>

        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
             <col style="width: 130px" />
             <col style="width: 350px" />
             <col style="width: 170px" />
             <col style="width: *" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
		    <td>
            <select class="w100p" id="productCtgry" name="productCtgry" ></select>

		    </td>
            <th scope="row">Type</th>
		    <td>
            <select class="w100p" id="matType" name="matType"></select>
		    </td>
        </tr>
        <tr>
            <th scope="row">Material Code</th>
            <td><input type="text" title=""  class="w100p"  id="matCode"  name="matCode" /></td>
            </td>
            <th scope="row">Material Name</th>
            <td><input type="text" title=""  class="w100p"  id="matName"  name="matName" /></td>
        </tr>
        <tr>
            <th scope="row">Defect Part Code</th>
            <td><input type="text" title=""  class="w100p"  id="defPartCode"  name="defPartCode" /></td>
            </td>
            <th scope="row">Defect Part Name</th>
            <td><input type="text" title=""  class="w100p"  id="defPartName"  name="defPartName" /></td>
        </tr>
        </tbody>
        </table><!-- table end -->
        </form>
        </section><!-- search_table end -->


        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#" id="btn_save" onclick="javascript:fn_save()"><spring:message code="sal.btn.save" /></a></p></li>

         <!--  <li><p class="btn_blue2"><a href="#"  onclick="javascript:fn_saveResultTrans()">test</a></p></li> -->
        </ul>
</form>

</section>

</section><!-- content end -->


</section>

</div>
