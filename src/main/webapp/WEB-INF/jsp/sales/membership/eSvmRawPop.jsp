<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
var memTypeData = [{"codeId": "1","codeName": "HP"},{"codeId": "2","codeName": "Cody"},{"codeId": "4","codeName": "Staff"},{"codeId": "7","codeName": "HT"}];
var stusIdDate =  [{"codeId": "1","codeName": "Active"},{"codeId": "5","codeName": "Approve"},{"codeId": "6","codeName": "Rejected"}];
var typeIdDate =  [{"codeId": "965","codeName": "Company"},{"codeId": "964","codeName": "Individual"}];
var stusProgressIdDate =  [{"codeId": "1","codeName": "Active"},{"codeId": "104","codeName": "Processing"},{"codeId": "21","codeName": "Failed"},{"codeId": "4","codeName": "Complete"}];

$(document).ready(function(){

	doDefCombo(memTypeData, '', 'vmemType', 'S', '');
	doDefCombo(stusIdDate, '', 'vstusId', 'M', 'fn_multiCombo');
	doDefCombo(typeIdDate, '', 'vtypeId', 'M', 'fn_multiCombo');
	doDefCombo(stusProgressIdDate, '', 'vstusProgressId', 'M', 'fn_multiCombo');
	doGetComboSepa('/common/selectBranchCodeList.do',  '1', ' - ', '', 'vbrnchId', 'M', 'fn_multiCombo'); //Branch Code

	fn_setToDay();

});

function fn_multiCombo(){
    $('#vstusId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#vstusId').multipleSelect("checkAll");
    $('#vbrnchId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#vbrnchId').multipleSelect("checkAll");
    $('#vtypeId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#vtypeId').multipleSelect("checkAll");
    $('#vstusProgressId').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    $('#vstusProgressId').multipleSelect("checkAll");
}

function fn_setToDay() {
    var today = new Date();

    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();

    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm
    }

    today = dd + "/" + mm + "/" + yyyy;
    $("#vreqstEndDt").val(today);

    var today_s = "01/" + mm + "/" + yyyy;
    $("#vreqstStartDt").val(today_s);
}

function fn_validation(){
     if($("#vbrnchId option:selected").length < 1)
     {
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='branch' htmlEscape='false'/>");
         return false;
     }

     if($("#vreqstStartDt").val() == "")
     {
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='Request Start Date' htmlEscape='false'/>");
         return false;
     }

     if($("#vreqstEndDt").val() == "")
     {
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='Request End Date' htmlEscape='false'/>");
         return false;
     }

    return true;
}
function fn_openReport(){
    if(fn_validation()){
        $("#V_WHERESQL").val("");
        var whereSQL = "";

        if($('#vstusId :selected').length > 0){
            whereSQL += " and ESVM.STUS in (";
            var runNo = 0;

            $('#vstusId :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += $(mul).val();
                }else{
                    whereSQL += "," + $(mul).val();
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if(!($("#vorgCode").val() == '' || $("#vorgCode").val() == null)){
            whereSQL += " AND T9.ORG_CODE = '" + $("#vorgCode").val() + "'";
        }

        if(!($("#vgrpCode").val() == '' || $("#vgrpCode").val() == null)){
            whereSQL += " AND T9.GRP_CODE = '" + $("#vgrpCode").val() + "'";
        }

        if(!($("#vdeptCode").val() == '' || $("#vdeptCode").val() == null)){
            whereSQL += " AND T9.DEPT_CODE = '" + $("#vdeptCode").val() + "'";
        }

        if(!($("#vmemType").val() == '' || $("#vmemType").val() == null)){
            whereSQL += " AND CRTUSR.USER_TYPE_ID= '" + $("#vmemType").val() + "'";
        }

        if($('#vtypeId :selected').length > 0){
            whereSQL += " and CUST.TYPE_ID in (";
            var runNo = 0;

            $('#vtypeId :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += $(mul).val();
                }else{
                    whereSQL += "," + $(mul).val();
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if($('#vbrnchId :selected').length > 0){
            whereSQL += " and CRTUSR.user_brnch_id in (";
            var runNo = 0;

            $('#vbrnchId :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += $(mul).val();
                }else{
                    whereSQL += "," + $(mul).val();
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if(!($("#vreqstStartDt").val() == null || $("#vreqstStartDt").val().length == 0) && !($("#vreqstEndDt").val() == null || $("#vreqstEndDt").val().length == 0)){
        	whereSQL += "AND ESVM.CRT_DT BETWEEN TO_DATE('"+$("#vreqstStartDt").val()+"', 'dd/mm/yyyy')  AND TO_DATE('"+$("#vreqstEndDt").val()+"', 'dd/mm/yyyy')";
        }

        if($('#vstusProgressId :selected').length > 0){
            whereSQL += " and NVL(ESVM.STUS_PROGRESS,1) in (";
            var runNo = 0;

            $('#vstusProgressId :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += $(mul).val();
                }else{
                    whereSQL += "," + $(mul).val();
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        console.log("whereSQL : " + whereSQL);
        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }
        $("#reportDownFileName").val("eSvmRawData"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#reportFileName").val("/membership/eSvmRawData.rpt");
        $("#reportForm #viewType").val("EXCEL");
        var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportForm", option);

    }

}
</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>eSVM Raw</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<!--reportFileName,  viewType 모든 레포트 필수값 -->
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row"><spring:message code="sal.title.text.preSalSts" /></th>
       <td>
            <%-- <select class="multy_select w100p" multiple="multiple" name="vstusId">
                <option value="1" selected="selected"><spring:message code="sal.btn.active" /></option>
                <option value="5" selected="selected"><spring:message code="sal.combo.text.approv" /></option>
                <option value="6" selected="selected"><spring:message code="sal.combo.text.rej" /></option>
            </select> --%>
            <select id="vstusId" name="vstusId" class="multy_select w100p" multiple="multiple"></select>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
        <td>
        <input type="text" title="vorgCode" id="vorgCode" name="vorgCode" placeholder="Org Code" class="w100p" />
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
        <td>
           <select id="vmemType" name="vmemType" class="w100p" ></select>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.postBrnch" /></th>
        <td>
            <select id="vbrnchId" name="vbrnchId" class="multy_select w100p" multiple="multiple"></select>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
           <%-- <select class="multy_select w100p" multiple="multiple" name="vtypeId">
                <option value="965"><spring:message code="sal.text.company" /></option>
                <option value="964"><spring:message code="sal.text.individual" /></option>
            </select> --%>
            <select id="vtypeId" name="vtypeId" class="multy_select w100p" multiple="multiple"></select>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td>
        <input type="text" title="vgrpCode" id="vgrpCode" name="vgrpCode"  placeholder="Grp Code" class="w100p"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
        <td>
        <input type="text" title="vdeptCode" id="vdeptCode" name="vdeptCode"  placeholder="Dept Code" class="w100p"/>
        </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.preSalDt" /></th>
    <td>
       <div class="date_set w100p"><!-- date_set start -->
           <p><input id="vreqstStartDt" name="vreqstStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
           <span>To</span>
           <p><input id="vreqstEndDt" name="vreqstEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
       </div><!-- date_set end -->
    </td>
</tr>
<tr>
        <th scope="row"><spring:message code="sal.title.text.prgssStus" /></th>
       <td>
            <%-- <select class="multy_select w100p" multiple="multiple" name="vstusProgressId">
                <option value="" selected="selected">None</option>
                <option value="1" selected="selected"><spring:message code="sal.btn.active" /></option>
                <option value="104" selected="selected"><spring:message code="sal.combo.text.processing" /></option>
                <option value="21" selected="selected"><spring:message code="sal.combo.text.failed" /></option>
                <option value="4" selected="selected"><spring:message code="sal.combo.text.complete" /></option>
            </select> --%>
            <select id="vstusProgressId" name="vstusProgressId" class="multy_select w100p" multiple="multiple"></select>
        </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()">Generate</a></p></li>
</ul>

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
