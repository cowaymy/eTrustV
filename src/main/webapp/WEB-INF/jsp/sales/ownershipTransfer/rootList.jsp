<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    var rotID, rotNo, rotOrdId, rotOrdNo, ccpID;
    var rootGridID;
    var ownershipTransferColumn = [
        {
            dataField : "rotId",
            visible : false
        },
        {
            dataField : "rotOrdId",
            visible : false
        },
        {
            dataField : "ccpId",
            visible : false
        },
        {
            dataField : "rotNo",
            headerText : "ROT No",
            width : 140
        },
        {
            dataField : "rotOrdNo",
            headerText : "Order No",
            width : 140
        },
        {
            dataField : "rotAppType",
            headerText : "Application Type",
            width : 150
        },
        {
            dataField : "rotOldCustId",
            headerText : "Original CID",
            width : 140
        },
        {
            dataField : "oldCustName",
            headerText : "Original Customer Name"
        },
        {
            dataField : "rotNewCustId",
            headerText : "New CID",
            width : 140
        },
        {
            dataField : "newCustName",
            headerText : "New Customer Name"
        },
        {
            dataField : "rotStus",
            headerText : "Status",
            width : 120
        },
        {
            dataField : "rotReqDt",
            headerText : "Request Date",
            width : 140
        }
    ];

    var ownershipTransferGridPros = {
        usePaging : true,
        pageRowCount : 20,
        editable : false,
        showRowNumColumn : true,
        showStateColumn : false
    };

    $(document).ready(function(){
        console.log("ready :: rotList");
        //rootGridID = GridCommon.createAUIGrid("grid_wrap", ownershipTransferColumn, '', ownershipTransferGridPros);
        rootGridID = AUIGrid.create("#grid_wrap", ownershipTransferColumn, ownershipTransferGridPros);

        doGetComboSepa('/common/selectBranchCodeList.do', '1', ' - ', '', 'rotReqBrnch', 'M', 'fn_multiCombo'); //Branch Code
        doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID', '', 'rotAppType', 'M', 'fn_multiCombo'); //Common Code
        doGetComboOrder('/sales/ownershipTransfer/selectStatusCode.do', '', '', '', 'rotStus', 'M', 'fn_multiCombo'); //Status Code

        $("#search").click(fn_searchROT);
        $("#requestROT").click(fn_requestROTSearchOrder);
        $("#updateROT").click(fn_updateROT);
        $("#search_requestor_btn").click(fn_supplierSearchPop);

        AUIGrid.bind(rootGridID, "cellClick", function(e) {
            console.log("rootList :: cellClick :: rowIndex :: " + e.rowIndex);
            console.log("rootList :: cellClick :: rotId :: " + e.item.rotId);
            console.log("rootList :: cellClick :: rotNo :: " + e.item.rotNo);
            rotId = e.item.rotId;
            rotNo = e.item.rotNo;
            rotOrdId = e.item.rotOrdId;
            rotOrdNo = e.item.rotOrdNo;
            ccpID = e.item.ccpId;
        });
    });

    function fn_multiCombo() {
        $('#rotReqBrnch').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });

        $('#rotAppType').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#rotAppType').multipleSelect("checkAll");

        $('#rotStus').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
    }

    function fn_supplierSearchPop() {
        Common.popupDiv("/eAccounting/webInvoice/supplierSearchPop.do", {accGrp:"VM10"}, null, true, "supplierSearchPop");
    }

    function fn_setSupplier() {
        $("#requestorID").val($("#search_memAccId").val());
        $("#requestorName").val($("#search_memAccName").val());
        $("#requestorInfo").val($("#search_memAccId").val() + " - " + $("#search_memAccName").val());
    }

    // Button functions - Start
    function fn_searchROT() {
        Common.ajax("GET", "/sales/ownershipTransfer/selectRootList.do", $("#searchForm").serialize(), function(result) {
            console.log(result);
            AUIGrid.setGridData(rootGridID, result);
        });
    }

    function fn_requestROT() {
        console.log("fn_requestROT");
        Common.popupDiv("/sales/ownershipTransfer/requestROT.do?isPop=true");
    }

    function fn_requestROTSearchOrder() {
        console.log("fn_requestROT2");
        Common.popupDiv("/sales/ownershipTransfer/requestROTSearchOrder.do?isPop=true");
    }

    function fn_updateROT() {
        console.log("fn_updateROT");
        if(rotId != "" && rotId != null) {
            var data = {
                rotId : rotId,
                rotNo : rotNo,
                salesOrdId : rotOrdId,
                salesOrdNo : rotOrdNo,
                ccpId : ccpID
            };
console.log(data);
            Common.popupDiv("/sales/ownershipTransfer/updateROT.do", data, null, true, "fn_updateROT");
        }
    }
    // Button functions - End

</script>

<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Sales</li>
        <li>CCP</li>
        <li>ROOT Request</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Rental Outright Ownership Transfer</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" id="search"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
            <li><p class="btn_blue"><a href="#" id="requestROT">Request</a></p></li>
            <li><p class="btn_blue"><a href="#" id="updateROT">Update</a></p></li>
            <li><p class="btn_blue type2"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form id="searchForm" name="searchForm" action="#" method="post">
            <input type="hidden" id="requestorName" name="requestorName">
            <input type="hidden" id="requestorID" name="requestorID">

            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">Order Number</th>
                    <td>
                        <input type="text" title="Order Number" id="rotOrdNo" name="rotOrdNo" placeholder="Order Number" class="w100p" />
                    </td>
                    <th scope="row">Application Type</th>
                    <td>
                        <select id="rotAppType" name="rotAppType" class="w100p"></select>
                    </td>
                    <th scope="row">Status</th>
                    <td>
                        <select id="rotStus" name="rotStus" class="w100p"></select>
                        <!--
                        <select class="multy_select w100p" multiple="multiple" id="rotStus" name="rotStus">
                            <option value="1" selected="selected">Active</option>
                            <option value="5" selected="selected">Approved</option>
                            <option value="6" selected="selected">Rejected</option>
                        </select>
                         -->
                    </td>
                </tr>
                <tr>
                    <th scope="row">Original Customer ID</th>
                    <td>
                        <input type="text" title="Existing Customer ID" id="oriCustID" name="oriCustID" placeholder="Existing Customer ID" class="w100p" />
                    </td>
                    <th scope="row">Transfer Customer ID</th>
                    <td>
                        <input type="text" title="New Customer ID" id="newCustID" name="newCustID" placeholder="New Customer ID" class="w100p" />
                    </td>
                    <th scope="row">Request Date</th>
                    <td>
                        <!-- date_set start -->
                        <div class="date_set w100p">
                            <p><input type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" id="reqStartDt" name="reqStartDt"/></p>
                            <span>To</span>
                            <p><input type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" id="reqEndDt" name="reqEndDt"/></p>
                        </div>
                        <!-- date_set end -->
                    </td>
                </tr>
                <tr>
                    <th scope="row">ROT No</th>
                    <td>
                        <input type="text" title="ROT No" id="rotNo" name="rotNo" placeholder="ROT No" class="w100p" />
                    </td>
                    <th scope="row">ROT Requestor</th>
                    <td>
                        <input type="text" title="" placeholder="Requestor ID" class="" style="width:93%" id="requestorInfo" name="reqInfo" readonly />
                        <a href="#" class="search_btn" id="search_requestor_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                    </td>
                    <th scope="row">Requestor Branch</th>
                    <td>
                        <select id="rotReqBrnch" name="rotReqBrnch" class="w100p"></select>
                    </td>
                </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article class="grid_wrap">
            <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
        </article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
</section><!-- content end -->
