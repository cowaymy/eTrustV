<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

	var ItmOption = {
	        type : "S",
	        isCheckAll : false
	};

	var ItmOption_M = {
	         type : "M",
	         isCheckAll : false
	};


  $(document).ready(function() {
	    var rankParam = {groupCode : 527, codeIn :[6988,6989,6990]};
        CommonCombo.make('rankReport', "/sales/pos/selectPosModuleCodeList", rankParam , '', ItmOption);
        CommonCombo.make('yearReport', "/attendance/selectYearList.do", null , '', ItmOption);
  });

  $(function() {
      $("#rankReport").change(function(){
          var value = $("#rankReport").val();
          var managerCode;
            switch(value) {
              case "6988":
                  managerCode= {memLvl : 1};
                  CommonCombo.make('managerCodeReport', "/attendance/selectManagerCode.do", managerCode , '', ItmOption_M);
               break;

              case "6989":
                  managerCode= {memLvl : 2};
                  CommonCombo.make('managerCodeReport', "/attendance/selectManagerCode.do", managerCode , '', ItmOption_M);
                  break;

              case "6990":
                  managerCode= {memLvl : 3};
                  CommonCombo.make('managerCodeReport', "/attendance/selectManagerCode.do", managerCode , '', ItmOption_M);
                  break;
            }

      });
});


  function fn_validation(){
      var isVal = true;

      if(FormUtil.isEmpty($('#rankReport').val())) {
          Common.alert("Please choose the Rank.");
          return false;
       }

      if(FormUtil.isEmpty($('#yearReport').val())) {
          Common.alert("Please choose the Year");
          return false;
       }
  }



  function fn_openGenerateYearlyData() {

	var isVal = true;

    isVal = fn_validation();

    if(isVal == false){
        return;
    }else{
        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        var rankReport, managerCodeReport, calMonthYearReport;

        var runCnt = 0;
        var managerCodeStr = '';
        if($("#managerCodeReport :selected").length > 0){
            $("#managerCodeReport :selected").each(function(idx, el) {
                if(runCnt > 0){
                	managerCodeStr += ",'" +$(el).val() + "'";
                }else{
                	managerCodeStr += "'" + $(el).val() + "'";
                }
                runCnt++;
            });
        }
        var managerCode = '';
        if(managerCodeStr != null && managerCodeStr != ''){
        	managerCode += ' AND MANAGER_CODE IN ('+managerCodeStr+')';
            runCnt = 0;
        }
        else{
        	managerCode = null;
        }

        rankReport = $('#rankReport').val();
        calMonthYearReport = $('#yearReport').val();

        $("#reportForm2 #v_rankReport").val(rankReport);
        $("#reportForm2 #v_managerCodeReport").val(managerCode);
        $("#reportForm2 #v_yearReport").val(calMonthYearReport);


        $("#reportForm2 #reportFileName").val('/attendance/AttendanceYearlyDataList.rpt');
        $("#reportForm2 #viewType").val("EXCEL");
        $("#reportForm2 #reportDownFileName").val("AttendanceYearlyDataList" + day + month + date.getFullYear());

        var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportForm2", option);
      }

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
      } else if (tag === 'select' && identifier === 'reportType') {
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
  <h1>Manager Attendance</h1>
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
   <form action="#" id="reportForm2">
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
    <input type="hidden" id="v_rankReport" name="v_rankReport" />
    <input type="hidden" id="v_managerCodeReport" name="v_managerCodeReport" />
    <input type="hidden" id="v_yearReport" name="v_yearReport" />
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
       <th scope="row">Report Type<span id='m1' name='m1' class='must'> *</span></th>
       <td>
       <select id="reportType" class="w100p">
         <option value="5" selected>Manager Yearly Attendance</option>
       </select>
       </td>

        <th scope="row">Rank</th>
        <td><select class="w100p" id="rankReport"  name="rankReport"></select></td>
      </tr>

      <tr>

      <th scope="row">Manager Code</th>
      <td><select class="w100p" id="managerCodeReport"  name="managerCodeReport"></td>

      <th scope="row">Year</th>
      <td><select class="w100p" id="yearReport"  name="yearReport"></td>
      </tr>

     </tbody>
    </table>
    <!-- table end -->
   </form>
  </section>
  <!-- search_table end -->
  <ul class="center_btns">
   <li><p class="btn_blue2 big">
     <a href="#" onclick="javascript:fn_openGenerateYearlyData()">Generate</a>
    </p></li>
   <li><p class="btn_blue2 big">
     <a href="#" onclick="$('#reportForm2').clearForm();">Clear</a>
    </p></li>
  </ul>
 </section>
 <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
