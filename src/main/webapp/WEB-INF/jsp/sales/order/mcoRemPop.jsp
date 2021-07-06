<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    $(document).ready(function() {
        console.log("mcoRemPop");
        createAUIGrid();
        fn_selMcoRem();

        /*
        Common.ajax("GET", "/sales/order/selectMCORemarkList.do", {salesOrderId : $("#salesOrdId").val()}, function(result) {
            console.log(result);
            AUIGrid.setGridData(mcoRemarkGridID2, result);
        });
        */
    });

    var mcoRemarkGridID, mcoRemarkGridID2;
    var salesOrderId = '${salesOrdId}';

    function createAUIGrid() {
        var columnLayout = [
            {
                headerText : 'Yes/No',
                dataField : "flag",
                width : 150
            }, {
                headerText : 'Remark',
                dataField : "remark",
                width : 355
            }, {
                headerText : 'Creator',
                dataField : "userName",
                width : 180
            }, {
                headerText : 'Create Date',
                dataField : "crtDt",
                width : 180
            }];

        var gridPros = {
                usePaging : true,
                pageRowCount : 20,
                editable : false,
                showRowNumColumn : true,
                showStateColumn : false,
                wordWrap : true
            };

        //mcoRemarkGridID = GridCommon.createAUIGrid("#grid_wrap_remList", columnLayout, "", gridPros);
        mcoRemarkGridID2 = GridCommon.createAUIGrid("grid_mcoRemark_wrap1", columnLayout, "", gridPros);
    }

    function fn_selMcoRem() {
        if($("#salesOrdId").val() == "")
            $("#salesOrdId").val(salesOrderId);

        Common.ajax("GET", "/sales/order/selectMCORemarkList.do", {salesOrderId : $("#salesOrdId").val()}, function(result) {
            console.log(result);
            AUIGrid.setGridData(mcoRemarkGridID2, result);
        });
    }

    function fn_saveConfirm() {
        if($("#remark").val() == "") {
            Common.alert("Remark cannot be empty!");
            return;
        }

        fn_saveRem();
    }

    function fn_saveRem() {
        Common.ajax("POST", "/sales/order/saveMcoRem.do", $("#addRemForm").serializeJSON(), function(result) {
            $("#agreeFlg").val("-");
            $("#remark").val("");
            fn_selMcoRem();
        });
    }

</script>

<div id="popup_wrap" class="popup_wrap">
    <header class="pop_header">
        <h1>New MCO Remark</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2">
                <a href="#"><spring:message code='sys.btn.close' /></a>
            </p></li>
        </ul>
    </header>

    <section class="pop_body">
        <!-- acodi_wrap start -->
        <div>

</div>

        <article class="acodi_wrap">
            <dl>
                <dt class="click_add_on on">
                    <a href="#">MCO Remarks Information & Transaction</a>
                </dt>
                <dd>
                <!--
                    <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width: 140px" />
                            <col style="width: *" />
                            <col style="width: 140px" />
                            <col style="width: *" />
                        </colgroup>

                        <tbody>
                            <tr>
                                <th scope="row"><spring:message code='service.title.Creator' /></th>
                                <td>
                                    <span><c:out value="${orderCall.crtUserId}" /></span>
                                </td>
                                <th scope="row"><spring:message code='service.title.CreateDate' /></th>
                                <td>
                                    <span><c:out value="${orderCall.crtDt}" /> </span>
                                </td>
                                <th scope="row"><spring:message code='service.title.CreateTime' /></th>
                                <td>
                                    <span><c:out value="${orderCall.crtTm}"/> </span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code='service.title.UpdateDate' /></th>
                                <td><span><c:out value="${firstCallLog[0].callDt}" /> </span></td>
                                <th scope="row"><spring:message code='service.title.UpdateTime' /></th>
                                <td>
                                    <span><c:out value="${firstCallLog[0].callTm}"/> </span>
                                </td>
                            </tr>
                            <tr>
                            </tr>
                        </tbody>
                    </table>
                     -->
                    <!--
                    <article class="grid_wrap mt20">
                        <div id="grid_wrap_remList" style="width: 100%; height: 250px; margin: 0 auto;"></div>
                    </article> -->
                    <article class="grid_wrap">
                        <div id="grid_mcoRemark_wrap1" style="width:100%; height:250px; margin:0 auto;"></div>
                    </article>
                </dd>
                <dt class="click_add_on">
                    <a href="#"><spring:message code='service.title.OrderFullDetails' /></a>
                </dt>
                <dd>
                    <!------------------------------------------------------------------------------
                        Order Detail Page Include START
                    ------------------------------------------------------------------------------->
                    <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
                    <!------------------------------------------------------------------------------
                        Order Detail Page Include END
                    ------------------------------------------------------------------------------->
                </dd>
            </dl>
        </article>
        <!-- acodi_wrap end -->

        <aside class="title_line mt20" id="hideContent4">
            <h2>New MCO Remark</h2>
        </aside>
        <form action="#" id="addRemForm">
            <input type="hidden" value='${salesOrdId}' id="salesOrdId" name="salesOrdId" />

            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width: 130px" />
                    <col style="width: *" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Agree to Proceed</th>
                        <td>
                            <select class="w100p" id="agreeFlg" name="agreeFlg">
                                <option value="-">Choose One</option>
                                <option value="0">No</option>
                                <option value="1">Yes</option>
                                <option value="2">Unreachable</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='service.title.Remark' /></th>
                        <td>
                            <textarea cols="20" rows="5" placeholder="Remark" id="remark" name="remark"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>

        <div id='sav_div'>
            <ul class="center_btns">
                <li>
                    <p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()">Save</a></p>
                </li>
                <li>
                    <p class="btn_blue2 big"><a href="#">Clear</a></p>
                </li>
            </ul>
        </div>
    </section>
</div>
<!-- popup_wrap end -->
