<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

let materialName, materialCode, materialCategory, materialType, branch;

$(document).ready(function() {
    doGetComboData("/common/selectCodeList.do",{ groupCode : 339 , codeIn : '03'}, '', 'locationType', 'S','');
    doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE'}, '', 'locationGrade', 'S','');
    doGetCombo('/common/selectCodeList.do', '11', '','materialCategory', 'M' , 'f_multiCombos');
    doGetCombo('/common/selectCodeList.do', '15', '', 'materialType', 'M','f_multiComboType3');
});

const getBranch = () => {
	$("#ctLocation option").remove();
    f_multiComboType2();
	doGetComboData('/logistics/totalstock/selectTotalDscList.do',$("#totalStockCtForm").serialize(), '', 'dscBranch', 'M', 'f_multiComboType');
}

const getCtLocation = () => {
	$("#ctLocation option").remove();
	f_multiComboType2();
	doGetComboData('/common/selectStockLocationList4.do', $("#totalStockCtForm").serialize() , '', 'ctLocation', 'M','f_multiComboType2');
}


$(function(){
	 $('#locationGrade').change(function(){
		 getBranch();
	 });

	$('#dscBranch').change(function(){
		if (!FormUtil.isEmpty($("#dscBranch").val())) {
			branch = $('#dscBranch').val();
		    if(branch.length >3){
		           Common.alert("Cannot more than 3 branch.",()=>{
		        	   $('.msg_box').remove();
		        	   getBranch();
		        });
		    }else{
		    	getCtLocation();
		    }
		}
		else{
			$("#ctLocation option").remove();
		    f_multiComboType2();
		}
	});

});

function f_multiComboType() {
    $(function() {
    	$("#ctLocation option").remove();
    	f_multiComboType2();
        $('#dscBranch').multipleSelect({
            selectAll : true
        });
    });
}

function f_multiComboType2() {
    $(function() {
        $('#ctLocation').multipleSelect({
            selectAll : true
        });
    });
}

function f_multiComboType3() {
    $(function() {
        $('#materialType').multipleSelect({
            selectAll : true
        });
    });
}

function f_multiCombos() {
    $(function() {
        $('#materialCategory').multipleSelect({
            selectAll : true
        });
    });
}


function fn_validation(){
    branch = $('#dscBranch').val();

    if (FormUtil.isEmpty($("#locationGrade").val())) {
           Common.alert("Please select Location Grade.");
           return false;
   }

	if (FormUtil.isEmpty($("#dscBranch").val())) {
            Common.alert("Please select Branch.");
            return false;
    }

    if(branch.length >3){
    	   Common.alert("Cannot more than 3 branch.",()=>{
	              $('.msg_box').remove();
	              getBranch();
	       });
           return false;
    }

	if (FormUtil.isEmpty($("#ctLocation").val())) {
            Common.alert("Please select Location.");
            return false;
    }

    return true;
}


function fn_genCtReport() {
    if (fn_validation()) {
	        let date = new Date();
	        let month = date.getMonth() + 1;
	        let day = date.getDate();

	        if (date.getDate() < 10) { day = "0" + date.getDate();}

	        if (month < 10) {month = "0" + (date.getMonth() + 1);}

	        materialName = FormUtil.isEmpty($("#materialName").val()) ? null : " AND (S26.STK_CODE = '" + $("#materialName").val() +"' OR S26.STK_DESC LIKE '%" + $("#materialName").val() + "%')";
	        materialCategory = FormUtil.isEmpty($("#materialCategory").val()) ? null :  " AND S26.STK_CTGRY_ID IN (" + $("#materialCategory").val() + ")";
	        materialType = FormUtil.isEmpty($("#materialType").val()) ? null : " AND S26.STK_TYPE_ID IN ( "+ $("#materialType").val() + ")";

	        let locgbparam = "";
	        let searchlocgb = $('#ctLocation').val();
	        if(!FormUtil.isEmpty($("#ctLocation").val())){
	             for (let i = 0 ; i < searchlocgb.length ; i++){
	                 if (locgbparam == ""){
	                     locgbparam = "'"+searchlocgb[i]+"'";
	                 }else{
	                     locgbparam = locgbparam +",'"+searchlocgb[i]+"'";
	                 }
	             }
	        }

	        locgbparam =  ' AND S28.WH_LOC_CODE IN (' +locgbparam +')';

	        $("#totalStockCtForm #reportFileName").val('/logistics/TotalStockCt.rpt');
	        $("#totalStockCtForm #reportDownFileName").val("StockReport_" + day + month + date.getFullYear());
	        $("#totalStockCtForm #viewType").val("EXCEL");
	        $("#totalStockCtForm #v_ctLocation").val(locgbparam);
	        $("#totalStockCtForm #v_materialName").val(materialName);
	        $("#totalStockCtForm #v_materialCategory").val(materialCategory);
	        $("#totalStockCtForm #v_materialType").val(materialType);

	        Common.report("totalStockCtForm", {isProcedure : true});

        }

    }

 $.fn.clearForm = function() {
     return this.each(function() {
         let type = this.type, tag = this.tagName.toLowerCase();
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
         $("#locationType").val("CT");
         $("#dscBranch").multipleSelect("uncheckAll");
         $("#ctLocation").multipleSelect("uncheckAll");
         $("#materialCategory").multipleSelect("uncheckAll");
         $("#materialType").multipleSelect("uncheckAll");
     });
 };


</script>

<div id="popup_wrap2" class="popup_wrap">
<header class="pop_header">
    <h1>Total Stock Report (CT)</h1>
	<ul class="right_opt">
	    <li><p class="btn_blue2"><a href="#"><spring:message code='expense.CLOSE'/></a></p></li>
	</ul>
</header>

<section class="pop_body">

<section class="search_table">
	<form action="#" method="post" id="totalStockCtForm">
	<input type="hidden" id="v_ctLocation" name="v_ctLocation" />
	<input type="hidden" id="v_materialName" name="v_materialName" />
<!-- 	<input type="hidden" id="v_materialCode" name="v_materialCode" /> -->
	<input type="hidden" id="v_materialCategory" name="v_materialCategory" />
	<input type="hidden" id="v_materialType" name="v_materialType" />
	<input type="hidden" id="reportFileName" name="reportFileName" />
	<input type="hidden" id="viewType" name="viewType" />
	<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />


		<table class="type1">
		        <caption>table</caption>
				<colgroup>
				   <col style="width:170px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
						<tr>
						    <th scope="row">Location Type</th>
						    <td><input id="locationType" value="CT" class="w100p" type="text" disabled="disabled"></td>
						</tr>

						<tr>
                            <th scope="row">Location Grade</th>
                            <td><select id="locationGrade" name="locationGrade"></select></td>
                        </tr>

						<tr>
						    <th scope="row">Branch</th>
						    <td><select id="dscBranch" name="dscBranch" class="multy_select w100p" multiple="multiple"></select></td>
						</tr>

						<tr>
						    <th scope="row">Location</th>
						    <td><select id="ctLocation" name="ctLocation" class="multy_select w100p"multiple="multiple"></select></td>
						</tr>

                        <tr>
		                   <th scope="row">Material Code/Name</th>
		                   <td >
<!-- 		                      <input type="hidden" title="" placeholder=""  class="w100p" id="materialCode" name="materialCode"/> -->
		                      <input type="text"   title="" placeholder=""  class="w100p" id="materialName" name="materialName"/>
		                   </td>
                        </tr>

                        <tr>
		                    <th scope="row">Category</th>
		                    <td>
		                       <select class="w100p" id="materialCategory"  name="materialCategory"></select>
		                    </td>
                        </tr>

                        <tr>
                           <th scope="row">Type</th>
		                   <td>
		                       <select class="w100p" id="materialType" name="materialType"></select>
		                   </td>
                        </tr>
				</tbody>
		</table>

		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_genCtReport()"><spring:message code='service.btn.Generate'/></a></p></li>
		    <li><p class="btn_blue2 big"><a href="#" id="clearbtn" onclick="javascript:$('#totalStockCtForm').clearForm();"><spring:message code='service.btn.Clear'/></a></p></li>
		</ul>
	</form>
</section>
</section>
</div>
