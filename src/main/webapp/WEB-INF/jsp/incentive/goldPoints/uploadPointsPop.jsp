<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

function fn_uploadFile() {

    if($("#uploadfile").val() == null || $("#uploadfile").val() == ""){
        Common.alert("File not found. Please upload the file.");
    } else {

    var formData = new FormData();
    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);

    Common.ajaxFile("/incentive/goldPoints/csvUploadPoints.do", formData, function (result) {
        console.log(result);
        Common.alert(result.message);
        });
    }
}


</script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->
 <header class="pop_header">
  <!-- pop_header start -->
  <h1><spring:message code='incentive.title.creditPtsUpload'/></h1>
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
          <col style="width:165px" />
          <col style="width:*" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">File</th>
            <td>
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
    </form>
    <ul class="center_btns mt20">
      <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
      <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/incentive/GoldPointsFormat.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
    </ul>
  </section>
</div><!-- popup_wrap end -->