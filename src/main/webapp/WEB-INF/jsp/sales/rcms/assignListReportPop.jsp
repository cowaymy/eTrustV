<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {

    if(MEM_TYPE == '6' || MEM_TYPE == '4'){
       $("#_rosCaller").multipleSelect("enable");
    }else{
       $("#_rosCaller").multipleSelect("disable");
    }

	CommonCombo.make('_rentalStusType', "/status/selectStatusCategoryCdList.do", {selCategoryId : 26} , 'INV|!|SUS',
	{
		id: "code",              // 콤보박스 value 에 지정할 필드명.
		name: "codeName",  // 콤보박스 text 에 지정할 필드명.
		isShowChoose: false,
		isCheckAll : false,
		type : 'M'
	});
	CommonCombo.make("_agentType", "/sales/rcms/selectAgentTypeList", {codeMasterId : '329'}, '',  {isShowChoose: false});

	CommonCombo.make('_assignUploadType','/common/selectCodeList.do', {groupCode:'422',orderValue:"CODE"},null,
	{
		id: "codeId",
		name: "codeName",
		type: "M"
	});

	$("#_agentType").change(function(){
		var agentType = $("#_agentType").val() != null ? $("#_agentType").val() : 2326;
		CommonCombo.make("_rosCaller", "/sales/rcms/selectRosCaller", {stus:'1',agentType: agentType}, '',
			    {
			        id:"agentGrpId",
			        name:"agentName",
			        isCheckAll : false,
			        isShowChoose: false ,
			        type: "M"
			    });
	});

	// Trigger onchange when page loaded.
	$("#_agentType").trigger('change');

});

function fn_genReport(){

    var whereSql = '';
    var whereSql2 = '';
    var runNo = 0;

	//Validation
	if($("#_assignUploadType").val() == null || $("#_assignUploadType").val() == ''){
		Common.alert('<spring:message code="sal.alert.msg.assignType" />');
		return;
	}else{
		whereSql2 += " AND  AGENT_TYP_UPL_ID IN (";
        $('#_assignUploadType :selected').each(function(i, mul){
            if(runNo > 0){
            	whereSql2 += ",'"+$(mul).val()+"'";
            }else{
            	whereSql2 += "'"+$(mul).val()+"'";
            }
            runNo += 1;
        });
        whereSql2 += ") ";

        runNo = 0;
	}

	if($("#_rosCaller").val() == null || $("#_rosCaller").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.rosCaller" />');
        return;
    }else{
    	whereSql += " AND  EXTENT3.AGENT_GRP_ID IN (";
        $('#_rosCaller :selected').each(function(i, mul){
            if(runNo > 0){
                whereSql += ",'"+$(mul).val()+"'";
            }else{
                whereSql += "'"+$(mul).val()+"'";
            }
            runNo += 1;
        });
        whereSql += ") ";

        runNo = 0;
    }

	if($("#_rentalStusType").val() == null || $("#_rentalStusType").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.plzSelRentalStusType" />');
        return;
    }else{
    	whereSql2 += " AND  RC_ITM_REN_STUS IN (";
        $('#_rentalStusType :selected').each(function(i, mul){
            if(runNo > 0){
            	whereSql2 += ",'"+$(mul).val()+"'";
            }else{
            	whereSql2 += "'"+$(mul).val()+"'";
            }
            runNo += 1;
        });
        whereSql2 += ") ";

    	runNo = 0;
    }

	if($("#listStartDt").val() == null || $("#listStartDt").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.assignStartDt" />');
        return;
    }
	if($("#listEndDt").val() == null || $("#listEndDt").val() == ''){
	    Common.alert('<spring:message code="sal.alert.msg.assignEndDt" />');
	    return;
	}
	if(($("#listStartDt").val() != null || $("#listStartDt").val() != '') &&  ($("#listEndDt").val() != null || $("#listEndDt").val() != '')){

	    var frArr = $("#listStartDt").val().split("/");
	    var toArr = $("#listEndDt").val().split("/");
	    var assignDtFrom = frArr[2]+"/"+frArr[1]+"/"+frArr[0]; // MM/dd/yyyy
	    var assignDtTo = toArr[2]+"/"+toArr[1]+"/"+toArr[0];

	    whereSql2 += " AND (RC_ITM_UPD_DT BETWEEN TO_DATE('"+assignDtFrom+"', 'yyyy/mm/dd') AND TO_DATE('"+assignDtTo+"', 'yyyy/mm/dd')+1)";
	}

	$("#reportFileName").val('/sales/AssignListingRaw.rpt');  //Rpt File Name
	$("#viewType").val("EXCEL");  //view Type

	//title
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

   console.log(whereSql);
   console.log(whereSql2);
    var title = "AssignmentListing_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
    $("#reportDownFileName").val(title); //Download File Name
    $("#V_WHERESQL").val(whereSql);// Procedure Param
    $("#V_WHERESQL2").val(whereSql2);// Procedure Param

	//Make Report
	var option = {
	        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	};

	Common.report("assignListReport", option);
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.assignListRaw" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_AddPopclose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.assignListRaw" /></h3>
</aside><!-- title_line end -->

<form id="assignListReport">

<!-- Essential -->
<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
<!-- Params -->
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" />

</form>


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
    <tr>
        <th scope="row"><spring:message code="sales.AssignUploadType" /></th>
        <td>
            <select  id="_assignUploadType" name="_assignUploadType" class="multy_select w100p" multiple="multiple">
            </select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.rentalStusType" /></th>
        <td>
            <select  id="_rentalStusType" name="_rentalStusType" class="multy_select w100p" multiple="multiple">
            </select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.agentType" /></th>
        <td>
            <select id="_agentType" name="_agentType" class="w100p" ></select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.rosCaller" /></th>
        <td>
            <select id="_rosCaller" name="_rosCaller" class="multy_select w100p" multiple="multiple">
            </select>
        </td>
    </tr>
    </tr>
	    <th scope="row"><spring:message code='sal.title.text.assignedDt'/></th>
	    <td>
	    <div class="date_set w100p"><!-- date_set start -->
	    <p><input id="listStartDt" name="startDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	    <span>To</span>
	    <p><input id="listEndDt" name="endDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	    </div><!-- date_set end -->
	    </td>
	    <th></th>
	    <td></td>
    </tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_genReport()"><spring:message code="sal.btn.genExcel" /></a></p></li>
</ul>

</section>
</div>