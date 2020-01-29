<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 09/04/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 14/10/2019  ONGHC  1.0.1          Amend Layout
 15/10/2019  ONGHC  1.0.2          Amend branch Condition
 11/12/2019  ONGHC  1.0.3          To Fix CT Listing without ' symbol
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

      doGetCombo('/common/selectCodeList.do', '10', '', 'appliType', 'M', 'fn_multiCombo');
      doDefCombo(branchDs, '', 'branch', 'S', '');   // Home Care Branch : 5743

      $("#branch").change(function() {
    	    doGetCombo('/homecare/services/as/selectCTByDSCSearch.do', $("#branch").val(), '', 'CTCode', 'M', 'fn_multiCombo');
        });
    });

  function fn_multiCombo() {
    $('#CTCode').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });

    $('#appliType').change(function() {
    }).multipleSelect({
      selectAll : false, // 전체선택
      width : '100%'
    }).multipleSelect("checkAll"); ;
  }

  function fn_validation() {
    var msg = "";
    var text = "";

    // INSTALLATION TYPE
    if ($("#instalType option:selected").length < 1) {
      text = "<spring:message code='service.title.InstallationType' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
    }
    // INSTALL DATE FROM
    if ($("#instalDtFrom").val() == '') {
      text = "<spring:message code='service.title.InstallDate' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
    } else if ($("#instalDtTo").val() == '') {  // INSTALL DATE TO
      text = "<spring:message code='service.title.InstallDate' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
    }
    // INSTALL STATUS
    if ($("#instalStatus").val() == '') {
      text = "<spring:message code='service.title.InstallStatus' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
    }
    // DSC BRANCH
    if ($("#branch").val() == '') {
      text = "<spring:message code='home.lbl.hdcBranch' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
    }
    // SORT BY
    if ($("#sortType").val() == '') {
      text = "<spring:message code='service.title.SortBy' />";
      msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
    }

    if (msg != '') {
      Common.alert(msg);
      return false;
    }

    msg = "";
    text = "";

    /*if ($("#orderNoFrom").val() != '' || $("#orderNoTo").val() != '') {
      if ($("#orderNoFrom").val() == '' || $("#orderNoTo").val() == '') {
        msg += "* <spring:message code='sys.common.alert.validation' arguments='Order Number (From & To)' htmlEscape='false'/> ";
      }
    }*/

    /*if ($("#instalNoFrom").val() != '' || $("#instalNoTo").val() != '') {
      if ($("#instalNoFrom").val() == '' || $("#instalNoTo").val() == '') {
        msg += "* <spring:message code='sys.common.alert.validation' arguments='Installation Number (From & To)' htmlEscape='false'/> ";
      }
    }*/

    if ($("#instalDtFrom").val() != '' || $("#instalDtTo").val() != '') {
      if ($("#instalDtFrom").val() == '' || $("#instalDtTo").val() == '') {
        text = "<spring:message code='service.title.InstallDate' />";
        msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
      }
    }

    /*if ($("#CTCodeFrom").val() != '' || $("#CTCodeTo").val() != '') {
      if ($("#CTCodeFrom").val() == '' || $("#CTCodeTo").val() == '') {
        msg += "* <spring:message code='sys.common.alert.validation' arguments='CT code (From & To)' htmlEscape='false'/>";
      }
    }*/

    if (msg != '') {
      Common.alert(msg);
      return false;
    }

    return true;
  }

  function fn_openReport() {
    if (fn_validation()) {
      var date = new Date();
      var installStatus = $("#instalStatus").val();
      var SelectSql = "";
      var whereSeq = "";
      var whereSeq2 = "";
      var orderBySql = "";
      var FullSql = "";
      var month = date.getMonth() + 1;
      var day = date.getDate();

      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      if ($("#instalStatus").val() != '' && $("#instalStatus").val() != null) {
        whereSeq += "AND B.STUS_CODE_ID IN (" + $("#instalStatus").val() + ") ";
      }

      if ($("#orderNoPop").val() != '' && $("#orderNoPop").val() != null) {
        whereSeq += "AND A.SALES_ORD_NO = '" + $("#orderNoPop").val() + "' ";
      }

      if ($("#instalDtFrom").val() != '' && $("#instalDtTo").val() != '' && $("#instalDtFrom").val() != null && $("#instalDtTo").val() != null) {
        whereSeq += "AND (B.INSTALL_DT >= TO_DATE('" + $("#instalDtFrom").val() + "' , 'DD/MM/YYYY') AND B.INSTALL_DT <= TO_DATE('" + $("#instalDtTo").val() + "', 'DD/MM/YYYY')) ";
      }

      if ($("#appliType").val() != '' && $("#appliType").val() != null) {
        whereSeq += "AND A.APP_TYPE_ID IN (" + $("#appliType").val() + ") ";
      }

      if ($("#instalNo").val() != '' && $("#instalNo").val() != null) {
        whereSeq += "AND B.INSTALL_ENTRY_NO = '" + $("#instalNo").val() + "' ";
      }

      //if ($("#CTCode").val() != '' && $("#CTCode").val() != null) {
        //whereSeq2 += "AND CTMEM.MEM_CODE IN (" + $("#CTCode").val() + ") ";
      //}

      if ($("#sBndlNo").val() != '' && $("#sBndlNo").val() != null) {
        whereSeq += "AND HMC.BNDL_NO = '" + $("#sBndlNo").val() + "' ";
      }

      // HomeCare add
      whereSeq += " AND A.BNDL_ID IS NOT NULL ";

      var ctCodeLst = "";
      var ctCode = $("#CTCode").val();
      if ($("#CTCode").val() != '' && $("#CTCode").val() != null) {
        for (var a = 0; a < ctCode.length; a++) {
          if (a == 0) {
            ctCodeLst += "'" + ctCode[a] + "'"
          } else {
            ctCodeLst += ", '" + ctCode[a] + "'"
          }
        }
        whereSeq2 += "AND CTMEM.MEM_CODE IN (" + ctCodeLst + ") ";
      }

      if ($("#instalType").val() != '' && $("#instalType").val() != null) {
        whereSeq2 += "AND CE.TYPE_ID IN (" + $("#instalType").val() + ") ";
      }

      if ($("#branch").val() != '' && $("#branch").val() != null) {
        whereSeq2 += "AND INSTALL.BRNCH_ID = (SELECT BRNCH_ID FROM SYS0005M WHERE CODE = '" + $("#branch").val() + "' AND STUS_ID = 1 AND TYPE_ID = 5754)";
      }

      if ($("#sortType").val() == "1") {
    	  orderBySql = "ORDER BY MAIN.INSTALL_ENTRY_ID ";
      } else if($("#sortType").val() == "2") {
    	  orderBySql = "ORDER BY CTMEM.MEM_CODE ";
      } else {
    	  orderBySql = "ORDER BY MAIN.BNDL_NO ";
      }

      console.log(whereSeq);
      console.log(whereSeq2);
      console.log(orderBySql);

      $("#installationNoteForm #V_WHERESQL").val(whereSeq);
      $("#installationNoteForm #V_WHERESQL2").val(whereSeq2);
      $("#installationNoteForm #V_INSTALLSTATUS").val(installStatus);
      $("#installationNoteForm #V_ORDERBYSQL").val(orderBySql);
      $("#installationNoteForm #V_SELECTSQL").val(SelectSql);
      $("#installationNoteForm #V_FULLSQL").val(FullSql);
      $("#installationNoteForm #reportFileName").val('/homecare/hcInstallationNote_WithOldOrderNo.rpt');
      $("#installationNoteForm #viewType").val("PDF");
      $("#installationNoteForm #reportDownFileName").val("InstallationNote_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true,
      };

      Common.report("installationNoteForm", option);
    }
  }

  function fn_clear() {
    $("#instalStatus").val('');
    $("#orderNoPop").val('');
    $("#instalDtFrom").val('');
    $("#instalDtTo").val('');
    $("#appliType").val('');
    $("#branch").val('');
    $("#instalNo").val('');
    $("#CTCode").val('');
    $("#instalType").val('');
    $("#sortType").val('3');
    $("#V_WHERESQL").val('');
    $("#V_WHERESQL2").val('');
    $("#V_INSTALLSTATUS").val('');
    $("#V_ORDERBYSQL").val('');
    $("#V_SELECTSQL").val('');
    $("#V_FULLSQL").val('');
    $("#reportFileName").val('');
    $("#viewType").val('');

    doGetCombo('/homecare/services/as/selectCTByDSCSearch.do', '-', '', 'CTCode', 'M', 'fn_multiCombo');
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   <spring:message code='service.title.InstallationNote' />
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#none"><spring:message code='expense.CLOSE' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
     <col style="width: 150px" />
     <col style="width: *" />
     <col style="width: 160px" />
     <col style="width: *" />
    </colgroup>
    <tbody>
     <tr>
      <th scope="row"><spring:message code='service.title.InstallationType' /><span name="m1" id="m1" class="must">*</span></th>
      <td>
       <select class="multy_select w100p" multiple="multiple" id="instalType" name="instalType">
       <c:forEach var="list" items="${instTypeList}" varStatus="status">
         <option value="${list.codeId}" selected>${list.codeName}</option>
        </c:forEach>
       </select>
      </td>
      <th scope="row"><spring:message code='service.title.OrderNumber' /></th>
      <td>

       <!-- <div class="date_set">
        <p>
         <input type="text" title="" placeholder="From" class="w100p"
          id="orderNoFrom" name="orderNoFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="" placeholder="To" class="w100p"
          id="orderNoTo" name="orderNoTo" />
        </p>
       </div> -->

       <input type="text" title="" placeholder="<spring:message code='service.title.OrderNumber' />" class="w100p" id="orderNoPop" name="orderNoPop" />
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.ApplicationType' /></th>
      <td>
       <select id="appliType" name="appType" class="multy_select w100p"></select>
      </td>
      <th scope="row"><spring:message code='service.title.InstallationNo' /></th>
      <td>

       <!-- <div class="date_set">
        <p>
         <input type="text" title="" placeholder="From" class="w100p"
          id="instalNoFrom" name="instalNoFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="" placeholder="To" class="w100p"
          id="instalNoTo" name="instalNoTo" />
        </p>
       </div> -->

       <input type="text" title="" placeholder="<spring:message code='service.title.InstallationNo' />" class="w100p" id="instalNo" name="instalNo" />
      </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.InstallDate' /><span name="m2" id="m2" class="must">*</span></th>
      <td>
       <div class="date_set">
        <p>
         <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="instalDtFrom" name="instalDtFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="instalDtTo" name="instalDtTo" />
        </p>
       </div>
      </td>
      <th scope="row"><spring:message code='service.title.InstallStatus' /> <span name="m3" id="m3" class="must">*</span></th>
      <td><select id="instalStatus" name="instalStatus" class="multy_select w100p">
        <c:forEach var="list" items="${installStatus }" varStatus="status">
         <c:choose>
          <c:when test="${list.codeId=='1'}">
            <option value="${list.codeId}" selected>${list.codeName}</option>
          </c:when>
          <c:otherwise>
            <option value="${list.codeId}">${list.codeName}</option>
          </c:otherwise>
         </c:choose>
        </c:forEach>
      </select></td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='home.lbl.hdcBranch' /> <span name="m4" id="m4" class="must">*</span></th>
      <td>
       <select id="branch" name="branch" class="w100p"></select>
      </td>

      <!-- <th scope="row"><spring:message code='service.title.CTCode' /></th>
      <td>
       <div class="date_set">
        <p>
         <input type="text" title="" placeholder="From" class="w100p"
          id="CTCodeFrom" name="CTCodeFrom" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="" placeholder="To" class="w100p"
          id="CTCodeTo" name="CTCodeTo" />
        </p>
       </div>
      </td> -->

      <th scope="row"><spring:message code='home.lbl.dtCode' /></th>
       <td>
        <select id="CTCode" name="CTCode" class="multy_select w100p" multiple="multiple">
        </select>
       </td>
     </tr>
     <tr>
      <th scope="row"><spring:message code='service.title.SortBy' /> <span name="m5" id="m5" class="must">*</span></th>
      <td>
        <select id="sortType" name="sortType">
	        <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
	        <option value="1">Installation Number</option>
	        <option value="2">DT Code</option>
            <option value="3" selected>Bundle No</option>
        </select>
      </td>
      <th scope="row">Bundle No</th>
      <td>
        <input type="text" title="" placeholder="Bundle No" class="w100p" id="sBndlNo" name="sBndlNo" />
      </td>
     </tr>
    </tbody>
   </table>
   <!-- table end -->
   <form method="post" id="installationNoteForm"
    name="installationNoteForm">
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
    <input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" />
    <input type="hidden" id="V_INSTALLSTATUS" name="V_INSTALLSTATUS" /> <input
     type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" /> <input
     type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" /> <input
     type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:fn_openReport()"><spring:message
       code='service.btn.Generate' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#none" onclick="javascript:fn_clear()"><spring:message
       code='service.btn.Clear' /></a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
