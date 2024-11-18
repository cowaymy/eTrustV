<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--
 DATE        BY     VERSION        REMARK
 ----------------------------------------------------------------
 08/02/2019  ONGHC  1.0.0          RE-STRUCTURE JSP.
 07/10/2019  ONGHC  1.0.1          AMEND CONDITION OF ORDER START AND END DATE
 12/04/2021  TEOHHD 1.0.2          Added searching criteria (order status, DSC branch, Ins Status, Ins Date, Appt Date, Product Category, Product Code)
 -->
<!-- <script>
    document.write('<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js?v='+new Date().getTime()+'"><\/script>');
</script> -->
<script type="text/javaScript">
  $(document).ready(
      function() {
          var optionUnit = {
                  id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
                  name: "codeName",  // 콤보박스 text 에 지정할 필드명.
                  isShowChoose: false,
                  isCheckAll : false,
                  type : 'M'
          };

          var selectValue = "1" + DEFAULT_DELIMITER + "81";

          CommonCombo.make('validStusId', "/status/selectStatusCategoryCdList.do", {selCategoryId : 22} , selectValue , optionUnit);
      }
  );



  function fn_validation() {


     if ($("#crtStartDt").val() != '' &&  $("#crtEndDt").val() == '' ) {
         Common.alert("Created End Date is required");
         return false;
     } else if ($("#crtStartDt").val() == '' &&  $("#crtEndDt").val() != '' ) {
         Common.alert("Created Start Date is required");
         return false;
     } else {
            var startDt = $("#crtStartDt").val();
            var endDt = $("#crtEndDt").val();
     }

    return true;
  }

  function fn_openReport() {
    if (fn_validation()) {

    	var quotationNo  = "";
    	var orderNo      = "";
    	var crtStartDt   = "";
    	var crtEndDt     = "";
    	var validStusId  = "";
    	var isHc  = "1";
    	var date = new Date();
    	var month = date.getMonth() + 1;
    	var day = date.getDate();

    	if ($("#quotationNo").val() != '' && $("#quotationNo").val() != null) {
    		quotationNo =$("#quotationNo").val();
    	}
    	else{
    		quotationNo =null;
    	}

    	if ($("#orderNo").val() != '' && $("#orderNo").val() != null) {
    		orderNo =$("#orderNo").val();
        }
        else{
        	orderNo =null;
        }


    	if ($("#crtStartDt").val() != '' && $("#crtStartDt").val() != null) {
    		crtStartDt =$("#crtStartDt").val();
    		crtEndDt =$("#crtEndDt").val();
        }
        else{
        	crtStartDt =null;
            crtEndDt =null;
        }

    	if ($("#validStusId").val() != '' && $("#validStusId").val() != null) {
    		validStusId =$("#validStusId").val();
        }
        else{
        	validStusId =null;
        }


      $("#quotationRawDataForm #V_QUOTATIONNO").val(quotationNo);
      $("#quotationRawDataForm #V_ORDERNO").val(orderNo);
      $("#quotationRawDataForm #V_CRTSTARTDT").val(crtStartDt);
      $("#quotationRawDataForm #V_CRTENDDT").val(crtEndDt);
      $("#quotationRawDataForm #V_VALIDSTUSID").val(validStusId);
      $("#quotationRawDataForm #V_ISHOMECARE").val(isHc);
      $("#quotationRawDataForm #reportFileName").val('/sales/QuotationRawData_Excel.rpt');
      $("#quotationRawDataForm #viewType").val("EXCEL");
      $("#quotationRawDataForm #reportDownFileName").val("QuotationRawData_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("quotationRawDataForm", option);
    }

  }
  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase();
      if (tag === 'form') {
        return $(':input', this).clearForm();
      }

      if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea') {
        this.value = '';
      } else if (type === 'checkbox' || type === 'radio') {
        this.checked = false;
      } else if (tag === 'select') {
        this.selectedIndex = -1;
        f_multiCombo();
      }
    });
  };

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>
   HC Quoatation Raw Data
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='expense.CLOSE' /></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" method="post" id="quotationRawDataForm">
    <input type="hidden" id="V_QUOTATIONNO" name="V_QUOTATIONNO" />
    <input type="hidden" id="V_ORDERNO" name="V_ORDERNO" />
    <input type="hidden" id="V_CRTSTARTDT" name="V_CRTSTARTDT" />
    <input type="hidden" id="V_CRTENDDT" name="V_CRTENDDT" />
    <input type="hidden" id="V_VALIDSTUSID" name="V_VALIDSTUSID" />
    <input type="hidden" id="V_ISHOMECARE" name="V_ISHOMECARE" />
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.quotationNo" /></th>
    <td>
    <input type="text" title="" placeholder="Quotation Number" class="w100p"  id="quotationNo"  name="quotationNo"  />

    </td>
    <th scope="row"><spring:message code="sal.text.ordNo" /> </th>
    <td>
    <input type="text" title="" placeholder="Order Number" class="w100p"   id="orderNo"  name="orderNo"/>
    </td>

</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.crtDate" /></th>
    <td>

    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text"  placeholder="DD/MM/YYYY" class="j_date"  id="crtStartDt"  name="crtStartDt" /></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text"  placeholder="DD/MM/YYYY" class="j_date"   id="crtEndDt"  name="crtEndDt"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="validStusId" name="validStusId">
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
     <a href="#" onclick="javascript:fn_openReport()"><spring:message
       code='service.btn.Generate' /></a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#"
      onclick="javascript:$('#quotationRawDataForm').clearForm();"><spring:message
       code='service.btn.Clear' /></a>
    </p></li>
  </ul>
  <div id="list_grid_wrap123" style="width: 100%; height: 200px; margin: 0 auto;"></div>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
