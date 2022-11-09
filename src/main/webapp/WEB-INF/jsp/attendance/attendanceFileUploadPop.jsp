<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var batchId;

function fn_uploadFile() {

	var flag= true;

	if($("#batchMthYear").val() == null || $("#batchMthYear").val() == ""){
	        Common.alert("Please select the Month.");
	        flag= false;
	        return;
	}


    if($("#uploadfile").val() == null || $("#uploadfile").val() == ""){
        Common.alert("File not found. Please upload the file.");
        flag= false;
        return;
    }


    if(flag){
        var formData = new FormData();
        formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
        formData.append("batchMthYear", $("#batchMthYear").val());
        formData.append("batchId", '');
        Common.ajaxFile("/attendance/csvUpload.do", formData, function (result) {
            batchId=result.data;
            Common.alert(result.message,fn_reload);
        });
    }

}

function fn_reload(){
	location.reload();
}

function fn_submitApproval(){
	if(FormUtil.isEmpty(batchId)){
		Common.alert("Please upload Attendance File before submit approval.");
	}
	else{
		var param = {
				batchId : batchId
		       };
		Common.popupDiv("/attendance/attendanceSubmitApproval.do", param, null, true, null);
	}
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
                        <input type="text" id="batchMthYear" name="batchMthYear" title="Month" class="j_date2 w100p" placeholder="Choose one" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">File</th>
                        <td colspan='5'>
                        <div class="auto_file w100p"><!-- auto_file start -->
                           <form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">

                                <input title="file add" type="file" id="uploadfile" name="uploadfile">
                                <label><span class="label_text "><a id = "txtFileInput" href="#">File</a></span><input class="input_text" type="text" readonly="readonly"></label>
                           </form>
                        </div><!-- auto_file end -->
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
        <ul class="center_btns mt20">
            <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
            <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/attendance/AttendanceUploadFormat.csv">Download Template</a></p></li>
        </ul>
    </section>

</div><!-- popup_wrap end -->