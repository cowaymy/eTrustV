<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">

    var gridID;

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
        }, {
            dataField : "memName",
            headerText : "Salesman Name",
            width : "30%"
        }, {
            dataField : "os",
            headerText : "Outstanding",
            width : "12%",
            dataType : "numeric",
            formatString : "#,##0.00",
            style : "aui-grid-user-custom-right"
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

        var gridOpt = {
                usePaging : true,
                pageRowCount : 20,
                editable : false,
                showStateColumn : false,
                showRowNumColumn : true
        }

        gridID = AUIGrid.create("#grid_wrap", columnLayout, gridOpt);
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

        if(!FormUtil.isNotEmpty($("#orgCode").val())) {
            Common.alert("Organization Code must not be empty!");
            return false;
        }

        Common.ajax("GET", "/organization/ownPurchase/searchOwnPurchase.do", $("#searchForm").serialize(), function(result) {
           console.log(result);
           AUIGrid.setGridData(gridID, result);
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
            </tbody>
        </table>
    </form>

    <article class="grid_wrap" id="grid_wrap"></article>

    <form id="ledgerForm" method="post">
        <input type="hidden" name="ordId" id="ordId" />
        <input type="hidden" name="ordNo" id="ordNo" />
    </form>
</section>