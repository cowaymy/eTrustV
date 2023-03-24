<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">

    var gridID;
    var gridExcelId;

    $(document).ready(function() {
        console.log("ownPurchaseOSList");
        createAUIGrid();

        if("${SESSION_INFO.userTypeId}" != "4" && "${SESSION_INFO.userTypeId}" != "6") {
            if("${SESSION_INFO.memberLevel}" == "1") {
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("readonly", true);

            } else if("${SESSION_INFO.memberLevel}" == "2") {
                $("#orgCode").val("${orgCode}");
                $("#groupCode").val("${grpCode}");

                $("#orgCode").attr("readonly", true);
                $("#groupCode").attr("readonly", true);

            } else if("${SESSION_INFO.memberLevel}" == "3") {
                $("#orgCode").val("${orgCode}");
                $("#groupCode").val("${grpCode}");
                $("#deptCode").val("${deptCode}");

                $("#orgCode").attr("readonly", true);
                $("#groupCode").attr("readonly", true);
                $("#deptCode").attr("readonly", true);

            } else if("${SESSION_INFO.memberLevel}" == "4") {
                $("#orgCode").val("${orgCode}");
                $("#groupCode").val("${grpCode}");
                $("#deptCode").val("${deptCode}");
                $("#memCode").val("${memCode}");

                $("#orgCode").attr("readonly", true);
                $("#groupCode").attr("readonly", true);
                $("#deptCode").attr("readonly", true);
                $("#memCode").attr("readonly", true);
            }
        }

        doGetComboOrder('/common/selectMemTypeCodeList.do', '1', 'CODE_ID',   '', 'listKeyinMemTypeId', 'M', 'fn_multiCombo'); //Common Code
        doGetComboOrder('/organization/selectStatus.do', '', 'STUS_CODE_ID',   '', 'listKeyinMemStusId', 'M', 'fn_multiCombo'); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_ID',   '', 'listKeyinPayModeId', 'M', 'fn_multiCombo'); //Common Code
    });

    function createAUIGrid() {
        var columnLayout = [{
            dataField : "salesOrdId",
            visible : false
        }, {
            dataField : "salesOrdNo",
            headerText : "Sales Order No",
            width : "10%"
        }, {
            dataField : "memCode",
            headerText : "Salesman Code",
            width : "10%"
        },
        {
            dataField : "productName",
            headerText : "Product",
            width : "12%"
        },{
            dataField : "memName",
            headerText : "Salesman Name",
            width : "25%"
        },
        {
            dataField : "target",
            headerText : "Target",
            dataType : "numeric",
            formatString : "#,##0.00",
            width : "10%"
        },{
            dataField : "os",
            headerText : "Outstanding",
            width : "10%",
            dataType : "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
        },{
            dataField : "unbill",
            headerText : "Unbill",
            width : "10%",
            dataType : "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
        },{
            dataField : "penalty",
            headerText : "Penalty",
            width : "10%",
            dataType : "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
        }, {
            dataField : "memType",
            headerText : "Type Name",
            width : "8%"
        }, {
            dataField : "memStus",
            headerText : "Member Status",
            width : "8%"
        }, {
            dataField : "ordStus",
            headerText : "Order Status",
            width : "8%"
        }, {
            dataField : "payMode",
            headerText : "Paymode",
            width : "8%"
        }, {
            dataField : "orgCode",
            headerText : "Org Code",
            width : "8%"
        }, {
            dataField : "grpCode",
            headerText : "Grp Code",
            width : "8%"
        }, {
            dataField : "deptCode",
            headerText : "Dept Code",
            width : "8%"
        }, {
            dataField : "undefined",
            headerText : " ",
            width : "14%",
            renderer : {
                type : "ButtonRenderer",
                labelText : "Order Ledger(1)",
                onclick : function(rowIndex, columnIndex, value, item) {
                    console.log("View Order Ledger :: salesOrdID :: " + item.salesOrdId);
                    console.log("View Order Ledger :: salesOrdNo ::" + item.salesOrdNo);
                    $("#ordId").val(item.salesOrdId);
                    $("#ordNo").val(item.salesOrdNo);
                    Common.popupWin("ledgerForm", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
                }
            }
        }];

        var columnExcelLayout = [{
            dataField : "salesOrdId",
            visible : false
        }, {
            dataField : "salesOrdNo",
            headerText : "Sales Order No",
        }, {
            dataField : "memCode",
            headerText : "Salesman Code",
        },{
            dataField : "memType",
            headerText : "Type Name",
        }, {
            dataField : "memStus",
            headerText : "Member Status",
        }, {
            dataField : "ordStus",
            headerText : "Order Status",
        } , {
            dataField : "productName",
            headerText : "Product",
            width : 200,
        }, {
            dataField : "payMode",
            headerText : "Paymode",
        },{
            dataField : "memName",
            headerText : "Salesman Name",
            width : 250,
        },{
            dataField : "target",
            headerText : "Target",
            dataType : "numeric",
            formatString : "#,##0.00",
        },{
            dataField : "os",
            headerText : "Outstanding",
            dataType : "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
        }, ,{
            dataField : "unbill",
            headerText : "Unbill",
            width : "10%",
            dataType : "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
        },{
            dataField : "penalty",
            headerText : "Penalty",
            width : "10%",
            dataType : "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
        },{
            dataField : "orgCode",
            headerText : "Org Code",
        }, {
            dataField : "grpCode",
            headerText : "Grp Code",
        }, {
            dataField : "deptCode",
            headerText : "Dept Code",
        }, {
            dataField : "undefined",
            headerText : " ",
            width : 130,
            renderer : {
                type : "ButtonRenderer",
                labelText : "Order Ledger(1)",
                onclick : function(rowIndex, columnIndex, value, item) {
                    console.log("View Order Ledger :: salesOrdID :: " + item.salesOrdId);
                    console.log("View Order Ledger :: salesOrdNo ::" + item.salesOrdNo);
                    $("#ordId").val(item.salesOrdId);
                    $("#ordNo").val(item.salesOrdNo);
                    Common.popupWin("ledgerForm", "/sales/order/orderLedgerViewPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "no"});
                }
            }
        }];

        var gridOpt = {
                usePaging : true,
                pageRowCount : 20,
                editable : false,
                showStateColumn : false,
                showRowNumColumn : true
        }

        var excelGridProsNew = {
                // 페이징 사용
                usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                pageRowCount : 20,
                // 셀 선택모드 (기본값: singleCell)
                selectionMode : "multipleCells",
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            };

        gridID = AUIGrid.create("#grid_wrap", columnLayout, gridOpt);
        gridExcelId = AUIGrid.create("#grid_excel_wrap", columnExcelLayout, excelGridProsNew);
    }

    function fn_clear() {
        console.log("fn_clear");
        location.reload();
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password' || type === 'hidden' || type === 'file' || tag === 'textarea'){
                this.value = '';
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;
            }else if (tag === 'select'){
                this.selectedIndex = 0;
            }
        });
    };

    function fn_search() {
        console.log("fn_search");

        if ("${SESSION_INFO.userTypeId}" == "4" && $("#memCode").val() == "${memCode}"){
        	$("#staffOwnPurch").val("true");
        } else {
            $("#staffOwnPurch").val("false");
        }

        if ("${SESSION_INFO.userTypeId}" == "4" && $("#memCode").val().startsWith("P")
            && $("#memCode").val() != "${memCode}") {
            Common.alert("Please enter your own staff code.");
            return false;
        } else if (!FormUtil.isNotEmpty($("#orgCode").val()) && $("#staffOwnPurch").val() != "true") {
            Common.alert("Organization Code must not be empty!");
            return false;
        }

        Common.ajax("GET", "/organization/ownPurchase/searchOwnPurchase.do", $("#searchForm").serialize(), function(result) {
           console.log(result);
           AUIGrid.setGridData(gridID, result);
           AUIGrid.setGridData(gridExcelId, result);
        });
    }



    function fn_gridExport(){

        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("grid_excel_wrap", "xlsx", "Own Purchase Outstanding List");
    }

    function fn_multiCombo(){
        $('#listKeyinMemTypeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listKeyinOrdStusId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listKeyinMemStusId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listKeyinPayModeId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
    }


</script>

<section id="content">

    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Organization</li>
        <li>Own Purchase Outstanding</li>
    </ul>

    <aside class="title_line">
        <h2>Own Purchase Outstanding</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_search();">Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();">Clear</a></p></li>
        </ul>
    </aside>

    <form action="#" id="searchForm" method="post">
        <input type="hidden" name="staffOwnPurch" id="staffOwnPurch" />
        <table class="type1">
            <caption>table</caption>
            <colgroup>
                <col style="width:130px" />
                <col style="width:*" />
                <col style="width:130px" />
                <col style="width:*" />
                <col style="width:130px" />
                <col style="width:*" />
                <col style="width:130px" />
                <col style="width:*" />
            </colgroup>

            <tbody>
                <tr>
                    <th scope="row">Organization Code</th>
                    <td>
                        <input type="text" title="Organization Code" placeholder="Organization Code" class="w100p" id="orgCode" name="orgCode" />
                    </td>
                    <th scope="row">Group Code</th>
                    <td>
                        <input type="text" title="Group Code" placeholder="Group Code" class="w100p" id="groupCode" name="groupCode" />
                    </td>
                    <th scope="row">Department Code</th>
                    <td>
                        <input type="text" title="Department Code" placeholder="Department Code" class="w100p" id="deptCode" name="deptCode" />
                    </td>
                    <th scope="row">Member Code</th>
                    <td>
                        <input type="text" title="Member Code" placeholder="Member Code" class="w100p" id="memCode" name="memCode" />
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='sal.text.memtype'/></th>
				    <td>
				        <select id="listKeyinMemTypeId" name="keyinMemTypeId" class="multy_select w100p" multiple="multiple"></select>
				    </td>
				    <th scope="row"><spring:message code='sal.text.orderStatus'/></th>
				    <td>
				      <select id="listKeyinOrdStusId" name="keyinOrdStusId" class="multy_select w100p" multiple="multiple">
				        <option value="1">Active</option>
				        <option value="4">Completed</option>
				        <option value="10">Cancelled</option>
				       </select>
				    </td>
				    <th scope="row">Member Status</th>
				    <td>
				        <select id="listKeyinMemStusId" name="keyinMemStusId" class="multy_select w100p" multiple="multiple"></select>
				    </td>
				    <th scope="row"><spring:message code='sal.title.text.payMode'/></th>
				    <td>
				        <select id="listKeyinPayModeId" name="keyinPayModeId" class="multy_select w100p" multiple="multiple"></select>
				    </td>
                </tr>
            </tbody>
        </table>
    </form>



  <aside class="title_line"><!-- title_line start -->

        <ul class="right_btns">
                <li><p class="btn_grid"><a id="btnExcel" onclick="javascript:fn_gridExport('xlsx');">Generate</a></p></li>

        </ul>
    </aside><!-- title_line end -->

    <article class="grid_wrap" id="grid_wrap"></article>

    <form id="ledgerForm" method="post">
        <input type="hidden" name="ordId" id="ordId" />
        <input type="hidden" name="ordNo" id="ordNo" />
    </form>
</section>

<section class="search_result"><!-- search_result start -->
	<article class="grid_wrap" id="grid_excel_wrap" style="display:none;"><!-- grid_wrap start -->
	</article><!-- grid_wrap end -->
</section><!-- search_result end -->

