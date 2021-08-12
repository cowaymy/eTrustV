<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/07/2021  KAHKIT 1.0.0          CREATE SERVICE ITEM STOCK REPORT
 -->

<script type="text/javaScript">
  $(document).ready( function() {
    doGetCombo('/services/sim/getBchTyp.do', '', '${BR_TYP_ID}', 'cboBchTypRaw', 'S', 'fn_onChgBch'); // BRANCH TYPE
    doDefCombo(categoryData, '' ,'cboCatStkRaw', 'M', 'category_multiCombo');

    // SET TRIGGER FUNCTION HERE --
    $("#cboBchTypRaw").change(function() {
      doGetCombo('/services/sim/getBch.do', $("#cboBchTypRaw").val(), '', 'cboBchPopRaw', 'S', '');
    });

  });

  function fn_onChgBch() {
    doGetCombo('/services/sim/getBch.do', $("#cboBchTypRaw").val(), '${SESSION_INFO.userBranchId}', 'cboBchPopRaw', 'S', '');

    if($("#cboBchTypRaw option[value='${BR_TYP_ID}']").length == 0) {
      $('#cboBchTypRaw').removeAttr("disabled");
    }
  }

  function category_multiCombo() {
      $(function() {
          $('#cboCatStkRaw').change(function() {
          }).multipleSelect({
              selectAll : true, // 전체선택
              width : '80%'
          }).multipleSelect("checkAll");
      });
  }

  function fn_openGenerate() {
    var brCde = "";
    var brName = "";
    var brType = "";

    var runNo = 0;

    if ($("#cboBchPopRaw option:selected").val() != "") {
      brCde = $("#cboBchPopRaw").val();
      brName = $("#cboBchPopRaw option:selected").text();
    }
    console.log($("#cboBchTypRaw option:selected").val())
    if ($("#cboBchTypRaw option:selected").val() != "") {
      brType = $("#cboBchTypRaw option:selected").text();
    }

    var whereSql = "WHERE 1=1 ";

    if (brCde !=  "") {
       whereSql += " AND M.BR_NO = '" + brCde + "' ";
    }
    if ($("#cboCatStkRaw").val() != "" || $("#cboCatStkRaw").val() != null) {
        whereSql += " AND  I.STK_CTGRY_ID IN (";
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

    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    var rptTyp = $("input[name='fileTypOpt']:checked").val();
    var rptNm = (rptTyp == "PDF") ? "/services/SrvStkRawData_PDF.rpt" : "/services/SrvStkRawData_EXCEL.rpt";

    $("#srvStkRawForm #V_WHERESQL").val(whereSql);
    $("#srvStkRawForm #V_BRANCHTYPE").val(brType);
    $("#srvStkRawForm #V_BRANCH").val(brName);
    $("#srvStkRawForm #reportFileName").val(rptNm);
    $("#srvStkRawForm #viewType").val(rptTyp);
    $("#srvStkRawForm #reportDownFileName").val("ServiceItem_StockReport_" + day + month + date.getFullYear());

    var option = {
      isProcedure : true,
    };

    Common.report("srvStkRawForm", option);
  }

</script>

<div id="popup_wrap" class="popup_wrap">

 <section id="content">

  <form id="srvStkRawForm" method="post">
   <div style="display: none">
    <!-- REPORT PURPOSE -->
    <input type="text" name="V_WHERESQL" id="V_WHERESQL" />
    <input type="text" name="V_BRANCHTYPE" id="V_BRANCHTYPE" />
    <input type="text" name="V_BRANCH" id="V_BRANCH" />
    <input type="text" name="reportFileName" id="reportFileName" />
    <input type="text" name="viewType" id="viewType" />
    <input type="text" name="reportDownFileName" id="reportDownFileName" />
   </div>
  </form>

  <header class="pop_header">
   <h1><spring:message code='service.title.srvItmMgmt'/> - <spring:message code='service.title.srvItmStkRaw'/> </h1>
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
           <th scope="row"><spring:message code='service.grid.brchTyp'/></th>
           <td>
            <select id="cboBchTypRaw" name="cboBchTypRaw" class="w100p" disabled />
           </td>
         </tr>
         <tr>
           <th scope="row"><spring:message code='service.grid.bch'/></th>
           <td>
            <select id="cboBchPopRaw" name="cboBchPopRaw" class="w100p">
              <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
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
           <th scope="row"><spring:message code='service.btn.fileFmt'/></th>
           <td>
             <input type="radio" value="PDF" name="fileTypOpt" checked> <label for="fileTypOpt">PDF</label>
             <input type="radio" value="EXCEL" name="fileTypOpt" checked> <label for="fileTypOpt">EXCEL</label>
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