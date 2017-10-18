<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javaScript">

//    sys.label.role : Role
//    sys.label.role.id : Role ID
//    sys.label.keyword : Keyword
//    sys.label.status : Status
//    sys.label.level : Level

    var roleGridId;

    var sRole = "<spring:message code='sys.label.role' />";
    var sRoleId = "<spring:message code='sys.label.role.id' />";
    var sKeyword = "<spring:message code='sys.label.keyword' />";
    var sStatus = "<spring:message code='sys.label.status' />";
    var sLevel = "<spring:message code='sys.label.level' />";

    var subAreaList = [];
    var postCodeList = [];

    var locations = $.parseJSON('${stateCodeList}');
    var gridColumnLayout = [{
        dataField: "zrLocId",
        editable: false,
        headerText: sLocationId
    }, {
        dataField: "zrLocStateId",
        headerText: "zrLocStateId",
        visible: false
    }, {
        dataField: "areaId",
        headerText: "areaId",
        visible: false
    }, {
        dataField: "postCodeId",
        headerText: "postCodeId",
        visible: false
    }, {
        dataField: "zrLocStusId",
        headerText: "zrLocStusId",
        visible: false
    }, {
        dataField: "name",
        headerText: sStateName,
        renderer: {
            type: "DropDownListRenderer",
            listFunction: function (rowIndex, columnIndex, item, dataField) {
                return locations;
            },
            keyField: "stateId",
            valueField: "name"
        }
    }, {
        dataField: "areaName",
        headerText: sAreaName,
        editRenderer: {
            type: "ComboBoxRenderer",
            showEditorBtnOver: true,
            listFunction: function (rowIndex, columnIndex, item, dataField) {
                fn_getSubAreaListByAsync(item.zrLocStateId);
                return subAreaList;
            },
            keyField: "areaId",
            valueField: "areaName"
        },
        labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
            var retStr = "";
            for (var i = 0, len = subAreaList.length; i < len; i++) {
                if (subAreaList[i]["areaId"] == value) {
                    retStr = subAreaList[i]["areaName"];
                    break;
                }
            }
            return retStr == "" ? value : retStr;
        }
    }, {
        dataField: "postCode",
        headerText: sPostCode,
        editRenderer: {
            type: "ComboBoxRenderer",
            showEditorBtnOver: true,
            listFunction: function (rowIndex, columnIndex, item, dataField) {
                fn_getPostCodeListByAsync(item.areaId);
                return postCodeList;
            },
            keyField: "postCodeId",
            valueField: "postCode"
        },
        labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
            var retStr = "";
            for (var i = 0, len = postCodeList.length; i < len; i++) {
                if (postCodeList[i]["postCodeId"] == value) {
                    retStr = postCodeList[i]["postCode"];
                    break;
                }
            }
            return retStr == "" ? value : retStr;
        }
    }, {
        dataField: "stusCodeName",
        headerText: "<spring:message code='sys.title.status' />",
        renderer: {
            type: "DropDownListRenderer",
            list: [{key: "1", value: "Active"}, {key: "8", value: "InActive"}],
            keyField: "key",
            valueField: "value"
        }

    }];

    $(function () {

        roleGridId = GridCommon.createAUIGrid("roleGridId", gridColumnLayout, "", "");

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

        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(roleGridId, "cellEditBegin", function (event) {
            if (event.dataField == "areaName") {
                var stateId = AUIGrid.getCellValue(roleGridId, event.rowIndex, "zrLocStateId");

                if (FormUtil.isEmpty(stateId)) {
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sStateName + "' htmlEscape='false'/>");
                    return false;
                }
            } else if (event.dataField == "postCode") {
                var areaId = AUIGrid.getCellValue(roleGridId, event.rowIndex, "areaId");

                if (FormUtil.isEmpty(areaId)) {
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sAreaName + "' htmlEscape='false'/>");
                    return false;
                }
            }
        });

        // 에디팅 종료 이벤트 바인딩
        AUIGrid.bind(roleGridId, "cellEditEnd", function (event) {

            //alert(JSON.stringify(event));

            if (event.dataField == "name") {
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "zrLocStateId", event.value);
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "areaName", "");
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "areaId", "");
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "postCodeId", "");
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "postCode", "");
            } else if (event.dataField == "areaName") {
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "areaId", event.value);
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "postCodeId", "");
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "postCode", "");
            } else if (event.dataField == "postCode") {
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "postCodeId", event.value);
            } else if (event.dataField == "stusCodeName") {
                AUIGrid.setCellValue(roleGridId, event.rowIndex, "zrLocStusId", event.value);
            }
        });

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

    function fn_getSubAreaListByAsync(areaStateId, _callback) {
        Common.ajaxSync("GET", "/common/getSubAreaList.do", {
            areaStusId: 1,
            areaStateId: areaStateId
        }, function (data) {
            subAreaList = data;
        });
    }

    function fn_getPostCodeListByAsync(areaId, _callback) {
        Common.ajaxSync("GET", "/common/getPostCodeList.do", {
            areaId: areaId
        }, function (data) {
            postCodeList = data;
        });
    }

    function fn_initSearch() {
        $("#sLocationId").val("");
        $("#sStateCode").val("");
        CommonCombo.initById("sSubAreaCode");
        $("#sPostCode").val("");
        $("#sStatus").multipleSelect("checkAll");
    }

    function fn_getZRLocationList() {
        Common.ajax("GET", "/common/getZRLocationList.do", $("#searchForm").serialize(), function (data) {
            AUIGrid.setGridData(roleGridId, data);
        });
    }

    function fn_deleteRow() {
        AUIGrid.removeRow(roleGridId, "selectedIndex");
    }

    function fn_addRow() {
        var item = {
            "zrLocId": "",
            "name": "<spring:message code='sys.info.grid.selectMessage'/>",
            "areaName": "",
            "postCode": "",
            "stusCodeName": "1",
            "zrLocStusId": "1"
        };
        // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
        AUIGrid.addRow(roleGridId, item, "first");
    }

    function fn_save() {

        var addList = AUIGrid.getAddedRowItems(roleGridId);
        if (!fn_validate(addList)) {
            return false;
        }

        var updateList = AUIGrid.getEditedRowItems(roleGridId);
        if (!fn_validate(updateList)) {
            return false;
        }

        Common.ajax("POST", "/common/saveZRLocation.do", GridCommon.getEditData(roleGridId), function (result) {
            Common.setMsg("<spring:message code='sys.msg.success'/>");
            fn_getZRLocationList();
        });
    }

    function fn_validate(gridDataList) {
        var retValue = true;

        $.each(gridDataList, function (index, item) {
            if (FormUtil.isEmpty(item.zrLocStateId)) {
                retValue = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sStateName + "' htmlEscape='false'/>");
                return false;
            } else if (FormUtil.isEmpty(item.areaId)) {
                retValue = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sAreaName + "' htmlEscape='false'/>");
                return false;
            } else if (FormUtil.isEmpty(item.postCodeId)) {
                retValue = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sPostCode + "' htmlEscape='false'/>");
                return false;
            }
        });

        return retValue;
    }

    function resetUpdatedItems() {
        // init editing grid data
        AUIGrid.resetUpdatedItems(myGridID, "a");
    }
</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>Sales</li>
        <li>Order list</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Role Management</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside><!-- title_line end -->


    <section class="search_table"><!-- search_table start -->
        <form action="#" method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px"/>
                    <col style="width:*"/>
                    <col style="width:180px"/>
                    <col style="width:*"/>
                    <col style="width:180px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">Role (Lvl 1)</th>
                    <td>
                        <select class="w100p">
                            <option value="">11</option>
                            <option value="">22</option>
                            <option value="">33</option>
                        </select>
                    </td>
                    <th scope="row">Role (Lvl 2)</th>
                    <td>
                        <select class="w100p">
                            <option value="">11</option>
                            <option value="">22</option>
                            <option value="">33</option>
                        </select>
                    </td>
                    <th scope="row">Role (Lvl 3)</th>
                    <td>
                        <select class="w100p">
                            <option value="">11</option>
                            <option value="">22</option>
                            <option value="">33</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Keyword</th>
                    <td><input type="text" title="" placeholder="" class="w100p"/></td>
                    <th scope="row">Status</th>
                    <td>
                        <select class="multy_select w100p" multiple="multiple">
                            <option value="1">11</option>
                            <option value="2">22</option>
                            <option value="3">33</option>
                        </select>
                    </td>
                    <th scope="row">Level</th>
                    <td>
                        <select class="multy_select w100p" multiple="multiple">
                            <option value="1">11</option>
                            <option value="2">22</option>
                            <option value="3">33</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Role ID</th>
                    <td colspan="5"><input type="text" title="" placeholder="" class=""/></td>
                </tr>
                </tbody>
            </table><!-- table end -->

            <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
                <p class="show_btn"></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                        <ul class="btns">
                            <li><p class="link_btn"><a href="#">menu1</a></p></li>
                            <li><p class="link_btn"><a href="#">menu2</a></p></li>
                            <li><p class="link_btn"><a href="#">menu3</a></p></li>
                            <li><p class="link_btn"><a href="#">menu4</a></p></li>
                            <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
                            <li><p class="link_btn"><a href="#">menu6</a></p></li>
                            <li><p class="link_btn"><a href="#">menu7</a></p></li>
                            <li><p class="link_btn"><a href="#">menu8</a></p></li>
                        </ul>
                        <ul class="btns">
                            <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
                            <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
                            <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
                            <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
                            <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
                            <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
                            <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
                            <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
                        </ul>
                        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide"/></a>
                        </p>
                    </dd>
                </dl>
            </aside><!-- link_btns_wrap end -->

        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
            <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
            <li><p class="btn_grid"><a href="#">DEL</a></p></li>
            <li><p class="btn_grid"><a href="#">INS</a></p></li>
            <li><p class="btn_grid"><a href="#">ADD</a></p></li>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            그리드 영역
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>
<!-- content end -->

</section><!-- container end -->
