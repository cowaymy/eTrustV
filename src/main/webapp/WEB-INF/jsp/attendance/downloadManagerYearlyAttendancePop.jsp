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

      if(FormUtil.isEmpty($('#rankRepsort').val())) {
          Common.alert("Please choose the Rank.");
          return false;
       }

//       if(FormUtil.isEmpty($('#managerCodeReport').val())) {
//           Common.alert("Please choose the Manager Code.");
//           return false;
//        }

      if(FormUtil.isEmpty($('#calMonthYearReport').val())) {
          Common.alert("Please choose the Month");
          return false;
       }
  }




  function fn_openGenerate() {
    if (fn_validation()) {

        var date = new Date();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        if (date.getDate() < 10) {
          day = "0" + date.getDate();
        }

        var rankReport, managerCodeReport, calMonthYearReport;

        if(FormUtil.isEmpty($('#rankReport').val())) {
        	rankReport = null;
         }
        else{
        	rankReport = $('#rankReport').val();
        }

        if(FormUtil.isEmpty($('#managerCodeReport').val())) {
        	managerCodeReport = null;
         }
        else{
        	managerCodeReport = $('#managerCodeReport').val();
        }

        if(FormUtil.isEmpty($('#calMonthYearReport').val())) {
        	calMonthYearReport = null;
         }
        else{
        	calMonthYearReport = $('#calMonthYearReport').val();
        }


        $("#reportForm1 #v_rankReport").val(rankReport);
        $("#reportForm1 #v_managerCodeReport").val(managerCodeReport);
        $("#reportForm1 #v_calMonthYearReport").val(calMonthYearReport);


        $("#reportForm1 #V_SELECTSQL").val(" ");
        $("#reportForm1 #V_ORDERBYSQL").val(" ");
        $("#reportForm1 #V_FULLSQL").val(" ");
        $("#reportForm1 #V_WHERESQL").val(whereSql);
        $("#reportForm1 #V_WHERESQL2").val(whereSql2);
        $("#reportForm1 #V_WHERESQL2LEFTJOIN").val(whereSql2LeftJoin);
        $("#reportForm1 #reportFileName").val('/services/PreASRawDataKOR.rpt');
        $("#reportForm1 #viewType").val("EXCEL");
        $("#reportForm1 #reportDownFileName").val("PREASRawData_" + day + month + date.getFullYear());

        var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportForm1", option);
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
   <form action="#" id="reportForm1">
    <!--reportFileName,  viewType 모든 레포트 필수값 -->
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
    <input type="hidden" id="ind" name="ind" value="${ind}"/>
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

      <th scope="row">Month</th>
      <td><input type="text" id="calMonthYearReport" name="calMonthYearReport" title="Month" class="j_date2 w100p" placeholder="Choose one" /></td>
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
