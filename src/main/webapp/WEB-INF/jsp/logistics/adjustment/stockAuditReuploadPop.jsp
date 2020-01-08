<!--=================================================================================================
* Task  : Logistics
* File Name : stockAuditReuploadPop.jsp
* Description : Stock Audit File Reupload
* Author : KR-OHK
* Date : 2019-10-23
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-23 KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

	$(document).ready(function () {

		$("input[name=attachFile]").on("dblclick", function () {

            Common.showLoader();

            var $this = $(this);
            var fileId = $this.attr("data-id");

            $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
                httpMethod: "POST",
                contentType: "application/json;charset=UTF-8",
                data: {
                    fileId: fileId
                },
                failCallback: function (responseHtml, url, error) {
                    Common.alert($(responseHtml).find("#errorMessage").text());
                }
            })
                .done(function () {
                    Common.removeLoader();
                    console.log('File download a success!');
                })
                .fail(function () {
                    Common.removeLoader();
                });
            return false; //this is critical to stop the click event which will trigger a normal file download
        });
	});


  $("#fileUp").click(function() {

		var flleName = "";
        var arrFileName = new Array();

        $.each($(".auto_file2"), function(){
            fileName = $(this).find(":text").val();
            if(FormUtil.isNotEmpty(fileName)) {
                arrFileName.push(fileName);
            }
        });

        if(arrFileName.length == 0) {
            var arg = "<spring:message code='log.head.groupwareAppAttFile' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        var obj = $("#appv1Form").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditDocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
                	if(Common.confirm("Groupware approve attach file?", function(){
                		 var formData = Common.getFormData("appv1Form");

                	     formData.append("atchFileGrpId", $("#atchFileGrpId").val());
                	     formData.append("updateFileIds", $("#updateFileIds").val());
                	     formData.append("deleteFileIds", $("#deleteFileIds").val());

                	     Common.ajaxFile("/logistics/adjustment/uploadGroupwareFile.do", formData, function(result) {
                            console.log(result);
                            $("#atchFileGrpId").val(result.data);
                            fn_save();
                        });
                    }));
                }
            }
       });
    });

	function fn_save() {

		var obj = $("#appv1Form").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.appvType = "comp";

        Common.ajax("POST", "/logistics/adjustment/saveDocAppvInfo.do", obj, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
        	$("#hidResultCode").val(result.code);
            Common.alert(result.message);
            $("#close").click();
        });
    }

	$("#close").click(function() {
		var resultCode = $("#hidResultCode").val();
		$("#popup_wrap_file").remove();

		if(resultCode == '00') { // Other GI / GR
	        $("#popup_wrap").remove();
	        getListAjax(1);
		}
    });

	//common_pub.js 에서 파일 change 이벤트 발생시 호출됨...
    function fn_abstractChangeFile(thisfakeInput) {
        // modyfy file case
        if (FormUtil.isNotEmpty(thisfakeInput.attr("data-id"))) {
            var updateFileIds = $("#updateFileIds").val();
            $("#updateFileIds").val(thisfakeInput.attr("data-id") + DEFAULT_DELIMITER + updateFileIds);
        }
    }

    //common_pub.js 에서 파일 delete 이벤트 발생시 호출됨...
    function fn_abstractDeleteFile(thisfakeInput) {
        // modyfy file case
        if (FormUtil.isNotEmpty(thisfakeInput.attr("data-id"))) {
            var deleteFileIds = $("#deleteFileIds").val();
            $("#deleteFileIds").val(thisfakeInput.attr("data-id") + DEFAULT_DELIMITER + deleteFileIds);
        }
    }
</script>

<div id="popup_wrap_file" class="popup_wrap">
   <!-- popup_wrap start -->
   <header class="pop_header">
    <!-- pop_header start -->
    <h1><spring:message code='log.title.updFile' /></h1>
    <ul class="right_opt">
     <li><p class="btn_blue2"><a id="close"><spring:message code='sys.btn.close' /></a></p></li>
    </ul>
   </header>
   <!-- pop_header end -->
   <section class="pop_body">
    <!-- pop_body start -->

    <form id="appv1Form" name="appv1Form" enctype="multipart/form-data">
      <input type="hidden" id="hidStockAuditNo" name="hidStockAuditNo" value="${docInfo.stockAuditNo}">
      <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="${docInfo.atchFileGrpId}">
      <input type="hidden" id="updateFileIds" name="updateFileIds" value="">
      <input type="hidden" id="deleteFileIds" name="deleteFileIds" value="">
      <input type="hidden" id="hidResultCode" name="hidResultCode" value="">
      <input type="hidden" id="hidUpdDtTime" name="hidUpdDtTime" value="${docInfo.updDtTime}">
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 160px" />
       <col style="width: *" />
       <col style="width: 160px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
        <tr>
            <th scope="row"><spring:message code='log.head.groupwareAppAttFile'/><span class="must">*</span></th>
            <td colspan='3'>

                <c:forEach var="fileInfo" items="${files}" varStatus="status">
                <div class="auto_file2"><!-- auto_file start -->
                   <input title="file add" style="width: 300px;" type="file">
                   <label>
                       <input type='text' class='input_text' readonly='readonly' name="attachFile"
                              value="${fileInfo.atchFileName}" data-id="${fileInfo.atchFileId}"/>
                       <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
                   </label>
                   <span class='label_text'><a href='#'><spring:message code='sys.btn.add'/></a></span>
                   <span class='label_text'><a href='#'><spring:message code='sys.btn.delete'/></a></span>
                </div>
                </c:forEach>

            </td>
        </tr>
      </tbody>
     </table>
     <!-- table end -->
    </form>
    <ul class="center_btns">
     <li><p class="btn_blue2 big"><a id="fileUp">Save</a></p></li>
    </ul>
   </section>
   <!-- pop_body end -->
  </div>
