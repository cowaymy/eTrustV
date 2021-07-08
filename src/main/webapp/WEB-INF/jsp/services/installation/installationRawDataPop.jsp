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
        doGetCombo('/common/selectCodeList.do', '10', '', 'appliType', 'M', 'f_multiCombo');
        //doGetComboData('/services/getProductList.do', '', '', 'prodCode', 'M', 'fn_multiCombo');
        doGetComboSepa('/common/selectBranchCodeList.do',  '5', '', '',   'dscBranch', 'M', 'f_multiCombo'); //Branch Code
        doGetCombo('/common/selectCodeList.do', '11', '', 'prodCat', 'M' ,'f_multiComboType');

        $('#orderStrDt').val($.datepicker.formatDate('01/mm/yy', new Date()));
        $('#orderEndDt').val($.datepicker.formatDate('dd/mm/yy', new Date()));
      }
  );

  function f_multiCombo() {
    $('#appliType').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });

    $('#dscBranch').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });

    $('#prodCode').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });

    $('#ordStatus').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });

    $('#insStatus').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });

  }

  function f_multiComboType() {
	  $('#prodCat').change(function() {
		  if ($('#prodCat').val() != null && $('#prodCat').val() != "" ){
              var prodCat = $('#prodCat').val().toString().split(",");

                 var prodCatParam = "";
                 for (var i = 0 ; i < prodCat.length ; i++){
                     if (prodCatParam == ""){
                    	 prodCatParam = prodCat[i];
                     }else{
                    	 prodCatParam = prodCatParam +"∈"+prodCat[i];
                     }
                 }
                 var param = {
                		 prodCat:prodCatParam
                }
                 doGetComboData('/services/getProductList2.do', param , '', 'prodCode', 'M','f_multiCombo');
           }
	    }).multipleSelect({
	      selectAll : true,
	      width : '100%'
	    });
  }

  function fn_validation() {

	  if (($("#orderStrDt").val() == '' &&  $("#orderEndDt").val() == '' )
              && ($("#insStrDt").val() == '' &&  $("#insEndDt").val() == '' )
              && ($("#apptStrDt").val() == '' &&  $("#apptEndDt").val() == '' )){

		  Common.alert("At least 1 of the date options below must be choosen:<br\> - Order Date<br\> - Appointment Date<br\> - Installation Date");
		  return false;

     }

	 if ($("#orderStrDt").val() != '' &&  $("#orderEndDt").val() == '' ) {
    	 Common.alert("Order End Date is required");
    	 return false;
     } else if ($("#orderStrDt").val() == '' &&  $("#orderEndDt").val() != '' ) {
         Common.alert("Order Start Date is required");
         return false;
     } else {
            var startDt = $("#orderStrDt").val();
            var endDt = $("#orderEndDt").val();

             if (!js.date.checkDateRange(startDt,endDt,"Order Date", "3"))
                return false;
     }


     if ($("#insStrDt").val() == '' &&  $("#insEndDt").val() != '' ) {
         Common.alert("Installation Start Date is required");
         return false;
     } else if ($("#insStrDt").val() != '' &&  $("#insEndDt").val() == '' ) {
         Common.alert("Installation End Date is required");
         return false;
     } else {
         var startDt2 = $("#insStrDt").val();
         var endDt2 = $("#insEndDt").val();

          if (!js.date.checkDateRange(startDt2,endDt2,"Installation Date", "3"))
             return false;
     }


     if ($("#apptStrDt").val() == '' &&  $("#apptEndDt").val() != '' ) {
         Common.alert("Appointment Start Date is required");
         return false;
     } else if ($("#apptStrDt").val() != '' &&  $("#apptEndDt").val() == '' ) {
         Common.alert("Appointment End Date is required");
         return false;
     } else {
         var startDt3 = $("#apptStrDt").val();
         var endDt3 = $("#apptEndDt").val();

          if (!js.date.checkDateRange(startDt3,endDt3,"Appointment Date", "3"))
             return false;
     }

    /* if ($("#orderStrDt").val() == '' || $("#orderEndDt").val() == '') {
      Common.alert("<spring:message code='sys.common.alert.validation' arguments='Order date (From & To)' htmlEscape='false'/>");
      return false;
    } */
    return true;
  }

  function fn_openReport() {
    if (fn_validation()) {
      var whereSql = "";
      var date = new Date();
      var month = date.getMonth() + 1;
      var day = date.getDate();

      var whereSql2 ="";

      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      if ($("#orderStrDt").val() != '' && $("#orderEndDt").val() != '' && $("#orderStrDt").val() != null && $("#orderEndDt").val() != null) {

        whereSql += " AND TO_DATE(SOM.SALES_DT) >= TO_DATE('" + $("#orderStrDt").val() + "', 'DD/MM/YYYY') "
                  + " AND TO_DATE(SOM.SALES_DT) <= TO_DATE('" + $("#orderEndDt").val() + "', 'DD/MM/YYYY') ";

      } else {
        whereSql += "AND TO_DATE(SOM.SALES_DT) >= TO_DATE(ADD_MONTHS(FN_GET_FIRST_DAY_MONTH(SYSDATE), -2))";
      }

      if ($("#pvMonth").val() != '' && $("#pvMonth").val() != null) {
        whereSql += "AND SOM.PV_MONTH = '"
                 + $("#pvMonth").val().substring(0, 2)
                 + "' AND SOM.PV_YEAR = '"
                 + $("#pvMonth").val().substring(3, 7) + "' ";
      }

      if ($("#appliType").val() != '' && $("#appliType").val() != null) {
        whereSql += " AND SOM.APP_TYPE_ID In (" + $("#appliType").val() + ") ";
      }

      if ($("#ordStatus").val() != '' && $("#ordStatus").val() != null){
    	  whereSql += " AND SOM.STUS_CODE_ID IN (" + $("#ordStatus").val() + ") ";
      }

      // Homecare Remove(except)
      whereSql += " AND SOM.BNDL_ID IS NULL ";
      //console.log("w " + whereSql);

      if ($("#dscBranch").val() != '' && $("#dscBranch").val() != null) {
    	  whereSql2 += " AND F.BRNCH_ID IN (" + $("#dscBranch").val() + ") ";
      }

      if ($("#insStatus").val() != '' && $("#insStatus").val() != null) {
    	  whereSql2 += " AND INS.STUS_CODE_ID IN (" + $("#insStatus").val() + ")";
      }

      if ($("#insStrDt").val() != '' && $("#insEndDt").val() != '' && $("#insStrDt").val() != null && $("#insEndDt").val() != null) {
          whereSql2 += " AND TO_DATE(INSD.CRT_DT) >= TO_DATE('" + $("#insStrDt").val() + "', 'DD/MM/YYYY') "
                    + " AND TO_DATE(INSD.CRT_DT) <= TO_DATE('" + $("#insEndDt").val() + "', 'DD/MM/YYYY') ";
      }

      if ($("#apptStrDt").val() != '' && $("#apptEndDt").val() != '' && $("#apptStrDt").val() != null && $("#apptEndDt").val() != null) {
          whereSql2 += " AND TO_DATE(INS.APPNT_DT) >= TO_DATE('" + $("#apptStrDt").val() + "', 'DD/MM/YYYY') "
                    + " AND TO_DATE(INS.APPNT_DT) <= TO_DATE('" + $("#apptEndDt").val() + "', 'DD/MM/YYYY') ";
      }

      if ($("#prodCat").val() != '' && $("#prodCat").val() != null){
          whereSql2 += " AND H.CODE_ID IN (" + $("#prodCat").val() + ")";
      }

      if ($("#prodCode").val() != '' && $("#prodCode").val() != null){
    	  var prodCodeT = $("#prodCode").val();

    	  var prodCodeList = "";
          for (var i = 0 ; i < prodCodeT.length ; i++){
              if (prodCodeList == ""){
            	  prodCodeList = "'" + prodCodeT[i] + "'";
              }else{
            	  prodCodeList = prodCodeList +",'"+prodCodeT[i] + "'";
              }
          }

    	  whereSql2 += " AND C.STK_CODE IN (" +prodCodeList + ") ";
      }

      $("#installationRawDataForm #V_WHERESQL").val(whereSql);
      $("#installationRawDataForm #V_WHERESQL_2").val(whereSql2);
      $("#installationRawDataForm #V_SELECTSQL").val('');
      $("#installationRawDataForm #reportFileName").val('/services/InstallationRawData_Excel.rpt');
      $("#installationRawDataForm #viewType").val("EXCEL");
      $("#installationRawDataForm #reportDownFileName").val("InstallationRawData_" + day + month + date.getFullYear());

      var option = {
        isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
      };

      Common.report("installationRawDataForm", option);
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
   <spring:message code='service.btn.InstallationRawData' />
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
   <form action="#" method="post" id="installationRawDataForm">
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
    <input type="hidden" id="V_WHERESQL_2" name="V_WHERESQL_2" />
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" /> <input
     type="hidden" id="viewType" name="viewType" /> <input
     type="hidden" id="reportDownFileName" name="reportDownFileName"
     value="DOWN_FILE_NAME" />
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
     <!-- Added criteria for searching, by Hui Ding, 12-04-2021 -->
      <tr>
       <th scope="row"><spring:message code='service.title.OrderDate' /></th>
       <td>
        <div class="date_set">
         <!-- date_set start -->
         <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="orderStrDt" name="orderStrDt" /></p>
         <span>To</span>
         <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="orderEndDt" name="orderEndDt" /></p>
        </div>
        <!-- date_set end -->
       </td>
       <th scope="row"><spring:message code='service.title.AppointmentDate' /></th>
        <td>
	        <div class="date_set">
	         <!-- Appointment Date start -->
	         <p><input type="text" title="Appointment start Date" placeholder="DD/MM/YYYY" class="j_date" id="apptStrDt" name="apptStrDt" /></p>
	         <span>To</span>
	         <p><input type="text" title="Appointment end Date" placeholder="DD/MM/YYYY" class="j_date" id="apptEndDt" name="apptEndDt" /></p>
	        </div>
	        <!-- Appointment Date end -->
       </td>
      </tr>

      <tr>
       <th scope="row"><spring:message code='service.title.ApplicationType' /></th>
       <td><select class="multy_select w100p" multiple="multiple" id="appliType" name="appliType"></select></td>
       <th scope="row"><spring:message code='service.grid.OrderStatus' /></th>
        <td>
            <select id="ordStatus" name="ordStatus" class="multy_select w100p" multiple="multiple">
                <option value="1">Active</option>
               <option value="4">Completed</option>
               <option value="10">Cancelled</option>
            </select>
        </td>
      </tr>

      <tr>
       <th scope="row"><spring:message code='service.title.PVMonth_PVYear' /></th>
       <td><input type="text" title="기준년월" class="j_date2 w100p" id="pvMonth" name="pvMonth" /></td>
       <th scope="row"><spring:message code='service.title.InstallationStatus' /></th>
        <td><select class="multy_select w100p" multiple="multiple" id="insStatus" name="insStatus">
            <c:forEach var="list" items="${installStatus }" varStatus="status">
	         <option value="${list.codeId}">${list.codeName}</option>
	        </c:forEach>
        </select></td>
      </tr>

      <tr>
        <th scope="row"><spring:message code='service.title.DSCBranch' /></th>
        <td><select class="w100p" multiple="multiple" id="dscBranch" name="dscBranch"></select></td>
        <th scope="row"><spring:message code='service.title.InstallationDate' /></th>
        <td>
        <div class="date_set">
         <!-- Installation Date start -->
         <p>
          <input type="text" title="Installation start Date" placeholder="DD/MM/YYYY" class="j_date" id="insStrDt" name="insStrDt" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="Installation end Date" placeholder="DD/MM/YYYY" class="j_date" id="insEndDt" name="insEndDt" />
         </p>
        </div>
        <!-- Installation Date end -->
       </td>
      </tr>

      <tr>
       <th scope="row"><spring:message code='sal.title.text.productCategory' /></th>
       <td>
            <select class="multy_select w100p" multiple="multiple" id="prodCat" name="prodCat"></select>
       </td>
       <th></th><td></td>
      </tr>

      <tr>
       <th scope="row"><spring:message code='service.title.ProductCode' /></th>
       <td>
            <select class="multy_select w100p" multiple="multiple" id="prodCode" name="prodCode"></select>
       </td>
       <th></th><td></td>
      </tr>
      <!-- End of adding criteria for searching -->
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
      onclick="javascript:$('#installationRawDataForm').clearForm();"><spring:message
       code='service.btn.Clear' /></a>
    </p></li>
  </ul>
  <div id="list_grid_wrap123" style="width: 100%; height: 200px; margin: 0 auto;"></div>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
