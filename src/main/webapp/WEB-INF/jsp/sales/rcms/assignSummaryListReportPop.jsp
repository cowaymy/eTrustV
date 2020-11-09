<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {

    //App Type
    CommonCombo.make("_appType", "/common/selectCodeList.do", {groupCode : '10'}, '66',{id: "codeId",name:"codeName",isShowChoose: false});
    //Rental Status
    CommonCombo.make('_rentalStusType', "/status/selectStatusCategoryCdList.do", {selCategoryId : 26} , 'INV|!|SUS', {id: "code", name: "codeName", isShowChoose: false,isCheckAll : false,type : 'M'});
    //Agent Type
    CommonCombo.make("_agentType", "/sales/rcms/selectAgentTypeList", {codeMasterId : '329'}, '',  {isShowChoose: false, type: "S",isShowChoose: true});
    //Customer Type
    CommonCombo.make("_customerType", "/common/selectCodeList.do", {groupCode : '8'}, '', {type : "M"});
    //Company Type
    CommonCombo.make("_companyType", "/common/selectCodeList.do", {groupCode : '95'}, null, {isShowChoose: false , isCheckAll : false, type: "M"});

    CommonCombo.make("_rosCaller", "/sales/rcms/selectRosCaller", {stus:'1'}, '',{  id:"agentId",  name:"agentName", isCheckAll : false,isShowChoose: false ,type: "M"});
    $("#_companyType").multipleSelect("disable");

    $("#_agentType").change(function(){
        CommonCombo.make("_rosCaller", "/sales/rcms/selectRosCaller", {stus:'1',agentType: $("#_agentType").val()}, '',
                {
                    id:"agentId",
                    name:"agentName",
                    isCheckAll : false,
                    isShowChoose: false ,
                    type: "M"
                });
    });

});

function fn_customerChng(){

    if($("#_customerType").val() == "964"){
        $("#_companyType").multipleSelect("disable");
    }else{
        $("#_companyType").multipleSelect("enable");
    }
}

function fn_genReport(){

    var whereSql = '';
    var assignDt = '';
    var runNo = 0;

  //Validation
    if($("#_customerType").val() != null || $("#_customerType").val() != ''){
    	//whereSql += " AND  EXTENT6.TYPE_ID = " + $("#_customerType").val();
    	whereSql += " AND  EXTENT6.TYPE_ID IN (";
    	$('#_customerType :selected').each(function(i, mul){
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
console.log($("#_companyType").val());
    if($("#_companyType").val()  != null){
        whereSql += " AND  EXTENT6.CORP_TYPE_ID IN (";
        $('#_companyType :selected').each(function(i, mul){
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

    if($("#_rosCaller").val() == null || $("#_rosCaller").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.rosCaller" />');
        return;
    }else{
        whereSql += " AND  EXTENT3.AGENT_ID IN (";
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

    if($("#_rentalStusType").val() != null || $("#_rentalStusType").val() != ''){
        whereSql += " AND  EXTENT5.ASSIGN_REN_STUS IN (";
        $('#_rentalStusType :selected').each(function(i, mul){
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

    if($("#_assignDt").val() == null || $("#_assignDt").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.assignDt" />');
        return;
    }else{
    	assignDt = $("#_assignDt").val();
    	/* whereSql += " AND  TO_CHAR(EXTENT5.CURR_ASSIGN_DT,'MM/YYYY') = '" + assignDt + "' "; */
    }


    $("#reportFileName").val('/sales/AssignSummaryRaw.rpt');  //Rpt File Name
    $("#viewType").val("EXCEL");  //view Type

    //title
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    var title = "AssignmentSummary_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
    $("#reportDownFileName").val(title); //Download File Name
    $("#V_WHERESQL").val(whereSql);// Procedure Param
    $("#V_ASSIGNDT").val(assignDt);

    //Make Report
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("assignSummaryReport", option);
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.assignSummaryListRaw" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_AddPopclose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.assignSummaryListRaw" /></h3>
</aside><!-- title_line end -->

<form id="assignSummaryReport">

<!-- Essential -->
<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
<!-- Params -->
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
<input type="hidden" id="V_ASSIGNDT" name="V_ASSIGNDT" />

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
        <th scope="row"><spring:message code="sal.title.text.rcmsAppType" /><span class="must">*</span></th>
        <td>
        <select id="_appType" name="_appType" class="w100p disabled" disabled="disabled" >
        </select>
        </td>
        <th scope="row"><spring:message code="sal.text.custType" /></th>
        <td>
          <select  id="_customerType" name="_customerType" class="w100p" onchange="javascript:fn_customerChng();"></select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.rentalStusType" /></th>
        <td>
            <select  id="_rentalStusType" name="_rentalStusType" class="multy_select w100p" multiple="multiple"></select>
        </td>
        <th scope="row"><spring:message code="sal.title.text.companyType" /></th>
        <td>
        <select id="_companyType" name="_companyType" class="multy_select w100p" multiple="multiple">
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
     <tr>
        <th scope="row"><spring:message code='sal.title.text.assignedDt'/></th>
        <td>
	        <div class="date_set w100p">
	        <p><input id="_assignDt" name="_assignDt" type="text" value="" placeholder="MM/YYYY" class="j_date2" /></p>
	        </div>
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