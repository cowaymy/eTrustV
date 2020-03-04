<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!--
 DATE              BY           VERSION        REMARK
 -------------------------------------------------------------------
13/02/2020     TOMMY       1.0.0            卐解 ！ 天锁斩月
 -->

<script type="text/javaScript">

  $(document)
      .ready(
          function() {

        	  $('.multy_select').on("change", function() {
              }).multipleSelect({});
            // SET COMBO DATA
            // APPLICATION CODE
            doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID', '', 'listAppType', 'M', 'fn_multiCombo'); //Common Code
            // DSC CODE
            doGetComboSepa('/common/selectBranchCodeList.do', '5', ' - ', '', 'listDSCCode', 'M', 'fn_multiCombo'); //Branch Code
            // FAIL REASON & FEEDBACK CODE
            doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=172', '', '', 'ddlFailReason', 'M', 'fn_multiCombo');
            doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=276', '', '', 'fbFailReason', 'M', 'fn_multiCombo');
              });

  function fn_multiCombo() {
    $('#listAppType').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });
    $('#listDSCCode').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });
    $('#ddlFailReason').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });
    $('#fbFailReason').change(function() {
    }).multipleSelect({
      selectAll : true, // 전체선택
      width : '100%'
    });

  }

  function fn_openReport() {

	      var date = new Date();
	      var SelectSql = "";
	      var whereSql = "";
	      var whereSql2 = "";
	      var orderBySql = "";
	      var FullSql = "";
	      var month = date.getMonth() + 1;
	      var day = date.getDate();
	      var msg = "";
	      var text = "";
	      var agingDay1 = $("#agingDayFrom").val();
	      var agingDay2 = $("#agingDayTo").val();

	      // VALIDATION - START
	      // ORDER DATE
/* 	     if ($("#instcallcreateDate").val() == '') {
	    	  text = "<spring:message code='service.title.OrderDate' />";
	    	  msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
	    	    } else if ($("#instcallendDate").val() == '') {
	    	    	  text = "<spring:message code='service.title.OrderDate' />";
	    	    	  msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
	    	    	    }

	     if (msg != '') {
	         Common.alert(msg);
	         return false;
	       }

	       if ($("#instcallcreateDate").val() != '' || $("#instcallendDate").val() != '') {
	             if ($("#instcallcreateDate").val() == '' || $("#instcallendDate").val() == '') {
	               text = "<spring:message code='service.title.OrderDate' />";
	               msg += "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
	             }
	           }


	         if (msg != '') {
	             Common.alert(msg);
	             return false;
	           } */

	      // VALIDATION - END



	      //ORDER NO
	      if ($("#orderNoCallLog").val() != '' && $("#orderNoCallLog").val() != null) {
	        whereSql += " AND SOM.SALES_ORD_NO IN ('" + $("#orderNoCallLog").val()
	        		+ "') ";
	      }

 	      //APPLICATION TYPE
	      if ($("#listAppType").val() != '' && $("#listAppType").val() != null) {
	          whereSql += " AND SOM.APP_TYPE_ID IN(" + $("#listAppType").val()
	              + ") ";
	        }

	      //ORDER DATE
	      if ($("#instcallcreateDate").val() != '' && $("#instcallendDate").val() != '' && $("#instcallcreateDate").val() != null && $("#instcallendDate").val() != null) {
	          whereSql += " AND (TO_DATE(SOM.SALES_DT) >= TO_DATE('" + $("#instcallcreateDate").val() + "' , 'DD/MM/YYYY')  AND TO_DATE(SOM.SALES_DT) <=  TO_DATE('" + $("#instcallendDate").val() + "' , 'DD/MM/YYYY')) ";
	        }

	      //CALL LOG DATE
          if ($("#instcallStrDate").val() != '' && $("#instcallEndDate").val() != '' && $("#instcallStrDate").val() != null && $("#instcallEndDate").val() != null) {
              whereSql2 += " AND (TO_DATE(B.CALL_FIRST_CRT_DT) >=  TO_DATE('" + $("#instcallStrDate").val() + "','DD/MM/YYYY') AND TO_DATE(B.CALL_FIRST_CRT_DT) <= TO_DATE('" + $("#instcallEndDate").val() + "','DD/MM/YYYY')) ";
            }

	      //CALL LOG TYPE
 	       if ($("#instcallLogType").val() != '' && $("#instcallLogType").val() != null) {
	              whereSql += " AND C.TYPE_ID IN (" + $("#instcallLogType").val()
	                  + ") ";
	            }

	      //CALL LOG STATUS
	        if ($("#instcallLogStatus").val() != '' && $("#instcallLogStatus").val() != null) {
                whereSql += " AND D.CALL_STUS_ID IN (" + $("#instcallLogStatus").val()
                    + ") ";
	        }

	      //INSTALL STATUS
	        if ($("#instalcallLogStatus").val() != '' && $("#instalcallLogStatus").val() != null) {
                whereSql += " AND B.STUS_CODE_ID IN (" + $("#instalcallLogStatus").val()
                    + ") ";
	        }

	      //DSC CODE
	         if ($("#listDSCCode").val() != '' && $("#listDSCCode").val() != null) {
	                whereSql += " AND A.BRNCH_ID IN (" + $("#listDSCCode").val()
	                    + ") ";
	            }

	      //FAIL REASON
	          if ($("#ddlFailReason").val() != '' && $("#ddlFailReason").val() != null) {
                  whereSql += " AND M.FAIL_ID  IN (" + $("#ddlFailReason").val()
                      + ") ";
              }

	      //FEEDBACK CODE
	           if ($("#fbFailReason").val() != '' && $("#fbFailReason").val() != null) {
	                  whereSql += " AND D.CALL_FDBCK_ID  IN (" + $("#fbFailReason").val()
	                      + ") ";
	              }

	      //AGING DAY
            if ($("#agingDayFrom").val() != '' && $("#agingDayTo").val() != '' && $("#agingDayFrom").val() != null && $("#agingDayTo").val() != null) {
        var agingDayFrom = $("#agingDayFrom").val();
        var agingDayTo = $("#agingDayTo").val();
        whereSql2 += " and (B.AGING_DT >= '" + agingDayFrom
            + "' AND B.AGING_DT <= '" + agingDayTo + "') ";
            }

	      console.log(whereSql);
	      console.log(whereSql2);

	      var callLogType = $("#instcallLogType").val();

	      $("#installationCallLogForm #V_CALLLOGTYPE").val(callLogType);
	      $("#installationCallLogForm #V_WHERESQL").val(whereSql);
	      $("#installationCallLogForm #V_WHERESQL2").val(whereSql2);
	      $("#installationCallLogForm #V_ORDERBYSQL").val(orderBySql);
	      $("#installationCallLogForm #V_SELECTSQL").val(SelectSql);
	      $("#installationCallLogForm #V_FULLSQL").val(FullSql);
	      $("#installationCallLogForm #reportFileName").val('/services/InstallationCallLogRaw_excel.rpt');
	      $("#installationCallLogForm #viewType").val("EXCEL");
	      $("#installationCallLogForm #reportDownFileName").val("InstallationCallLogRaw_" + day + month + date.getFullYear());

	      var option = {
	        isProcedure : true,
	      };

	      Common.report("installationCallLogForm", option);
	    }

  $.fn.clearForm = function() {
	    return this.each(function() {
	        var type = this.type, tag = this.tagName.toLowerCase();
	        if (tag === 'form'){
	            return $(':input',this).clearForm();
	        }
	        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
	            this.value = '';
	        }else if (type === 'checkbox' || type === 'radio'){
	            this.checked = false;
	        }else if (tag === 'select'){
	            this.selectedIndex = -1;
	        }
	        $("#instcallcreateDate").val("");
	        $("#instcallendDate").val("");
	        $("#instcallStrDate").val("");
	        $("#instcallEndDate").val("");
	        $("#agingDayFrom").val("");
	        $("#agingDayTo").val("");
	    });
	};


  </script>
  <div id="popup_wrap" class="popup_wrap">
   <!-- popup_wrap start -->
   <header class="pop_header">
    <!-- pop_header start -->
    <h1>
     <spring:message code='service.title.InstCallLogRaw' />
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
          <form method="post" id="installationCallLogForm"
      name="installationCallLogForm">
      <input type="hidden" id="V_CALLLOGTYPE" name="V_CALLLOGTYPE" />
      <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
       <input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" />
        <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" />
        <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" />
        <input type="hidden" id="V_FULLSQL" name="V_FULLSQL" />
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
       <col style="width: 160px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
  <tr>
      <th scope="row"><spring:message code='service.title.OrderNo' /></th>
      <td><input type="text" class="w100p" id="orderNoCallLog" name="orderNo" /></td>

      <th scope="row"><spring:message
        code='service.title.ApplicationType' /></th>
      <td><select class="multy_select w100p" multiple="multiple"
       id="listAppType" name="appType">
      </select></td>

     </tr>
<tr>
  <th scope="row"><spring:message
        code='service.title.OrderDate' /><span name="m1" id="m1" class="must">*</span></th>
      <td>
       <div class="date_set">
        <!-- date_set start -->
        <p>
         <input type="text" title="${crtDt}"
          placeholder="${dtFmt}" class="j_date" id="instcallcreateDate"
          name="createDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="${endDt}"
          placeholder="${dtFmt}" class="j_date" id="instcallendDate"
          name="endDate" />
        </p>
       </div> <!-- date_set end -->
      </td>

         <th scope="row"><spring:message
        code='service.title.CallLogDate' /></th>
      <td>
       <div class="date_set">
        <!-- date_set start -->
        <p>
         <input type="text" title="${crtDt}"
          placeholder="${dtFmt}" class="j_date" id="instcallStrDate"
          name="callStrDate" />
        </p>
        <span>To</span>
        <p>
         <input type="text" title="${endDt}"
          placeholder="${dtFmt}" class="j_date" id="instcallEndDate"
          name="callEndDate" />
        </p>
       </div> <!-- date_set end -->
      </td>
</tr>


     <tr>
      <th scope="row"><spring:message
        code='service.title.CallLogType' /></th>
      <td>
               <select class="w100p" id="instcallLogType" name="instcallLogType">
        <option value="257">New Installation Order</option>
        <option value="258">Product Exchange</option>

<%--        <select  class="multy_select w100p" multiple="multiple"
        id="instcallLogType" name="instcallLogType">
        <c:forEach var="list" items="${instcallLogTyp}" varStatus="status">
         <c:choose>
           <c:when test="${list.code=='257'}">
             <option value="${list.code}" selected>${list.codeName}</option>
           </c:when>
           <c:otherwise>
             <option value="${list.code}">${list.codeName}</option>
           </c:otherwise>
         </c:choose>
        </c:forEach>
      </select> --%>
      </td>

      <th scope="row"><spring:message
        code='service.title.CallLogStatus' /></th>
      <td>
    <select  class="multy_select w100p" multiple="multiple"
       id="instcallLogStatus" name="instcallLogStatus">
 <c:forEach var="list" items="${instcallLogSta}" varStatus="status">
<%--          <c:choose>
            <c:when test="${list.code=='1' || list.code=='19'}">
             <option value="${list.code}" selected>${list.codeName}</option>
           </c:when>
           <c:otherwise> --%>
             <option value="${list.code}">${list.codeName}</option>
<%--             </c:otherwise>
         </c:choose> --%>
        </c:forEach>
      </select></td>

     </tr>

     <tr>
          <th scope="row"><spring:message code='service.title.InstallStatus' /> <span name="instcallLogStatus" id="instcallLogStatus" ></span></th>
      <td><select  id="instalcallLogStatus" name="instalcallLogStatus" class="multy_select w100p" multiple="multiple">
        <c:forEach var="list" items="${instcallLogStatus }" varStatus="status">
      <%--    <c:choose>
           <c:when test="${list.codeId=='1'}">
            <option value="${list.codeId}" selected>${list.codeName}</option>
          </c:when>
          <c:otherwise> --%>
            <option value="${list.codeId}">${list.codeName}</option>
       <%--    </c:otherwise>
         </c:choose> --%>
        </c:forEach>
      </select></td>

      <th scope="row"><spring:message code='service.title.DSCCode' /></th>
      <td><select class="multy_select w100p" multiple="multiple" id="listDSCCode"
       name="DSCCode">
      </select></td>
     </tr>

     <tr>
      <th scope="row"><spring:message code='service.grid.FailReason' /></th>
       <td>
         <select id='ddlFailReason' name='ddlFailReason'  class="multy_select w100p" multiple="multiple">
         </select>
       </td>

              <th scope="row"><spring:message code='service.title.FeedbackCode' /></th>
       <td>
         <select id='fbFailReason' name='fbFailReason'  class="multy_select w100p" multiple="multiple">
         </select>
       </td>

     </tr>
     <tr>
      <th scope="row">Aging Day (Call Log VS Installation)</th>
      <td>
        <div class="date_set">
         <!-- date_set start -->
         <p>
          <input type="text" title="" placeholder="From" class="w100p"
           id="agingDayFrom" name="agingDayFrom" />
         </p>
         <span>To</span>
         <p>
          <input type="text" title="" placeholder="To" class="w100p"
           id="agingDayTo" name="agingDayTo" />
         </p>
        </div>
        <!-- date_set end -->
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
       <a href="#" onclick="javascript:$('#installationCallLogForm').clearForm();"><spring:message
         code='service.btn.Clear' /></a>
      </p></li>
    </ul>
   </section>
   <!-- pop_body end -->
  </div>
  <!-- popup_wrap end -->
