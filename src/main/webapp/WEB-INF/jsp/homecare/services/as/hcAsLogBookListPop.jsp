<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 26/06/2019  ONGHC  1.0.0          RE-STRUCTURE JSP
 -->

<script type="text/javaScript">
//Branch : 5743
var branchDs = [];
<c:forEach var="obj" items="${branchList}">
    branchDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}"});
</c:forEach>

  $(document).ready(
    function() {
      $('.multy_select').on("change", function() {
      }).multipleSelect({});

      //doGetCombo('/services/as/report/selectMemberCodeList.do', '', '','CTCode', 'S' ,  '');
      //doGetComboSepa("/common/selectBranchCodeList.do", 5, '-', '', 'branch', 'S', '');
      doDefCombo(branchDs, '', 'branch', 'S', '');   // Home Care Branch : 5743

      $("#branch").change(function() {
                doGetCombo('/homecare/services/as/selectCTByDSCSearch.do', $("#branch").val(), '', 'CTCode', 'S', '');
      }); // INCHARGE CT

    });

  function fn_validation() {
	var startDate = $('#asAppDate').val();
    var endDate = $('#asAppDate2').val();

    if ($("#asAppDate").val() == '' || $("#asAppDate2").val() == '') {
      var text = "<spring:message code='service.title.AppointmentDate' />";
      Common.alert("* <spring:message code='sys.msg.necessary' arguments='"+ text + "' htmlEscape='false'/>");
      return false;
    }

    if (fn_getDateGap(startDate, endDate) > 31) {
        var fName = "Appointment Date";

        Common.alert("<spring:message code='service.msg.asSearchDtRange' arguments='" + fName + " ; <b>" + 31 +"</b>' htmlEscape='false' argumentSeparator=';' />");
        return false;
    }

    return true;
  }

  function fn_openGenerate() {
    var date = new Date();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var runNo1 = 0;
    var runNo2 = 0;
    var asType = "";
    var asStus = "";

    if (date.getDate() < 10) {
      day = "0" + date.getDate();
    }
    if (fn_validation()) {
      var ASAppDate = $("#asAppDate").val() == '' ? "" : $("#asAppDate").val();
      var ASAppDate2 = $("#asAppDate2").val() == '' ? "" : $("#asAppDate2").val();
      var ASCTCode = $("#CTCode").val() == '' ? "" : $("#CTCode option:selected").text();
      var ASBranch = $("#branch").val() == '' ? "" : $("#branch option:selected").text();
      var ASCTGroup = $("#CTGroup").val() == '' ? "" : $("#CTGroup option:selected").text();
      var whereSql = "";

      if ($("#asType :checked").length > 0) {
        $("#asType :checked").each(function(i, mul) {
          if ($(mul).val() != "0") {
            if (runNo1 > 0) {
              asType += ", " + $(mul).val() + " ";
            } else {
              asType += " " + $(mul).val() + " ";
            }
            runNo1 += 1;
          }
        });
      }

      if ($("#asType :checked").val() != '' && $("#asType :checked").val() != null) {
        whereSql += " AND ae.AS_TYPE_ID IN (" + asType + ") ";
      }
      if ($("#asAppDate").val() != '' && $("#asAppDate").val() != null && $("#asAppDate2").val() != '' && $("#asAppDate2").val() != null ) {
        whereSql += " AND ae.AS_APPNT_DT >= TO_DATE('" + $("#asAppDate").val() + "','DD/MM/YYYY') AND ae.AS_APPNT_DT <= TO_DATE('" + $("#asAppDate2").val() + "','DD/MM/YYYY')";
      }
      if ($("#CTCode").val() != '' && $("#CTCode").val() != null) {
        whereSql += " AND mr.MEM_ID = " + $("#CTCode").val() + " ";
      }
      if ($("#branch").val() != '' && $("#branch").val() != null) {
        whereSql += " AND ae.AS_BRNCH_ID = ( SELECT BRNCH_ID FROM SYS0005M WHERE CODE = '" + $("#branch").val() + "' AND STUS_ID = 1 AND TYPE_ID = 5754)";
      }
      if ($("#CTGroup").val() != '' && $("#CTGroup").val() != null) {
        whereSql += " AND ae.AS_MEM_GRP = '" + $("#CTGroup").val() + "' ";
      }

      // HomeCare add
      whereSql += " AND OM.BNDL_ID IS NOT NULL ";

      if ($("#asStatus1 :checked").length > 0) {
          $("#asStatus1 :checked").each(function(i, mul) {
            if ($(mul).val() != "0") {
              if (runNo2 > 0) {
                asStus += ", " + $(mul).val() + " ";
              } else {
                asStus += " " + $(mul).val() + " ";
              }
              runNo2 += 1;
            }
          });
        }

      if ($("#asStatus1 :selected").val() != ''
          && $("#asStatus1 :selected").val() != null) {
        whereSql += " AND ae.AS_STUS_ID IN (" + asStus + ") ";
      }

      $("#reportFormList #reportFileName").val('/homecare/hcASLogBookList.rpt');
      $("#reportFormList #reportDownFileName").val("ASLogBook_" + day + month + date.getFullYear());
      $("#reportFormList #viewType").val("PDF");
      $("#reportFormList #V_SELECTSQL").val();
      $("#reportFormList #V_WHERESQL").val(whereSql);
      $("#reportFormList #V_ORDERBYSQL").val();
      $("#reportFormList #V_FULLSQL").val();
      $("#reportFormList #V_ASAPPDATE").val(ASAppDate);
      $("#reportFormList #V_ASAPPDATE2").val(ASAppDate2);
      $("#reportFormList #V_ASCTCODE").val(ASCTCode);
      $("#reportFormList #V_ASBRANCH").val(ASBranch);
      $("#reportFormList #V_ASCTGROUP").val(ASCTGroup);

      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("reportFormList", option);
    }
  }

  function fn_getDateGap(sdate, edate) {
	    var startArr, endArr;

	    startArr = sdate.split('/');
	    endArr = edate.split('/');

	    var keyStartDate = new Date(startArr[2], startArr[1], startArr[0]);
	    var keyEndDate = new Date(endArr[2], endArr[1], endArr[0]);
	    var gap = (keyEndDate.getTime() - keyStartDate.getTime()) / 1000 / 60 / 60 / 24;

	    return gap;
	  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }
      if (type === 'text' || type === 'password' || type === 'hidden'
          || tag === 'textarea') {
        this.value = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
      } else if (tag === 'select') {
        this.selectedIndex = 0;
      }

    });
  };
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1><spring:message code='service.btn.asLogBook'/></h1>
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
   <form action="#" id="reportFormList">
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
    <input type="hidden" id="V_ASAPPDATE" name="V_ASAPPDATE" />
    <input type="hidden" id="V_ASAPPDATE2" name="V_ASAPPDATE2" />
    <input type="hidden" id="V_ASCTCODE" name="V_ASCTCODE" />
    <input type="hidden" id="V_ASBRANCH" name="V_ASBRANCH" />
    <input type="hidden" id="V_ASCTGROUP" name="V_ASCTGROUP" />
     <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
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
       <th scope="row"><spring:message code='service.grid.ASTyp' /></th>
       <td><select class="multy_select w100p" multiple="multiple" id="asType" name="asType">
        <c:forEach var="list" items="${asLogBookTyp}" varStatus="status">
          <option value="${list.codeId}" selected>${list.codeName}</option>
        </c:forEach>
       </select></td>
       <th scope="row"><spring:message code='service.title.AppointmentDate' /><span class='must'>*</span></th>
        <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="Create start Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="asAppDate" />
         </p>
         <span><spring:message code='svc.hs.reversal.to' /></span>
         <p>
          <input type="text" title="Create end Date"
           placeholder="DD/MM/YYYY" class="j_dateHc" id="asAppDate2" />
         </p>
        </div> <!-- date_set end -->
       </td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='sal.title.text.dscBrnch' /></th>
       <td>
         <select id="branch" name="branch" class="w100p">
          <%-- <option value=""><spring:message code='sal.combo.text.chooseOne' /></option> --%>
         </select>
       </td>
       <th scope="row"><spring:message code='home.lbl.dtCode' /></th>
       <td>
         <select id="CTCode" name="CTCode" class="w100p">
          <%-- <option value=""><spring:message code='sal.combo.text.chooseOne' /></option> --%>
         </select></td>
      </tr>
      <tr>
       <th scope="row"><spring:message code='home.lbl.dTGroup' /></th>
       <td><select id="CTGroup" name="CTGroup" class="w100p">
       <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
        <c:forEach var="list" items="${asLogBookGrp}" varStatus="status">
          <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
       </select></td>
       <th scope="row"><spring:message code='service.text.Status' /></th>
       <td>
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
     <a href="#none" onclick="javascript:fn_openGenerate()"><spring:message code='service.btn.Generate' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:$('#reportFormList').clearForm();"><spring:message code='service.btn.Clear' /></a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->