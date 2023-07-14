<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 15/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP and Add Order Number Search Criteria
 26/04/2019  ONGHC  1.0.1          ADD RECALL STATUS
 -->
<script type="text/javaScript">
  $(document).ready(
    function() {
      $('.multy_select').on("change", function() {
    }).multipleSelect({});

    //doGetCombo('/services/as/report/selectMemberCodeList.do', '', '', 'CTCode', 'S', '');
    //doGetComboSepa("/common/selectBranchCodeList.do", 5758, '-', '', 'branch', 'S', '');
    doGetComboSepa('/homecare/selectHomecareAndDscBranchList.do',  '', ' - ', '',   'branch', 'M', 'fn_multiCombo'); //Branch Code
  });

  function fn_validation() {
    if ($("#asType").val() == '') {
      var text = "<spring:message code='service.grid.ASTyp' />";
      Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#ordNumFr").val() != '' || $("#ordNumTo").val() != '') {
      if ($("#ordNumFr").val() == '' || $("#ordNumTo").val() == '') {
        var text = "<spring:message code='service.placeHolder.ordNo' />";
        Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
        return false;
      }
    }

    if ($("#asNumFr").val() != '' || $("#asNumTo").val() != '') {
      if ($("#asNumFr").val() == '' || $("#asNumTo").val() == '') {
        var text = "<spring:message code='service.grid.ASNo' />";
        Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
        return false;
      }
    }

    if ($("#reqDtFr").val() != '' || $("#reqDtTo").val() != '') {
      if ($("#reqDtFr").val() == '' || $("#reqDtTo").val() == '') {
        var text = "<spring:message code='service.grid.ReqstDt' />";
        Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#asResultNoFr").val() != '' || $("#asResultNoTo").val() != '') {
      if ($("#asResultNoFr").val() == '' || $("#asResultNoTo").val() == '') {
        var text = "<spring:message code='service.grid.ResultNo' />";
        Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
        return false;
      }
    }
    if ($("#appDtFr").val() != '' || $("#appDtTo2").val() != '') {
      if ($("#appDtFr").val() == '' || $("#appDtTo2").val() == '') {
        var text = "<spring:message code='service.grid.AppntDt' />";
        Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
        return false;
      }
    }
    return true;
  }

  function fn_openGenerate(type) {
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();

    var runNo1 = 0;
    var runNo2 = 0;
    var asStus = "";

    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }

    if (fn_validation()) {
      var whereSql = "";
      var asNoFrom = "";
      var asNoTo = "";

      if ($("#asStatus1 :checked").length > 0) {
        $("#asStatus1 :checked").each(function(i, mul) {
          if ($(mul).val() != "0") {
            if (runNo1 > 0) {
              asStus += ", " + $(mul).val() + " ";
            } else {
              asStus += " " + $(mul).val() + " ";
            }
            runNo1 += 1;
          }
        });
      }

      var ordNoFrom = "";
      var ordNoTo = "";
      if ($("#ordNumFr").val() != '' && $("#ordNumTo").val() != ''
          && $("#ordNumFr").val() != null
          && $("#ordNumTo").val() != null) {
        ordNoFrom = $("#ordNumFr").val();
        ordNoTo = $("#ordNumTo").val();
        whereSql += "AND (O.SALES_ORD_NO >= '" + ordNoFrom
            + "' AND O.SALES_ORD_NO <= '" + ordNoTo + "') ";
      }

      if ($("#asNumFr").val() != '' && $("#asNumTo").val() != ''
          && $("#asNumFr").val() != null
          && $("#asNumTo").val() != null) {
        asNoFrom = $("#asNumFr").val();
        asNoTo = $("#asNumTo").val();
        whereSql += "AND (ae.AS_No >= '" + asNoFrom
            + "' AND ae.AS_No <= '" + asNoTo + "') ";
      }

      var asRnoFrom = "";
      var asRnoTo = "";
      if ($("#asResultNoFr").val() != ''
          && $("#asResultNoTo").val() != ''
          && $("#asResultNoFr").val() != null
          && $("#asResultNoTo").val() != null) {
        asRnoFrom = $("#asResultNoFr").val();
        asRnoTo = $("#asResultNoTo").val();
        whereSql += "and (am.AS_RESULT_NO >= '" + asRnoFrom
            + "' AND am.AS_RESULT_NO <= '" + asRnoTo + "') ";
      }

      var ctCode = "";
      if ($("#CTCode :checked").length > 0) {
          $("#CTCode :checked").each(function(i, mul) {
            if ($(mul).val() != "0") {
              if (runNo2 > 0) {
            	  ctCode += ", " + $(mul).val() + " ";
              } else {
            	  ctCode += " " + $(mul).val() + " ";
              }
              runNo2 += 1;
            }
          });
          whereSql += "AND mr.Mem_ID IN ( " + ctCode + ") ";
        }

      var ctCodeText = "";
      if ($("#CTCode").val() != '' && $("#CTCode").val() != null) {
          var runNo3 = 0;
          $("#CTCode  option:selected").each(function(i, mul){
          if(runNo3 == 0){
        	  ctCodeText += $(mul).text();
          }else{
        	  ctCodeText += "," + $(mul).text();
          }

          runNo3 += 1;
          });
      }

      var dscCode = "";
      if ($("#branch").val() != '' && $("#branch").val() != null) {
        dscCode = $("#branch  option:selected").text();
        whereSql += "AND ae.AS_BRNCH_ID IN ( " + $("#branch").val() + ") ";
      }

      var dscCodeText = "";
      if ($("#branch").val() != '' && $("#branch").val() != null) {
          var runNo4 = 0;
          $("#branch  option:selected").each(function(i, mul){
          if(runNo4 == 0){
              dscCodeText += $(mul).text();
          }else{
              dscCodeText += "," + $(mul).text();
          }

          runNo4 += 1;
          });
      }

      var appointDateFrom = "";
      var appointDateTo = "";
      if ($("#appDtFr").val() != '' && $("#appDtTo2").val() != ''
          && $("#appDtFr").val() != null
          && $("#appDtTo2").val() != null) {
        appointDateFrom = $("#appDtFr").val();
        appointDateTo = $("#appDtTo2").val();
        whereSql += "AND ae.AS_APPNT_DT >= to_date('"
            + $("#appDtFr").val()
            + "', 'DD/MM/YYYY') AND ae.AS_APPNT_DT <= to_date('"
            + $("#appDtTo2").val() + "', 'DD/MM/YYYY')  ";
      }

      var requestDateFrom = "";
      var requestDateTo = "";
      if ($("#reqDtFr").val() != '' && $("#reqDtTo").val() != ''
          && $("#reqDtFr").val() != null
          && $("#reqDtTo").val() != null) {
        requestDateFrom = $("#reqDtFr").val();
        requestDateTo = $("#reqDtTo").val();
        whereSql += "AND ae.AS_REQST_DT >= to_date('"
            + $("#reqDtFr").val()
            + "', 'DD/MM/YYYY') AND ae.AS_REQST_DT <= to_date('"
            + $("#reqDtTo").val() + "', 'DD/MM/YYYY') ";
      }


      if ($("#asStatus1 :selected").val() != ''
          && $("#asStatus1 :selected").val() != null) {
        whereSql += " AND ae.AS_STUS_ID IN (" + asStus + ") ";
      }

      var asType = "";
      asType = $("#asTypeReport :selected").val();
      if (asType != '' && asType != null) {

        whereSql += "AND ae.AS_TYPE_ID IN (" + asType + ") " + " ";
      } else {
        var text = "<spring:message code='service.grid.ASTyp' />";
        Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
        return false;
      }

      var asGroup = "";
      if ($("#CTGroup").val() != '' && $("#CTGroup").val() != null) {
        asGroup = $("#CTGroup  option:selected").text();
        whereSql += "AND ae.AS_MEM_GRP = '" + $("#CTGroup").val()
            + "' ";
      }
      var asSort = "";

      // homecare add
      whereSql += " AND O.BNDL_ID IS NOT NULL ";

      // SP_CR_AS_SUM_LIST
      $("#reportFormAS #reportFileName").val('/homecare/hcASSummaryList.rpt');
      $("#reportFormAS #reportDownFileName").val("ASSummaryList_" + day + month + date.getFullYear());
      if(type == 'PDF'){
          $("#reportFormAS #viewType").val("PDF");
      }
      else {
          $("#reportFormAS #viewType").val("EXCEL");
      }
      $("#reportFormAS #V_SELECTSQL").val();
      $("#reportFormAS #V_WHERESQL").val(whereSql);
      $("#reportFormAS #V_GROUPBYSQL").val();
      $("#reportFormAS #V_FULLSQL").val();
      $("#reportFormAS #V_ASNOFORM").val(asNoFrom);
      $("#reportFormAS #V_ASNOTO").val(asNoTo);
      $("#reportFormAS #V_ASRNOFROM").val(asRnoFrom);
      $("#reportFormAS #V_ASRNOTO").val(asRnoTo);
      $("#reportFormAS #V_CTCODE").val(ctCodeText);
      $("#reportFormAS #V_DSCCODE").val(dscCodeText);
      $("#reportFormAS #V_REQUESTDATEFROM").val(requestDateFrom);
      $("#reportFormAS #V_REQUESTDATETO").val(requestDateTo);
      $("#reportFormAS #V_APPOINDATEFROM").val(appointDateFrom);
      $("#reportFormAS #V_APPOINDATETO").val(appointDateTo);
      $("#reportFormAS #V_ASTYPEID").val(asType);
      $("#reportFormAS #V_ASSTATUS").val(asStus);
      $("#reportFormAS #V_ASGROUP").val(asGroup);
      $("#reportFormAS #V_ASTEMPSORT").val(asSort);
      $("#reportFormAS #V_ORDNUMTO").val(ordNoTo);
      $("#reportFormAS #V_ORDNUMFR").val(ordNoFrom);

      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("reportFormAS", option);

    }
  }

  function fn_changeCT() {
    var branchCd = $("#branch").val();
    doGetCombo('/services/as/report/selectMemberCodeList2.do', branchCd, '', 'CTCode', 'S', '');
  }

  function fn_multiCombo() {
	    $(function() {
	        $('#branch').change(function() {
	            //console.log('1');

	            if ($('#branch').val() != null && $('#branch').val() != "" ){
	            	var brnchCdparam = "";
	                var branchCd = $("#branch").val();
	                for (var i = 0 ; i < branchCd.length ; i++){
                        if (brnchCdparam == ""){
                        	brnchCdparam = branchCd[i];
                        }else{
                        	brnchCdparam = brnchCdparam +"∈"+branchCd[i];
                        }
                    }
	                var param = {groupCode:brnchCdparam}
	                doGetComboObj('/services/as/report/selectMemberCodeList2.do', param, '', 'CTCode', 'M', 'fn_multiComboType');
	                console.log($('#branch').val());
	              }
	        })
	         .multipleSelect({
	            selectAll : true
	        });
	    });
  }

  function fn_multiComboType() {
	    $(function() {
	        $('#CTCode').change(function() {
	        	console.log($('#CTCode').val());
	        }).multipleSelect({
	            selectAll : true
	        });
	    });
	}
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>AS Summary Listing</h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#none"><spring:message code='sys.btn.close' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" id="reportFormAS" method="post">
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" /> <input
     type="hidden" id="V_WHERESQL" name="V_WHERESQL" /> <input
     type="hidden" id="V_GROUPBYSQL" name="V_GROUPBYSQL" /> <input
     type="hidden" id="V_FULLSQL" name="V_FULLSQL" /> <input
     type="hidden" id="V_ASNOFORM" name="V_ASNOFORM" /> <input
     type="hidden" id="V_ASNOTO" name="V_ASNOTO" /> <input
     type="hidden" id="V_ASRNOFROM" name="V_ASRNOFROM" /> <input
     type="hidden" id="V_ASRNOTO" name="V_ASRNOTO" /> <input
     type="hidden" id="V_CTCODE" name="V_CTCODE" /> <input
     type="hidden" id="V_DSCCODE" name="V_DSCCODE" /> <input
     type="hidden" id="V_REQUESTDATEFROM" name="V_REQUESTDATEFROM" /> <input
     type="hidden" id="V_REQUESTDATETO" name="V_REQUESTDATETO" /> <input
     type="hidden" id="V_APPOINDATEFROM" name="V_APPOINDATEFROM" /> <input
     type="hidden" id="V_APPOINDATETO" name="V_APPOINDATETO" /> <input
     type="hidden" id="V_ASTYPEID" name="V_ASTYPEID" /> <input
     type="hidden" id="V_ASSTATUS" name="V_ASSTATUS" /> <input
     type="hidden" id="V_ASGROUP" name="V_ASGROUP" /> <input
     type="hidden" id="V_ORDNUMTO" name="V_ORDNUMTO" /> <input
     type="hidden" id="V_ORDNUMFR" name="V_ORDNUMFR" /> <input
     type="hidden" id="V_ASTEMPSORT" name="V_ASTEMPSORT" />
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 150px" />
      <col style="width: *" />
      <col style="width: 150px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
      <tr>
       <th scope="row"><spring:message code='service.grid.ASTyp' /><span class="must">*</span></th>
       <td><select class="multy_select w100p" multiple="multiple" id="asTypeReport">
         <c:forEach var="list" items="${asSumTyp}" varStatus="status">
           <option value="${list.codeId}" selected>${list.codeName}</option>
         </c:forEach>
       </select></td>
       <th scope="row"><spring:message code='service.grid.SalesOrder' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="" placeholder="<spring:message code='svc.hs.reversal.from' />" class="w100p" id="ordNumFr" />
         </p>
         <span><spring:message code='svc.hs.reversal.to' /></span>
         <p>
          <input type="text" title="" placeholder="<spring:message code='svc.hs.reversal.to' />" class="w100p" id="ordNumTo" />
         </p>
        </div> <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.grid.ASNo' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="" placeholder="<spring:message code='svc.hs.reversal.from' />" class="w100p" id="asNumFr" />
         </p>
         <span><spring:message code='svc.hs.reversal.to' /></span>
         <p>
          <input type="text" title="" placeholder="<spring:message code='svc.hs.reversal.to' />" class="w100p" id="asNumTo" />
         </p>
        </div> <!-- date_set end -->
       </td>
       <th scope="row"><spring:message code='service.grid.ResultNo' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="" placeholder="<spring:message code='svc.hs.reversal.from' />" class="w100p"
           id="asResultNoFr" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="" placeholder="<spring:message code='svc.hs.reversal.to' />" class="w100p"
           id="asResultNoTo" />
         </p>
        </div> <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.grid.ReqstDt' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="reqDtFr" />
         </p>
         <span><spring:message code='svc.hs.reversal.to' /></span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="reqDtTo" />
         </p>
        </div> <!-- date_set end -->
       </td>
       <th scope="row"><spring:message code='service.title.AppointmentDate' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="appDtFr" />
         </p>
         <span><spring:message code='svc.hs.reversal.to' /></span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="appDtTo2" />
         </p>
        </div> <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row">HDC Code</th>
       <td><select class="multy_select w100p" multiple="multiple" id="branch">
         <c:forEach var="list" items="${branch}" varStatus="status">
           <option value="${list.codeId}" selected>${list.codeName}</option>
         </c:forEach>
       </select></td>
        <th scope="row"><spring:message code='home.lbl.dtCode' /></th>
       <td>
       <select class="multy_select w100p" multiple="multiple" id="CTCode">
<%--         <c:forEach var="list" items="${CTCode}" varStatus="status">
          <option value="${list.codeId}" selected>${list.codeId}</option>
       </c:forEach> --%>
 </select></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='service.title.CTGroup' /></th>
       <td><select id="CTGroup" class="w100p">
        <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
        <c:forEach var="list" items="${asSumGrp}" varStatus="status">
          <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
       </select></td>
       <th scope="row"><spring:message code='service.text.Status' /></th>
       <td>
        <!-- Edit by KV change to edit button-->
        <select class="multy_select w100p" multiple="multiple" id="asStatus1" name="asStatus1">
         <c:forEach var="list" items="${asSumStat}" varStatus="status">
           <option value="${list.codeId}" selected>${list.codeName}</option>
         </c:forEach>
       </select>
       </td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
     <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:fn_openGenerate('EXCEL')"><spring:message code='sys.btn.excel' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:fn_openGenerate('PDF')"><spring:message code='service.btn.Generate' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:$('#reportFormAS').clearForm();"><spring:message code='service.btn.Clear' /></a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->