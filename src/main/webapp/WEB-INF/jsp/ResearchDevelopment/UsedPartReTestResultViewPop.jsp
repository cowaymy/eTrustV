<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    $(document).ready(
            function() {

            	$("#defEvt_div").attr("style", "display:block");

                $("#dscCode").val("${DSC_CODE}");
                $("#PROD_CDE").val("${STK_CODE}");

                doGetCombo('/ResearchDevelopment/selectCTList.do', '', $("#TEST_UP_CT").val(), 'cmbCtList', 'S', '');
                fn_getTestResultInfo();

                fn_DisablePageControl(); // DISABLE ALL THE FIELD

    });

    function fn_DisablePageControl() {
        $("#ddlStatus").attr("disabled", true);
        $("#dpSettleDate").attr("disabled", true);
        $("#tpSettleTime").attr("disabled", true);
        $("#ddlDSCCode").attr("disabled", true);
        $("#cmbCtList").attr("disabled", true);
        $("#ddlProdGenuine").attr("disabled", true);
        $("#txtTestResultRemark").attr("disabled", true);
        $("#manufacDate").attr("disabled", true);

        $("#def_code").attr("disabled", true);
        $("#def_def").attr("disabled", true);
        $("#def_part").attr("disabled", true);
        $("#def_type").attr("disabled", true);
        $("#solut_code").attr("disabled", true);

        $("#def_code_text").attr("disabled", true);
        $("#def_def_text").attr("disabled", true);
        $("#def_part_text").attr("disabled", true);
        $("#def_type_text").attr("disabled", true);
        $("#solut_code_text").attr("disabled", true);

        $("#def_def_id").attr("disabled", true);

        $("#btnSaveDiv").attr("style", "display:none");
    }


    function fn_getTestResultInfo() {
        Common.ajax("GET", "/ResearchDevelopment/getTestResultInfo.do", $("#resultUPForm").serialize(), function(result) {

            $("#txtResultNo").text(result[0].testResultNo);
            $("#ddlStatus").val(result[0].testUpStus);
            $("#dpSettleDate").val(result[0].testUpSetlDt);
            $("#tpSettleTime").val(result[0].testUpSetlTm);
            $("#ddlProdGenuine").val(result[0].testUpGne);
            $("#manufacDate").val(result[0].testMnfDt);
            $("#txtTestResultRemark").val(result[0].testUpRem);

            $("#def_part").val(result[0].defectCodeDp);
            $("#def_part_id").val(result[0].defectIdDp);
            $("#def_part_text").val(result[0].defectDescDp);

            $("#def_def").val(result[0].defectCodeDd);
            $("#def_def_id").val(result[0].defectIdDd);
            $("#def_def_text").val(result[0].defectDescDd);

            $("#def_code").val(result[0].defectCodeDc);
            $("#def_code_id").val(result[0].defectIdDc);
            $("#def_code_text").val(result[0].defectDescDc);

            $("#def_type").val(result[0].defectCodeDt);
            $("#def_type_id").val(result[0].defectIdDt);
            $("#def_type_text").val(result[0].defectDescDt);

            $("#solut_code").val(result[0].defectCodeSc);
            $("#solut_code_id").val(result[0].defectIdSc);
            $("#solut_code_text").val(result[0].defectDescSc);

          });
    };

</script>
<div id="popup_wrap" class="popup_wrap">
    <!-- popup_wrap start -->
    <section id="content">
        <!-- content start -->
        <form id="resultUPForm" method="post">
            <div style="display: none">
                <input type="text" name="PROD_CDE" id="PROD_CDE" />
                <input type="text" name="TEST_RESULT_NO" id="TEST_RESULT_NO" value="${TEST_RESULT_NO}" />
                <input type="text" name="DSC_CODE" id="DSC_CODE" value="${DSC_CODE}" />
                <input type="text" name="TEST_RESULT_ID" id="TEST_RESULT_ID" value="${TEST_RESULT_ID}" />
                <input type="text" name="TEST_UP_CT" id="TEST_UP_CT" value="${CT_CODE}" />
            </div>
        </form>
        <header class="pop_header">
            <!-- pop_header start -->
            <h1><spring:message code='rnd.title.viewUsedPartTestRst' /></h1>
            <ul class="right_opt">
                <li><p class="btn_blue2">
                        <a href="#"><spring:message code='sys.btn.close' /></a>
                    </p></li>
            </ul>
        </header>
        <!-- pop_header end -->
        <form id="resultUPAllForm" method="post">
            <section class="pop_body">
                <!-- pop_body start -->
                <aside class="title_line">
                    <h3 class="red_text">
                        <spring:message code='service.msg.msgFillIn' />
                    </h3>
                </aside>
                <article class="acodi_wrap">
                    <dl>
                        <dt class="click_add_on on">
                            <a href="#"><spring:message code='service.title.asRstDtl' /></a>
                        </dt>
                        <dd>
                            <table class="type1">
                                <!-- table start -->
                                <caption>table</caption>
                                <colgroup>
                                    <col style="width: 160px" />
                                    <col style="width: *" />
                                    <col style="width: 110px" />
                                    <col style="width: *" />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row"><spring:message code='service.grid.ResultNo' /></th>
                                        <td><span id='txtResultNo'></span></td>
                                        <th scope="row"><spring:message code='sys.title.status' /></th>
                                        <td><select class="w100p" id="ddlStatus" name="ddlStatus">
                                                <option value=""><spring:message code='sal.combo.text.chooseOne' /></option>
                                                <option value="4">Complete</option>
                                        </select></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.grid.SettleDate' />
                                        <span id='m2' name='m2' class="must" style="display: none">*</span></th>
                                        <td><input type="text" title="Create start Date" id='dpSettleDate' name='dpSettleDate'
                                            placeholder="DD/MM/YYYY" class="readonly j_date" disabled="disabled" /></td>
                                       <th scope="row">
                                        <spring:message code='service.grid.SettleTm' />
                                        <span id='m4' name='m4' class="must" style="display: none">*</span></th>
                                        <td>
                                            <div class="time_picker">
                                                <input type="text" title="" placeholder="Settle Time" id='tpSettleTime' name='tpSettleTime'
                                                    class="readonly time_date" disabled="disabled" />
                                                <ul>
                                                    <li><spring:message code='service.text.timePick' /></li>
                                                    <c:forEach var="list" items="${timePick}" varStatus="status">
                                                        <li><a href="#">${list.codeName}</a></li>
                                                    </c:forEach>
                                                </ul>
                                            </div> <!-- time_picker end -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.title.DSCCode' />
                                        <span id='m5' name='m5' class="must" style="display: none">*</span></th>
                                        <td>
                                          <input type="text" title="" placeholder="" class="readonly"
                                            disabled="disabled" id='dscCode' name='dscCode' />
                                        </td>
                                        <th scope="row"><spring:message code='service.grid.CTCode' />
                                            <span id='m7' name='m7' class="must" style="display: none">*</span></th>
                                            <td><select class="w100p" id="cmbCtList" name="cmbCtList"></select></td>
                                   </tr>

                                    <tr>
                                        <th scope="row">Product Genuine
                                            <span id='m17' name='m17' class="must" style="display: none">*</span></th>
                                        <td><select id='ddlProdGenuine' name='ddlProdGenuine' class="w100p">
                                            <option value="">Choose One</option>
                                            <option value="Genuine">Genuine</option>
                                            <option value="Non Genuine">Non Genuine</option>
                                        </select></td>


                                        <th scope="row">Manufacturing Date
                                        <span id='m18' name='m18' class="must" style="display: none">*</span></th>
                                        <td><input type="text" title="Manufacturing Date" id='manufacDate' name='manufacDate'
                                            placeholder="DD/MM/YYYY" class="readonly j_date" /></td>

                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.title.Remark' />
                                        <span id='m14' name='m14' class="must" style="display: none">*</span></th>
                                        <td colspan="3">
                                        <textarea cols="20" rows="5" placeholder="remark" id='txtTestResultRemark' name='txtTestResultRemark'></textarea></td>
                                    </tr>
                                </tbody>
                            </table>
                        </dd>

                        <dt class="click_add_on" id='defEvt_dt'">
                            <a href="#"><spring:message code='service.title.asDefEnt' /></a>
                        </dt>
                        <dd id='defEvt_div'>
                            <table class="type1">
                                <!-- table start -->
                                <caption>table</caption>
                                <colgroup>
                                    <col style="width: 140px" />
                                    <col style="width: *" />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row"><spring:message code='service.text.defPrt' />
                                        <span id='m11' name='m11' class="must" >*</span></th>
                                        <td>
                                        <input type="text" title="" placeholder="" disabled="disabled" id='def_part' name='def_part' class=""
                                            onblur="fn_getASReasonCode2(this, 'def_part' ,'305')" onkeyup="this.value = this.value.toUpperCase();" /> <a
                                            class="search_btn" id="DP">
                                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
                                            alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_part_id' name='def_part_id' class="" />
                                        <input type="text" title="" placeholder="" id='def_part_text' name='def_part_text' class="" disabled style="width: 60%;" /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message code='service.text.dtlDef' />
                                        <span id='m12' name='m12' class="must">*</span></th>
                                        <td><input type="text" title="" placeholder="" disabled="disabled" id='def_def' name='def_def' class=""
                                            onblur="fn_getASReasonCode2(this, 'def_def'  ,'304')" onkeyup="this.value = this.value.toUpperCase();" />
                                        <a class="search_btn" id="DD">
                                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
                                                alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_def_id' name='def_def_id' class="" />
                                        <input type="text" title="" placeholder="" id='def_def_text' name='def_def_text' class="" disabled style="width: 60%;" /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"><spring:message  code='service.text.defCde' />
                                        <span id='m10' name='m10' class="must">*</span></th>
                                        <td><input type="text" title="" placeholder="" disabled="disabled" id='def_code' name='def_code' class=""
                                            onblur="fn_getASReasonCode2(this, 'def_code', '303')" onkeyup="this.value = this.value.toUpperCase();" />
                                        <a class="search_btn" id="DC">
                                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif"
                                            alt="search" /></a> <input type="hidden" title="" placeholder="" id='def_code_id' name='def_code_id' class="" />
                                        <input type="text" title="" placeholder="" id='def_code_text' name='def_code_text' class="" disabled style="width: 60%;" /></td>
                                    </tr>

                                    <tr>
                                            <th scope="row"><spring:message code='service.text.defTyp' /><span id='m9' name='m9' class="must" style="display:none">*</span></th>
                                        <td>
                                            <input type="text" title="" id='def_type' name='def_type' placeholder="" disabled="disabled"  class="" onblur="fn_getASReasonCode2(this, 'def_type' ,'387')" onkeyup="this.value = this.value.toUpperCase();"/>
                                            <a class="search_btn" id="HDT"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                                            <input type="hidden" title="" id='def_type_id' name='def_type_id' placeholder="" class="" />
                                            <input type="text" title="" placeholder="" id='def_type_text' name='def_type_text' class="" disabled style="width:60%;"/>
                                        </td>
                                    </tr>

                                    <tr>
                                            <th scope="row"><spring:message code='service.text.sltCde' /><span id='m13' name='m13' class="must" style="display:none">*</span></th>
                                        <td>
                                            <input type="text" title="" placeholder="" class="" disabled="disabled" id='solut_code' name='solut_code' onblur="fn_getASReasonCode2(this, 'solut_code'  ,'337')" onkeyup="this.value = this.value.toUpperCase();"/>
                                            <a class="search_btn" id="HSC"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                                            <input type="hidden" title="" placeholder="" class="" id='solut_code_id' name='solut_code_id' />
                                            <input type="text" title="" placeholder="" class="" id='solut_code_text' name='solut_code_text' disabled style="width:60%;"/>
                                        </td>
                                    </tr>

                                </tbody>
                            </table>
                        </dd>
                        </dl>
                </article>
                 <!-- pop_body end -->
            </section>
        </form>
    </section>
</div>