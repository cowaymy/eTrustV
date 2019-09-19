<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var ynData = [{"codeId": "1","codeName": "YES"},{"codeId": "0","codeName": "NO"}];

$(document).ready(function() {

	//Application Type
    CommonCombo.make("_appType", "/common/selectCodeList.do", {groupCode : '10'}, '66', {id: "codeId",name:"codeName",isShowChoose: false});
    //orderStatus
    CommonCombo.make('_orderStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 27} , '4', {id: "stusCodeId",name: "codeName", isShowChoose: false});
    //rentalStatus
    CommonCombo.make('_rentalStusType', "/status/selectStatusCategoryCdList.do", {selCategoryId : 26} , 'INV|!|SUS', {id: "code",name: "codeName",isShowChoose: false,isCheckAll : false,type : 'M'});

    doDefCombo(ynData, '' ,'_etrYn', 'S', '');
    doDefCombo(ynData, '' ,'_sensitiveYn', 'S', '');

    $("#_appType").prop("disabled", true);
});

function fn_genReport(){

    var whereSql = '';
    var runNo = 0;

    //Validation

    if($("#_orderStatus option:selected").val() == ""){
    	Common.alert('<spring:message code="sal.alert.msg.selOrdStus" />');
        return;
    }else{
    	whereSql += "AND EXTENT2.STUS_CODE_ID = " + $("#_orderStatus option:selected").val();
    }

    if($("#_rentalStusType").val() == null || $("#_rentalStusType").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.plzSelRentalStusType" />');
        return;
    }else{
        whereSql += " AND  EXTENT7.STUS_CODE_ID IN (";
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

    if($("#_sensitiveYn option:selected").val() != ""){
        whereSql += "AND RCMS.SENSITIVE_FG = " + $("#_sensitiveYn option:selected").val() + " ";
    }

    if($("#_etrYn option:selected").val() != ""){
    	whereSql += "AND RCMS.ETR_FG = " + $("#_etrYn option:selected").val() + " ";
    }

    if(($("#etrStartDt").val() == null || $("#etrStartDt").val() == '') && !($("#etrEndDt").val() == null || $("#etrEndDt").val() == '')){
    	Common.alert('<spring:message code="sal.alert.msg.assignEndDt" />');
        return;
    }
    if($("#etrEndDt").val() == null || $("#etrEndDt").val() == '' && !($("#etrStartDt").val() == null || $("#etrStartDt").val() == '')){
    	Common.alert('<spring:message code="sal.alert.msg.assignStartDt" />');
        return;
    }
    if(($("#etrStartDt").val() != null || $("#etrStartDt").val() != '') &&  ($("#etrEndDt").val() != null || $("#etrEndDt").val() != '')){

        var frArr = $("#etrStartDt").val().split("/");
        var toArr = $("#etrEndDt").val().split("/");
        var assignDtFrom = frArr[1]+"/"+frArr[0]+"/"+frArr[2]; // MM/dd/yyyy
        var assignDtTo = toArr[1]+"/"+toArr[0]+"/"+toArr[2];

        whereSql += " AND (EXTENT1.RC_ITM_CRT_DT BETWEEN TO_DATE('"+assignDtFrom+" 00:00:00', 'MM/dd/YY HH24:MI:SS') AND TO_DATE('"+assignDtTo+" 23:59:59', 'MM/dd/YY HH24:MI:SS'))";
    }

    $("#reportFileName").val('/sales/eTRListingSummaryRaw.rpt');  //Rpt File Name
    $("#viewType").val("EXCEL");  //view Type

    //title
    var date = new Date().getDate();
    if(date.toString().length == 1){
        date = "0" + date;
    }

    var title = "eTRListingSummary_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
    $("#reportDownFileName").val(title); //Download File Name
    $("#V_WHERESQL").val(whereSql);// Procedure Param

    //Make Report
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("etrReport", option);
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.etrSummaryListRaw" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_AddPopclose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.etrSummaryListRaw" /></h3>
</aside><!-- title_line end -->

<form id="etrReport">

<!-- Essential -->
<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
<!-- Params -->
<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />

</form>


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
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
        <th scope="row"><spring:message code="sal.title.text.ordStus" /><span class="must">*</span></th>
        <td>
          <select  id="_orderStatus" name="_orderStatus" class="w100p"></select>
        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.text.rentalStatus" /><span class="must">*</span></th>
            <td><select id="_rentalStusType" name="_rentalStusType" class="multy_select w100p" multiple="multiple"></select></td>
        <th scope="row"><spring:message code='sal.title.text.etrUploadDt'/></th>
	        <td>
	        <div class="date_set w100p"><!-- date_set start -->
	        <p><input id="etrStartDt" name="startDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	        <span>To</span>
	        <p><input id="etrEndDt" name="endDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	        </div>
	        </td>
    </tr>
    <tr>
        <th scope="row"><spring:message code="sal.title.text.sensitive" /></th>
            <td><p><select id="_sensitiveYn" name="_sensitiveYn" class="w100p"></select></p></td>
        <th scope="row"><spring:message code="sal.title.text.etr" /></th>
            <td><p><select id="_etrYn" name="_etrYn" class="w100p"></select></p></td>
    </tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript: fn_genReport()"><spring:message code="sal.btn.genExcel" /></a></p></li>
</ul>

</section>
</div>