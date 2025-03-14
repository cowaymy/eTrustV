<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    var gridID;

    $(document).ready(function() {
        createAUIGrid();
        populateCollectionBranches();
        populateRedemptionItems();

        AUIGrid.bind(gridID, "cellClick", function(event) {
            $("#_rdmId").val(event.item.rdmId);
            $('#_rdmNo').val(event.item.rdmNo);

        });

        $('#btnSearchRdm').click(function() {
        	fn_searchRedemptionList();
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

        $('#btnAdminCancelRdm').click(function() {
            var selIdx = AUIGrid.getSelectedIndex(gridID)[0];

            if (selIdx > -1) {
                var rdmStatus = AUIGrid.getCellValue(gridID, selIdx, "status");

                if ( (rdmStatus != "Active") && (rdmStatus != "In Progress") ) {
                    Common.alert('<spring:message code="incentive.alert.msg.rdmValidateAdminCancel" />');
                } else {
                    fn_promptAdminCancelConfirm(selIdx);
                }
            }
            else {
                Common.alert('<spring:message code="incentive.alert.msg.rdmMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="incentive.alert.msg.noRdmSel" /></b>');
            }
        });

        $('#btnAdminForfeitRdm').click(function() {
                    var selIdx = AUIGrid.getSelectedIndex(gridID)[0];

                    if(selIdx > -1) {
                        var rdmStatus = AUIGrid.getCellValue(gridID, selIdx, "status");

                        if (rdmStatus != "Ready For Collect") {
                            Common.alert('Only Ready For Collect redemptions can be updated');
                        }
                        else {
	                           var param="";
	                           param =$("#_rdmId").val()+"";

                              Common.popupDiv("/incentive/goldPoints/updateForfeitRedemptionPop.do", { rdmId : param}, null , true, 'updateForfeitRedemptionPop');
                        }
                    }
                    else {
                        Common.alert('<spring:message code="incentive.alert.msg.rdmMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="incentive.alert.msg.noRdmSel" /></b>');
                    }
        });

//         $('#btnAdminForfeitRdm').click(function() {
//             var selIdx = AUIGrid.getSelectedIndex(gridID)[0];

//             if (selIdx > -1) {
//                 var rdmStatus = AUIGrid.getCellValue(gridID, selIdx, "status");

//                 if ( (rdmStatus != "Ready For Collect")) {
//                     Common.alert('Only Ready For Collect Redemptions can be forfeited');
//                 } else {
//                     fn_promptAdminForfeitConfirm(selIdx);
//                 }
//             }
//             else {
//                 Common.alert('<spring:message code="incentive.alert.msg.rdmMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="incentive.alert.msg.noRdmSel" /></b>');
//             }
//         });

        $('#btnUpdRdm').click(function() {
//             var selIdx = AUIGrid.getSelectedIndex(gridID)[0];

            var chkSaveArray = AUIGrid.getCheckedRowItems(gridID);
            var flag = true;
            var param="";

            if(chkSaveArray.length>0){
                for (var i = 0 ; i < chkSaveArray.length ; i++){
                    if(chkSaveArray[i].item.status != "In Progress" && chkSaveArray[i].item.status != "Ready For Collect")
                    {
                         Common.alert('<spring:message code="incentive.alert.msg.rdmValidateUpdate" />');
                         flag=false;
                    }
                }

                if(flag ==true){
                	for (var i = 0 ; i < chkSaveArray.length ; i++){
                		if(i==0){
                            param = chkSaveArray[i].item.rdmId+"";
                        }
                        else{
                            param = param +"∈"+chkSaveArray[i].item.rdmId;
                        }
                	}
                    Common.popupDiv("/incentive/goldPoints/updateRedemptionPop.do", { rdmId : param }, null , true, 'updateRedemptionPop');
                }
            }
            else{
            	 Common.alert('<spring:message code="incentive.alert.msg.rdmMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="incentive.alert.msg.noRdmSel" /></b>');
            }



//             if(selIdx > -1) {
//                 var rdmStatus = AUIGrid.getCellValue(gridID, selIdx, "status");

//                 if (rdmStatus != "In Progress" && rdmStatus != "Ready For Collect") {
//                     Common.alert('<spring:message code="incentive.alert.msg.rdmValidateUpdate" />');
//                 } else {
//                 	Common.popupDiv("/incentive/goldPoints/updateRedemptionPop.do", { rdmId : $("#_rdmId").val() }, null , true, 'updateRedemptionPop');
//                 }
//             }
//             else {
//                 Common.alert('<spring:message code="incentive.alert.msg.rdmMiss" />' + DEFAULT_DELIMITER + '<b><spring:message code="incentive.alert.msg.noRdmSel" /></b>');
//             }
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
                showRowCheckColumn : true, //checkBox
                wordWrap : true,
                headerHeight : 45
        }

        gridID = AUIGrid.create("#grid_wrap", columnLayout, gridOpt);
    }

    function fn_searchRedemptionList() {
        Common.ajax("GET", "/incentive/goldPoints/searchRedemptionList.do", $("#searchForm").serialize(), function(result) {
//         	console.log(result);
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

    function fn_promptAdminCancelConfirm(selIdx) {

        var memName = AUIGrid.getCellValue(gridID, selIdx, "memName");
        var memCode = AUIGrid.getCellValue(gridID, selIdx, "memCode");
        var rdmItem = AUIGrid.getCellValue(gridID, selIdx, "rdmItem");
        var qty = AUIGrid.getCellValue(gridID, selIdx, "qty");
        var totalPts = AUIGrid.getCellValue(gridID, selIdx, "totalPts");

        var confirmCancelMsg = memName + "<br />" + memCode + "<br />" +
        rdmItem + "<br />Quantity : " + qty + "<br />Total Gold Points : " +
        totalPts + "<br /><br />" + "Do you want to cancel this redemption request?";

        Common.confirm(confirmCancelMsg, fn_adminCancelRedemption);
    }

    function fn_promptAdminForfeitConfirm(selIdx) {

        var memName = AUIGrid.getCellValue(gridID, selIdx, "memName");
        var memCode = AUIGrid.getCellValue(gridID, selIdx, "memCode");
        var rdmItem = AUIGrid.getCellValue(gridID, selIdx, "rdmItem");
        var qty = AUIGrid.getCellValue(gridID, selIdx, "qty");
        var totalPts = AUIGrid.getCellValue(gridID, selIdx, "totalPts");

        var confirmCancelMsg = memName + "<br />" + memCode + "<br />" +
        rdmItem + "<br />Quantity : " + qty + "<br />Total Gold Points : " +
        totalPts + "<br /><br />" + "Do you want to forfeit this redemption request?";

        Common.confirm(confirmCancelMsg, fn_adminForfeitRedemption);
    }

    function fn_cancelRedemption() {
        Common.ajax("POST", "/incentive/goldPoints/cancelRedemption.do", {rdmId:$('#_rdmId').val()}, function(result) {
            if(result.p1 == 1) {     //successful cancelled redemption
                Common.alert("Your Gold Points Redemption Request has been cancelled. <br />Redemption No. : "
                		+ $('#_rdmNo').val(), fn_reloadList);
            } else if (result.p1 == 99) {
                Common.alert("Failed to Cancel. Redemption is neither active nor in-progress", fn_reloadList);
            }
        });
    }

    function fn_adminCancelRedemption() {
        Common.ajax("POST", "/incentive/goldPoints/adminCancelRedemption.do", {rdmId:$('#_rdmId').val()}, function(result) {
            if(result.p1 == 1) {     //successful cancelled redemption
                Common.alert("Gold Points Redemption Request has been cancelled. <br />Redemption No. : "
                        + $('#_rdmNo').val(), fn_reloadList);
            } else if (result.p1 == 99) {
                Common.alert("Failed to Cancel. Redemption is not In Progress", fn_reloadList);
            }
        });
    }

    function fn_adminForfeitRedemption() {
        Common.ajax("POST", "/incentive/goldPoints/adminForfeitRedemption.do", {rdmId:$('#_rdmId').val()}, function(result) {
            if(result.p1 == 1) {     //successful forfeited redemption
                Common.alert("Gold Points Redemption Request has been forfeited. <br />Redemption No. : "
                        + $('#_rdmNo').val(), fn_reloadList);
            } else if (result.p1 == 99) {
                Common.alert("Failed to Forfeit. Redemption is not Ready In Collect", fn_reloadList);
            }
        });
    }

    function fn_reloadList() {
        location.reload();
    }

    function fn_excelDownRedemption() {
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon
            .exportTo("grid_wrap", "xlsx",
                "<spring:message code='incentive.title.redemptionList'/>");
    }

    function populateCollectionBranches() {
        doGetComboSepa('/common/selectBranchCodeList.do', '45', ' - ', '', 'cmbCollectionBranch', 'M', 'f_multiCombo');
    }

    function populateRedemptionItems() {
    	doGetComboSepa('/incentive/goldPoints/selectRedemptionItemList.do', '', ' - ', '', 'cmbRedemptionItem', 'M', 'f_multiCombo');
    }

    function f_multiCombo(){
        $(function() {
            $('#cmbCollectionBranch').change(function() {
            }).multipleSelect({
                selectAll: false,
                width: '100%'
            });

            $('#cmbRedemptionItem').change(function() {
            }).multipleSelect({
                selectAll: false,
                width: '100%'
            });

        });
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
            <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
                <li><p class="btn_blue"><a id="btnAdminCancelRdm" href="#">Cancel Request (Admin)</a></p></li>
            </c:if>
             <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
                <li><p class="btn_blue"><a id="btnAdminForfeitRdm" href="#">Forfeit Request (Admin)</a></p></li>
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
                <col style="width:110px" />
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
                    <th scope="row">Redemption Status</th>
                    <td>
                        <select class="multy_select w100p" multiple="multiple" id="cmbRdmStatus" name="cmbRdmStatus">
                            <option value="">Select Status</option>
                            <option value="1">Active</option>
                            <option value="4">Completed</option>
                            <option value="10">Cancelled</option>
                            <option value="60">In Progress</option>
                            <option value="110">Ready For Collect</option>
                            <option value="114">Forfeited</option>
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
                        <select class="multy_select w100p" multiple="multiple" id="cmbRedemptionItem" name="cmbRedemptionItem"></select>
                    </td>
                    <th scope="row">Collection Branch</th>
                    <td>
                        <select class="multy_select w100p" multiple="multiple" id="cmbCollectionBranch" name="cmbCollectionBranch"></select>
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
                <tr>
                    <th scope="row">Item Code</th>
                    <td>
                        <input type="text" title="Item Code" placeholder="" class="w100p" id="itemCode" name="itemCode" />
                    </td>
                    <th></th>
                    <td></td>

                    <th></th>
                    <td></td>

                    <th></th>
                    <td></td>
                 </tr>
            </tbody>
        </table>
    </form>

    <br/>
    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid">
                <a href="#" onClick="fn_excelDownRedemption()"><spring:message code='service.btn.Generate' /></a>
                </p></li>
        </c:if>
   </ul>

    <article class="grid_wrap" id="grid_wrap"></article>

</section>