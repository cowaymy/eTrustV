<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<html>
<script type="text/javascript">

    $(document).ready(function () {
    	
    	//Check Box
        var emgncyFlag = $("#emgncyFlag").val() == 'Y' ? true : false;

        if (emgncyFlag == true) {
            $("#emgncyFlag").attr("checked", true);
        }
    	
        fn_selectNoticeListAjax();

        $("#delete").click(function () {
            Common.confirm("Are you sure you want to delete?", fn_deleteNotice);
        });

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
    
  //Check Box
    function fn_checkbox() {
        if ($("#emgncyFlag").is(":checked")) {
            $("#emgncyFlag").val("Y");
        } else {
            $("#emgncyFlag").val("N");
        }
    }

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

    function fn_close() {
        $("#popClose").click();
        fn_selectNoticeListAjax();
    }


    function onlyNumber(obj) {
        $(obj).keyup(function () {
            $(this).val($(this).val().replace(/[^0-9]/g, ""));
        });
    }

    function fn_modifyNotice() {

        if (FormUtil.isEmpty($("#ntceSubject").val())) {
            Common.alert("<spring:message code='notice.alert.subject'/>");
            return false;
        }
        if (FormUtil.isEmpty($("#ntceCntnt").val())) {
            Common.alert("<spring:message code='notice.alert.content'/>");
            return false;
        }
        if (FormUtil.isEmpty($("#password").val())) {
            Common.alert("<spring:message code='notice.alert.password'/>");
            return false;
        }

        fn_checkbox();
        
        var formData = Common.getFormData("noticeForm");

        formData.append("ntceNo", $("#ntceNo").val());
        formData.append("crtUserId", $("#crtUserId").val());
        formData.append("fileGroupId", $("#fileGroupId").val());
        formData.append("updateFileIds", $("#updateFileIds").val());
        formData.append("deleteFileIds", $("#deleteFileIds").val());

        formData.append("ntceSubject", $("#ntceSubject").val());
        formData.append("emgncyFlag", $("#emgncyFlag").val());
        formData.append("password", $("#password").val());
        formData.append("ntceStartDt", $("#ntceStartDt").val());
        formData.append("ntceEndDt", $("#ntceEndDt").val());
        formData.append("ntceCntnt", $("#ntceCntnt").val());


        Common.ajaxFile("/notice/updateNotice.do", formData, function (result) {
            Common.alert(result.message);
            $("#popClose").click();
            fn_selectNoticeListAjax();
        });
    }

    function fn_deleteNotice() {

        if ($("#password").val() == '') {
            Common.alert("Please key in Password");
            return false;
        }

        Common.ajax("POST", "/notice/deleteNotice.do", $("#noticeForm").serializeJSON(), function (result) {

            Common.alert(result.message);
            $("#popClose").click();
            fn_selectNoticeListAjax();
        });
    }

</script>

<body>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1><spring:message code='notice.title.ViewNotice'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form action="#" id="noticeForm" name="noticeForm" enctype="multipart/form-data">
            <input type="hidden" id="ntceNo" name="ntceNo" value="${noticeInfo.ntceNo}">
            <input type="hidden" id="fileGroupId" name="fileGroupId" value="${noticeInfo.atchFileGrpId}">
            <input type="hidden" id="updateFileIds" name="updateFileIds" value="">
            <input type="hidden" id="deleteFileIds" name="deleteFileIds" value="">
            <input type="hidden" id="crtUserId" name="crtUserId" value="${noticeInfo.crtUserId}">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px"/>
                    <col style="width:*"/>
                    <col style="width:130px"/>
                    <col style="width:*"/>
                    <col style="width:130px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row"><spring:message code='sys.title.subject'/><span class="must">*</span></th>
                    <td colspan="5">
                        <input id="ntceSubject" name="ntceSubject" value="${noticeInfo.ntceSubject}" type="text"
                               title="" placeholder="" class="w100p"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='sys.title.writer'/></th>
                    <td>
                        <input id="rgstUserNm" value="${noticeInfo.rgstUserNm}" type="text" title="" placeholder=""
                               class="readonly w100p" readonly="readonly"/>
                    </td>
                    <th scope="row"><spring:message code='sys.title.issue'/> <spring:message code='sys.title.date'/></th>
                    <td>
                        <input id="crtDt" name="crtDt" value="${fn:substring(noticeInfo.crtDt,0,10)}" type="text"
                               title="" placeholder="" class="readonly w100p" readonly="readonly"/>
                    </td>
                    <th scope="row"><spring:message code='sys.title.read'/> <spring:message code='sys.title.count'/></th>
                    <td>
                        <input id="readCnt" name="readCnt" value="${noticeInfo.readCnt}" type="text" title=""
                               placeholder="" class="readonly w100p" readonly="readonly"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='notice.title.emergency'/></th>
                    <td>
                        <label><input id="emgncyFlag" name="emgncyFlag" value="${noticeInfo.emgncyFlag}"
                                      type="checkbox"/><span></span></label>
                    </td>
                    <th scope="row"><spring:message code='notice.title.password'/></th>
                    <td colspan="3">
                        <input id="password" name="password" type="password" value="${noticeInfo.password}" title=""
                               placeholder="" class=""/>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='notice.title.NoticePeriod'/></th>
                    <td colspan="5">

                        <div class="date_set"><!-- date_set start -->
                            <p><input id="ntceStartDt" name="ntceStartDt" value="${noticeInfo.ntceStartDt}" type="text"
                                      title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"/></p>
                            <span>To</span>
                            <p><input id="ntceEndDt" name="ntceEndDt" value="${noticeInfo.ntceEndDt}" type="text"
                                      title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"/></p>
                        </div><!-- date_set end -->

                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='notice.title.content'/><span class="must">*</span></th>
                    <td colspan="5">
                        <textarea id="ntceCntnt" name="ntceCntnt" cols="20" rows="30"
                                  style="margin: 0px 4px 0px 0px; width: 827px; height: 340px;">${noticeInfo.ntceCntnt}</textarea>
                    </td>
                </tr>
                </tbody>
            </table><!-- table end -->

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row" rowspan="2"><spring:message code='notice.title.AttachedFile'/></th>
                    <td>
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

                        <div class="auto_file2"><!-- auto_file start -->
                            <input title="file add" style="width: 300px;" type="file">
                            <label>
                                <input type='text' class='input_text' readonly='readonly' value="" data-id=""/>
                                <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
                            </label>
                            <span class='label_text'><a href='#'><spring:message code='sys.btn.add'/></a></span>
                            <span class='label_text'><a href='#'><spring:message code='sys.btn.delete'/></a></span>
                        </div>

</div><!-- auto_file end -->
</td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<!--
<ul class="left_btns">
    <li><p class="red_text">* 표시가 된 곳은 필수 입력입니다.</p></li>
</ul>
-->

<c:choose>
    <c:when test="${not empty noticeInfo.crtUserId && noticeInfo.rgstUserNm eq userName}">
        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_modifyNotice();"><spring:message code='notice.btn.modify'/></a></p></li>
            <li><p class="btn_blue2 big"><a href="#" id="delete"><spring:message code='sys.btn.delete'/></a></p></li>
        </ul>
    </c:when>
    <c:otherwise>
        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_close();"><spring:message code='notice.btn.list'/></a></p></li>
        </ul>
    </c:otherwise>
</c:choose>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>