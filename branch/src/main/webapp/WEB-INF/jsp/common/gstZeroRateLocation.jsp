<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javaScript">

    var locationGridId;

    var sLocationId = "<spring:message code='sys.title.location' /> <spring:message code='sys.info.id' />";
    var sStateName = "<spring:message code='sys.title.state' /> <spring:message code='sys.title.name' />";
    var sAreaName = "<spring:message code='sys.title.area' /> <spring:message code='sys.title.name' />";
    var sPostCode = "<spring:message code='sys.title.post.code' />";

    var subAreaList = [];
    var postCodeList = [];

    var locations = $.parseJSON('${stateCodeList}');
    var gridColumnLayout = [{
        dataField: "zrLocId",
        editable : false,
        headerText:sLocationId
    }, {
        dataField : "zrLocStateId",
        headerText : "zrLocStateId",
        visible : false
    }, {
        dataField : "areaId",
        headerText : "areaId",
        visible : false
    }, {
        dataField : "postCodeId",
        headerText : "postCodeId",
        visible : false
    }, {
        dataField : "zrLocStusId",
        headerText : "zrLocStusId",
        visible : false
    },{
            dataField: "name",
            headerText: sStateName,
            renderer : {
                type : "DropDownListRenderer",
                listFunction : function(rowIndex, columnIndex, item, dataField) {
                    return locations;
                },
                keyField : "stateId",
                valueField : "name"
            }
    }, {
        dataField: "areaName",
        headerText: sAreaName,
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true,
            listFunction : function(rowIndex, columnIndex, item, dataField) {
                fn_getSubAreaListByAsync(item.zrLocStateId);
                return subAreaList;
            },
            keyField : "areaId",
            valueField : "areaName"
        },
        labelFunction: function(rowIndex, columnIndex, value, headerText, item) {
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
        editRenderer : {
            type : "ComboBoxRenderer",
            showEditorBtnOver : true,
            listFunction : function(rowIndex, columnIndex, item, dataField) {
                fn_getPostCodeListByAsync(item.areaId);
                return postCodeList;
            },
            keyField : "postCodeId",
            valueField : "postCode"
        },
        labelFunction: function(rowIndex, columnIndex, value, headerText, item) {
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
        renderer : {
            type : "DropDownListRenderer",
            list : [{key : "1", value : "Active"}, {key : "8", value : "InActive"}],
            keyField : "key",
            valueField : "value"
        }

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

        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(locationGridId, "cellEditBegin", function(event){
            if (event.dataField == "areaName") {
                var stateId = AUIGrid.getCellValue(locationGridId, event.rowIndex, "zrLocStateId");

                if (FormUtil.isEmpty(stateId)) {
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sStateName + "' htmlEscape='false'/>");
                    return false;
                }
            }else if (event.dataField == "postCode") {
                var areaId = AUIGrid.getCellValue(locationGridId, event.rowIndex, "areaId");

                if (FormUtil.isEmpty(areaId)) {
                    Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sAreaName + "' htmlEscape='false'/>");
                    return false;
                }
            }
        });

        // 에디팅 종료 이벤트 바인딩
        AUIGrid.bind(locationGridId, "cellEditEnd", function (event) {

            //alert(JSON.stringify(event));

            if (event.dataField == "name") {
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "zrLocStateId", event.value);
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "areaName", "");
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "areaId", "");
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "postCodeId", "");
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "postCode", "");
            }else if(event.dataField == "areaName"){
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "areaId", event.value);
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "postCodeId", "");
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "postCode", "");
            }else if(event.dataField == "postCode"){
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "postCodeId", event.value);
            }else if(event.dataField == "stusCodeName"){
                AUIGrid.setCellValue(locationGridId, event.rowIndex, "zrLocStusId", event.value);
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

    function fn_getSubAreaListByAsync(areaStateId, _callback){
        Common.ajaxSync("GET", "/common/getSubAreaList.do", {
            areaStusId: 1,
            areaStateId: areaStateId
        }, function (data) {
            subAreaList = data;
        });
    }

    function fn_getPostCodeListByAsync(areaId, _callback){
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
            AUIGrid.setGridData(locationGridId, data);
        });
    }

    function fn_deleteRow(){
        AUIGrid.removeRow(locationGridId, "selectedIndex");
    }

    function fn_addRow() {
        var item = {"zrLocId": "", "name": "<spring:message code='sys.info.grid.selectMessage'/>", "areaName": "", "postCode": "", "stusCodeName": "1", "zrLocStusId": "1"};
        // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
        AUIGrid.addRow(locationGridId, item, "first");
    }

    function fn_save() {

        var addList = AUIGrid.getAddedRowItems(locationGridId);
        if(!fn_validate(addList)){
            return false;
        }

        var updateList = AUIGrid.getEditedRowItems(locationGridId);
        if(!fn_validate(updateList)){
            return false;
        }

        Common.ajax("POST", "/common/saveZRLocation.do", GridCommon.getEditData(locationGridId), function(result) {
            Common.setMsg("<spring:message code='sys.msg.success'/>");
            fn_getZRLocationList();
        });
    }

    function fn_validate(gridDataList){
        var retValue = true;

        $.each(gridDataList, function(index, item){
            if(FormUtil.isEmpty(item.zrLocStateId)){
                retValue = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sStateName + "' htmlEscape='false'/>");
                return false;
            }else if(FormUtil.isEmpty(item.areaId)){
                retValue = false;
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + sAreaName + "' htmlEscape='false'/>");
                return false;
            }else if(FormUtil.isEmpty(item.postCodeId)){
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
        <li>System</li>
        <li>GST Zero Rate Location</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="javascript:void(0);" class="click_add_on">System</a></p>
        <h2>GST Zero Rate Location Search</h2>
        <ul class="right_btns">
            <li>
                <c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <p class="btn_blue">
                <a href="javascript:void(0);" id="btnSearch"><span class="search"></span><spring:message code='sys.btn.search'/></a>
                </p>
                </c:if>
            </li>
            <!-- <li><p class="btn_blue"><a href="javascript:void(0);" id="btnClear"><span class="clear"></span>Clear</a></p>
            </li> -->
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
                <p class="show_btn">
                  <%--   <a href="javascript:void(0);">
                      <img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show"/>
                    </a>  --%>
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
                <li><p class="btn_grid"><a href="javascript:void(0);" id="btnAdd"><spring:message code='sys.btn.add'/></a></p></li>
                <li><p class="btn_grid"><a href="javascript:void(0);" id="btnSave"><spring:message code='sys.btn.save'/></a></p></li>
            </c:if>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="locationGridId" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>
<!-- content end -->
