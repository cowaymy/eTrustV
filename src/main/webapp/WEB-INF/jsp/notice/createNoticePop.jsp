<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script>

    function fn_saveNewNotice() {

        if (FormUtil.isEmpty($("#ntceSubject").val())) {
            Common.alert("Please key in Subject");
            return false;
        }
        if (FormUtil.isEmpty($("#ntceCntnt").val())) {
            Common.alert("Please key in Content");
            return false;
        }


        var formData = Common.getFormData("insertNoticeForm");
        formData.append("emgncyFlag", $("#emgncyFlag").val());
        formData.append("ntceSubject", $("#ntceSubject").val());
        formData.append("rgstUserNm", $("#rgstUserNm").val());
        formData.append("password", $("#password").val());
        formData.append("ntceStartDt", $("#ntceStartDt").val());
        formData.append("ntceEndDt", $("#ntceEndDt").val());
        formData.append("ntceCntnt", $("#ntceCntnt").val());

        Common.ajaxFile("/notice/insertNotice.do", formData, function (result) {
            $("#popClose").click();
            fn_selectNoticeListAjax();
            Common.setMsg("<spring:message code='sys.msg.success'/>");
        }, function (jqXHR, textStatus, errorThrown) {
            Common.alert("<spring:message code='sys.msg.fail'/>");
            Common.setMsg("<spring:message code='sys.msg.fail'/>");
        });

    }

    function onlyNumber(obj) {
        $(obj).keyup(function () {
            $(this).val($(this).val().replace(/[^0-9]/g, ""));
        });
    }

    function fn_checkbox() {
        if ($("#emgncyFlagCheck").is(":checked")) {
            $("#emgncyFlag").val("Y");
        } else {
            $("#emgncyFlag").val("N");
        }
    }

    function fn_close() {
        $("#popClose").click();
    }

    function setInputFile2() {//인풋파일 세팅하기
        $(".auto_file2").append("<label><input type='text' class='input_text' readonly='readonly' /><span class='label_text'><a href='#'>File</a></span></label><span class='label_text'><a href='#'>Add</a></span><span class='label_text'><a href='#'>Delete</a></span>");
    }

    setInputFile2();

    $(document).on(//인풋파일 삭제
        "click", ".auto_file2 a:contains('Delete')", function () {
            var fileNum = $(".auto_file2").length;

            if (fileNum <= 1) {

            } else {
                $(this).parents(".auto_file2").remove();
            }

            return false;
        });

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>New Notice</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->

        <form id="insertNoticeForm" name="insertNoticeForm" method="post" enctype="multipart/form-data">
            <input type="hidden" name="emgncyFlag" id="emgncyFlag" value="N">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px"/>
                    <col style="width:*"/>
                    <col style="width:130px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row"><spring:message code='sys.title.subject'/><span class="must">*</span></th>
                    <td colspan="3">
                        <input id="ntceSubject" name="ntceSubject" type="text" title="" placeholder="Subject"
                               class="w100p"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='sys.title.writer'/></th>
                    <td colspan="3">
                        <input id="rgstUserNm" name="rgstUserNm" value="${userName}" type="text" title="" placeholder=""
                               class="readonly w100p" readonly="readonly"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Emergency</th>
                    <td>
                        <label><input id="emgncyFlagCheck" type="checkbox"
                                      onclick="javascript:fn_checkbox();"/><span></span></label>
                    </td>
                    <th scope="row">Password</th>
                    <td>
                        <input id="password" name="password" type="password" onkeydown="onlyNumber(this)" title=""
                               placeholder="Number Only" class="w100p"/>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Notice Period</th>
                    <td colspan="3">

                        <div class="date_set"><!-- date_set start -->
                            <p><input id="ntceStartDt" name="ntceStartDt" type="text" title="Create start Date"
                                      placeholder="DD/MM/YYYY" class="j_date"/></p>
                            <span>To</span>
                            <p><input id="ntceEndDt" name="ntceEndDt" type="text" title="Create end Date"
                                      placeholder="DD/MM/YYYY" class="j_date"/></p>
                        </div><!-- date_set end -->

                    </td>
                </tr>
                <tr>
                    <th scope="row">Contents<span class="must">*</span></th>
                    <td colspan="3">
                        <textarea id="ntceCntnt" name="ntceCntnt" cols="20" rows="30"
                                  style="margin: 0px 4px 0px 0px; width: 827px; height: 340px;"></textarea>
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
                    <th scope="row" rowspan="2">Attached File</th>
                    <td>
                        <div class="auto_file2 attachment_file w100p"><!-- auto_file start -->
                            <input type="file" title="file add" style="width:300px"/>
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

        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a onclick="javascript:fn_saveNewNotice();">Save</a></p></li>
            <li><p class="btn_blue2 big"><a onclick="javascript:fn_close();">Cancel</a></p></li>
        </ul>

    </section><!-- pop_body end -->

</div>
<!-- popup_wrap end -->

