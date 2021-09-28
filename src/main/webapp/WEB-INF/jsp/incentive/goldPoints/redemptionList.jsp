<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    var gridID;

    $(document).ready(function() {
        createAUIGrid();

        AUIGrid.bind(gridID, "cellClick", function(event) {
            $("#_rdmId").val(event.item.rdmId);
            $('#_rdmNo').val(event.item.rdmNo);

        });

        $('#btnSearchRdm').click(function() {
        	fn_search();
        });

        $('#btnNewRdm').click(function() {
        	fn_newRedemption();
        });

        $('#btnCancelRdm').click(function() {
            var selIdx = AUIGrid.getSelectedIndex(gridID)[0];

            if (selIdx > -1) {
            	var rdmStatus = AUIGrid.getCellValue(gridID, selIdx, "status");

            	if (rdmStatus != "Active") {
            		Common.alert('<spring:message code="incentive.alert.msg.rdmValidateCancel" />');
            	} else {
            	    fn_promptCancelConfirm(selIdx);
            	}
            }
            else {
                Common.alert('<spring:message code="incentive.alert.msg.rdmMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="incentive.alert.msg.noRdmSel" /></b>');
            }
        });

        $('#btnUpdRdm').click(function() {
            var selIdx = AUIGrid.getSelectedIndex(gridID)[0];
            if(selIdx > -1) {
                var rdmStatus = AUIGrid.getCellValue(gridID, selIdx, "status");

                if (rdmStatus != "In Progress" && rdmStatus != "Ready For Collect") {
                    Common.alert('<spring:message code="incentive.alert.msg.rdmValidateUpdate" />');
                } else {
                	Common.popupDiv("/incentive/goldPoints/updateRedemptionPop.do", { rdmId : $("#_rdmId").val() }, null , true, 'updateRedemptionPop');
                }
            }
            else {
                Common.alert('<spring:message code="incentive.alert.msg.rdmMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="incentive.alert.msg.noRdmSel" /></b>');
            }
        });

        if("${SESSION_INFO.userTypeId}" != "4" && "${SESSION_INFO.userTypeId}" != "6") {
        	$("#orgCode").val("${orgCode}");
            $("#grpCode").val("${grpCode}");
            $("#deptCode").val("${deptCode}");
            $("#memCode").val("${memCode}");

            $("#orgCode").attr("readonly", true);
            $("#grpCode").attr("readonly", true);
            $("#deptCode").attr("readonly", true);
            $("#memCode").attr("readonly", true);
        }
    });

    function createAUIGrid() {
        var columnLayout = [{
            dataField : "rdmId",
            headerText : "Redemption ID.",
            visible : false
        },{
            dataField : "rdmNo",
            headerText : "<spring:message code='incentive.title.redemptionNo' />",
            width : "9%"
        }, {
            dataField : "crtDt",
            headerText : "Key-In-At",
            width : "8%"
        }, {
            dataField : "status",
            headerText : "Status",
            width : "8%"
        }, {
            dataField : "memCode",
            headerText : "Member Code",
            width : "10%"
        }, {
            dataField : "memName",
            headerText : "Member Name",
            width : "10%"
        }, {
            dataField : "rdmItem",
            headerText : "Item",
            width : "10%"
        }, {
            dataField : "qty",
            headerText : "Qty",
            width : "3%"
        }, {
            dataField : "totalPts",
            headerText : "<spring:message code='incentive.title.totalPtsRdm' />",
            width : "7%"
        }, {
            dataField : "collectBrnch",
            headerText : "<spring:message code='incentive.title.collectionBranch' />",
            width : "10%"
        }, {
            dataField : "updDt",
            headerText : "<spring:message code='incentive.title.lastUpdate' />",
            width : "8%"
        }, {
            dataField : "updatorUserName",
            headerText : "<spring:message code='incentive.title.lastUpdator' />",
            width : "10%"
        }, {
            dataField : "rem",
            headerText : "Remark",
            width : "8%"
        }];

        var gridOpt = {
                usePaging : true,
                pageRowCount : 20,
                editable : false,
                showStateColumn : false,
                showRowNumColumn : true,
                wordWrap : true,
                headerHeight : 45
        }

        gridID = AUIGrid.create("#grid_wrap", columnLayout, gridOpt);
    }

    function fn_search() {
        Common.ajax("GET", "/incentive/goldPoints/searchRedemptionList.do", $("#searchForm").serialize(), function(result) {
           AUIGrid.setGridData(gridID, result);
        });
    }

    function fn_addItems() {
        Common.popupDiv("/incentive/goldPoints/uploadRedemptionItemsPop.do", null, null, true, "uploadRedemptionItemsPop");
    }

    function fn_newRedemption() {
        Common.popupDiv("/incentive/goldPoints/newRedemptionPop.do", null, null, true, "newRedemptionPop");
    }

    function fn_promptCancelConfirm(selIdx) {

        var memName = AUIGrid.getCellValue(gridID, selIdx, "memName");
        var memCode = AUIGrid.getCellValue(gridID, selIdx, "memCode");
        var rdmItem = AUIGrid.getCellValue(gridID, selIdx, "rdmItem");
        var qty = AUIGrid.getCellValue(gridID, selIdx, "qty");
        var totalPts = AUIGrid.getCellValue(gridID, selIdx, "totalPts");

        var confirmCancelMsg = memName + "<br />" + memCode + "<br />" +
        rdmItem + "<br />Quantity : " + qty + "<br />Total Gold Points : " +
        totalPts + "<br /><br />" + "Do you want to cancel this redemption request?";

        Common.confirm(confirmCancelMsg, fn_cancelRedemption);
    }

    function fn_cancelRedemption() {
        Common.ajax("POST", "/incentive/goldPoints/cancelRedemption.do", {rdmId:$('#_rdmId').val()}, function(result) {
            if(result.p1 == 1) {     //successful cancelled redemption
                Common.alert("Your Gold Points Redemption Request has been cancelled. <br />Redemption No. : "
                		+ $('#_rdmNo').val(), fn_reloadList);
            } else if (result.p1 == 99) {
                Common.alert("Failed to Cancel. Redemption is not active", fn_reloadList);
            }
        });
    }

    function fn_reloadList() {
        location.reload();
    }

</script>

<section id="content">

    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Incentive Rewards</li>
        <li>Gold Points Redemption</li>
        <li>Points Summary</li>
    </ul>

    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Redeem</h2>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                <li><p class="btn_blue"><a href="javascript:fn_addItems();">Add Items</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                <li><p class="btn_blue"><a id="btnUpdRdm" href="#">Update Status</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
                <li><p class="btn_blue"><a id="btnCancelRdm" href="#">Cancel Request</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
                <li><p class="btn_blue"><a id="btnNewRdm" href="#">New</a></p></li>
            </c:if>
            <li><p class="btn_blue"><a id="btnSearchRdm" href="#">Search</a></p></li>
        </ul>
    </aside>

    <form action="#" id="searchForm" method="post">
        <input id="_rdmId" name="rdmId" type="hidden" value="" />
        <input id="_rdmNo" name="rdmNo" type="hidden" value="" />

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
                    <th scope="row">Member Type</th>
                    <td>
                        <select class="w100p" id="cmbMemType" name="cmbMemType">
                            <option value="" selected>Select Account</option>
                            <c:forEach var="list" items="${memberType}" varStatus="status">
                                <option value="${list.codeId}">${list.codeName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th scope="row">Member Code</th>
                    <td>
                       <input type="text" title="Member Code" placeholder="" class="w100p" id="memCode" name="memCode" />
                    </td>
                    <th scope="row">Member Name</th>
                    <td>
                        <input type="text" title="Member Name" placeholder="" class="w100p" id="memName" name="memName" />
                    </td>
                    <th scope="row">IC Number</th>
                    <td>
                        <input type="text" title="IC Number" placeholder="" class="w100p" id="icNum" name="icNum" />
                    </td>
                </tr>
                <tr>
                    <th scope="row">Organization Code</th>
                    <td>
                        <input type="text" title="Organization Code" placeholder="Organization Code" class="w100p" id="orgCode" name="orgCode" />
                    </td>
                    <th scope="row">Group Code</th>
                    <td>
                        <input type="text" title="Group Code" placeholder="Group Code" class="w100p" id="grpCode" name="grpCode" />
                    </td>
                    <th scope="row">Department Code</th>
                    <td>
                        <input type="text" title="Department Code" placeholder="Department Code" class="w100p" id="deptCode" name="deptCode" />
                    </td>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="status" name="status">
                            <option value="" selected>Select Account</option>
                            <c:forEach var="list" items="${status }" varStatus="status">
                                <option value="${list.statuscodeid}">${list.name}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Redemption No.</th>
                    <td>
                        <input type="text" title="Redemption No." placeholder="" class="w100p" id="redemptionNo" name="redemptionNo" />
                    </td>
                    <th scope="row">Item</th>
                    <td>
                        <select class="w100p" id="item" name="item">
                            <option value="" selected>Select Item</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Collection Branch</th>
                    <td>
                        <select class="w100p" id="collectionBranch" name="collectionBranch">
                            <option value="" selected>Select Branch</option>
                        </select>
                    </td>
                    <th scope="row">Redeem Date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                            <p><input type="text" title="Redeem start Date" id="redeemStDate" name="redeemStDate" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
                                <span><spring:message code="sal.text.to" /></span>
                            <p><input type="text" title="Redeem end Date" id="redeemEnDate" name="redeemEnDate" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
                        </div><!-- date_set end -->
                    </td>
                </tr>
            </tbody>
        </table>
    </form>

    <article class="grid_wrap" id="grid_wrap"></article>

</section>