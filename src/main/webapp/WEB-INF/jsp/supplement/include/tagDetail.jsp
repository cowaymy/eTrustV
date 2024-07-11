<script type="text/javascript">

$(document).ready(
	    function() {

	        /* atchFileGrpId */
            var attachList = $("#atchFileGrpId").val();
            Common.ajax("Get", "/supplement/selectAttachListCareline.do", { atchFileGrpId : attachList },
              function(result) {
                if (result) {
                  if (result.length > 0) {
                    $("#attachTd").html("");
                    for (var i = 0; i < result.length; i++) {
                      //$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
                      var atchTdId = "atchId" + (i + 1);
                      $("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                      $(".input_text[name='" + atchTdId + "']").val(result[i].atchFileName);
                    }

                    // 파일 다운
                    $(".input_text").dblclick(
                      function() {
                        var oriFileName = $(this).val();
                        var fileGrpId;
                        var fileId;
                        for (var i = 0; i < result.length; i++) {
                          if (result[i].atchFileName == oriFileName) {
                            fileGrpId = result[i].atchFileGrpId;
                            fileId = result[i].atchFileId;
                          }
                        }
                        fn_atchViewDown(fileGrpId, fileId);
                    });
                  }
                }
              });



             var attachList2 =  $("#atchFileGrpIdHQ").val();
            Common.ajax("Get", "/supplement/selectAttachListHq.do", { atchFileGrpId : attachList2 },
              function(result) {
                if (result) {
                  if (result.length > 0) {
                    $("#attachTd").html("");
                    for (var i = 0; i < result.length; i++) {
                      //$("#attachTd").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' value='" + attachList[i].atchFileName + "'/></div>");
                      var atchTdId = "atchId2" + (i + 1);
                      $("#attachTd2").append("<div class='auto_file2 auto_file3'><input type='text' class='input_text' readonly='readonly' name='" + atchTdId + "'/></div>");
                      $(".input_text[name='" + atchTdId + "']").val(result[i].atchFileName);
                    }

                    // 파일 다운
                    $(".input_text").dblclick(
                      function() {
                        var oriFileName = $(this).val();
                        var fileGrpId;
                        var fileId;
                        for (var i = 0; i < result.length; i++) {
                          if (result[i].atchFileName == oriFileName) {
                            fileGrpId = result[i].atchFileGrpId;
                            fileId = result[i].atchFileId;
                          }
                        }
                        fn_atchViewDown(fileGrpId, fileId);
                    });
                  }
                }
              });

              function fn_atchViewDown(fileGrpId, fileId) {
            	    if (typeof fileGrpId == 'undefined') {
            	      return;
            	    }
            	    var data = {
            	      atchFileGrpId : fileGrpId,
            	      atchFileId : fileId
            	    };

            	    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do", data, function(result) {
            	      if (result == null){
            	        return;
            	      }
            	      var fileSubPath = result.fileSubPath;
            	      fileSubPath = fileSubPath.replace('\', ' / '');
            	      window.open("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
            	    });
            	  }



	    });
</script>

<article class="tap_area">
  <table class="type1">
    <!-- table start -->
    <caption>table</caption>
    <colgroup>
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
      <col style="width: 180px" />
      <col style="width: *" />
    </colgroup>
    <tbody>
      <tr>
        <th scope="row"><spring:message code="service.grid.counselingNo" /></th>
        <td ><span>${tagInfo.counselingNo}</span></td>
        <th scope="row"><spring:message code="service.title.inqCustNm" /></th>
        <td ><span>${tagInfo.custName}</span></td>
        <th scope="row"><spring:message code="service.title.inqMemTyp" /></th>
        <td ><span></span></td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.initMainDept" /></th>
        <td colspan="2">${tagInfo.inchgDeptName}</td>
        <th scope="row"><spring:message code="service.title.initSubDept" /></th>
        <td colspan="2">${tagInfo.subDeptName}</td>
      </tr>

       <tr>
        <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
        <td colspan="2">${tagInfo.supRefNo}</td>
        <th scope="row"><spring:message code="service.title.CustomerID" /></th>
        <td colspan="2">${tagInfo.custId}</td>
      </tr>


      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementTagRegisterDt" /></th>
        <td colspan="2">${tagInfo.tagRegisterDt}</td>
        <th scope="row"><spring:message code="supplement.text.supplementTagStus" /></th>
        <td colspan="2">${tagInfo.tagStatus}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="service.text.InChrDept" /></th>
        <td colspan="2">${tagInfo.inchgDeptName}</td>
        <th scope="row"><spring:message code="service.grid.subDept" /></th>
        <td colspan="2">${tagInfo.subDeptName}</td>
      </tr>
      <tr>
        <th scope="row"><spring:message code="supplement.text.supplementMainTopicInquiry" /></th>
        <td colspan="2">${tagInfo.mainTopic}</td>
        <th scope="row"><spring:message code="supplement.text.supplementSubTopicInquiry" /></th>
        <td colspan="2">${tagInfo.subTopic}</td>
      </tr>
      <tr>
          <td colspan="6"></td>
          </tr>
      <tr>
        <th scope="row"><spring:message code="service.title.carelineAttc" /></th>
         <td colspan="5" id="attachTd"><input type="hidden" id="atchFileGrpId" value="${tagInfo.supTagFlAttId1}">
         </td>
      </tr>

      <tr>
        <th scope="row"><spring:message code="service.title.hqAttc" /></th>
        <td colspan="5" id="attachTd2"><input type="hidden" id="atchFileGrpIdHQ" value="${tagInfo.supTagFlAttId2 }">
         </td>
      </tr>

    </tbody>
    </br>
  </table>

</article>
