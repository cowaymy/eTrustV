<!--=================================================================================================
* Task  : Logistics
* File Name : serialSearchPop.jsp
* Description : serial Search
* Author : KR-JUN
* Date : 2019-11-27
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-11-27  KR-JUN        Init
*=================================================================================================-->
<!--=================================================================================================
Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "620", resizable: "no", scrollbars: "no"});

function fnSerialSearchResult(data) {
    data.forEach(function(dataRow) {
        console.log("serialNo : " + dataRow.serialNo);
    });
}

<form id="frmSearchSerial" name="frmSearchSerial" method="post">
    <input id="pGubun" name="pGubun" type="hidden" value="SEARCH, RADIO, CHECK" />
    <input id="pFixdYn" name="pFixdYn" type="hidden" value="Y, N" />
    <input id="pLocationType" name="pLocationType" type="hidden" value="" />
    <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
    <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
    <input id="pStatus" name="pStatus" type="hidden" value="I,O" />
    <input id="pSerialNo" name="pSerialNo" type="hidden" value="ZKG0H5AA19B2500002" />
</form>
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<script type="text/javaScript" language="javascript">
    var mainGridID;

    var codeList = [];
    <c:forEach var="list" items="${codeList446}">
    codeList.push({
        codeId : "${list.codeId}",
        codeMasterId : "${list.codeMasterId}",
        code : "${list.code}",
        codeName : "${list.codeName}",
        codeDesc : "${list.codeDesc}"
    });
    </c:forEach>

    $(document).ready(function() {
        createAUIGrid();

        doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '${pLocationType}', 'locType', 'M','f_multiCombo');

        doDefComboCode(getCodeList("MASTER", "", "446", "", "all"), '', 'searchStatus', 'M', 'f_multiComboSearchStatus');

        setButton();

        setSearchFixd();

        $("#btnSearch").click(function() {
            getMainList();
        });

        $("#btnConfiirm").click(function() {
            getConfiirm("Confiirm");
        });

        $("#btnClose").click(function() {
            window.close();
        });
    });

    function createAUIGrid() {
        var mainColumnLayout = [
            {dataField:"serialNo", headerText:"Serial No", width:160, height:30},
            {dataField:"itmCode", headerText:"Item Code", width:100, height:30},
            {dataField:"stkDesc", headerText:"Item Description", width:200, height:30, style:"aui-grid-user-custom-left"},
            {dataField:"stkTypeNm", headerText:"Item Type", width:100, height:30},
            {dataField:"stusCode", headerText:"Status", width:70, height:30, labelFunction:function(rowIndex, columnIndex, value, headerText, item) {
                return getCodeList("CODE", "", "446", item.stusCode);
            }},
            {dataField:"lastDelvryGrDt", headerText:"GR Date", width:100, height:30, dataType:"date", dateInputFormat:"yyyymmdd", formatString:"dd/mm/yyyy"},
            {dataField : "stkId",visible : false}
        ];

        var mainGridOptions = {
            // 페이지 설정
            usePaging : true,
            // 한 화면에 출력되는 행 개수 10
            pageRowCount : 10,
            // 편집 가능 여부 (기본값 : false)
            editable : false,
            // 상태 칼럼 사용
            showStateColumn : false,
            displayTreeOpen: true,
            // 셀 선택모드 (기본값: singleCell)
            selectionMode : "multipleCells",
            headerHeight: 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns: true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove: true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn: true,
            // 에디팅 셀 마커 표시 안함.
            showEditedCellMarker : false,
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
            groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />"
        };

        if ("RADIO" == "${pGubun}") {
            $.extend(mainGridOptions, {showRowCheckColumn : true, rowCheckToRadio : true});
        }

        if ("CHECK" == "${pGubun}") {
            $.extend(mainGridOptions, {showRowCheckColumn : true});
        }

        mainGridID = GridCommon.createAUIGrid("mainGrid", mainColumnLayout, "", mainGridOptions);

        if ("CHECK" == "${pGubun}") {
            AUIGrid.bind(mainGridID, "cellDoubleClick", function(event) {
                if (event.rowIndex > -1) {
                    getConfiirm("Click", AUIGrid.getItemByRowIndex(mainGridID, event.rowIndex));
                }
            });
        }
    }

    function getMainList() {
        if (FormUtil.isEmpty($("#locType").val())) {
            Common.alert('Please Enter Location.');
            return;
        }
        if (FormUtil.isEmpty($("#locCode").val())) {
            Common.alert('Please Enter Location.');
            return;
        }
        if (FormUtil.isEmpty($("#searchItemCodeOrName").val())) {
            Common.alert('Please Enter Item Code Or Item Name.');
            return;
        }

        Common.ajax("POST", "/logistics/SerialMgmt/serialSearchDataList.do", $("#searchForm").serializeJSON(), function (result) {
            AUIGrid.setGridData(mainGridID, result.data);
        });
    }

    function setButton() {
        if ("SEARCH" == "${pGubun}") {
            $(".search_result_button").hide();
        }
    }

    function setSearchFixd() {
        if ("${pFixdYn}" == "Y" || "${pFixdYn}" == "" || "${pFixdYn}" == null) {
            $("#locType").attr("disabled", true);
            $("#locCode").attr("disabled", true);
            $("#searchItemCodeOrName").attr("disabled", true);
            $("#searchStatus").attr("disabled", true);
            $("#searchSerialNo").attr("disabled", true);
        }
    }

    function getCodeList(codeType, codeId, codeMasterId, code, returnType) {
        var searchData = codeList.filter(function(e) {
            if (codeType == "ID") {
                return e.codeId == codeId;
            }
            else if (codeType == "CODE") {
                return e.codeMasterId == codeMasterId && e.code == code;
            }
            else if (codeType == "MASTER") {
                return e.codeMasterId == codeMasterId;
            }
            else {
                return e.code == code;
            }
        });

        if (searchData.length > 0) {
            if (returnType == "all") {
                return searchData;
            }
            else {
                return searchData[0].codeName;
            }
        }
        else {
            return "";
        }
    }

    function f_multiCombo() {
        $(function() {
            $('#locType').change(function() {
                if ($('#locType').val() != null && $('#locType').val() != "" ){
                    var searchlocgb = $('#locType').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                         }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                         }
                     }

                     var param = {searchlocgb:locgbparam , grade:""}
                     CommonCombo.make('locCode', '/common/selectStockLocationList2.do', param , '${pLocationCode}', {type: 'M', id:'codeId', name:'codeName', width:'68%', isCheckAll:false});
                  }
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function f_multiComboSearchStatus() {
        $(function() {
            $('#searchStatus').change(function() {
            }).multipleSelect({
                selectAll : true
            });
        });

        if ("${pStatus}" != "") {
            $.each("${pStatus}".split(","), function(index, value) {
                $("#searchStatus option").each(function() {
                    if (this.value == value) {
                        $("#searchStatus option:eq(" + this.index + ")").attr("selected", "selected");
                    }
                });
            });
        }
        else {
            if ("SEARCH" == "${pGubun}") {
                $("#searchStatus option").each(function() {
                    if (this.value == "I" || this.value == "O") {
                        $("#searchStatus option:eq(" + this.index + ")").attr("selected", "selected");
                    }
                });
            }
            else {
                $("#searchStatus option").each(function() {
                    if (this.value == "I") {
                        $("#searchStatus option:eq(" + this.index + ")").attr("selected", "selected");
                    }
                });
            }
        }
    }

    function getConfiirm(event, data) {
        var rtnData = [];
        if (event == "Click") {
            rtnData.push(data);
        }
        if (event == "Confiirm") {
            var checkedItems = AUIGrid.getCheckedRowItems(mainGridID);
            if (checkedItems.length <= 0 ) {
                alert("Please Check.");
                return;
            }

            $.each(checkedItems, function(index, value) {
                rtnData.push(value.item);
            });
        }
        opener.fnSerialSearchResult(rtnData);
        window.close();
    }
</script>

<section id="popup_wrap" class="popup_wrap pop_win"><!-- content start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Search Serial No.</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue2"><a id="btnClose"><span class="clear"></span>Close</a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <section class="search_table"><!-- search_table start -->
            <form id="searchForm" name="searchForm">
                <table class="type1"><!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:35%" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><span style="color:red">*</span> Location</th>
                            <td>
                                <select id="locType" name="locType[]" multiple="multiple" style="width:120px"></select>
                                <select id="locCode" name="locCode[]"><option value="">Choose One</option></select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span style="color:red">*</span> Item Code / Name</th>
                            <td>
                                <input type="text"  id="searchItemCodeOrName" name="searchItemCodeOrName"  class="w100p" value="${pItemCodeOrName}" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"> Status</th>
                            <td>
                                <select class="w100p" id="searchStatus" name="searchStatus[]" multiple="multiple"></select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"> Serial No</th>
                            <td>
                                <input type="text"  id="searchSerialNo" name="searchSerialNo"  class="w100p" value="${pSerialNo}" />
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
            </form>
            &nbsp;
            &nbsp;
        </section><!-- search_table end -->

        <section class="search_result"><!-- search_result start -->
            <article class="grid_wrap">
                <div id="mainGrid" class="autoGridHeight"></div>
            </article>
        </section><!-- search_result end -->

        <section class="search_result_button">
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="btnConfiirm">Confiirm</a></p></li>
            </ul>
        </section>
    </section>
</section><!-- content end -->
