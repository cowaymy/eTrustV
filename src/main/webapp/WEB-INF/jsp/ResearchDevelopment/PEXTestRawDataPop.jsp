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

    if (($("#settleDtFrm").val() == '' || $("#settleDtTo").val() == '') /* && $("#reportType").val() == '3' */) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (From & To)' htmlEscape='false'/>");
        return false;
    }

    if ($("#settleDtFrm").val() != '' && $("#settleDtTo").val() == '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (To)' htmlEscape='false'/>");
        return false;
    }
    if ($("#settleDtFrm").val() == '' && $("#settleDtTo").val() != '') {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='Settle date (From)' htmlEscape='false'/>");
        return false;
    }

    return true;
  }

  function fn_openGenerate() {
    //if (fn_validation()) {
      var V_WHERE = "";


      if ($("#ddlStatus").val() != '' && $("#ddlStatus").val() != null) {
    	  var V_STATUS = " AND TEST_RESULT_STUS IN ('" + $("#ddlStatus").val().toString().replace(/,/g, "','") + "') ";
    	  V_WHERE += V_STATUS;
    	  console.log(V_WHERE);
      }

      if ($("#cmbProdCategory").val() != '' && $("#cmbProdCategory").val() != null) {
         var V_PRODCAT = " AND STK_CTGRY_ID IN ('" + $("#cmbProdCategory").val().toString().replace(/,/g, "','") + "') ";
         V_WHERE += V_PRODCAT;
      }

      if ($("#settleDtFrm").val() != '' && $("#settleDtFrm").val() != null && $("#settleDtTo").val() != '' && $("#settleDtTo").val() != null ) {
    	  var settleDtFrm = $("#settleDtFrm").val().substring(6, 10) + "-"
          + $("#settleDtFrm").val().substring(3, 5) + "-"
          + $("#settleDtFrm").val().substring(0, 2);

    	  V_WHERE += " AND ( TO_CHAR(TEST_SETTLE_DT, 'YYYYMMDD')  >= TO_CHAR(TO_DATE(" + $("#settleDtFrm").val() + ",'dd/mm/yyyy'), 'YYYYMMDD'))";

    	  var settleDtTo = $("#settleDtTo").val().substring(6, 10) + "-"
          + $("#settleDtTo").val().substring(3, 5) + "-"
          + $("#settleDtTo").val().substring(0, 2);

    	  V_WHERE += " AND ( TO_CHAR(TEST_SETTLE_DT, 'YYYYMMDD')  <= TO_CHAR(TO_DATE(" + $("#settleDtTo").val() + ",'dd/mm/yyyy'), 'YYYYMMDD'))";
      }

         /*  var date = new Date();
          var month = date.getMonth() + 1;
          var day = date.getDate();
          if (date.getDate() < 10) {
            day = "0" + date.getDate();
          } */

          //SP_CR_GEN_PEX_TEST_RAW
          $("#reportForm1").append('<input type="hidden" id="V_WHERE" name="V_WHERE"  /> ');

          var option = {
            isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
          };

          $("#reportForm1 #V_WHERE").val(V_WHERE);
          $("#reportForm1 #reportFileName").val('/ResearchDevelopment/PEXTestResultRawData.rpt');
          $("#reportForm1 #reportDownFileName").val("PEXTestResultRawData_" + today);
          $("#reportForm1 #viewType").val("EXCEL");

          Common.report("reportForm1", option);
      //}
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

