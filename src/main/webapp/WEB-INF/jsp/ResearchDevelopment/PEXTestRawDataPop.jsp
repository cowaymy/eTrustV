<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
today = "${today}";
  $(document).ready(
		  function() {
			  $("#m5").hide(); //hide mandatory indicator (*) for Settle Date
			  //doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo');
			  //doGetCombo('/common/selectCodeList.do', '11', '','cmbProdCategory', 'M' , 'f_multiCombo');
			  CommonCombo.make('cmbProdCategory', '/common/selectCodeList.do', {groupCode : 11, codeIn : 'WP,AP,BT,BB,MAT,FRM,POE'}, '' , {type: 'M'});
		  });

   function f_multiCombo() {
	    $(function() {
	    	$('#cmbProdCategory').change(function() {

            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            });
	    });
  }

  function fn_validation() {

    if (($("#settleDateFrom").val() == '' || $("#settleDateTo").val() == '') /* && $("#reportType").val() == '3' */) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (From & To)' htmlEscape='false'/>");
        return false;
    }

    if ($("#settleDateFrom").val() != '' && $("#settleDateTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (To)' htmlEscape='false'/>");
        return false;
    }
    if ($("#settleDateFrom").val() == '' && $("#settleDateTo").val() != '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (From)' htmlEscape='false'/>");
        return false;
    }

    return true;
  }

  function fn_openGenerate() {
    //if (fn_validation()) {
      var V_WHERESTATUS = "";
      var V_WHEREPRODCAT = "";
      var V_WHERESETTLEDTFR = "";
      var V_WHERESETTLEDTTO = "";
      var V_WHEREGNG = "";

      if ($("#ddlStatus").val() != '' && $("#ddlStatus").val() != null) {
    	  var V_STATUS = " AND TEST_RESULT_STUS IN ('" + $("#ddlStatus").val().toString().replace(/,/g, "','") + "') ";
    	  V_WHERESTATUS += V_STATUS;
      }

      if ($("#cmbProdCategory").val() != '' && $("#cmbProdCategory").val() != null) {
         var V_PRODCAT = " AND STK_CTGRY_ID IN ('" + $("#cmbProdCategory").val().toString().replace(/,/g, "','") + "') ";
         V_WHEREPRODCAT += V_PRODCAT;
      }

      if ($("#settleDateFrom").val() != '' && $("#settleDateFrom").val() != null && $("#settleDateTo").val() != '' && $("#settleDateTo").val() != null ) {

    	  V_WHERESETTLEDTFR += " AND (TO_CHAR(TEST_SETTLE_DT, 'DD/MM/YYYY')  >= TO_CHAR(TO_DATE('" + $("#settleDateFrom").val() + "','dd/mm/yyyy'), 'DD/MM/YYYY'))";

    	  V_WHERESETTLEDTTO += " AND (TO_CHAR(TEST_SETTLE_DT, 'DD/MM/YYYY')  <= TO_CHAR(TO_DATE('" + $("#settleDateTo").val() + "','dd/mm/yyyy'), 'DD/MM/YYYY'))";
      }

      if ($("#ddlProdGenuine").val() != '' && $("#ddlProdGenuine").val() != null) {
          var V_GNG = " AND PROD_GENUINE IN ('" + $("#ddlProdGenuine").val().toString().replace(/,/g, "','") + "') ";
          V_WHEREGNG += V_GNG;
      }

	      var date = new Date();
	      var month = date.getMonth() + 1;
	      var day = date.getDate();
	      if (date.getDate() < 10) {
	        day = "0" + date.getDate();
	      }

          //SP_CR_GEN_PEX_TEST_RAW
          $("#reportForm1").append('<input type="hidden" id="V_WHERESTATUS" name="V_WHERESTATUS"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHEREPRODCAT" name="V_WHEREPRODCAT"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESETTLEDTFR" name="V_WHERESETTLEDTFR"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHERESETTLEDTTO" name="V_WHERESETTLEDTTO"  /> ');
          $("#reportForm1").append('<input type="hidden" id="V_WHEREGNG" name="V_WHEREGNG"  /> ');

          var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

          $("#reportForm1 #V_WHERESTATUS").val(V_WHERESTATUS);
          $("#reportForm1 #V_WHEREPRODCAT").val(V_WHEREPRODCAT);
          $("#reportForm1 #V_WHERESETTLEDTFR").val(V_WHERESETTLEDTFR);
          $("#reportForm1 #V_WHERESETTLEDTTO").val(V_WHERESETTLEDTTO);
          $("#reportForm1 #V_WHEREGNG").val(V_WHEREGNG);
          $("#reportForm1 #reportFileName").val('/ResearchDevelopment/PEXTestResultRawData.rpt');
          $("#reportForm1 #reportDownFileName").val("PEXTestResultRawData_" + day + month + date.getFullYear());
          $("#reportForm1 #viewType").val("EXCEL");

          Common.report("reportForm1", option);
  }

  $.fn.clearForm = function() {
    return this.each(function() {
      var type = this.type, tag = this.tagName.toLowerCase(); identifier = this.id;
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

      $("#reportForm1 .tr_toggle_display").hide();

    });
  };
</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>PEX Test Result Raw Data
     <span style="color:red">( <spring:message code='service.message.dtRange31'/> )</span>
  </h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#">CLOSE</a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->
 <section class="pop_body">
  <!-- pop_body start -->
  <section class="search_table">
   <!-- search_table start -->
   <form action="#" id="reportForm1">
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
    <table class="type1">
     <!-- table start -->
     <caption>table</caption>
     <colgroup>
      <col style="width: 130px" />
      <col style="width: *" />
      <col style="width: 130px" />
      <col style="width: *" />
     </colgroup>
     <tbody>
     <tr>
      <th scope="row"><spring:message code='sys.title.status' />
           <span id='m1' name='m1' class="must">*</span></th>
      <td>
	       <select class="w100p" id="ddlStatus" name="ddlStatus" class="w100p">
	       <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
	       <c:forEach var="list" items="${PEXTRStatus}" varStatus="status">
	       <option value="${list.codeId}">${list.codeName}</option>
      </c:forEach></select></td>

      <th scope="row">Product Category</th>
            <td><select class="w100p" id="cmbProdCategory" name="cmbProdCategory"></select></td>
      </tr>
      <tr>
        <th scope="row">
            <spring:message code='service.grid.SettleDate' />
       </th>
       <td>
          <div class="date_set w100p">
             <p><input type="text" title="Create start Date" id='settleDateFrom' name='settleDateFrom'
                     placeholder="DD/MM/YYYY" class="j_date" /></p>
             <span><spring:message code='pay.text.to' /></span>
            <p><input type="text" title="Create end Date" id='settleDateTo' name='settleDateTo'
                     placeholder="DD/MM/YYYY" class="j_date" /></p>
           </div>
       </td>
       <th scope="row">Product Genuine</th>
       <td><select id='ddlProdGenuine' name='ddlProdGenuine' class="w100p">
	       <option value="">Choose One</option>
	       <option value="G">Genuine</option>
	       <option value="NG">Non-Genuine</option>
       </select></td>
      </tr>
     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#" onclick="javascript:fn_openGenerate()">Generate</a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#" onclick="$('#reportForm1').clearForm();">Clear</a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

