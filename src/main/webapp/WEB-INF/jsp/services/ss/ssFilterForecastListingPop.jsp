<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
    $(document).ready(function() {
    	$("#exportType").val("PDF");
    });

    function fn_validation() {
        if ($("#forecastMonth").val() == '') {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='forecast month' htmlEscape='false'/>");
            return false;
        }

        return true;
    }

    function fn_openReport() {
        if (fn_validation()) {
            var date = new Date();
            var month = date.getMonth() + 1;
            var day = date.getDate();
            if (date.getDate() < 10) {
                day = "0" + date.getDate();
            }
            var forecastDt2 = $("#forecastMonth").val().substring(0, 2) + "/"+ $("#forecastMonth").val().substring(3, 7);

            $("#ssFilterForm #reportFileName").val('/services/SSFilterForecastListing.rpt');
            $("#ssFilterForm #reportDownFileName").val("SSFilterForecast_" + month + date.getFullYear());
            $("#ssFilterForm #V_FORECASTDATE").val(forecastDt2);
            $("#ssFilterForm #viewType").val("PDF");
            var option = {
                isProcedure : true,
            };

            Common.report("ssFilterForm", option);
        }
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form') {
                return $(':input', this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea') {
                this.value = '';
            } else if (type === 'checkbox' || type === 'radio') {
                this.checked = false;
            } else if (tag === 'select') {
                this.selectedIndex = -1;
            }
        });
    };
</script>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1><spring:message code='service.title.ssFilterForecastListing'/></h1>
        <ul class="right_opt">
            <li>
              <p class="btn_blue2">
                  <a href="#"><spring:message code='sys.btn.close' /></a>
              </p>
            </li>
        </ul>
    </header>
    <section class="pop_body">
        <section class="search_table">
            <form action="#" method="post" id="ssFilterForm">
                <input type="hidden" id="V_FORECASTDATE" name="V_FORECASTDATE" />
                <input type="hidden" id="reportFileName" name="reportFileName" />
                <input type="hidden" id="viewType" name="viewType" />
                <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />

                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 170px" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><spring:message code='service.text.forecastMonth'/></th>
                            <td>
                               <input type="text" title="" class="j_date2" id="forecastMonth" name="forecastMonth" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <ul class="center_btns">
                    <li>
                        <p class="btn_blue2 big">
                            <a href="#" onclick="javascript:fn_openReport()"><spring:message code='service.btn.Generate' /></a>
                        </p>
                    </li>
                    <li>
                        <p class="btn_blue2 big">
                            <a href="#" id="clearbtn" onclick="javascript:$('#ssFilterForm').clearForm();"><spring:message code='service.btn.Clear' /></a>
                        </p>
                    </li>
                </ul>
            </form>
        </section>
    </section>
</div>


