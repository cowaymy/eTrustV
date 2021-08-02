<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 16/07/2021  KAHKIT 1.0.0          CREATE SERVICE ITEM FORECAST REPORT
 -->

<script type="text/javaScript">

var forecastMonthData = [
                         {"codeId": "2","codeName": "1 month"}
                         ,{"codeId": "3","codeName": "2 months"}
                         ,{"codeId": "4","codeName": "3 months"}
                         ,{"codeId": "5","codeName": "4 months"}
                        ];

$(document).ready( function() {
    doDefCombo(categoryData, '' ,'cboCatStkRaw', 'M', 'f_multiCombo');
    doDefCombo(forecastMonthData, '' ,'cboForecastMonth', 'S', '');
    doGetCombo('/services/sim/getBch.do', '', '', 'cboBchPopRaw', 'M', 'f_multiCombo');
    doGetCombo('/services/sim/getItm.do', '', '', 'cboItmPopRaw', 'M', 'f_multiCombo'); // ITEM TYPE
    doGetCombo('/services/sim/getBchTyp.do', '', '', 'cboBchTypRaw', 'M', 'f_multiCombo'); // BRANCH TYPE
    doGetCombo('/common/selectCodeList.do', '49', '','cboRegionPopRaw', 'M' , 'f_multiCombo'); //region
  });

  function f_multiCombo() {
      $(function() {
          $('#cboCatStkRaw').change(function() {
          }).multipleSelect({
              selectAll : true, // 전체선택
              width : '80%'
          }).multipleSelect("checkAll");

          $('#cboBchPopRaw').change(function() {
          }).multipleSelect({
              selectAll: true,
              width: '80%'
          }).multipleSelect("checkAll");

          $('#cboItmPopRaw').change(function() {
          }).multipleSelect({
              selectAll: true,
              width: '80%'
          }).multipleSelect("checkAll");

          $('#cboBchTypRaw').change(function() {
          }).multipleSelect({
              selectAll: true,
              width: '80%'
          }).multipleSelect("checkAll");

          $('#cboRegionPopRaw').change(function() {
          }).multipleSelect({
              selectAll: true,
              width: '80%'
          }).multipleSelect("checkAll");;
      });

  }

  function fn_openGenerate() {

	var rptTyp = "EXCEL";
	var rptNm = "/services/SrvForecastRawData.rpt";

	var brCde = "";
    var brName = "";

    var forecastMonth = 0;

    var runNo = 0;

    var whereSql = "WHERE 1=1 ";

    if ($("#cboForecastMonth").val() != "") {
    	forecastMonth = $("#cboForecastMonth").val();
    }else{
    	Common.alert("Please select forecast month");
    	return;
    }

    if ($("#cboBchPopRaw").val() != null) {
    	whereSql += " AND  M.BR_NO IN (";
        $('#cboBchPopRaw :selected').each(function(i, mul){
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

    if ($("#cboCatStkRaw").val() != null) {
        whereSql += " AND  I.STK_TYPE_ID IN (";
        $('#cboCatStkRaw :selected').each(function(i, mul){
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

    if ($("#cboItmPopRaw").val() != null) {
        whereSql += " AND  M.ITM_CDE IN (";
        $('#cboItmPopRaw :selected').each(function(i, mul){
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

    if ($("#cboBchTypRaw").val() != null) {
    	whereSql += " AND  B.TYPE_ID IN (";
    	$('#cboBchTypRaw :selected').each(function(i, mul){
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

    if ($("#cboRegionPopRaw").val() != null) {
    	whereSql += " AND  B.REGN_ID IN (";
        $('#cboRegionPopRaw :selected').each(function(i, mul){
            if(runNo > 0){
            	whereSql += ","+$(mul).val()+"";
            }else{
            	whereSql += ""+$(mul).val()+"";
            }
            runNo += 1;
        });
        whereSql += ") ";

        runNo = 0;
    }

    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    $("#srvItmForecastForm #V_WHERESQL").val(whereSql);
    $("#srvItmForecastForm #V_FRCSTMTH").val(forecastMonth);
    $("#srvItmForecastForm #reportFileName").val(rptNm);
    $("#srvItmForecastForm #viewType").val(rptTyp);
    $("#srvItmForecastForm #reportDownFileName").val("ServiceItem_StockReport_" + day + month + date.getFullYear());

    var option = {
      isProcedure : true,
    };
console.log($("#srvItmForecastForm").serializeJSON());
    Common.report("srvItmForecastForm", option);
  }

</script>

<div id="popup_wrap" class="popup_wrap">

 <section id="content">

  <form id="srvItmForecastForm" method="post">
   <div style="display: none">
    <!-- REPORT PURPOSE -->
    <input type="text" name="V_WHERESQL" id="V_WHERESQL" />
    <input type="text" name="V_FRCSTMTH" id="V_FRCSTMTH" />
    <input type="text" name="reportFileName" id="reportFileName" />
    <input type="text" name="viewType" id="viewType" />
    <input type="text" name="reportDownFileName" id="reportDownFileName" />
   </div>
  </form>

  <header class="pop_header">
   <h1><spring:message code='service.title.srvItmMgmt'/> - <spring:message code='service.title.srvItmForecastRaw'/> </h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a href="#"><spring:message code='sys.btn.close'/></a>
     </p></li>
   </ul>
  </header>

  <section class="pop_body">
    <section class="search_table">
      <form action="#" method="post" id="srvItmEntryForm" onsubmit="return false;">
        <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
         <tr>
           <th scope="row"><spring:message code='service.title.forecastMonth'/><span class="must"> *</span></th>
           <td>
            <select id="cboForecastMonth" name="cboForecastMonth" class="w100p"/>
           </td>
         </tr>
         <th scope="row"><spring:message code='sal.title.text.region'/></th>
            <td>
                <select id="cboRegionPopRaw" name="cboRegionPopRaw" class="multy_select w100p" multiple="multiple">
                </select>
            </td>
         <tr>
         <tr>
           <th scope="row"><spring:message code='service.grid.brchTyp'/></th>
           <td>
            <select id="cboBchTypRaw" name="cboBchTypRaw"  class="multy_select w100p" multiple="multiple"/>
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.grid.bch'/></th>
           <td>
            <select id="cboBchPopRaw" name="cboBchPopRaw" class="w100p">
            </select>
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='sal.title.text.category'/></th>
           <td>
             <select id="cboCatStkRaw" name="cboCatStkRaw" class="w100p" /></select>
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='sal.title.item'/></th>
           <td>
             <select id="cboItmPopRaw" name="cboItmPopRaw" class="w100p"/>
           </td>
         </tr>
      </tbody>
     </table>
      <p class="btn_blue2 big" align="center">
       <a href="#" onclick="fn_openGenerate()"><spring:message code='pay.btn.generate'/></a>
     </p>
     <!-- table end -->
    </form>
   </section>
  </section>
  <!-- content end -->
 </section>
 <!-- content end -->
</div>
<!-- popup_wrap end -->
<script>
</script>