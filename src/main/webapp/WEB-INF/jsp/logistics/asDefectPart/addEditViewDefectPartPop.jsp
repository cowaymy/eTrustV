
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
    $("#listStatus").val('${asDefectPartInfo.stus}');

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
            defPartName : $("#defPartName").val(),
            stus : $("#listStatus").val()

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

	var msg = "";

	if($("#productCtgry").val() == ""){
		msg += "* Please select a product category <br>"
	}
	if($("#matType").val() == ""){
        msg += "* Please select a product type <br>"
    }
	if($("#matCode").val() == ""){
        msg += "* Please select a material code <br>"
    }
	if($("#matName").val() == ""){
        msg += "* Please select a material name <br>"
    }
	if($("#defPartCode").val() == ""){
        msg += "* Please select a defect part code <br>"
    }
	if($("#defPartName").val() == ""){
        msg += "* Please select a defect part name <br>"
    }

	if(msg != "") {
		Common.alert(msg);
        return false;
	}
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
        <tr>
            <th scope="row">Status</th>
            <td>
            <select id="listStatus" name="status" class="w100p">
	           <option value="1">Active</option>
	           <option value="8">Inactive</option>
            </select>
            </td>
            <th scope="row"></th>
            <td></td>
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
