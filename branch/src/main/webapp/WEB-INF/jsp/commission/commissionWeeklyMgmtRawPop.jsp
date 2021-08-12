<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!--
 DATE              BY           VERSION        REMARK
 -------------------------------------------------------------------
26/02/2020     TOMMY       1.0.0
 -->

<script type="text/javaScript">
var userType = '${SESSION_INFO.userTypeId}';

  $(document)
      .ready(
          function() {

        	  if(userType == 1){

        	   if ("${SESSION_INFO.memberLevel}" == "1") {

        		   $("#wsReportType").val(5); // WS Achievement - GM

        	        } else if ("${SESSION_INFO.memberLevel}" == "2") {

        	        	$("#wsReportType").val(4); // WS Achievement - SM

        	        } else if ("${SESSION_INFO.memberLevel}" == "3") {

        	        	$("#wsReportType").val(3); // WS Achievement - HM

        	        }

        	      doGetCombo('/commission/system/selectHPDeptCodeListByCode', '${memCode}', '', 'cmbDeptCode', 'S', '');
        	      $("#wsReportType").attr('disabled',true);
                 // $("#cmbDeptCode").attr('disabled',true);
        	  }else{

        		  $("#cmbDeptCode").attr('disabled',true);

        	  }


              $("#wsReportType").change(
                      function() {

                    	  var reportType =  $("#wsReportType").val();

                    	 if(reportType == 3){
                    		$("#cmbDeptCode").attr('disabled',false);
                    		 doGetCombo('/commission/system/selectHPDeptCodeListByLv', 3, '', 'cmbDeptCode', 'S', ''); // HM DEPT CODE
                    	 }
                    	 else if(reportType == 4 ){
                    		 $("#cmbDeptCode").attr('disabled',false);
                             doGetCombo('/commission/system/selectHPDeptCodeListByLv', 2, '', 'cmbDeptCode', 'S', ''); // SM DEPT CODE
                    	 }
                         else if(reportType == 5 ){
                             $("#cmbDeptCode").attr('disabled',false);
                             doGetCombo('/commission/system/selectHPDeptCodeListByLv', 1, '', 'cmbDeptCode', 'S', ''); // GM DEPT CODE
                         }
                    	 else if(reportType == 2 ){
                    		 $("#cmbDeptCode").attr('disabled',true);

                    	 }

                      });



          });

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

        });
    };


    function fn_openWSReport(){
    	var reportType = $("#wsReportType").val();


    	if(reportType == 2){
    		fn_weeklyAchievementRawExcel();
    	}
    	else if(reportType == 3){

    		var deptCode = $("#cmbDeptCode").val();
    		if(deptCode == null || deptCode == "" || deptCode == "undefined"){
    			Common.alert("* Please select Department Code.");
    			return false;
    		}else{
    		fn_weeklyAchievementHM();
    		}

    	}
        else if(reportType == 4){
            fn_weeklyAchievementSM();
        }
        else if(reportType == 5){
            fn_weeklyAchievementGM();
        }
        else{
        	Common.alert("* Please select Report Type.");
        	return false;
        }
    }



    function fn_weeklyAchievementRawExcel(){
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        var searchDt = $("#searchWSDt").val();
        var pvyear = searchDt.substring(3);
        var pvmonth = Number(searchDt.substring(0,2));

        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        $("#wsReportForm #reportFileName").val('/commission/weeklyAchievementRaw_Excel.rpt');
        $("#wsReportForm #viewType").val("EXCEL");
        $("#wsReportForm #V_YEAR").val(pvyear);
        $("#wsReportForm #V_MONTH").val(pvmonth);
        $("#wsReportForm #reportDownFileName").val(
            "WeeklyAchievementRaw_" + day + month + date.getFullYear());

        var option = {
                  isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };

      Common.report("wsReportForm", option);
    }

    function fn_weeklyAchievementHM(){
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        var searchDt = $("#searchWSDt").val();
        var pvyear = searchDt.substring(3);
        var pvmonth = Number(searchDt.substring(0,2));
        var deptCode = $("#cmbDeptCode").val();

        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        $("#wsReportForm #reportFileName").val('/commission/weeklyAchievementHM.rpt');
        $("#wsReportForm #viewType").val("PDF");
        $("#wsReportForm #V_YEAR").val(pvyear);
        $("#wsReportForm #V_MONTH").val(pvmonth);
        $("#wsReportForm #V_DEPT_CODE").val(deptCode);
        $("#wsReportForm #reportDownFileName").val(
            "WeeklyAchievementHM_" + day + month + date.getFullYear());

        var option = {
                  isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };

      Common.report("wsReportForm", option);
    }

    function fn_weeklyAchievementSM(){
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        var searchDt = $("#searchWSDt").val();
        var pvyear = searchDt.substring(3);
        var pvmonth = Number(searchDt.substring(0,2));
        var deptCode = $("#cmbDeptCode").val();

        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        $("#wsReportForm #reportFileName").val('/commission/weeklyAchievementSM.rpt');
        $("#wsReportForm #viewType").val("PDF");
        $("#wsReportForm #V_YEAR").val(pvyear);
        $("#wsReportForm #V_MONTH").val(pvmonth);
        $("#wsReportForm #V_DEPT_CODE").val(deptCode);
        $("#wsReportForm #reportDownFileName").val(
            "WeeklyAchievementSM_" + day + month + date.getFullYear());

        var option = {
                  isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };

      Common.report("wsReportForm", option);

    }

    function fn_weeklyAchievementGM(){
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        var searchDt = $("#searchWSDt").val();
        var pvyear = searchDt.substring(3);
        var pvmonth = Number(searchDt.substring(0,2));
        var deptCode = $("#cmbDeptCode").val();

        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        $("#wsReportForm #reportFileName").val('/commission/weeklyAchievementGM.rpt');
        $("#wsReportForm #viewType").val("PDF");
        $("#wsReportForm #V_YEAR").val(pvyear);
        $("#wsReportForm #V_MONTH").val(pvmonth);
        $("#wsReportForm #V_DEPT_CODE").val(deptCode);
        $("#wsReportForm #reportDownFileName").val(
            "WeeklyAchievementHM_" + day + month + date.getFullYear());

        var option = {
                  isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };

      Common.report("wsReportForm", option);


    }




  </script>
  <div id="popup_wrap" class="popup_wrap">
   <!-- popup_wrap start -->
   <header class="pop_header">
    <!-- pop_header start -->
    <h1>WS Achievement Raw - Report
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
          <form method="post" id="wsReportForm"
      name="wsReportForm">
    <input type='hidden' id='reportFileName' name='reportFileName'/>
    <input type='hidden' id='viewType' name='viewType'/>
    <input type='hidden' id='reportDownFileName' name='reportDownFileName'/>
    <input type='hidden' id='V_YEAR' name='V_YEAR'/>
    <input type='hidden' id='V_MONTH' name='V_MONTH'/>
      <input type='hidden' id='V_DEPT_CODE' name='V_DEPT_CODE'/>

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
            <th scope="row"><spring:message
        code='commission.text.search.reportType' /></th>
      <td>
               <select class="w100p" id="wsReportType" name="wsReportType">
       <!--  <option value="1">WS Achievement Raw - PDF</option> -->
        <option value="2">WS Achievement Raw - Excel</option>
        <option value="3">WS Achievement - HM</option>
        <option value="4">WS Achievement - SM</option>
        <option value="5">WS Achievement - GM</option>
        </select>

              <th scope="row"><spring:message code='commission.text.search.monthYear'/></th>
               <td><input type="text" id="searchWSDt" name="searchWSDt" title="Month/Year" class="j_date2" value="${searchWSDt}" style="width: 200px;" /></td>
      </tr>
    <tr>
      <th scope="row"><spring:message code='service.title.DepartmentCode' /> <span  class="must">*</span></th>
      <td>
       <select id="cmbDeptCode" name="cmbDeptCode" class="w100p"></select>
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
       <a href="#" onclick="javascript:fn_openWSReport()"><spring:message
         code='service.btn.Generate' /></a>
      </p></li>
     <li><p class="btn_blue2 big">
       <a href="#" onclick="javascript:$('#wsReportForm').clearForm();"><spring:message
         code='service.btn.Clear' /></a>
      </p></li>
    </ul>
   </section>
   <!-- pop_body end -->
  </div>
  <!-- popup_wrap end -->
