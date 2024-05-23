
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
var typeId = "";
var busiCat = "";

$(document).ready(function(){

	if ('${codeMgmtMap.busiCat}' == 'HA'){ //AS
		busiCat = '6665';
    }else{
    	busiCat = '6666';
    }

    doGetCombo('/sales/promotion/selectProductCategoryList.do', '', '${codeMgmtMap.prodCatId}', 'productCtgry', 'S','');
    doGetCombo('/common/selectCodeList.do', '500', '${codeMgmtMap.busiCat}', 'busiCat', 'S','');
    doGetCombo('/common/selectCodeList.do', '553', '${codeMgmtMap.typeId}', 'type', 'S','');
    doGetCombo('/services/codeMgmt/selectCodeCatList.do', '${codeMgmtMap.typeId}', '${codeMgmtMap.codeCatId}', 'codeCtgry', 'S','');

    fn_toggle('${codeMgmtMap.codeCatId}');
    fn_viewType("${viewType}");

    $('#nc_close').click(function() {
        fn_saveclose();
    });

});

function  fn_viewType(type){
    type = "${viewType}";

    console.log('${codeMgmtMap}');
    console.log('${codeMgmtMap.busiCat}');
    $("#busiCat").val('${codeMgmtMap.busiCat}');
    $("#type").val(typeId);
    $("#productCtgry").val('${codeMgmtMap.prodCatId}');
    $("#codeCtgry").val('${codeMgmtMap.codeCatId}');
    $("#svcCode").val('${codeMgmtMap.defectCode}');
    if('${codeMgmtMap.codeCatId}' == '11'){
        $("#svcLargeCode").val('${codeMgmtMap.svcLargeCode}');
    }else{
    	$("#svcLargeCode").val('${codeMgmtMap.defectGrpCode}');
    }
    $("#svcCodeDesc").val('${codeMgmtMap.codeDesc}');
    $("#svcCodeRmk").val('${codeMgmtMap.codeRemark}');

    $("#productCode").val('${codeMgmtMap.prodCode}');
    $("#prdLaunchDt").val('${codeMgmtMap.prodLaunchDt}');
    $("#ctComm").val('${codeMgmtMap.ctComm}');
    $("#asCost").val('${codeMgmtMap.asCost}');

    $("#hidCodeCatName").val('${codeMgmtMap.codeCatName}');
    $("#hidDefectId").val('${codeMgmtMap.defectId}');
    $("#hidDefectGrp").val('${codeMgmtMap.defectGrp}');

    if (type == 2 || type == 1){ //Edit and New
        $('#btn_save').show();
    }

    if (type == 3){ //View

    	$("#busiCat").prop("disabled", true);
    	$("#type").prop("disabled", true);
    	$("#productCtgry").prop("disabled", true);
    	$("#codeCtgry").prop("disabled", true);
    	$("#svcCode").prop("disabled", true);
    	$("#svcLargeCode").prop("disabled", true);
    	$("#svcCodeDesc").prop("disabled", true);
    	$("#svcCodeRmk").prop("disabled", true);

    	$("#productCode").prop("disabled", true);
    	$("#prdLaunchDt").prop("disabled", true);
    	$("#ctComm").prop("disabled", true);
    	$("#asCost").prop("disabled", true);

        $('#btn_save').hide();
    }
}

function fn_toggle(selVal) {
    if(selVal == '19') { //Product Setting
        $(".tr_toggle_display").show();
        $(".tr_toggle_code").hide();
    } else {
    	if(selVal == '2' || selVal == '4' || selVal == '6' || selVal == '8' || selVal == '11'){
    		$(".tr2_toggle_display").show();
    	}else{
    		$(".tr2_toggle_display").hide();
    	}
        $(".tr_toggle_display").hide();
        $(".tr_toggle_code").show();
    }
}

function fn_changeCodeCat(selVal) {
    doGetCombo('/services/codeMgmt/selectCodeCatList.do', selVal, '${codeMgmtMap.codeCatId}', 'codeCtgry', 'S','');

}

function fn_save(){

    var flag = false;
    var type = "${viewType}";

    if(fn_validate()){
        if(msg != "") {
            Common.alert(msg);
            flag = true;
        }
    }

    if (type == 1){ // New
    	if($("#codeCtgry").val() == '19') {
            if(fn_chkProductAvail()){
                   flag = true;
                   return;
               }
       }else{
           //SYS0032M
           if($("#codeCtgry").val() >= 12 && $("#codeCtgry").val() <= 16){
               if(fn_chkDupReasons()){
                   flag = true;
                   return;
               }
           }else{ //SYS0100M
               if(fn_chkDupDefectCode()){
                   flag = true;
                   return;
               }
           }
       }
    }

    if(!flag){
        fn_saveNewCode();
    }
}

function fn_chkProductAvail(){
	var rtnVAL = false;
	Common.ajaxSync("GET", "/services/codeMgmt/chkProductAvail.do", {"prodCode" : $("#productCode").val()}, function(result) {
	    //$("#hidVal").val(result.length);

	    if(result[0].count < 1 ){
	        rtnVAL = true;
	        Common.alert( $("#productCode").val() + " this material code is not available <br>");
	        return true;
	    }
	});
	return rtnVAL;
}

function fn_chkDupReasons(){
    var rtnVAL = false;

    Common.ajaxSync("GET", "/services/codeMgmt/chkDupReasons.do", {"codeCtgry" : $("#codeCtgry").val(),"svcCode" : $("#svcCode").val()}, function(result) {
        //$("#hidVal").val(result.length);

        if(result[0].count > 0 ){
            rtnVAL = true;
            Common.alert($("#svcCode").val() + " this reason code is already in system <br>");
            return true;
        }
    });

    return rtnVAL;
}

function fn_chkDupDefectCode(){
    var rtnVAL = false;
    Common.ajaxSync("GET", "/services/codeMgmt/chkDupDefectCode.do", {"codeCtgry" : $("#codeCtgry").val(),"svcCode" : $("#svcCode").val()}, function(result) {
        //$("#hidVal").val(result.length);

        console.log(result[0].count);
        if(result[0].count > 0 ){
            rtnVAL = true;
            Common.alert( $("#svcCode").val() + " this defect code is already in system <br>");
            return true;
        }
    });

    return rtnVAL;
}

function fn_validate(){

    msg = "";
    //checkReges
    var checkRegexResult = true;
    var regExpSpecChar = /^[^*|\":<>[\]{}`\\';@&$]+$/;
    var viewType = "${viewType}";

    if($("#codeCtgry").val() == '19') { //Product Setting

    	if(viewType == "1"){ //New Code
            msg += "* Product Setting Cannot be added <br>";
            msg += "* Proceed to Edit Code for product setting <br>";
        }

    	if($("#productCode").val() == ""){
            msg += "* Please enter material code <br>";
        }



    	/* if($("#prdLaunchDt").val() == ""){
            msg += "* Please select product launch date <br>";
        }

    	if($("#ctComm").val() == ""){
            msg += "* Please enter product CT commission <br>";
        }

    	if($("#asCost").val() == ""){
            msg += "* Please enter product as cost price <br>";
        } */
    } else {

    	//DC, HDD, HDC, DD
    	if($("#codeCtgry").val() >= 1 && $("#codeCtgry").val() <= 4){
    		if($("#productCtgry").val() == ""){
                msg += "* Please select a product category <br>";
            }
    	}

    	if($("#type").val() == ""){
            msg += "* Please select a service type <br>";
        }

        if($("#codeCtgry").val() >= 1 && $("#codeCtgry").val() <= 9){
	    	if($("#busiCat").val() == ""){
	            msg += "* Please select a business category <br>";
	        }
    	}

    	if($("#codeCtgry").val() == ""){
            msg += "* Please select a code category <br>";
        }

    	if($("#svcCode").val() == ""){
            msg += "* Please enter service code <br>";
        }

    	if($("#svcCodeDesc").val() == ""){
            msg += "* Please enter code description <br>";
        }

    	if($("#svcCodeRmk").val() == ""){
            msg += "* Please enter code remark <br>";
        }
    }

    return msg;
}

function fn_saveNewCode(){
        var newCodeM = {
            viewType : '${viewType}',

            busiCat : $("#busiCat").val(),
            type : $("#type").val(),
            productCtgry : $("#productCtgry").val(),
            codeCtgry : $("#codeCtgry").val(),
            svcCode : $("#svcCode").val(),
            svcLargeCode : $("#svcLargeCode").val(),
            svcCodeDesc : $("#svcCodeDesc").val(),
            svcCodeRmk : $("#svcCodeRmk").val(),

            productCode : $("#productCode").val(),
            prdLaunchDt : $("#prdLaunchDt").val(),
            ctComm : $("#ctComm").val(),
            asCost : $("#asCost").val(),

            hidCodeCatName : $("#hidCodeCatName").val(),
            hidDefectId : $("#hidDefectId").val(),
            hidDefectGrp : $("#hidDefectGrp").val()
        }

        var saveForm = {
            "newCodeM" :  newCodeM
        }

        Common.ajax("POST", "/services/codeMgmt/saveNewCode.do", saveForm, function(result) {
           Common.alert(result.message, fn_saveclose);
           $("#popup_wrap").remove();
           //fn_selectCodeMgmtList();
        });
}

function fn_saveclose() {
    addNewCodePopupId.remove();
}

</script>


<div id="popup_wrap" class="popup_wrap "><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>
    <c:if test="${viewType eq  '1' }"> Add New Service Code</c:if>
    <c:if test="${viewType eq  '2' }"> Edit New Service Code</c:if>
    <c:if test="${viewType eq  '3' }"> View New Service Code</c:if>
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
            <input type="text" name="hidTypeId" id="hidTypeId"/>
            <input type="text" name="hidCodeCatName" id="hidCodeCatName"/>
            <input type="text" name="hidDefectId" id="hidDefectId"/>
            <input type="text" name="hidDefectGrp" id="hidDefectGrp"/>
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
            <th scope="row">Business Category</th>
            <td>
                <select class="w100p" id="busiCat" name="busiCat" ></select>
            </td>
            <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
            <td>
                <select class="w100p" id="productCtgry" name="productCtgry" ></select>
            </td>
        </tr>
        <tr>
            <th scope="row">Type</th>
            <td>
                <select class="w100p" id="type" name="type" onchange="javascript : fn_changeCodeCat(this.value)" ></select>
            </td>
            <th scope="row">Code Category</th>
            <td>
                <select class="w100p" id="codeCtgry" name="codeCtgry" onchange="javascript : fn_toggle(this.value)"></select>
            </td>
        </tr>
        <tr class="tr_toggle_code">
            <th scope="row">Code</th>
            <td><input type="text" title=""  class="w100p"  id="svcCode"  name="svcCode" /></td>
            <th scope="row" class="tr2_toggle_display">Large Code</th>
            <td><input type="text" title=""  class="w100p tr2_toggle_display"  id="svcLargeCode"  name="svcLargeCode" /></td>
        </tr>
        <tr class="tr_toggle_code">
            <th scope="row">Code Desc</th>
            <td><input type="text" title=""  class="w100p"  id="svcCodeDesc"  name="svcCodeDesc" /></td>
            <th scope="row">Code Remark</th>
            <td><input type="text" title=""  class="w100p"  id="svcCodeRmk"  name="svcCodeRmk" /></td>
        </tr>
        <tr class="tr_toggle_display" style="display:none;">
            <th scope="row">Product Code</th>
            <td><input type="text" title=""  class="w100p"  id="productCode"  name="productCode" /></td>
            </td>
            <th scope="row">Product Launch Date</th>
            <td><input type="text" title="Product Launch Date" placeholder="DD/MM/YYYY" class="w100p j_date" id="prdLaunchDt" /></td>
        </tr>
        <tr class="tr_toggle_display" style="display:none;">
            <th scope="row">CT Commission</th>
            <td><input type="text" title=""  class="w100p"  id="ctComm"  name="ctComm" /></td>
            </td>
            <th scope="row">AS Cost</th>
            <td><input type="text" title=""  class="w100p"  id="asCost"  name="asCost" /></td>
        </tr>
        </tbody>
        </table><!-- table end -->
        </form>
        </section><!-- search_table end -->


        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#" id="btn_save" onclick="javascript:fn_save()"><spring:message code="sal.btn.save" /></a></p></li>
        </ul>
</form>

</section>

</section><!-- content end -->


</section>

</div>
