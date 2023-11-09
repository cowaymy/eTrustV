<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
    doGetComboData("/common/selectCodeList.do",{ groupCode : 339 , orderValue : 'CODE', codeIn : '02,04'}, '', 'loctype', 'S','');
    doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE'}, '', 'locgrade', 'A','');
//     doGetComboData('/common/selectDepartmentCode.do',  '', ' - ', '',   'deptCode', 'M', 'fn_multiCombo2'); //Dept Code

    function fn_multiCombo2(){
        $('#deptCode').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });

}
    $("#loctype").change(function(){
    	if($("#loctype").val() == "02"){
    		 $("#Branch").attr("disabled", true);
    		 doGetComboData("/common/selectStockLocationList.do",{locgb : $("#loctype").val()},''   , 'location' , 'S', '');
    	} else {
    		$("#Branch").attr("disabled", false);
    		doGetComboData('/logistics/totalstock/selectTotalBranchList.do','', '', 'Branch', 'S','');
    	}

    });

    $("#Branch").change(function(){
        if((($('#loctype').val() == "04") || ($('#loctype').val() == "02")) && ($('#Branch').val() != "")){
//             doGetComboData('/common/selectStockLocationList.do', paramdata , '', 'location', 'S','');
            doGetComboData('/common/selectDepartmentCode.do', {brnchId : $("#Branch").val()},'','deptCode', 'S', ''); //Dept Code
        }
    });

    $("#deptCode").change(function(){
        if(($('#loctype').val() == "04") && ($('#Branch').val() != "")){
             doGetComboData('/common/selectStockLocationListByDept.do', {deptCode : $("#deptCode").val()}, '', 'location', 'S','');
        }
    });

});

function fn_validation(){
    if($("#loctype").val() == ''){
            Common.alert("Please select Location Type.");
            return false;
    }
    if($("#location").val() == '' || $("#location").val() == null){
            Common.alert("Please select Location.");
            return false;
    }
    return true;
}

function fn_validationBulk(){
	if($("#loctype").val() == "02"){
		  if($("#loctype").val() == ''){
	            Common.alert("Please select Location Type.");
	            return false;
	    }
	    if($("#location").val() == '' || $("#location").val() == null){
	            Common.alert("Please select Location.");
	            return false;
	    }
	} else if($("#loctype").val() == "04") {
    if($("#loctype").val() == ''){
            Common.alert("Please select Location Type.");
            return false;
    }
    if($("#Branch").val() == '' || $("#Branch").val() == null){
            Common.alert("Please select Branch.");
            return false;
    }
    if($("#deptCode").val() == '' || $("#deptCode").val() == null){
        Common.alert("Please select Department Code (CM).");
        return false;
}}
    return true;
}

    function fn_openReport() {
        if (fn_validation()) {
            var date = new Date();
            var month = date.getMonth() + 1;
            var day = date.getDate();
            if (date.getDate() < 10) {
                day = "0" + date.getDate();
            }
            if (date.getDate() < 10) {
                month = "0" + (date.getMonth() + 1);
            }

            console.log("fn_openReport");
            console.log("loctype value " + $("#loctype").val());
            console.log("branch " + $("#Branch").val())
            console.log("branch " + $("#deptCode").val())

            $("#totalStockForm #reportFileName").val('/logistics/TotalStock_PDF.rpt');
            $("#totalStockForm #reportDownFileName").val("StockReport_" + $("#location").val() +"_" + day + month + date.getFullYear());
            $("#totalStockForm #viewType").val("PDF");
            $("#totalStockForm #V_LOCATIONTYPE").val($("#loctype").val());
            $("#totalStockForm #V_LOCATION").val($("#location").val());

            var option = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };

                Common.report("totalStockForm", option);
            }

        }

    function fn_bulkGen() {
        if (fn_validationBulk()) {
            var date = new Date();
            var month = date.getMonth() + 1;
            var day = date.getDate();
            if (date.getDate() < 10) {
                day = "0" + date.getDate();
            }
            if (date.getDate() < 10) {
                month = "0" + (date.getMonth() + 1);
            }

            console.log("fn_bulkGen");
            console.log("Location type ID " + $("#loctype").val());
            console.log("Branch ID " + $("#Branch").val())
            console.log("Department Code " + $("#deptCode").val())
            console.log("Location Code " + $("#location").val())

            $("#totalStockForm #reportFileName").val('/logistics/TotalStockBulk_PDF.rpt');
            $("#totalStockForm #reportDownFileName").val("StockReport_" + $("#deptCode").val() +"_" + day + month + date.getFullYear());
            $("#totalStockForm #viewType").val("PDF");
            $("#totalStockForm #V_LOCATIONTYPE").val($("#loctype").val());
            $("#totalStockForm #V_DEPTCODE").val($("#deptCode").val());

            var option = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };

                Common.report("totalStockForm", option);
            }

        }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form') {
                return $(':input', this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea') {
                this.value = '';
            }
            else if (type === 'checkbox' || type === 'radio') {
                this.checked = false;
            }
            else if (tag === 'select') {
                this.selectedIndex = -1;
            }
        });
    };
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Total Stock Report (PDF)</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="totalStockForm">
<input type="hidden" id="V_LOCATIONTYPE" name="V_LOCATIONTYPE" />
<input type="hidden" id="V_LOCATION" name="V_LOCATION" />
<input type="hidden" id="V_DEPTCODE" name="V_DEPTCODE" />
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
   <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Location Type</th>
    <td>
     <select id="loctype" name="loctype">
    </select>
    </td>
</tr>

<tr>
    <th scope="row">Branch</th>
    <td>
    <select id="Branch" name="Branch">
    <option value="">Choose One</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Department Code (CM)</th>
    <td>
    <select id="deptCode" name="deptCode">
    <option value="">Choose One</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Location</th>
    <td>
    <select id="location" name="location">
    <option value="">Choose One</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Location Grade</th>
    <td>
    <select id="locgrade" name="locgrade">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()"><spring:message code='service.btn.Generate'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_bulkGen()"><spring:message code='service.btn.bulkGenerate'/></a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="clearbtn" onclick="javascript:$('#totalStockForm').clearForm();"><spring:message code='service.btn.Clear'/></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
