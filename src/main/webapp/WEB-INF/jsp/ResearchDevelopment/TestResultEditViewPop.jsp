<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
  var regGridID;
  var actPrdCode;

  $(document).ready(function() {

    fn_selectPEXDataInfo();
  });

  var PEXDataInfo = {};

  function fn_selectPEXDataInfo() {

    Common.ajax("GET", "/ResearchDevelopment/getPEXTestResultInfo", $("#resultPEXTestResultForm")
        .serialize(), function(result) {
      PEXDataInfo = result;
    });
  }

   function setPopData() {

    var options = {
	    TEST_RESULT_ID : '${TEST_RESULT_ID}',
	    TEST_RESULT_NO : '${TEST_RESULT_NO}',
	    SO_EXCHG_ID : '${SO_EXCHG_ID}',
	    MOD : '${MOD}'
    };

    fn_setPEXDataInit(options);

    if ('${MOD}' == "RESULTVIEW") {
      $("#btnSaveDiv").attr("style", "display:none");

      $("#btnSaveDiv").attr("style", "display:none");
      $("#addDiv").attr("style", "display:none");

       // KR-OHK Serial Check
      $("#serialSearch").attr("style", "display:none");
      $("#serialEdit").attr("style", "display:none");

      $('#dpSettleDate').attr("disabled", true);
      $('#tpSettleTime').attr("disabled", true);
      $('#ddlDSCCode').attr("disabled", true);

      $('#ddlCTCode').attr("disabled", true);
      $('#txtTestResultRemark').attr("disabled", true);

      $('#def_code').attr("disabled", true);
      $('#def_part').attr("disabled", true);
      $('#def_def').attr("disabled", true);

      $('#def_code_text').attr("disabled", true);
      $('#def_part_text').attr("disabled", true);
      $('#def_def_text').attr("disabled", true);

    }
  };
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <section id="content">
  <!-- content start -->
  <form id="resultPEXTestResultForm" method="post">
   <div style="display: none">
    <input type="text" name="TEST_RESULT_ID" id="TEST_RESULT_ID" value="${TEST_RESULT_ID}" />
    <input type="text" name="TEST_RESULT_NO" id="TEST_RESULT_NO" value="${TEST_RESULT_NO}" />
    <input type="text" name="SO_EXCHG_ID" id="SO_EXCHG_ID" value="${SO_EXCHG_ID}" />
    <input type="text" name="RCD_TMS" id="RCD_TMS" value="${RCD_TMS}" />
    <input type="text" name="PROD_CDE" id="PROD_CDE" />
    <input type="text" name="PROD_CAT" id="PROD_CAT" />
    <input type="text" name="MOD" id="MOD" value="${MOD}" />

   </div>
  </form>
  <header class="pop_header">
   <!-- pop_header start -->
   <h1>
    <spain id='title_spain'>View PEX Test Result</spain>
    <%--  <c:if test="${MOD eq  'RESULTEDIT' }"> <spring:message code='service.btn.editAs' /> </c:if>  --%>
   </h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a href="#"><spring:message code='sys.btn.close' /></a>
     </p></li>
   </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
   <!-- pop_body start -->
   <!-- tap_wrap end -->
   <aside class="title_line">
    <!-- title_line start -->
    <h3 class="red_text"><spring:message code='service.msg.msgFillIn' /></h3>
   </aside>
   <!-- title_line end -->
   <!-- asResultInfo info tab  start...-->
   <jsp:include page='${pageContext.request.contextPath}/ResearchDevelopment/TestResultInfoEdit.do' />
   <!-- asResultInfo info tab  end...-->
   <script>
   </script>
   </article>
   <!-- acodi_wrap end -->
   <div id='btnSaveDiv'>
   <ul class="center_btns mt20">
    <li><p class="btn_blue2 big">
      <a href="#" onclick="fn_doSave()"><spring:message code='sys.btn.save' /></a>
     </p></li>
    <li><p class="btn_blue2 big">
      <a href="#" onClick="fn_doClear()"><spring:message code='sys.btn.clear' /></a>
     </p></li>
   </ul>
   </div>
  </section>
  <!-- content end -->
 </section>
 <!-- content end -->
</div>
<!-- popup_wrap end -->
