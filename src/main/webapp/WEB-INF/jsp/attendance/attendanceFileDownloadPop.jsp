<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

function fn_openGenerate() {

	  var date = new Date();
      var month = date.getMonth() + 1;
      var day = date.getDate();
      if (date.getDate() < 10) {
        day = "0" + date.getDate();
      }

      var batchMthYear, batchMemType;

      if(FormUtil.isEmpty($('#batchMthYear_download').val())) {
    	  batchMthYear = null;
       }
      else{
    	  batchMthYear = $('#batchMthYear_download').val();
      }

      if(FormUtil.isEmpty($('#batchMemType_download').val())) {
    	  batchMemType = null;
       }
      else{
    	  batchMemType = $('#batchMemType_download').val();
      }


     $("#reportForm1 #v_batchMemType").val(batchMemType);
     $("#reportForm1 #v_batchMthYear").val(batchMthYear);

     $("#reportForm1 #reportFileName").val('/attendance/AttendanceRawData.rpt');
     $("#reportForm1 #viewType").val("EXCEL");
     $("#reportForm1 #reportDownFileName").val("AttendanceRawData_" + day + month + date.getFullYear());

     var option = {
          isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
     };

      Common.report("reportForm1", option);
  }


function fn_reload(){
    location.reload();
}


</script>

<div id="popup_wrap_download" class="popup_wrap size_mid"><!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>Attendance - File Download</h1>
  <ul class="right_opt">

   <li><p class="btn_blue2">
     <a href="#"><spring:message code='expense.CLOSE'/></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form action="#" method="post" id="reportForm1">
        <input type="hidden" id="reportFileName" name="reportFileName" />
        <input type="hidden" id="viewType" name="viewType" />
        <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
        <input type="hidden" id="v_batchMemType" name="v_batchMemType" />
        <input type="hidden" id="v_batchMthYear" name="v_batchMthYear" />
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Month</th>
                        <td colspan='5'>
                        <input type="text" id="batchMthYear_download" name="batchMthYear_download" title="Month" class="j_date2" placeholder="Choose one" />
                        </td>
                    </tr>
                    <tr>
                         <th scope="row">Member Type</th>
                         <td colspan='5'>
                            <select class="" id="batchMemType_download" name="batchMemType_download">
                                <option value="">Choose One</option>
                                <option value="4">Staff</option>
                                <option value="6677">Manager</option>
                            </select>
                         </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a href="javascript:fn_openGenerate();">Download File</a></p></li>

        </ul>
    </section>

</div><!-- popup_wrap end -->