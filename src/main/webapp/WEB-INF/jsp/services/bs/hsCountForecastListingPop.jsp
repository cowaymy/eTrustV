<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
$(document).ready(function(){
	 $('.multy_select').on("change", function() {
		    //console.log($(this).val());
		}).multipleSelect({});

	 //doGetCombo('/common/selectCodeList.do', '10', '','appliType', 'S' , '');
	 //doGetComboSepa("/common/selectBranchCodeList.do",5 , '-',''   , 'branch' , 'S', '');

	 /**doGetCombo('/services/bs/selectBranch_id', 42, '','brnch', 'S');

	 $("#brnch").change(function (){
	 doGetCombo('/services/bs/selectCTMByDSC_id',  $("#brnch").val(), '','memCode', 'S' ,  '');
	        });
	    **/
	    if ($("#userType").val() == "2" && $("#memberLevel").val() == "4") {
	        //doGetCombo('/services/bs/getCdUpMemList.do', $(this).val(), '', 'CMGroup', 'S','fn_cmdBranchCode');
	        doGetCombo("/services/bs/report/selectCodyBranch.do",'',''   , 'branchCmb' , 'S', 'fn_setDefaultBranch');
	        doGetCombo("/services/bs/report/getCdUpMem.do",'',''   , 'CMGroup' , 'S', 'fn_setDefaultCM');
	        doGetCombo("/services/bs/report/selectCodyList2.do",'',''   , 'codyList' , 'S', 'fn_setDefaultCody');
	        $("#clearbtn").hide();


	      }
	    else{
	    doGetCombo("/services/bs/report/reportBranchCodeList.do",'' ,''   , 'branchCmb' , 'S', '');
	    doGetCombo("/services/bs/report/safetyLevelQtyList.do",'' ,''   , 'safetyLv' , 'S', '');
	    }


	    $("#branchCmb").change(function(){
	        doGetCombo("/services/bs/report/selectCMGroupList.do",$("#branchCmb").val() ,''   , 'CMGroup' , 'S', '');

	        if($("#branchCmb").val() != '0'){
	            $("#safetyLv").prop("disabled" , true);
	        } else {
	            $("#safetyLv").prop("disabled" , false);
	        }
	    });

	    $("#CMGroup").change(function(){
	            doGetCombo("/services/bs/report/selectCodyList.do",$("#CMGroup").val() ,''   , 'codyList' , 'S', '');
	    });

	    if ($("#userType").val() == "2" && $("#memberLevel").val() == "4") {
	        //doGetCombo('/services/bs/getCdUpMemList.do', $(this).val(), '', 'CMGroup', 'S','fn_cmdBranchCode');
	        doGetCombo("/services/bs/report/selectCodyBranch.do",'',''   , 'branchCmb' , 'S', 'fn_setDefaultBranch');
	        doGetCombo("/services/bs/report/getCdUpMem.do",'',''   , 'CMGroup' , 'S', 'fn_setDefaultCM');
	        doGetCombo("/services/bs/report/selectCodyList2.do",'',''   , 'codyList' , 'S', 'fn_setDefaultCody');
	        $("#clearbtn").hide();


	      }

});

function fn_validation(){
	 if($("#branchCmb option:selected").length < 1)
	    {
		    Common.alert("<spring:message code='sys.common.alert.validation' arguments='branch' htmlEscape='false'/>");
	        return false;
	    }

	 if($("#CMGroup").text() == 'choose one')
     {
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='CM Group' htmlEscape='false'/>");
         return false;
     }
	if($("#forecastMonth").val() == ''){
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='the forecast month' htmlEscape='false'/>");
         return false;
    }


	return true;
}
function fn_openReport(){
	if(fn_validation()){
		var date = new Date();
	    var installStatus = $("#instalStatus").val();
	    var SelectSql = "";
	    var whereSeq = "";
	    var orderBySql = "";
	    var FullSql = "";
	    var month = date.getMonth()+1;
	    var day =date.getDate();
        if(date.getDate() < 10){
            day = "0"+date.getDate();
        }
	    var tmpforecastMonth = $("#forecastMonth").val();
	    var forecastMonth =tmpforecastMonth.substring(3,7)+"-"+tmpforecastMonth.substring(0,2)+"-01";
	    var branchid = 0;
	    branchid = Number($("#branchCmb option:selected").val());
        var cmid = 0;
        cmid = Number($("#CMGroup option:selected").val());
        var codyId = $("#codyList").val();

        /* Added for HS Count Forecast Listing Enhancement. Hui Ding 2020-07-28 */
        if (cmid == '' && codyId == null || cmid == '' && codyId == '') {
            cmid = 0;
            console.log("BSCountForecast_Branch");
            $("#reportForm #reportFileName").val('/services/BSCountForecastByBranch.rpt');
            $("#reportForm #reportDownFileName").val("BSCountForecastByBranch_"+day+month+date.getFullYear());
            $("#reportForm #V_FORECASTDATE").val(forecastDt);
            $("#reportForm #V_BRANCHID").val(branchId);
            $("#reportForm #V_CMID").val(cmid);

        }
        else if (cmid > 0 && codyId == 0) {
            console.log("BSCountForecast_CMGroup");
            $("#reportForm #reportFileName").val('/services/BSCountForecastByCMGroup.rpt');
            $("#reportForm #reportDownFileName").val("BSCountForecastByCMGroup_"+day+month+date.getFullYear());
            $("#reportForm #V_FORECASTDATE").val(forecastDt);
            $("#reportForm #V_BRANCHID").val(branchId);
            $("#reportForm #V_CMID").val(cmid);
        }
        else if (cmid > 0 && codyId > 0) {
            console.log("BSCountForecast_Cody");
            $("#reportForm #reportFileName").val('/services/BSCountForecast_Cody.rpt');
            $("#reportForm #reportDownFileName").val("BSCountForecastByCody_"+day+month+date.getFullYear());
            $("#reportForm #V_FORECASTDATE").val(forecastDt);
            $("#reportForm #V_BRANCHID").val(branchId);
            $("#reportForm #V_MEMBERID").val(codyId);
            $("#reportForm #V_MEMBERLVL").val(4);
        }

        if ($("#exportType").val() == "PDF") {
            $("#hsFilterForm #viewType").val("PDF");
            var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };

            Common.report("reportForm", option);

        }
        else {
            $("#reportForm #viewType").val("EXCEL");
            var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };

            Common.report("reportForm", option);
        }

	    /* $("#reportForm #viewType").val("PDF");

	    if(cmid==0){
        	$("#reportForm #reportFileName").val('/services/BSCountForecastByBranch.rpt');
        	$("#reportForm #reportDownFileName").val("BSCountForecastByBranch_"+day+month+date.getFullYear());
	    }else{
        	$("#reportForm #reportFileName").val('/services/BSCountForecastByCMGroup.rpt');
        	$("#reportForm #reportDownFileName").val("BSCountForecastByCMGroup_"+day+month+date.getFullYear());
	    }

	     $("#installationNoteForm #V_WHERESQL").val(whereSeq);
	     $("#installationNoteForm #V_INSTALLSTATUS").val(installStatus);
	     $("#installationNoteForm #V_ORDERBYSQL").val(orderBySql);
	     $("#installationNoteForm #V_SELECTSQL").val(SelectSql);
	     $("#installationNoteForm #V_FULLSQL").val(FullSql);

	     //$("#installationNoteForm #reportFileName").val('/services/InstallationNote_WithOldOrderNo.rpt');

	     $("#reportForm #V_FORECASTDATE").val(forecastMonth);
	     $("#reportForm #V_BRANCHID").val(branchid);
	     $("#reportForm #V_CMID").val(cmid);


	     //$("#reportForm #reportDownFileName").val("InstallationNote_"+date.getDate()+month+date.getFullYear());



	   //report 호출
	     var option = {
	             isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
	     };

	     Common.report("reportForm", option);
	     */
	}

}

function fn_clear(){

	$("#branchCmb").val('');
	$("#CMGroup").val('');
	$("#codyList").val('');
	$("#forecastMonth").val('');
}

 /* Added for HS Count Forecast Listing Enhancement. Hui Ding 2020-07-28 */
 function fn_setDefaultCM() {
        $('#CMGroup option:eq(1)').attr('selected', 'selected');
        $("#CMGroup").prop("disabled" , true);
        //$('#CMGroup').attr('class', 'w100p readonly ');

}

function fn_setDefaultCody() {
    $('#codyList option:eq(1)').attr('selected', 'selected');
    $("#codyList").prop("disabled" , true);
    //$('#codyList').attr('class', 'w100p readonly ');

}

function fn_setDefaultBranch() {
    $('#branchCmb option:eq(1)').attr('selected', 'selected');
    $("#branchCmb").prop("disabled" , true);
    $("#safetyLv").prop("disabled" , true);
    //$('#branchCmb').attr('class', 'w100p readonly ');

}

</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>HS Management - HS Count Forecast Listing</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="reportForm">
<input type="hidden" id="V_FORECASTDATE" name="V_FORECASTDATE" />
<input type="hidden" id="V_BRANCHID" name="V_BRANCHID" />
<input type="hidden" id="V_CMID" name="V_CMID" />
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
<!-- Enhancement - Added new criteria for searching HS Count Forecast Listing Report. Hui Ding 2020-07-28 -->
<tr>
    <th scope="row">Export Type</th>
    <td>
         <select id="exportType" name="exportType">
                <option value="PDF">PDF</option>
                <option value="EXCEL">Excel</option>
            </select>
    </td>
</tr>
<tr>
    <th scope="row">Forecast Month</th>
    <td><input type="text" title="Forecast Month" id="forecastMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <select class="w100p" id = "branchCmb">

    </select>
    </td>
</tr>
<tr>
    <th scope="row">Safety Level</th>
    <td>
    <select id="safetyLv" name="safetyLv">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">CM Group</th>
    <td>
    <select class="w100p" id = "CMGroup">

    </select>
    </td>
</tr>
<tr>
    <th scope="row">Cody</th>
    <td>
    <select id="codyList" name="codyList">
    </select>
    </td>
</tr>
<tr>
    <td colspan="2" class="col_all"><span class="red_text fl_right">Forecast is up to 4 months.</span></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_openReport()">Generate</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
