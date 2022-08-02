<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

function fn_uploadFile() {

    if($("#uploadfile").val() == null || $("#uploadfile").val() == ""){
        Common.alert("File not found. Please upload the file.");
    } else {

    var formData = new FormData();
    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("batchMthYear", $("#batchMthYear").val());
    formData.append("batchMemType", $("#batchMemType").val());
    Common.ajaxFile("/attendance/csvUpload.do", formData, function (result) {
    	$("#batchId").val("${batchId}".trim());
        Common.alert(result.message);
        });
    }
}

function fn_submitApproval(){
// 	if($("#batchId").val()=="0"){
// 		Common.alert("Please upload Attendance File before submit approval.");
// 	}
// 	else{
		var param = {
				batchId : $("#batchId").val()
		       };

		Common.popupDiv("/attendance/attendanceSubmitApproval.do", param, null, true, 'attendanceSubmitApproval');
// 	}
}


</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1>Attendance - File Upload</h1>
  <ul class="right_opt">
   <li><p class="btn_blue2">
     <a href="#"><spring:message code='expense.CLOSE'/></a>
    </p></li>
  </ul>
 </header>
 <!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form action="#" method="post">
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
                        <input type="text" id="batchMthYear" name="batchMthYear" title="Month" class="j_date2" placeholder="Choose one" />
                        </td>
                    </tr>
                    <tr>
                         <th scope="row">Member Type</th>
                         <td colspan='5'>
                            <select class="" id="batchMemType" name="batchMemType">
                                <option value="">Choose One</option>
<!--                                 <option value="1">Health Planner</option> -->
<!--                                 <option value="2">Coway Lady</option> -->
                                <option value="4">Staff</option>
<!--                                 <option value="7">Homecare Technician</option> -->
                                <option value="6677">Manager</option>
                            </select>
                         </td>
                    </tr>
                    <tr>
                        <th scope="row">File</th>
                        <td colspan='5'>
                        <div class="auto_file"><!-- auto_file start -->
                           <form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">

                                <input title="file add" type="file" id="uploadfile" name="uploadfile">
                                <label><span class="label_text"><a id = "txtFileInput" href="#">File</a></span><input class="input_text" type="text" readonly="readonly"></label>
                           </form>
                        </div><!-- auto_file end -->
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
            <input type="hidden" id="batchId" name="batchId" value="0" />
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
            <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/attendance/AttendanceUploadFormat.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
            <li><p class="btn_blue2 big"><a href="javascript:fn_submitApproval();"><spring:message code='sys.btn.submit'/></a></p></li>
        </ul>
    </section>

</div><!-- popup_wrap end -->