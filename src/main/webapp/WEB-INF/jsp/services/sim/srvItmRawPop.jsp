<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 27/06/2019  ONGHC  1.0.0          CREATE FOR SERVICE ITEM MANEGEMENT
 06/08/2019  ONGHC  1.0.1          REMOVE DISABLE ATTRIBUTE FOR BRANCH
 09/07/2021  KAHKIT 1.0.2          MAJOR ENHANCEMENT
 -->

<script type="text/javaScript">
  $(document).ready( function() {
    //doGetCombo('/services/sim/getBchTyp.do', '', '${BR_TYP_ID}', 'cboBchTypRaw', 'S', 'fn_onChgBch'); // BRANCH TYPE
    //doGetCombo('/services/sim/getItm.do', '', '', 'cboItmPopRaw', 'S', ''); // ITEM TYPE
    doGetCombo('/services/sim/getBchTyp.do', '', '${BR_TYP_ID}', 'cboBchTypRaw', 'M', 'f_multiCombo'); // BRANCH TYPE
    doGetCombo('/services/sim/getItm.do', '', '', 'cboItmPopRaw', 'M', 'f_multiCombo'); // ITEM TYPE
    doGetCombo('/common/selectCodeList.do', '49', '','cboRegionPopRaw', 'M' , 'f_multiCombo'); //region
    doDefCombo(categoryData, '' ,'cboCatPopRaw', 'M', 'f_multiCombo');

    // SET TRIGGER FUNCTION HERE --
    /* $("#cboBchTypRaw").change(function() {
      doGetCombo('/services/sim/getBch.do', $("#cboBchTypRaw").val(), '', 'cboBchPopRaw', 'M', '');
    }); */
    doGetCombo('/services/sim/getBch.do', '', '', 'cboBchPopRaw', 'M', 'f_multiCombo');

  });

  //Multiple dropdownlist config
  function f_multiCombo() {
    $(function() {
      $('#cboBchTypRaw').change(function() {
        }).multipleSelect({
            selectAll: true,
            width: '80%'
      });
      $('#cboItmPopRaw').change(function() {
        }).multipleSelect({
            selectAll: true,
            width: '80%'
      });
      $('#cboRegionPopRaw').change(function() {
      }).multipleSelect({
          selectAll: true,
          width: '80%'
      });
      $('#cboBchPopRaw').change(function() {
      }).multipleSelect({
          selectAll: true,
          width: '80%'
      });
      $('#cboCatPopRaw').change(function() {
      }).multipleSelect({
          selectAll: true,
          width: '80%'
    });
    });
  }

  function fn_onChgBch() {
    doGetCombo('/services/sim/getBch.do', $("#cboBchTypRaw").val(), '${SESSION_INFO.userBranchId}', 'cboBchPopRaw', 'S', '');

    if($("#cboBchTypRaw option[value='${BR_TYP_ID}']").length == 0) {
      $('#cboBchTypRaw').removeAttr("disabled");
    }
  }

  function fn_openGenerate() {
    var text = "";

    // CLEAR DATA
    $("#srvItmRawForm #TRX_STR_DT").val("");
    $("#srvItmRawForm #TRX_END_DT").val("");
    $("#srvItmRawForm #BR").val("");
    $("#srvItmRawForm #ITM_CDE").val("");

    // SET DATA
    $("#srvItmRawForm #TRX_STR_DT").val($("#trxStrDt").val());
    $("#srvItmRawForm #TRX_END_DT").val($("#trxEndDt").val());
    $("#srvItmRawForm #BR").val($("#cboBchPopRaw").val());
    $("#srvItmRawForm #ITM_CDE").val($("#cboItmPopRaw").val());

    var brCde = "";
    var itmCde = "";
    let regionCde = "";
    let brTyp = "";
    let category = "";

    let runNo = 0;

    if ($("#trxStrDt").val() == "" || $("#trxStrDt").val() == null) {
      text = "<spring:message code='service.grid.trxDttFrm'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }
    if ($("#trxEndDt").val() == "" || $("#trxEndDt").val() == null) {
      text = "<spring:message code='service.grid.trxDttTo'/>";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/>");
      return;
    }
    if ($("#cboBchPopRaw").val() != "" || $("#cboBchPopRaw").val() != null) {
      //brCde = $("#cboBchPopRaw").val();
        $('#cboBchPopRaw :selected').each(function(i, mul){
            if(runNo > 0){
            	brCde += ","+$(mul).val()+"";
            }else{
            	brCde += ""+$(mul).val()+"";
            }
            runNo += 1;
        });

        runNo = 0;
    }
    if ($("#cboItmPopRaw").val() != "" || $("#cboItmPopRaw").val() != null) {
      //itmCde = $("#cboItmPopRaw").val();
        $('#cboItmPopRaw :selected').each(function(i, mul){
            if(runNo > 0){
            	itmCde += ","+$(mul).val()+"";
            }else{
            	itmCde += ""+$(mul).val()+"";
            }
            runNo += 1;
        });

        runNo = 0;
    }
    if ($("#cboBchTypRaw").val() != "" || $("#cboBchTypRaw").val() != null) {
        $('#cboBchTypRaw :selected').each(function(i, mul){
            if(runNo > 0){
            	brTyp += ","+$(mul).val()+"";
            }else{
            	brTyp += ""+$(mul).val()+"";
            }
            runNo += 1;
        });

        runNo = 0;
    }
    if ($("#cboRegionPopRaw").val() != "" || $("#cboRegionPopRaw").val() != null) {
    	$('#cboRegionPopRaw :selected').each(function(i, mul){
            if(runNo > 0){
            	regionCde += ","+$(mul).val()+"";
            }else{
            	regionCde += ""+$(mul).val()+"";
            }
            runNo += 1;
        });

        runNo = 0;
    }
    if ($("#cboCatPopRaw").val() != "" || $("#cboCatPopRaw").val() != null) {
    	$('#cboCatPopRaw :selected').each(function(i, mul){
            if(runNo > 0){
                category += ","+$(mul).val()+"";
            }else{
                category += ""+$(mul).val()+"";
            }
            runNo += 1;
        });

        runNo = 0;
    }

    var whereSql = "WHERE 1=1 ";
    var keyInDateFrom = $("#trxStrDt").val().substring(6, 10) + "-"
                      + $("#trxStrDt").val().substring(3, 5) + "-"
                      + $("#trxStrDt").val().substring(0, 2);
    var keyInDateTo = $("#trxEndDt").val().substring(6, 10) + "-"
                    + $("#trxEndDt").val().substring(3, 5) + "-"
                    + $("#trxEndDt").val().substring(0, 2);

    if (keyInDateFrom !=  "" && keyInDateTo != "") {
      whereSql += " AND (TO_CHAR(B.TRX_DT,'YYYY-MM-DD')) >= '" + keyInDateFrom + "' AND (TO_CHAR(B.TRX_DT,'YYYY-MM-DD')) <= '" + keyInDateTo + "' ";
    }

    if (brCde !=  "") {
       whereSql += " AND A.BR_NO IN (" + brCde + ") ";
    }
    if (itmCde !=  "") {
       whereSql += " AND A.ITM_CDE IN (" + itmCde + ") ";
    }
    if (regionCde !=  "") {
        whereSql += " AND D.REGN_ID IN (" + regionCde + ") ";
     }
    if (brTyp !=  "") {
        whereSql += " AND D.TYPE_ID IN (" + brTyp + ") ";
     }
    if (category !=  "") {
        whereSql += " AND C.STK_TYPE_ID IN (" + category + ") ";
     }

    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    //var rptTyp = $("input[name='fileTypOpt']:checked").val();
    // Comment rptTyp due to enhancement not longer need
    var rptTyp = "EXCEL2";
    var rptNm = "/services/SrvItmRawData.rpt";

    if (rptTyp == "EXCEL2") {
      rptTyp = "EXCEL";
      rptNm = "/services/SrvItmRawDataNoGrp.rpt"
    } else if (rptTyp == "PDF2") {
      rptTyp = "PDF";
      rptNm = "/services/SrvItmRawDataNoGrp.rpt"
    }

    $("#srvItmRawForm #V_SELECTSQL").val(" ");
    $("#srvItmRawForm #V_ORDERBYSQL").val(" ");
    $("#srvItmRawForm #V_FULLSQL").val(" ");
    $("#srvItmRawForm #V_WHERESQL").val(whereSql);
    $("#srvItmRawForm #V_TRXSTRDT").val(keyInDateFrom);
    $("#srvItmRawForm #V_TRXENDDT").val(keyInDateTo);
    $("#srvItmRawForm #reportFileName").val(rptNm);
    $("#srvItmRawForm #viewType").val(rptTyp);
    $("#srvItmRawForm #reportDownFileName").val("ServiceItemRaw_" + day + month + date.getFullYear());

    var option = {
      isProcedure : true,
    };
    console.log($("#srvItmRawForm #V_WHERESQL").val());
    Common.report("srvItmRawForm", option);
  }

</script>

<div id="popup_wrap" class="popup_wrap">

 <section id="content">

  <form id="srvItmRawForm" method="post">
   <div style="display: none">
    <input type="text" name="TRX_STR_DT" id="TRX_STR_DT" />
    <input type="text" name="TRX_END_DT" id="TRX_END_DT" />
    <input type="text" name="BR" id="BR" />
    <input type="text" name="ITM_CDE" id="ITM_CDE" />
    <!-- REPORT PURPOSE -->
    <input type="text" name="V_SELECTSQL" id="V_SELECTSQL" />
    <input type="text" name="V_WHERESQL" id="V_WHERESQL" />
    <input type="text" name="V_ORDERBYSQL" id="V_ORDERBYSQL" />
    <input type="text" name="V_FULLSQL" id="V_FULLSQL" />
    <input type="text" name="V_TRXSTRDT" id="V_TRXSTRDT" />
    <input type="text" name="V_TRXENDDT" id="V_TRXENDDT" />
    <input type="text" name="reportFileName" id="reportFileName" />
    <input type="text" name="viewType" id="viewType" />
    <input type="text" name="reportDownFileName" id="reportDownFileName" />
   </div>
  </form>

  <header class="pop_header">
   <h1><spring:message code='service.title.srvItmMgmt'/> - <spring:message code='service.title.rawDt'/></h1>
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
          <th scope="row"><spring:message code='service.grid.trxDt'/><span class="must"> *</span></th>
          <td>
            <div class="date_set w100p">
              <p>
                <input type="text" title="<spring:message code='service.grid.trxDt'/>" placeholder="DD/MM/YYYY" class="j_date" id="trxStrDt" name="trxStrDt" />
              </p>
              <span>To</span>
              <p>
                <input type="text" title="<spring:message code='service.grid.trxDt'/>" placeholder="DD/MM/YYYY" class="j_date" id="trxEndDt" name="trxEndDt" />
              </p>
            </div>
          </td>
         </tr>
         <th scope="row"><spring:message code='sal.title.text.region'/></th>
            <td>
                <select id="cboRegionPopRaw" name="cboRegionPopRaw" class="multy_select w100p" multiple="multiple">
                </select>
            </td>
         <tr>
           <th scope="row"><spring:message code='service.grid.brchTyp'/></th>
           <td>
            <select id="cboBchTypRaw" name="cboBchTypRaw"  class="multy_select w100p" multiple="multiple"/>
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.grid.bch'/></th>
           <td>
            <select id="cboBchPopRaw" name="cboBchPopRaw" class="w100p" class="multy_select w100p" multiple="multiple">
              <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
            </select>
           </td>
         </tr>
         <tr>
         <th scope="row"><spring:message code='sal.title.text.category'/></th>
           <td>
            <select id="cboCatPopRaw" name="cboCatPopRaw" class="w100p" />
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='sal.title.item'/></th>
           <td>
             <select id="cboItmPopRaw" name="cboItmPopRaw" class="w100p" class="multy_select w100p" multiple="multiple"/>
           </td>
         </tr>
         <%-- <tr>
           <th scope="row"><spring:message code='service.btn.fileFmt'/></th>
           <td>
             <input type="radio" value="PDF" name="fileTypOpt"> <label for="fileTypOpt">PDF(Grouping)</label>
             <input type="radio" value="EXCEL" name="fileTypOpt"> <label for="fileTypOpt">EXCEL(Grouping)</label>
             <input type="radio" value="PDF2" name="fileTypOpt" checked> <label for="fileTypOpt">PDF</label>
             <input type="radio" value="EXCEL2" name="fileTypOpt" checked> <label for="fileTypOpt">EXCEL</label>
           </td>
         </tr> --%>
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