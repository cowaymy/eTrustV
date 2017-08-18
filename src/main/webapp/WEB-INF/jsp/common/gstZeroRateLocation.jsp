<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javaScript">

    var locationGridId;
    var gridColumnLayout = [{
        dataField: "zrLocId",
        headerText: "<spring:message code='sys.title.location' /> <spring:message code='sys.info.id' />"
    }, {
        dataField: "name",
        headerText: "<spring:message code='sys.title.state' /> <spring:message code='sys.title.name' />"
    }, {
        dataField: "areaName",
        headerText: "<spring:message code='sys.title.area' /> <spring:message code='sys.title.name' />"
    }, {
        dataField: "postCode",
        headerText: "<spring:message code='sys.title.post.code' />"
    }, {
        dataField: "stusCodeName",
        headerText: "<spring:message code='sys.title.status' />"
    }];

    $(function () {

        locationGridId = GridCommon.createAUIGrid("locationGridId", gridColumnLayout, "", "");

        var calback = function () {
            $('#sStateCode').on("change", function () {
                var $this = $(this);

                CommonCombo.initById("sSubAreaCode");

                if (FormUtil.isNotEmpty($this.val())) {

                    CommonCombo.make("sSubAreaCode", "/common/getSubAreaList.do", {
                        areaStusId: 1,
                        areaStateId: $this.val()
                    }, "", {
                        id: "areaId",
                        name: "areaName"
                    });

                }
            });
        };

        CommonCombo.make("sStateCode", "/common/getStateCodeList.do", {stusCodeId: 1}, "", {
            id: "stateId",
            name: "name"
        }, calback);

        $("#btnSearch").on("click", function () {
            fn_getZRLocationList();
        });

        $("#btnClear").on("click", function () {
            fn_initSearch();
        });

        $("#btnDel").on("click", function () {
            fn_deleteRow();
        });

        $("#btnAdd").on("click", function () {
            fn_addRow();
        });

        $("#btnSave").on("click", function () {
            fn_save();
        });

    });

    function fn_initSearch() {
        $("#sLocationId").val("");
        $("#sStateCode").val("");
        CommonCombo.initById("sSubAreaCode");
        $("#sPostCode").val("");
        $("#sStatus").multipleSelect("checkAll");
    }

    function fn_getZRLocationList() {
        Common.ajax("GET", "/common/getZRLocationList.do", $("#searchForm").serialize(), function (data) {
            AUIGrid.setGridData(locationGridId, data);
        });
    }

    function fn_deleteRow(){

    }

    function fn_addRow() {
        // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
        AUIGrid.addRow(locationGridId, "", "first");
    }

    function fn_save() {

    }
</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>System</li>
        <li>GST Zero Rate Location</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="javascript:void(0);" class="click_add_on">My menu</a></p>
        <h2>GST Zero Rate Location Search</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:void(0);" id="btnSearch"><span class="search"></span>Search</a>
            </p></li>
            <li><p class="btn_blue"><a href="javascript:void(0);" id="btnClear"><span class="clear"></span>Clear</a></p>
            </li>
        </ul>
    </aside><!-- title_line end -->


    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" name="searchForm" action="" method="post">

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
                    <th scope="row">Location ID</th>
                    <td>
                        <input type="text" title="" placeholder="Location ID" class="w100p" id="sLocationId"
                               name="zrLocId"/>
                    </td>
                    <th scope="row">State Name</th>
                    <td>
                        <select class="w100p" id="sStateCode" name="zrLocStateId">
                        </select>
                    </td>
                    <th scope="row">Area Name</th>
                    <td>
                        <select class="w100p" id="sSubAreaCode" name="areaId">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Post Code</th>
                    <td>
                        <input type="text" title="" placeholder="Post Code" class="w100p" id="sPostCode"
                               name="postCode"/>
                    </td>
                    <th scope="row">Status</th>
                    <td colspan="3">
                        <select class="multy_select" multiple="multiple" id="sStatus" name="zrLocStusId">
                            <option value="1" selected>Active</option>
                            <option value="8" selected>InActive</option>
                        </select>
                    </td>
                </tr>
                </tbody>
            </table><!-- table end -->

            <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
                <p class="show_btn"><a href="javascript:void(0);"><img
                        src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show"/></a>
                </p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                        <ul class="btns">
                            <li><p class="link_btn"><a href="javascript:void(0);">menu1</a></p></li>
                            <li><p class="link_btn"><a href="javascript:void(0);">menu2</a></p></li>
                            <li><p class="link_btn"><a href="javascript:void(0);">menu3</a></p></li>
                            <li><p class="link_btn"><a href="javascript:void(0);">menu4</a></p></li>
                            <li><p class="link_btn"><a href="javascript:void(0);">Search Payment</a></p></li>
                            <li><p class="link_btn"><a href="javascript:void(0);">menu6</a></p></li>
                            <li><p class="link_btn"><a href="javascript:void(0);">menu7</a></p></li>
                            <li><p class="link_btn"><a href="javascript:void(0);">menu8</a></p></li>
                        </ul>
                        <ul class="btns">
                            <li><p class="link_btn type2"><a href="javascript:void(0);">menu1</a></p></li>
                            <li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
                            <li><p class="link_btn type2"><a href="javascript:void(0);">menu3</a></p></li>
                            <li><p class="link_btn type2"><a href="javascript:void(0);">menu4</a></p></li>
                            <li><p class="link_btn type2"><a href="javascript:void(0);">Search Payment</a></p></li>
                            <li><p class="link_btn type2"><a href="javascript:void(0);">menu6</a></p></li>
                            <li><p class="link_btn type2"><a href="javascript:void(0);">menu7</a></p></li>
                            <li><p class="link_btn type2"><a href="javascript:void(0);">menu8</a></p></li>
                        </ul>
                        <p class="hide_btn"><a href="javascript:void(0);"><img
                                src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
                                alt="hide"/></a>
                        </p>
                    </dd>
                </dl>
            </aside><!-- link_btns_wrap end -->

        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                <li><p class="btn_grid"><a href="javascript:void(0);" id="btnDel"><spring:message code='sys.btn.del'/></a></p></li>
                <li><p class="btn_grid"><a href="javascript:void(0);" id="btnAdd"><spring:message code='sys.btn.add'/></a></p></li>
                <li><p class="btn_grid"><a href="javascript:void(0);" id="btnSave"><spring:message code='sys.btn.save'/></a></p></li>
            </c:if>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="locationGridId"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>
<!-- content end -->
