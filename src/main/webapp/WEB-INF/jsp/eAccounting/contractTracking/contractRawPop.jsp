<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript" language="javascript">
var vendorType =  [{"codeId": "965","codeName": "Entity"},{"codeId": "964","codeName": "Individual"}];
var contractType = [];
<c:forEach var="obj" items="${contractType}">
contractType.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
</c:forEach>
$(document).ready(function(){
	doDefCombo(vendorType, '', 'rVendorType', 'M', 'fn_multiCombo');
	console.log('contractType' + contractType);
	doDefCombo(contractType, '', 'rListContractType', 'M', 'fn_multiCombo');

	//fn_setToDay();
});

function fn_multiCombo(){
    $('#rVendorType').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    //$('#rVendorType').multipleSelect("checkAll");
    $('#rListContractType').change(function() {
        //console.log($(this).val());
    }).multipleSelect({
        selectAll: true, // 전체선택
        width: '100%'
    });
    //$('#rVendorType').multipleSelect("checkAll");
}

/* function fn_setToDay() {
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
} */

function fn_validation(){

     if($("#rCreatedStartDt").val() == "" && $("#rCreatedEndDt").val() == "" &&  $("#rCommStartDt").val() == "" && $("#rCommEndDt").val() == "" )
     {
         Common.alert("* Please select date");
         return false;
     }

     if(($("#rCreatedStartDt").val() != "" && $("#rCreatedEndDt").val() == "") || ($("#rCreatedStartDt").val() == "" && $("#rCreatedEndDt").val() != ""))
     {
    	 Common.alert("* Please select date");
         return false;
     }

     if(($("#rCommStartDt").val() != "" && $("#rCommEndDt").val() == "") || ($("#rCommStartDt").val() == "" && $("#rCommEndDt").val() != ""))
     {
         Common.alert("* Please select date");
         return false;
     }

    return true;
}
function fn_genReport(){
    if(fn_validation()){
        $("#V_WHERESQL").val("");
        var whereSQL = "";

        if(!($("#rCreatedStartDt").val() == '' || $("#rCreatedStartDt").val() == null) && !($("#rCreatedEndDt").val() == '' || $("#rCreatedEndDt").val() == null)){
        	whereSQL +=  " AND to_date(TO_CHAR(MAIN.CRT_DT,'DD/MM/YYYY'),'DD/MM/YYYY') between TO_DATE('" + $("#rCreatedStartDt").val() + "','DD/MM/YYYY') and  TO_DATE('" + $("#rCreatedEndDt").val() + "','DD/MM/YYYY')";
        }

        if(!($("#rCommStartDt").val() == '' || $("#rCommStartDt").val() == null) && !($("#rCommEndDt").val() == '' || $("#rCommEndDt").val() == null)){
            whereSQL +=  " AND to_date(TO_CHAR(MAIN.CONT_COMM_DT,'DD/MM/YYYY'),'DD/MM/YYYY') between TO_DATE('" + $("#rCommStartDt").val() + "','DD/MM/YYYY') and  TO_DATE('" + $("#rCommEndDt").val() + "','DD/MM/YYYY')";
        }

        if(!($("#rDeptName").val() == '' || $("#rDeptName").val() == null)){
            whereSQL += " AND UPPER(DET.DEPT_NAME) LIKE UPPER('" + $("#rDeptName").val() + "') || '%'";
        }

        if(!($("#rPicName").val() == '' || $("#rPicName").val() == null)){
            whereSQL += " AND UPPER(DET.PIC_NAME) LIKE UPPER('" + $("#rPicName").val() + "') || '%'";
        }

        if($('#rVendorType :selected').length > 0){
            whereSQL += " and DET.VEN_TYPE in (";
            var runNo = 0;

            $('#rVendorType :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += $(mul).val();
                }else{
                    whereSQL += "," + $(mul).val();
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if(!($("#rVendorPicName").val() == '' || $("#rVendorPicName").val() == null)){
            whereSQL += " AND UPPER(DET.VEN_PIC_NAME) LIKE UPPER('" + $("#rVendorPicName").val() + "') || '%'";
        }

        if($('#rContractType :selected').length > 0){
            whereSQL += " and MAIN.CONT_TYPE in (";
            var runNo = 0;

            $('#rContractType :selected').each(function(i, mul){
                if(runNo == 0){
                    whereSQL += $(mul).val();
                }else{
                    whereSQL += "," + $(mul).val();
                }

                runNo += 1;
            });
            whereSQL += ") ";
        }

        if(!($("#rNoCycle").val() == '' || $("#rNoCycle").val() == null)){
            whereSQL += " AND MAIN.RENEWAL_CYCLE = '" + $("#rNoCycle").val() + "'";
        }

        console.log("whereSQL : " + whereSQL);
        $("#V_WHERESQL").val(whereSQL);

        var date = new Date().getDate();
        if(date.toString().length == 1){
            date = "0" + date;
        }
        var month = new Date().getMonth()+1;
        if(month.toString().length == 1){
        	month = "0" + month;
        }
        $("#reportDownFileName").val("contractTrackRawData"+date+month+new Date().getFullYear());
        $("#reportFileName").val("/e-accounting/contractTrackRawData.rpt");
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
<h1>Contract tracking Raw</h1>
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
    <th scope="row">Date Created</th>
    <td>
	    <div class="date_set w100p">
	        <p><input id="rCreatedStartDt" name="rCreatedStartDt" type="text" value="" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	        <span>To</span>
	        <p><input id="rCreatedEndDt" name="rCreatedEndDt" type="text" value="" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	    </div>
    </td>
</tr>
<tr>
    <th scope="row">Contract Commencement Date</th>
    <td>
	    <div class="date_set w100p">
	        <p><input id="rCommStartDt" name="rCommStartDt" type="text" value="" title="Commencement start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	        <span>To</span>
	        <p><input id="rCommEndDt" name="rCommEndDt" type="text" value="" title="Commencement end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	    </div>
    </td>
</tr>
<tr>
    <th scope="row">Contract Owner Department</th>
    <td>
       <input type="text" id="rDeptName" name="rDeptName" class="w100p"/>
    </td>
</tr>
<tr>
    <th scope="row">Contract Owner Name</th>
    <td>
       <input type="text" id="rPicName" name="rPicName" class="w100p"/>
    </td>
</tr>
<tr>
    <th scope="row">Type of Vendor</th>
    <td>
	    <select class="multy_select" multiple="multiple" id="rVendorType" name="rVendorType">
		    <option value="1">Entity</option>
		    <option value="2">Individual</option>
	    </select>
    </td>
</tr>
<tr>
    <th scope="row">Vendor Department</th>
    <td>
       <input type="text" id="rVendorPicName" name="rVendorPicName" class="w100p"/>
    </td>
</tr>
<tr>
    <th scope="row">Contract Type</th>
    <td>
        <select id="rListContractType" name="rContractType" class="multy_select w100p" multiple="multiple"></select>
   </td>
</tr>
<tr>
    <th scope="row">No. of Renewal Cycle</th>
    <td>
        <input type="text" id="rNoCycle" name="rNoCycle" class="w100p"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_genReport()">Generate</a></p></li>
</ul>

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
