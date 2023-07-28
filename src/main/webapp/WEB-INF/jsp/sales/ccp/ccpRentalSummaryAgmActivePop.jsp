<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<script type="text/javascript">

let startDt = moment().subtract(6, 'months').add(1,'days').format('DD/MM/YYYY');
let endDt = moment().format('DD/MM/YYYY');

let memType = '${orgInfo.memType}';
let memLvl = parseInt('${orgInfo.memLvl}');

$("#crtDateFr").val(startDt);
$("#crtDateTo").val(endDt);

switch (memType){
case '1' :
case '2' :
case '7' :

	if(memLvl <= 4){
		$("#orgCode").val('${orgInfo.orgCode}');
		$("#groupCode").val('${orgInfo.grpCode}');
		$("#deptCode").val('${orgInfo.deptCode}');
		$("#memCode").val('${orgInfo.memCode}');
	}
	if(memLvl <= 3){
        $("#agmActiveform #memCode").removeAttr("class").removeAttr("readonly");
        $("#memCode").val('');
    }
    if(memLvl <= 2){
        $("#agmActiveform #deptCode").removeAttr("class").removeAttr("readonly");
        $("#deptCode").val('');
    }
    if(memLvl <= 1){
        $("#agmActiveform #grpCode").removeAttr("class").removeAttr("readonly");
        $("#groupCode").val('');

    }

	break;
default :
	$(function(){
        $("#agmActiveform :input[type=text][readonly='readonly']").removeAttr("class").removeAttr("readonly");
    });
	break;
};

fetch("/sales/ccp/selectAgreementProgressStatus.do")
    .then(Response=>Response.json())
    .then(data => {
    	let result = data.filter(data => data.id != 10);
    	let dropdown = $('#ddlProgress');

    	dropdown.empty();
    	dropdown.prop('selectedIndex', 0);

    	$.each(result, function (key, entry) {
    	    dropdown.append($('<option></option>').attr('value', entry.id).text(entry.codeName));
    	});

    	dropdown.change(function(){}).multipleSelect({selectAll: true});
    });


$.fn.clearForm = function() {
    return this.each(function() {

        let type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }
        $("#crtDateFr").val(startDt);
        $("#crtDateTo").val(endDt);
    });
};

function validRequiredField(){
    let valid = true;
    let message = "";

    let startDt = moment($("#crtDateFr").val(),'DD/MM/YYYY');
    let endDt   = moment($("#crtDateTo").val(),'DD/MM/YYYY');

    if(!$("#crtDateFr").val() || !$("#crtDateTo").val()){
        Common.alert('Rental Agreement Rawdata'+ DEFAULT_DELIMITER + "* Please key in the Date created.\n");
        return;
    }
    else if (endDt.diff(startDt, "months") > 11){
        Common.alert('Rental Agreement Rawdata'+ DEFAULT_DELIMITER + "* Please select a date range of 12 months.\n");
        return;
    }

    fn_report();
}

function fn_report(){

    let whereSQL = "";

    if($('#agmActiveform  #orgCode').val())
    	whereSQL += " AND EXTENT2.ORG_CODE = '" + $('#agmActiveform #orgCode').val() + "' ";

    if($('#agmActiveform  #groupCode').val())
        whereSQL += " AND EXTENT2.GRP_CODE = '" + $('#agmActiveform #groupCode').val() + "' ";

    if($('#agmActiveform  #deptCode').val())
        whereSQL += " AND EXTENT2.DEPT_CODE = '" + $('#agmActiveform #deptCode').val() + "' ";

    if($('#agmActiveform  #memCode').val())
        whereSQL += " AND Extent8.MEM_CODE = '" + $('#agmActiveform #memCode').val() + "' ";

    if($('#ddlProgress :selected').length > 0){
        let selectedProgress = "";

        $('#ddlProgress :selected').each(function(i, mul){
        	selectedProgress += (i > 0) ? "," + $(mul).val() : $(mul).val();
        });

        whereSQL +=" AND Extent1.GOV_AG_PRGRS_ID IN (" + selectedProgress + ") ";
   }

    if(!($("#crtDateFr").val() == null || $("#crtDateFr").val().length == 0)){
        whereSQL += " AND EXTENT1.GOV_AG_CRT_DT >= TO_DATE('"+$("#crtDateFr").val()+"', 'DD/MM/YYYY')";
    }
    if(!($("#crtDateTo").val() == null || $("#crtDateTo").val().length == 0)){
        whereSQL += " AND EXTENT1.GOV_AG_CRT_DT <= TO_DATE('"+$("#crtDateTo").val()+"', 'DD/MM/YYYY')";
    }

    $("#agmActiveform #reportFileName").val("/sales/rentalActiveAGM.rpt");
    $("#agmActiveform #reportDownFileName").val("Rental Active AGM Listing (Organisation)_"+ moment().format('DDMMYYYY') );
    $("#V_WHERESQL").val(whereSQL);

    let option = {isProcedure : true };
    Common.report("agmActiveform", option);
}

</script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Active AGM Listing(Organisation)</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header>

<section class="pop_body">
<aside class="title_line">
</aside>

<section class="search_table">
<form action="#" method="post" id="agmActiveform">
<table class="type1">
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
<th><spring:message code="sal.text.orgCode"/></th>
    <td><input class="readonly" type="text" id="orgCode" name="orgCode"/ readonly ></td>
</tr>
<tr>
    <th><spring:message code="sal.text.GroupCode"/></th>
    <td><input class="readonly" type="text" id="groupCode"  name="groupCode" readonly/></td>
</tr>
<tr>
    <th><spring:message code="sal.text.detpCode"/></th>
    <td><input class="readonly" type="text" id="deptCode"  name="deptCode" readonly/></td>
</tr>
<tr>
    <th><spring:message code="sal.text.memberCode"/></th>
    <td><input class="readonly" type="text" id="memCode"  name="memCode" readonly/></td>
</tr>
<tr>
    <th scope="row">Date created</th>
        <td>
           <div class="date_set">
              <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="crtDateFr"/></p>
              <span><spring:message code="sal.title.to" /></span>
              <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="crtDateTo"/></p>
           </div>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.combo.text.prgssStus" /></th>
    <td>
    <select class="multy_select" multiple id="ddlProgress"></select>
    </td>
</tr>
</tbody>
</table>

<ul class="right_btns">
    <li><p class="btn_blue"><a href="javascript:void(0);" onclick="javascript: validRequiredField();"><spring:message code="sal.btn.generate" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#agmActiveform').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName"/>
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL"/>

</form>

</section>
</section>
</div>